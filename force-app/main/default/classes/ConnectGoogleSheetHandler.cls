/*public class ConnectGoogleSheetHandler {
    @future(callout=true)
    public static void connectGoogleViaApi(List<Id>updatedLeadIds){
        List<Lead>updatedLead = [Select Email , Phone, Company from Lead Where Id IN :updatedLeadIds];
        String url = 'https://script.google.com/a/macros/cloudanalogy.com/s/AKfycbx7UNv0kWVOd6iyAfiE4vXcdxAAAsFaBrlU0IwwgLkrj_mJ0n067n6xLxnhWFexTW0/exec';
        for(Lead i: updatedLead){
            Map<String, String> data = new Map<String, String>{
                'Email' => i.Email,
                'Phone' => i.Phone,
                'Company' => i.Company
        	};
                
                
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('POST');
            req.setHeader('Authorization', 'Bearer ' + accessToken);  // Replace with actual token

            req.setHeader('Content-Type', 'application/json');
            req.setBody(JSON.serialize(data));
    
            Http http = new Http();
            HttpResponse res = http.send(req);
            
            // Log the response for debugging
            System.debug(res.getBody());
        }
    }
}

*/
/*


/*public class ConnectGoogleSheetHandler {

    public static void connectGoogleViaApi() {
        HttpRequest request = new HttpRequest();

        // Replace 'Sheet1!A1:E10' with your actual sheet name and range
        String sheetRange = 'Sheet1';
        
        // Proper endpoint format (assumes you used Legacy Named Credential named 'GoogleSheetNC')
        String endpoint = 'callout:GoogleSheetNC/v4/spreadsheets/10xdvHgW8FPYTkJT4C8Zv8VPywv-aiiraF94n5IaQ0uE/values/' + EncodingUtil.urlEncode(sheetRange, 'UTF-8');
        
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        
        Http http = new Http();
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) {
            System.debug('Response Body: ' + response.getBody());
        } else {
            System.debug('Error: ' + response.getStatusCode() + ' - ' + response.getStatus());
            System.debug('Response Body: ' + response.getBody());
        }
    }
}/////////
*/
public class ConnectGoogleSheetHandler {

   

    public static void connectGoogleViaApi() {
        HttpRequest request = new HttpRequest();

        // Define the range
        String sheetRange = 'Sheet1!A1:Z1000';

        String endpoint = 'callout:JwtNamedCredential/v4/spreadsheets/10xdvHgW8FPYTkJT4C8Zv8VPywv-aiiraF94n5IaQ0uE/values/' + EncodingUtil.urlEncode(sheetRange, 'UTF-8');

        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');

        Http http = new Http();
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200){
            System.debug(response.getBody());
        }
        else{
           System.debug('Status Code'+response.getStatusCode());
        }
        /*List<Lead>emailslead = [Select Email from Lead];
        List<String>emails = new List<String>();
        
        for(Lead i: emailslead){
            emails.add(i.Email);
        }

        if (response.getStatusCode() == 200) {
            Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> rawRows = (List<Object>) jsonMap.get('values');

            List<Lead> leadsToInsert = new List<Lead>();
            

           
                for (Integer i = 1; i < rawRows.size(); i++) {
                    List<Object> row = (List<Object>) rawRows[i];
                    String emailFromSheet = (row.size() > 3 && row[3] != null) ? (String) row[3] : null;

                    if (emailFromSheet != null && emails.contains(emailFromSheet)) {
                        continue;
                    }
                    List<String> fieldApiNames = new List<String>{'FirstName', 'LastName', 'Company', 'Email', 'Phone', 'LeadSource', 'Status'};
                    
    
                    Lead lead = new Lead();
    
                    for (Integer j = 0; j < row.size() && j < fieldApiNames.size(); j++) {
                        lead.put(fieldApiNames[j], (String) row[j]);
                    }
    
                    leadsToInsert.add(lead);
                }
                
                if (!leadsToInsert.isEmpty()) {
                    insert leadsToInsert;
                    System.debug('Inserted ' + leadsToInsert.size() + ' Leads successfully.');
                }
            
        } else {
            System.debug('Error: ' + response.getStatusCode());
            System.debug('Body: ' + response.getBody());
        }*/
    }

}