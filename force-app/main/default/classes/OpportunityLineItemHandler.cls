public class OpportunityLineItemHandler {
    public static void countOLI(List<OpportunityLineItem>newList){
        Set<Id>oppId = new Set<Id>();
        for(OpportunityLineItem oli : newList){
            oppId.add(oli.OpportunityId);
        }
        Set<Id>accId = new Set<Id>();
        for(Opportunity opp: [Select Id, AccountId from Opportunity Where Id IN: oppId]){
            accId.add(opp.AccountId);
        }
        
        List<AggregateResult>aggResult = [Select Opportunity.AccountId oAI , Count(Id) TotalCount from OpportunityLineItem Where Opportunity.AccountId IN:accId and Opportunity.AccountId != NULL Group By Opportunity.AccountId ];
        System.debug(aggResult);
        
        Map<Id,Integer>mapp = new Map<Id,Integer>();
        for(AggregateResult agr: aggResult){
            mapp.put((Id)agr.get('oAI'),(Integer)agr.get('TotalCount'));
            System.debug(agr.get('oAI'));
        }
        List<Account>allUpdatedAccount = new List<Account>();
        for(Id i: accId){
            Account acc = new Account();
            acc.Id = i;
            acc.Number_of_Products__c = mapp.containsKey(i) ? mapp.get(i):0;
            allUpdatedAccount.add(acc);
        }
        System.debug(mapp);
        update allUpdatedAccount;
    }
    
    
    
    
    
    
    public static void sendEmail(List<OpportunityLineItem>newList){
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        Set<Id>oppId = new Set<Id>();
        for(OpportunityLineItem i: newList){
            oppId.add(i.OpportunityId);
        }
        List<Account>accName = [Select Id, Client_Contact__c from Account Where Id IN (Select AccountId from Opportunity Where Id IN: oppId) And Client_Contact__c != NULL];
        
        for(Account acc: accName){
            //List<String>emailList = new List<String>();
            Contact clientContact = [Select Email from Contact Where Id = :acc.Client_Contact__c LIMIT 1];
            System.debug(clientContact);
            if(clientContact != NULL){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new List<String>{clientContact.Email});
                mail.setSubject('New Product Added');
                mail.setPlainTextBody('New Product has been created');
                mailList.add(mail);
            }     
        }
        Messaging.sendEmail(mailList);
    }
    
    public static void deleteOpportunity(List<OpportunityLineItem>oldList){
        Set<Id>ids = new Set<Id>();
        for(OpportunityLineItem i: oldList){
            ids.add(i.OpportunityId);
        }
        List<Opportunity>oppList = [Select Id from Opportunity Where Id IN:ids];
        System.debug(oppList);
        delete oppList;
    }
    
    public static void insertQuotation(List<OpportunityLineItem>newList){
        List<Id>oppId = new List<id>();
        
        for(OpportunityLineItem oli : newList){
            oppId.add(oli.OpportunityId);
        }
        List<Quote>quoteList = new List<Quote>();
        
        for(Id i : oppId){
            Quote newQ = new Quote();
            newQ.OpportunityId = i;
            newQ.Name = 'New Quote';
            quoteList.add(newQ);
        }
        
        insert quoteList;

    }
    
    
    
    public static void createAsset(List<OpportunityLineItem>newList){
        List<OpportunityLineItem>associatedAccList = [Select Id,Opportunity.AccountId ,Product2Id from OpportunityLineItem Where Id IN :newList And Opportunity.AccountId != NULL];
        
        List<Id>proId = new List<Id>();
        for(OpportunityLineItem olI : associatedAccList){ 
             proId.add(olI.Product2Id);
        }
        List<Contact>conId= [Select Id From Contact Where AccountId != NULL Limit 1];
        List<Asset>assetList = new List<Asset>();
        for(Id i: proId){
        	Asset newA = new Asset();
            newA.Name = 'CloudA';
            newA.Product2Id = i;
            newA.ContactId = conId[0].id;
            assetList.add(newA);
        }
        
        insert assetList;
        
    }
    
    
   /* public static void checkOpp(List<OpportunityLineItem>newList){
        List<Id>oliId = new List<id>();
        for(OpportunityLineItem i: newList){
            oliId.add(i.Id);
        }
        List<OpportunityLineItem>olI = [Select Id, Opportunity.Product_Type__c ,Product2.Family from OpportunityLineItem Where Id IN:oliId];
        System.debug(olI);
        for(OpportunityLineItem i: newList){
            for(OpportunityLineItem j: olI){
                if((i.Id == j.Id) && (j.Opportunity.Product_Type__c != j.Product2.Family)){
                    i.addError('Product Family does not match');
                }
            }
        }
        
    }
    */
    
    public static void deductTotalProQuantity(List<OpportunityLineItem>newList){
        try{
            List<Id>oliId = new List<Id>();
            for(OpportunityLineItem i: newList){
                oliId.add(i.Id);
            }
            List<OpportunityLineItem>olI  = [Select Product2Id , Quantity from OpportunityLineItem Where ID In: oliId];
            Map<Id,Decimal>mapp = new Map<Id,Decimal>();
            for(OpportunityLineItem i: olI){
                mapp.put(i.Product2Id, i.Quantity);
            }
            List<Product2> pro = [Select Id, Available_Quantity__c, Total_Quantity__c from Product2 Where Id IN : mapp.keySet()];
            for(Product2 p: pro){
                p.Available_Quantity__c = p.Total_Quantity__c - mapp.get(p.Id);
                System.debug(p.Available_Quantity__c);
            }
            update pro;
            System.debug(pro);
        }
        catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    
    
    public static void addAssert(List<OpportunityLineItem>newList){
        List<Id>oliId = new List<Id>();
        for(OpportunityLineItem i:newList){
            oliId.add(i.Id);
        }
        List<OpportunityLineItem>accId = [Select Opportunity.AccountId from OpportunityLineItem Where Id IN: oliId];
        List<Asset>assetList = new List<Asset>();
        for(OpportunityLineItem i: accId){
            Asset newAsset = new Asset();
            
            newAsset.AccountId = i.Opportunity.AccountId;
            newAsset.Name = 'AssetNew';
            assetList.add(newAsset);
        }
        insert assetList;
        
    }
    
    
    public static void taskSheet36(List<OpportunityLineItem>oliList){
        try{
            Set<Id>oppId = new set<Id>();
            for(OpportunityLineItem oli: oliList){
                if(oli.OpportunityId != NULL){
                    oppId.add(oli.OpportunityId);
                }
            }
            
            List<Opportunity>oppList = [Select Id, AccountId from Opportunity Where Id IN: oppId];
            set<Id>AccId = new set<Id>();
            for(Opportunity opp: oppList){
                AccId.add(opp.AccountId);
            }
            
            List<AggregateResult>oliCount = [Select Opportunity.AccountId accId  , Count(Id) totalCount from OpportunityLineItem Where Opportunity.AccountId IN: AccId Group By Opportunity.AccountId];
            
            Map<Id,Integer>storeAccIdWithOLICount = new Map<Id,Integer>();
            
            for(AggregateResult i: oliCount){
                storeAccIdWithOLICount.put((Id)i.get('accid'), (Integer)i.get('totalCount'));
            }
            
            List<Account>accList = [Select Id , No_of_Products__c from Account Where Id IN: storeAccIdWithOLICount.keyset()];
            
            for(Account i: accList){
                i.No_of_Products__c = storeAccIdWithOLICount.get(i.Id);
            }
            
            update accList;
        }catch(Exception e){
            System.debug(e.getLineNumber());
            System.debug(e.getMessage());
        }
    }
    
    public static void takSheet63(List<OpportunityLineItem>deletedOLI){
        try{
            Set<Id>oppId = new Set<Id>();
            for(OpportunityLineItem oli: deletedOLI){
                oppId.add(oli.OpportunityId);
            }
            
            List<Opportunity>oppList = [Select Id from Opportunity Where Id IN: oppId];
            if(!oppList.isEmpty()){
                delete oppList;
            }
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    
    
    public static void takSheet44(List<OpportunityLineItem>oliList){
        
        try{
            List<Quote>qList = new List<Quote>();
        for(OpportunityLineItem i: oliList){
            Quote q = new Quote();
            q.OpportunityId  = i.OpportunityId;
            q.Name = 'newq';
            qList.add(q);
            System.debug(q);
        }
        if(!qList.isEmpty()){
            insert qList;
        }
        }
        catch(Exception e){
           System.debug(e.getLineNumber());
           System.debug(e.getMessage());
        }
    }
}