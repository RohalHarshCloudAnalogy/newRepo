@isTest
Private class ContactTriggerHandlerTest {
	//@isTest
    static void que65Test(){
        List<Account>accList = new List<Account>();
        for(Integer i=0;i<5;i++){
            Account acc = new Account();
            acc.Name = 'NewConAcc';
            accList.add(acc);
        }
        List<Contact>conList = new List<Contact>();
        Test.startTest();
        insert accList;
       
        for(Account acc: accList){
            Contact con = new Contact();
            con.AccountId = acc.Id;
            con.LastName  = acc.Name;
            conList.add(con);
        }
       
        insert conList;
        
        Test.stopTest();
        List<Account>updatedAccList = new List<Account>();
        for(Account acc: updatedAccList){
            System.assertEquals(True,acc.Contact_Created__c);
        }
    }
    
    @isTest
    static void testCreateContactRelationship() {
        List<Contact> testContacts = new List<Contact>();
        
        for (Integer i = 0; i < 5; i++) {
            testContacts.add(new Contact(
                LastName = 'Test' + i,
                Contact_Relationship__c = true
            ));
        }
        
        Test.startTest();
        insert testContacts;
        Test.stopTest();
        
        List<Contact_Relationship__c> createdRelationships = [
            SELECT Id, Contact__c, Name FROM Contact_Relationship__c
        ];
        
        System.assertEquals(5, createdRelationships.size());
        
        for (Contact_Relationship__c relationship : createdRelationships) {
            System.assertNotEquals(null, relationship.Contact__c);
            System.assertEquals('New CR', relationship.Name);
        }
    }
    
    @isTest
    static void testPutSumAmountInAccount() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 2; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert accounts;

        List<Opportunity> opportunities = new List<Opportunity>();
        opportunities.add(new Opportunity(Name = 'Test Opp 1', Amount = 1000, StageName = 'Closed Won', CloseDate = Date.today(), AccountId = accounts[0].Id));
        opportunities.add(new Opportunity(Name = 'Test Opp 2', Amount = 2000, StageName = 'Closed Won', CloseDate = Date.today(), AccountId = accounts[0].Id));
        opportunities.add(new Opportunity(Name = 'Test Opp 3', Amount = 1500, StageName = 'Closed Won', CloseDate = Date.today(), AccountId = accounts[1].Id));
        insert opportunities;

        List<Contact> contacts = new List<Contact>();
        for (Account acc : accounts) {
            contacts.add(new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = acc.Id));
        }
        insert contacts;

        Test.startTest();
        ContactTriggerHandler.putSumAmountInAccount(contacts);
        Test.stopTest();

        accounts = [SELECT Id, Total_Opportunity_Amount__c FROM Account];
        
        System.assertEquals(3000, accounts[0].Total_Opportunity_Amount__c);
        System.assertEquals(1500, accounts[1].Total_Opportunity_Amount__c);
    }
}