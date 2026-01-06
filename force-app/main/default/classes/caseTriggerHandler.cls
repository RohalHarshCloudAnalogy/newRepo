public class caseTriggerHandler {
	public static void insertCaseNumber(List<Case>newList){
        List<Account>acc = [Select Id from Account];
        for(Case nc:newList){
            for(Account i:acc){
                if(nc.AccountId == i.Id){
                    i.Latest_Case_Inserted__c = nc.CaseNumber;
                    break;
                }
        	}
        }
        update acc;
    }
    
    public static void udpateAccountRating(List<Case>newList){
        List<Id>accId = new List<Id>();
        for(Case cs: newList){
            accId.add(cs.AccountId);
        }
        List<Account>accList = [Select Id,Rating from Account Where Id IN: accId];
        
        List<AggregateResult>allCase = [Select AccountId, Count(Id) Total_Count from Case Where Status = 'Closed' Group By AccountId];
        Map<Id,Integer>mapp = new Map<Id,Integer>();
        for(AggregateResult cs: allCase){
            mapp.put((Id)cs.get('AccountId'), (Integer)cs.get('Total_Count'));
        }
        
        for(Account acc: accList){
            if(mapp.get(acc.Id)<= 2){
                acc.Rating = 'Cold';
            }
            else if(mapp.get(acc.Id)<6){
                acc.Rating = 'Warm';
            }
            else{
                acc.Rating  ='Hot';
            }
        }
        update accList;
    }
    
    public static void udpateAccount(List<Case>newList){
        List<Id>accId = new List<Id>();
        for(Case i : newList){
            if(i.AccountId != NULL){
                accId.add(i.Accountid);
            }
        }
        List<Account>accList =[Select Id from Account Where Id IN:accid];
        
        List<AggregateResult>casesStatusData = [Select AccountId ,Status, Count(Id) Total_Count from Case Where AccountId IN: accId group by AccountId , Status];
        Map<Id,Map<String,Integer>>mapp = new Map<Id, Map<String,Integer>>();
        for(AggregateResult i: casesStatusData){
            if(!(mapp.containsKey((Id)i.get('AccountId')))){
                mapp.put((Id)i.get('AccountId'), new Map<String,Integer>());
                
            }
            mapp.get((Id)i.get('AccountId')).put((string)i.get('Status'),(Integer)i.get('Total_Count'));
        }
        
        for(Account acc: accList){
            acc.Number_of_New_Cases__c = mapp.get(acc.Id).get('New');
            acc.Number_of_Working_Cases__c = mapp.get(acc.Id).get('Working');
            acc.Number_of_Escalated_Cases__c = mapp.get(acc.Id).get('Escalated');
        }
        update accList;
        
    }
    
    public static void udpateAccountAndTask(List<Case>newList){
        Map<Id,List<String>>mapp = new Map<Id,List<String>>();
        for(Case i: newList){
            mapp.put(i.AccountId, new List<String>());
            mapp.get(i.AccountId).add(i.CaseNumber);
            mapp.get(i.AccountId).add(i.Status);
        }
        
        List<Account>accList = [Select id,Description from Account Where Id IN:mapp.keySet()];
        for(Account acc:accList){
            acc.Description = mapp.get(acc.Id)[0]+mapp.get(acc.Id)[1];
        }
        update accList;
        List<Task>taskList = [Select AccountId,Status from Task Where AccountId IN: mapp.keySet()];
        for(Task t: taskList){
            t.Status = mapp.get(t.AccountId)[1];
        }
        
        update taskList;
    }
    
    public static void handleAfterUpdate(List<Case>caseList){
        List<Contact>contactList = new List<Contact>();
        for(Case c: caseList){
            if(c.ContactId == NULL){
               Contact con = new Contact();
                System.debug(con.Id);
                c.ContactId = con.Id;
                con.LastName = 'newConCONCOCn';
               contactList.add(con); 
            }
        }
        
        insert contactList;   
    }
    
    
   
    
}