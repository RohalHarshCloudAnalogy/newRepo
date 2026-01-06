public class OpportunityTriggerHandler {
    Public static void updateOpportunity(List<Opportunity>newList,List<Opportunity>oldList){
        for(Integer i=0;i<newList.size();i++){
            if(newList[i].StageName != oldList[i].StageName && newList[i].StageName =='Closed Won' ){
                newList[i].CloseDate = System.Today();
                newList[i].Type = 'New Customer';
            }
        }
    }

    public static void stopCreationOfOpp(List<Opportunity>newList){
        List<id>oppId = new List<Id>();
        for(Opportunity opp:newList){
            oppId.add(opp.AccountId);
        }
        
        List<AggregateResult>opList = [Select AccountId , Count(Id) Total_Count from Opportunity where AccountId IN:oppId And Account.Working__c = 'ASIA' AND StageName = 'Closed Won' Group by AccountId Having Count(Id)>=2 ];
        Map<Id,Integer>mapp = new Map<Id,Integer>();
        
        for(AggregateResult ar:opList){
            mapp.put((Id)ar.get('AccountId'), (Integer)ar.get('Total_Count'));
        }
        
        for(Opportunity opp: newList){
            if(mapp.get(opp.AccountId) >=2){
                opp.addError('Can not create or update this opportunity');
            }
        }
   }
    
    public static void updateAccName(List<Opportunity>newList){
        Set<Id>AccId = new Set<Id>();
        for(Opportunity opp: newList){
            if(opp.AccountId != NULL){
                AccId.add(opp.AccountId);
            }
        }
        
        List<Opportunity>oppList = [Select AccountId,Name,Amount from Opportunity Where AccountId IN: AccId];
        Map<Id,Opportunity>mapp = new Map<Id,Opportunity>();
        for(Opportunity opp: oppList){
            if(!mapp.containsKey(opp.AccountId) || mapp.get(opp.AccountId).Amount < opp.Amount){
                mapp.put(opp.AccountId , opp);
            }
        }
        
        List<Account>accList = [Select Id,Name from Account Where Id IN:AccId];
        for(Account acc: accList){
            acc.Name = mapp.get(acc.Id).Name;
        }
        if(!accList.isEmpty()){
            update accList;
        }
        
    }
    
    public static void updateClientContact(List<Opportunity>newList){
        Map<Id,Id>mapp = new Map<Id,Id>();
        for(Opportunity opp:newList){
            mapp.put(opp.AccountId,opp.Client_Contact__c);
        }
        List<Account>accList = [Select Id, NewField__c from Account Where Id IN: mapp.keySet()];
        for(Account acc: accList){
            acc.Client_Contact__c = mapp.get(acc.Id);
        }
        update accList;
    }
    
    public static void updateAccountRating(List<Opportunity>newList){
        List<Id>accId = new List<Id>();
        for(Opportunity opp : newList){
            if(opp.AccountId != NULL){
                accId.add(opp.AccountId);
            }
            
        }
        List<Account>accList = [Select Id,Rating from Account Where Id IN: accId];
        List<AggregateResult>accIdWithTotalOppAmount = [Select AccountId , Sum(Amount) Total_Amount from Opportunity Where AccountId IN:accId Group by AccountId];
        
        Map<Id,Decimal>storeAccIdWithTotalOppAmount = new Map<Id,Decimal>();
        for(AggregateResult aR : accIdWithTotalOppAmount){
            storeAccIdWithTotalOppAmount.put((Id)aR.get('AccountId'),(Decimal)aR.get('Total_Amount'));
        }
        
        for(Account acc: accList){
            if(storeAccIdWithTotalOppAmount.get(acc.Id) <= 50000){
                acc.Rating = 'Cold';
            }
            else if(storeAccIdWithTotalOppAmount.get(acc.Id) <= 100000){
                acc.Rating = 'Warm';
            }
            else{
                acc.Rating ='Hot';
            }
        }
        update accList;
    }
    
    
    public static void createTask(List<Opportunity>newList,List<Opportunity>oldList){
        System.debug(1);
        List<Id>oppId = new List<id>();
        for(Integer i=0;i<newList.size();i++){
            if(newList[i].StageName != oldList[i].StageName){
                oppId.add(newList[i].Id);
            }
        }
        
        List<AggregateResult>aR = [Select WhatId , Count(Id) Total_Count from Task Where WhatId IN: oppId Group By WhatId];
        Map<Id,Decimal>mapp = new Map<Id,Decimal>();
        for(AggregateResult i: aR){
            if((Decimal)i.get('Total_Count') >=1){
                mapp.put((Id)i.get('WhatId') , (Decimal)i.get('Total_Count'));
            }
        }
        List<Task>taskList = new List<Task>();
        List<Task>allTask = [Select Id,Description,WhatId from Task Where WhatId IN : oppId];
        
        for(Opportunity opp:newList){
            if(mapp.containsKey(opp.Id)){
                for(Task i: allTask){
                    if(i.WhatId == opp.Id){
                        i.Description = opp.StageName;
                        System.debug(i.Description);
                    }
                }
            }
            
            else{
                
                Task creteTask = new Task();
                creteTask.WhatId = opp.Id;
                creteTask.Subject = 'Call';
                creteTask.Priority ='Normal';
                creteTask.OwnerId = opp.OwnerId;
                taskList.add(creteTask);
                
            }
            
        }
        update allTask;
        
        insert taskList;
        System.debug(taskList);
        
          
    }
    
    
    public static void stopCretionOpp(List<Opportunity>newList){
        Set<Id>accId = new Set<Id>();
        for(Opportunity opp: newList){
            accId.add(opp.AccountId);
            
        }
        List<Id>newAcId = new List<Id>();
        List<AggregateResult>oppList = [Select AccountId from Opportunity Where CreatedDate = Today And AccountId IN: accId Group by AccountId Having Count(Id)>=1 ];
        for(AggregateResult aR : oppList){
            newAcId.add((Id)aR.get('AccountId'));
        }
        for(Opportunity opp:newList){
            if(newAcId.contains(opp.AccountId)){
                opp.addError('Can not create more opportunity today');
            }
        }
        
    }
    
    public static void brain2(List<Opportunity>oppList){
        System.debug(1);
        List<Id>accId = new List<Id>();
        for(Opportunity opp: oppList){
            if(opp.AccountId !=NULL){
                accId.add(opp.AccountId);
            }
        }
        Map<Id, Integer>mapp = new Map<Id,Integer>();
        List<Account>accList = [Select Id ,(select Id from Opportunities Where CreatedDate = Today) from Account Where Id IN: accId];
        System.debug(accList);
        for(Account i: accList){
            mapp.put(i.Id,i.Opportunities.size());
        }
        System.debug(mapp);
        
        for(Opportunity opp: oppList){
            if(mapp.get(opp.AccountId) >0){
                System.debug(mapp.get(opp.AccountId));
                opp.addError('Can not insert more that one opportunity at oneday');
            }
            System.debug(3);
        }
        
        
    }
    
    public static void taskSheet41(List<Opportunity>oppList){
        try{
            Set<Id>oppId = new Set<Id>();
            for(Opportunity opp: oppList){
                oppId.add(opp.Id);
            }
            PricebookEntry onePB = [Select id from PricebookEntry Limit 1];
            Product2 onePro = [Select Id from Product2 Limit 1];
            List<OpportunityLineItem>oliList= new List<OpportunityLineItem>();
            for(Id i: oppId){
                OpportunityLineItem oli = new OpportunityLineItem();
                oli.OpportunityId = i;
                oli.PricebookEntryId = onePB.Id;
               // oli.Product2Id = onePro.Id;
                oli.Quantity = 30;
                oli.TotalPrice= 30000;
                
                oliList.add(oli);
            }
            
            if(!oliList.isEmpty()){
                insert oliList;
            }
        }
        catch(Exception e){
            System.debug(e.getMessage());
        }
    }
}