public with sharing class fetchAccount {
    @AuraEnabled(
        cacheable=true) // with cacheable=true, the data will be saved on client side in case of quick data loading
    public static List<Account> getAccount(string searchKey){
        if(String.isNotBlank(searchKey)){
            String searchPattern = '%' + searchKey + '%';
            return [Select Id,Name,AccountNumber,Phone from Account Where Name Like :searchPattern ];
        }
        else{
            return [Select Id,Name,AccountNumber,Phone from Account Limit 20];
        }
    }
    

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(Id accountId)
    {
        return [SELECT Id , FirstName,LastName ,Email FROM Contact Where AccountId = :accountId];
    }

    @AuraEnabled(cacheable = true)
    public static List<Opportunity> getOpportunity(Id accountId){
        try {
            return [Select Id , Name , StageName from Opportunity Where AccountId = :accountId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String deleteAccounts(List<Id> accounts) {
        System.debug('Accs to be deleted: ' +accounts);
        try {
            Database.DeleteResult[] deleteResults = Database.delete(accounts, false); // use partial success mode
            List<String> errorMessages = new List<String>();
    
            for (Database.DeleteResult result : deleteResults) {
                if (!result.isSuccess()) {
                    for (Database.Error err : result.getErrors()) {
                        errorMessages.add(err.getMessage());
                    }
                }
            }
    
            if (errorMessages.isEmpty()) {
                return 'Deletion Successful';
            } else {
                return 'Partial Failure: ' + String.join(errorMessages, '; ');
            }
    
        } catch (Exception e) {
            throw new AuraHandledException('Server Error: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static void saveAccounts(List<Account> accList) {
        try {
            insert accList;
        } catch (Exception e) {
            // return meaningful message to LWC
            throw new AuraHandledException('Failed to save accounts: ' + e.getMessage());
        }
    }

    @AuraEnabled(cacheable = true)
    public static List<ObjectPermissions> getObjects(){
        try{
            return [SELECT SObjectType FROM ObjectPermissions ORDER BY SObjectType ASC];
        }catch (Exception e) {
            // return meaningful message to LWC
           system.debug('fetch datea');
            throw new AuraHandledException('Some Error ' + e.getMessage());
        }
    
    }

    @AuraEnabled
    public static List<Map<String, String>> getRelatedField(String objectApiName) {
        try {
            Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objectApiName).getDescribe().fields.getMap();
            List<Map<String, String>> fieldList = new List<Map<String, String>>();

            for (String fieldName : fieldMap.keySet()) {
                Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldName).getDescribe();
                Map<String, String> fieldInfo = new Map<String, String>();
                fieldInfo.put('label', fieldDescribe.getLabel());
                fieldInfo.put('apiName', fieldName);
                fieldInfo.put('type', String.valueOf(fieldDescribe.getType()));
                fieldList.add(fieldInfo);
            }

            return fieldList;
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching fields: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Decimal> getCountAmount(Id accId){
        try {
            AggregateResult sumAmount  = [Select Sum(Amount) Total_Amount from Opportunity Where AccountId =: accId];
            Decimal totalAmount = (Decimal)sumAmount.get('Total_Amount');
            System.debug(totalAmount);

            List<Opportunity> oppList = [SELECT Id, Name, AccountId FROM Opportunity WHERE AccountId = :accId];
            System.debug(oppList);
            List<Decimal> amountList = new List<Decimal>();
            Decimal totalCount = oppList.size();
            amountList.add(totalAmount);
            amountList.add(totalCount);
            return amountList;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void sendEmail(String email, String Subject, String Body){
        try {
            List<Messaging.SingleEmailMessage>emailSendList = new List<Messaging.SingleEmailMessage>();

            Messaging.SingleEmailMessage emailInstance = new Messaging.SingleEmailMessage();
            emailInstance.setToAddresses(new List<String>{email});
            emailInstance.setSubject(Subject);
            emailInstance.setPlainTextBody(Body);
            emailSendList.add(emailInstance);

            Messaging.sendEmail(emailSendList);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    @AuraEnabled
    public static List<Account> accWithContacts(){
        try{
            List<Account> accList = [SELECT Id,Name,(SELECT Id,Name,FirstName,LastName FROM Contacts) FROM Account Where Name != 'Sample Account for Entitlements' Limit 3];
            if(!accList.isEmpty()){
                return accList;
            }else{
                return null;
            }
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }


    @AuraEnabled
    public static void attachFile(String accId ,String base64Data, String files ){
        try {

            System.debug('apex 1');
            ContentVersion cv = new ContentVersion();
            cv.Title = files; // Set the title of the file
            cv.PathOnClient = files; // Set the file name/path as it appears on the client
            cv.VersionData = EncodingUtil.base64Decode(base64Data); // Decode the base64 data into actual binary content
            insert cv; // Insert the ContentVersion record
            System.debug('apex 2');

            ContentVersion insertedCV = [
                SELECT Id, ContentDocumentId 
                FROM ContentVersion 
                WHERE Id = :cv.Id 
                LIMIT 1
            ];

            System.debug('apex 3');


            List<ContentDocumentLink>conDocLinkList = new List<ContentDocumentLink>();
            
            ContentDocumentLink conDocLink = new ContentDocumentLink();

            conDocLink.ContentDocumentId = insertedCV.ContentDocumentId;
            conDocLink.LinkedEntityId = accId; 

            conDocLink.ShareType = 'V';
            conDocLink.VISIBILITY = 'AllUsers';

            conDocLinkList.add(conDocLink);

            if(!conDocLinkList.isEmpty()){
                upsert conDocLinkList;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}