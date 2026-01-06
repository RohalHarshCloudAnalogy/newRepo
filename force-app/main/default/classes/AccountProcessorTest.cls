@isTest
public class AccountProcessorTest {
	@isTest
    public static void testing(){
        Account acc = new Account();
        acc.name = 'Newadskfakjn';
        Test.startTest();
        insert acc;
        List<Contact>conList = new List<Contact>();
        for(Integer i=0;i<2;i++){
            Contact con= new Contact();
            con.AccountId = acc.id;
            con.LastName = 'sdaajakj'+i;
            conList.add(con);
        }
        insert conList;
        List<Id>newId = new List<Id>();
        newId.add(acc.Id);
        AccountProcessor.countContacts(newId);
        Test.stopTest();
        Account updatedAcc = [Select Name ,Total_Contact_Count__c from Account Limit 1];
        System.assertEquals(2,updatedAcc.Total_Contact_Count__c);
    }
}