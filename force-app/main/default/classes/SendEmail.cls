public class SendEmail {
    public static void sendEmailWithRecordId(){
          try{
            List<Messaging.SingleEmailMessage>emailsList = new List<Messaging.SingleEmailMessage>();
            
            Messaging.SingleEmailMessage emailInstance = new Messaging.SingleEmailMessage();
            String email = 'akshatnigam2020@gmail.com';
            emailInstance.setToAddresses(new List<String>{email});
            emailInstance.setSubject('Please Verify this');
            emailInstance.setHtmlBody('Hi Akshat Nigam,<br><br>' +
    'Please review the procurement by using the link below:<br>' +
    '<a href="https://orgfarm-09e2fe45f5-dev-ed.develop.lightning.force.com/lightning/r/Procurement__c/a01gL000006G2ooQAC/view">View Procurement</a>');
            
            emailsList.add(emailInstance);
            Messaging.sendEmail(emailsList);
            
        }catch(Exception e){
            System.debug(e.getMessage());
        }
        
    }
}