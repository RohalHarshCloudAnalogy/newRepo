public with sharing class AccountLWCOne {
    @AuraEnabled(cacheable=true)
     public static Case getCaseDetails(Id caseId) {
         return [
             SELECT Id, Subject, Description, Priority, Status, CreatedDate,
                    Owner.Name, Contact.Name
             FROM Case
             WHERE Id = :caseId
         ];
     
         }   
        @AuraEnabled
        public static List<Contact> getContacts(){
            try {
                return [Select Id, Name from Contact With_Security_Enforced];
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }
}