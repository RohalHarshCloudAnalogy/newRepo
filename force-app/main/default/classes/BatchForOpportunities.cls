public class BatchForOpportunities implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext context){
        System.debug('Start Method');
        String query = 'Select Id, Name, AccountId from Opportunity Where StageName = \'Closed Won\'';
        return Database.getQueryLocator(query);   
    }
    
    public void execute(Database.BatchableContext context, List<Opportunity>oppList){
        set<Id>accId =  new set<Id>();
        for(Opportunity opp:oppList){
            accId.add(opp.AccountId);
        }
        Map<Id,Account>accMap = new Map<Id,Account>([Select Id, Name ,OwnerId from Account Where Id IN:accId]);
        
        List<Task>allTask = new List<Task>();
        for(Opportunity opp:oppList){
            Account acc = accMap.get(opp.AccountId);
            if(acc!=NULL){
                Task t = new Task();
                t.subject = 'Completed';
                t.Priority = 'Normal';
                t.OwnerId = acc.OwnerId;
                t.WhatId = opp.Id;
                t.Status = 'Not Started';
                allTask.add(t);
            }
               
            
        }
        if(!allTask.isEmpty()){
            insert allTask;
        	
        }
    }
    public void finish(Database.BatchableContext context){
         List<AsyncApexJob>aaJ = [SELECT Id, JobType, ApexClassId, Status, TotalJobItems, MethodName FROM AsyncApexJob Where Id =:context.getJobId() ];
        System.debug(aaJ);
        System.debug(context);
        
    }
}