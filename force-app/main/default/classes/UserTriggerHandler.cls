public class UserTriggerHandler {
    public static void sendEmailToManager(List<User>newList){
        System.debug(1);
        Set<Id>managerId = new Set<Id>();
        for(User i: newList){
            managerId.add( i.Managerid );
        }
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        List<User>managers = [Select Email from User Where Id IN:managerid];
        
        for(User i: managers){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String>emails = new List<String>();
            emails.add(i.Email);
            mail.setToAddresses(emails);
            mail.setSubject('Your Accounts and Number of Related Contacts');
            mail.setPlainTextBody('Hiiiiiiiiiiii');
            mailList.add(mail);
            
        }
        Messaging.sendEmail(mailList);
        System.debug(2);
        
    }
}