@isTest 
private class AccountTriggerHandlerTest{
    @isTest
    static void updateAccTest(){
        List<Account>accList = new List<Account>();
        for(Integer i=0;i<10;i++){
            Account acc = new Account();
            acc.Name = 'Acc'+i;
            accList.add(acc);
        }
        
        Test.startTest();
        insert accList;
        
        List<Account>curAcc = [Select Id , Description from Account Where Name Like '%Acc%'];
        
        AccountTriggerHandler.updateAcc(curAcc);
        update curAcc;
        
        for(Account ac: curAcc){
            System.assertEquals('This is  update trigger class',ac.Description);
        }
    }
    
    @isTest
    static void createAccContactTest(){
        List<Account>accList = new List<Account>();
        for(Integer i=0;i<10;i++){
            Account acc = new Account();
            acc.Name = 'Acc'+i;
            accList.add(acc);
        }
        
        Test.startTest();
        insert accList;
        List<Id>accId = new List<Id>();
        for(Account ac: accList ){
            accId.add(ac.Id);
        }
        AccountTriggerHandler.createAccContact(accList);
        
        
        List<Contact>conList = [Select Id from Contact Where AccountId = :accId];
        
        System.assertEquals(10,conList.size());
        
    }
    
    @isTest
    static void insertRatingTest(){
        List<Account>accList = new List<Account>();
        for(Integer i=0;i<10;i++){
            if(i<7){
                Account acc = new Account();
                acc.Name = 'Acc'+i;
                acc.Industry = 'Media';
                accList.add(acc);
            }
            else{
                Account acc = new Account();
                acc.Name = 'Acc'+i;
                accList.add(acc);
            }
            
        }
        
        Test.startTest();
        insert accList;
        
        AccountTriggerHandler.insertRating(accList);
        update accList;
        
        for(Account acc: accList){
            if(acc.Industry == 'Media'){
                System.assertEquals('Hot',acc.Rating);
            }
            else{
                System.assertEquals('Cold',acc.Rating);
            }
        }
    }
    
    @isTest
    static void stopDelition(){
        List<Account>accList = new List<Account>();
        for(Integer i=0;i<10;i++){
            Account acc = new Account();
            acc.Name = 'Acc'+i;
            acc.Active__c = 'Yes';
            accList.add(acc);
        }
        
        Test.startTest();
        insert accList;
        
        AccountTriggerHandler.stopDelition(accList);
        
        List<Account>afterDelAcc = [Select Id from Account Where Name Like '%Acc%'];
        System.assertEquals(10,afterDelAcc.size());
    }
    
    @isTest
    static void checkRelatedContactsTest(){
        List<Account>accList = new List<Account>();
        for(Integer i=0;i<10;i++){
            Account acc = new Account();
            acc.Name = 'Acc'+i;
            acc.Active__c = 'Yes';
            accList.add(acc);
        }
        
        Test.startTest();
        insert accList;
        
        List<Contact>conList = new List<Contact>();
        Integer i=0;
        for(Account acc :accList){
            if(i<7){
                Contact con = new Contact();
            	con.LastName ='con'+acc.Name;
                con.AccountId = acc.Id;
                conList.add(con);
                i++;
            }
        }
        insert conList;
        
        AccountTriggerHandler.checkRelatedContacts(accList);
    }
}
	/*@isTest
    static void createConAcc(){
        List<Account>accList = new List<Account>();
        for(Integer i=0;i<10;i++){
            Account acc = new Account();
            acc.Name = 'Acc'+i;
            accList.add(acc);
        }
        
        Test.startTest();
        insert accList;
        Test.stopTest();
        
		List<Contact>conList = [Select Id from Contact Where AccountId =: accList[0].Id];
        System.Assert(conList!=NULL , 'Contact not created');
    }
    
    //@isTest
    static void updateAccountTest(){
        List<Account>accList = new List<Account>();
        for(Integer i=0;i<10;i++){
            Account acc = new Account();
            acc.Name = 'Acc'+i;
            accList.add(acc);
        }
       
        Test.startTest();
        insert accList;
        List<Id>AccId = new List<Id>();
        for(Account acc: accList){
            acc.Name = acc.Name +9999;
            AccId.add(acc.Id);
        }
        update accList;
        Test.stopTest();
        
        List<account>newList = [Select Id from Account Where Id IN: AccId];
        System.Assert(newList.size()!=NULL, 'Did not updated');
    }
    
    
    
    //@isTest
    static void insertRatingHotTest(){
         List<Account>accList = new List<Account>();
        List<Id>accId = new List<Id>();
        for(Integer i=0;i<10;i++){
            Account acc = new Account();
            acc.Name = 'newAcc';
            acc.Industry = 'Media';
            accList.add(acc);
        }
       
        Test.startTest();
        insert accList;
        for(Account acc: accList){
           
            accId.add(acc.Id);
        }
        Test.stopTest();
        
        List<Account>accUpdate = [Select Id,Rating From Account Where Id IN: accId Limit 1];
        System.AssertEquals(accUpdate[0].Rating,'Hot', 'Not Updated');
        
        
    }
    
    //@isTest
    static void insertRatingCodeTest(){
        List<Account>accList = new List<Account>();
        List<Id>accId = new List<Id>();
        for(Integer i=0;i<10;i++){
            Account acc = new Account();
            acc.Name = 'newName';
            acc.Industry = '';
            accList.add(acc);
        }
       
        Test.startTest();
        insert accList;
        for(Account acc: accList){
            accId.add(acc.Id);
        }
        Test.stopTest();
        
        List<Account>accUpdate = [Select Id,Rating From Account Where Id IN: accId Limit 1];
        System.AssertEquals(accUpdate[0].Rating,'Cold' ,'Not Updated');
        
        
    }
    
    
    //@isTest
    static void stopDelitionTest(){
        List<Account>accList = new List<Account>();
        List<Id>accId = new List<Id>();
        for(Integer i=0;i<5;i++){
            Account acc = new Account();
            acc.Name = 'newName';
            acc.Active__c = 'Yes';
            accList.add(acc);
        }
        for(Integer i=0;i<5;i++){
            Account acc = new Account();
            acc.Name = 'newName';
            acc.Active__c = 'No';
            accList.add(acc);
        }
        Test.startTest();
        insert accList;
        
       	Database.DeleteResult[] results = Database.delete(accList,false);
        Test.stopTest();
        
        for(Integer i=0;i<accList.size();i++){
            if(accList[i].Active__c == 'Yes'){
                System.Assert(!results[i].isSuccess(),'Active accounts should not be deleted');
                System.Assert(results[i].getErrors().size() >0, 'For Active accounts it should give error');
            }
            else{
                System.Assert(results[i].isSuccess(),'Inactive accounts should be deleted');
            }
        }
        
    }
    
    //@isTest
    static void updatePhoneFieldTest(){
        List<Account>accList = new List<Account>();
        for(Integer i=0;i<5;i++){
            Account acc = new Account();
            acc.Name = 'updatePhoneField';
            accList.add(acc);
        }
        
        List<Contact>conList = new List<Contact>();
        
        List<Id>accId = new List<Id>();
        Test.startTest();
        insert accList;
        
        for(Account acc: accList){
            accId.add(acc.Id);
            Contact con  = new Contact();
            con.AccountId = acc.Id;
            con.LastName = acc.Name;
            conList.add(con);
        }
        
        insert conList;
        for(Account acc: accList){
            acc.phone = '098098098';
        }
        update accList;
        Test.stopTest();
        
        List<Contact>updateCon = [Select Id from Contact Where Id IN:accId];
        for(Contact con: updateCon){
            System.AssertEquals('098098098',con.Phone);
        }

    }
    
    //@isTest
    static void checkRelatedContactsTest(){
        List<Account>accList = new List<Account>();
        for(Integer i=0;i<5;i++){
            Account acc = new Account();
            acc.Name = 'AccContact';
            acc.Industry = 'Energy';
            accList.add(acc);
        }

        for(Integer i=0;i<5;i++){
            Account acc = new Account();
            acc.Name = 'AccNoContact';
            acc.Industry = 'Energy';
            accList.add(acc);
        }
       
        
        Test.startTest();
        insert accList;

         
        List<Contact>conList = new List<Contact>();
        for(Account acc:accList){
            if(acc.Name == 'AccContact'){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.LastName = acc.Name;
                conList.add(con);
            }
        }
        
        insert conList;


        Database.DeleteResult[] results = Database.delete(accList,false);
        Test.stopTest();

        for(Integer i=0;i<accList.size();i++){
            if(accList[i].Name == 'AccContact'){
                System.Assert(!results[i].isSuccess(),'Can not delete account related to contact');
                System.Assert(results[i].getErrors().size() > 0);
            }else{
                System.Assert(results[i].isSuccess(),'Can be deleted');
            }
        }
        
    }
    
    //@isTest
    static void question10Test1(){
        List<Id>AccId = new List<Id>();
        List<Account>accList = new List<Account>();
        for(Integer i=0;i<5;i++){
            Account acc = new Account();
            acc.Name  = 'TestQuestion10';
            accList.add(acc);
        }
        
        for(Integer i=0;i<5;i++){
            Account acc = new Account();
            acc.Name  = 'TestQuestion10';
            acc.Industry = 'Media';
            accList.add(acc);
        }
        
        for(Integer i=0;i<5;i++){
            Account acc = new Account();
            acc.Name  = 'TestQuestion10';
            acc.Industry = 'Banking';
            accList.add(acc);
        }
        
        Test.startTest();
        Database.SaveResult[] results = Database.insert(accList,false);
        for(Account acc: accList){
            AccId.add(acc.Id);
        }
        Test.stopTest();
        List<Account>newAccList = [Select Id ,Industry, Rating from Account Where Id IN :ACCID];
        
        for(Integer i=0;i<newAccList.size();i++){
            if(newAccList[i].Industry==NULL){
                System.assert(!results[i].isSuccess(),'Acc With Null industry can not be created');
                System.assert(results[i].getErrors().size()>0,'It should give errror');
            }
            else if(newAccList[i].Industry == 'Media'){
                System.assertEquals('Hot',accList[i].Rating);
            }
            else{
                System.AssertEquals('Cold',accList[i].Rating);
            }
        }
        
    }
    
    
    //test 66
    //@IsTest
    static void outOfZipTest(){
        List<Account>newList = new List<Account>();
       
        for(Integer i=0;i<10;i++){
            Account acc = new Account();
            acc.Name = 'acc'+i;
            acc.BillingStreet = 'BillingStreet';
            acc.BillingCity = 'BillingCity';
            acc.BillingState = 'BillingState';
            acc.BillingPostalCode = '123456';
            acc.BillingCountry = 'BillingCountry';
            newList.add(acc);
           
        }
        
        List<Contact>conList = new List<Contact>();
        List<Id>accId = new List<Id>();
        Test.startTest();
        insert newList;
        Integer i=1;
        for(Account acc: newList){
            accId.add(acc.Id);
            if(Math.Mod(i,2) ==0){
                Contact con = new Contact();
                con.AccountId = acc.id;
                con.LastName = 'NewCon'+i;
                con.MailingPostalCode ='123456';
                conList.add(con);
               
            }
            else{
                Contact con = new Contact();
                con.AccountId = acc.id;
                con.LastName = 'NewCon'+i;
                con.MailingPostalCode = '3456';
                conList.add(con);
                
            }
            i++;
        }
        insert conList;
        
        for(Account acc: newList){
            acc.BillingCity= 'UP';
        }
        
        update newList;
        
        Test.stopTest();
        
      List<Account>allAccount = [Select Id from Account Where ID IN: accId AND Out_of_Zip__c = True];
        System.Assert(allAccount.size()>0,'Incorrect ');
    }
*/