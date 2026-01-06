@isTest
public class caseTriggerHandlerTest {
	@isTest
    static void udpateAccountAndTaskque67(){
       List<Account>accList = new List<Account>();
        for(Integer i=0;i<5;i++){
            Account acc = new Account();
            acc.Name = 'Acc'+i;
            accList.add(acc);
        }
        List<Task>taskList = new List<Task>();
        List<Case>caseList = new List<Case>();
        
        Test.startTest();
        insert accList;
        for(Account acc: accList){
            Task newTask = new Task();
            Case newCase = new Case();
            newCase.Accountid = acc.Id;
            newCase.Status = 'New';
            newCase.Origin = 'Phone';
            
            newTask.WhatId = acc.Id;
            newTask.Subject = 'newTask';
            taskList.add(newTask);
        }
        
        insert taskList;
        insert caseList;
        
        for(Case cs: caseList){
            cs.Status = 'Working';
        }
        
        
        
    }
}