public class KYCVerificationQueueable implements Queueable, Database.AllowsCallouts {

    private Id kycDocId;

    // 🔹 Constructor to receive record Id
    public KYCVerificationQueueable(Id docId){
        this.kycDocId = docId;
    }

    public void execute(QueueableContext qc){

        try{
            // 🔹 1️⃣ Fetch KYC Document record
            KYC_Document__c doc = [
                SELECT Id, Name, Verification_Status__c, 
                       Approval_Submitted__c
                FROM KYC_Document__c
                WHERE Id = :kycDocId
                LIMIT 1
            ];

            // 🔹 2️⃣ Make HTTP Callout to KYC API
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://api.signzy.com/api/v3/kyc/verify'); // Replace with real API
            request.setMethod('POST');
            request.setHeader('Content-Type','application/json');

            // Example request body (you can pass dynamic docType if needed)
           // 🔹 Get the latest ContentVersion of uploaded file for this KYC_Document__c
           List<ContentDocumentLink> links = [
                SELECT ContentDocumentId
                FROM ContentDocumentLink
                WHERE LinkedEntityId = :doc.Id
                ORDER BY SystemModstamp DESC
                LIMIT 1
            ];

            ContentVersion cv;

            if(!links.isEmpty()){
                cv = [
                    SELECT Id, Title, VersionData, FileType
                    FROM ContentVersion
                    WHERE ContentDocumentId = :links[0].ContentDocumentId
                    AND IsLatest = true
                    LIMIT 1
                ];
            }

            if(cv != null){
                String base64Data = EncodingUtil.base64Encode(cv.VersionData);

                Map<String,Object> body = new Map<String,Object>();
                body.put('documentId', doc.Id);
                body.put('documentName', cv.Title);
                body.put('fileType', cv.FileType);
                body.put('fileData', base64Data); // 🔥 actual uploaded file

                request.setBody(JSON.serialize(body));
            }


            HttpResponse response = http.send(request);

            // 🔹 3️⃣ Parse API response
            String apiResult = 'Manual'; // default if API fails
            String responseBody = response.getBody();

            if(response.getStatusCode() == 200){
                Map<String,Object> resMap = (Map<String,Object>) JSON.deserializeUntyped(responseBody);
                if(resMap.containsKey('status')){
                    apiResult = (String) resMap.get('status'); // Valid / Invalid / Manual
                }
            }

            // 🔹 4️⃣ Update KYC Document record
            doc.Verification_Status__c = apiResult;
            doc.API_Response__c = responseBody;

            update doc;

            // 🔹 5️⃣ Auto-submit Approval if status is Valid and not already submitted
            if(apiResult == 'Valid' && (doc.Approval_Submitted__c == null || !doc.Approval_Submitted__c)){
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setObjectId(doc.Id);
                req.setComments('Auto submitted after API verification');
                Approval.process(req);

                // mark submitted
                doc.Approval_Submitted__c = true;
                update doc;
            }

        } catch(Exception ex){
            System.debug('Error in KYCVerificationQueueable: ' + ex.getMessage());
            // Optional: store error in a field for troubleshooting
            KYC_Document__c errorDoc = [SELECT Id, API_Response__c FROM KYC_Document__c WHERE Id = :kycDocId LIMIT 1];
            errorDoc.API_Response__c = 'Error: ' + ex.getMessage();
            update errorDoc;
        }

    }
}