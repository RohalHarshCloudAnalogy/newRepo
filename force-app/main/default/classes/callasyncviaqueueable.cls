public class callasyncviaqueueable implements Queueable {
	 private List<Studentt__c>allStudent;
     private List<Instrucctor__c>instructor;
    
    public callasyncviaqueueable(List<Studentt__c>allStudent,List<Instrucctor__c>instructor){
        this.allStudent = allStudent;
        this.instructor = instructor;
    }
    
    public void execute(QueueableContext context){
        List <messaging.singleEmailMessage> mailList = new  list <messaging.singleEmailMessage>();

        
        
        for(Instrucctor__c i: instructor){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String>allEmail = new List<String>();
            
            allEmail.add(i.Email__c);
           	mail.setToaddresses(allEmail);
            mail.setSubject('Meeting Time Has Been Changed');
            mail.setPlainTextBody('meeting time is change ');
            mailList.add(mail);
            
        }
        List<String>email = new List<String>();
        System.debug(1);
        for(Studentt__c i : allStudent){
            System.debug(2);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String>allEmaill = new List<String>();
            allEmaill.add(i.Email__c);
           	mail.setToaddresses(allEmaill);
            mail.setSubject('Meeting Time Has Been Changed');
            mail.setPlainTextBody('meeting time is change');
            mailList.add(mail);
            System.debug(mail);
            
        }
        System.debug(3);
        System.debug(mailList);
        
        if(!mailList.isEmpty()){
            Messaging.sendEmail(mailList);
        }
    }
}