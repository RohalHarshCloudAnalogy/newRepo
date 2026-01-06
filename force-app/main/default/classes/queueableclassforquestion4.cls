public class queueableclassforquestion4 implements Queueable {
	private List<Studentt__c>sList;
     private List<Instrucctor__c>iList;
    
    public queueableclassforquestion4(List<Studentt__c>sList,List<Instrucctor__c>iList){
        this.sList = sList;
        this.iList = iList;
    }
    public void execute(QueueableContext context){
    	List <messaging.singleEmailMessage> mailList = new  list <messaging.singleEmailMessage>();

        for(Studentt__c i: sList){
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String>allEmail = new List<String>();
            
            allEmail.add(i.Email__c);
           	mail.setToaddresses(allEmail);
            mail.setSubject('Enroll');
            mail.setPlainTextBody('Enroll');
            mailList.add(mail);
        }
        
        for(Instrucctor__c i: iList){
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String>allEmail = new List<String>();
            
            allEmail.add(i.Email__c);
           	mail.setToaddresses(allEmail);
            mail.setSubject('Enroll');
            mail.setPlainTextBody('Enroll');
            mailList.add(mail);
            System.debug(mailList);
        }
        
        Messaging.sendEmail(mailList);
    }
    
}