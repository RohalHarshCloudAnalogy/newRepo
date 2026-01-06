public class AccountTriggerHandler {
    public static void updateAcc(List<Account> newList){
        for(Account acc: newList){
            acc.Description = 'This is  update trigger class';
        }
    }
    
    
    public static void createAccContact(List<Account> newList){
        
       List<Contact>con = new List<Contact>();
        for(Account acc: newList){
                
            Contact nc = new Contact();
            nc.LastName = acc.Name;
            nc.AccountId = acc.Id;
            nc.Phone = acc.Phone;
            con.add(nc);
                
           
           }
            insert con;
            
        }
    
    
    public static void insertRating(List<Account>newList){
        
        for(Account acc:newList){
            if(acc.Industry != NULL && acc.Industry == 'Media'){
                acc.Rating = 'Hot';
            }
            else{
                acc.Rating= 'Cold';
            }
        }
        
    }
    
    public static void stopDelition(List<Account>newList){
        for(Account acc:newList){
            if(acc.Active__c == 'Yes'){
                acc.adderror('Cant delete Active Account');
            }
        }
    }
    
 
    public static void checkRelatedContacts(List<Account>newList){
        Set<Id> accountIdSet = new Set<Id>();
        for(Account acc: newList){
            accountIdSet.add(acc.Id);
        }
        
        Map<Id,Account> accountMap = new Map<Id,Account>([Select Id, Name,(Select Id From Contacts) from Account where Id in : accountIdSet]);
        for(Account acc: newList){
            if(accountMap.get(acc.Id).Contacts.size() > 0){
                acc.addError('Can not delete this account');
            }
        }
    }
    //sending mail
    public static void sendMailOnAccountDelete(List<Account>oldList){
        try{
            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
            List<Id>accId = new List<Id>();
            for(Account acc: oldList){
                accId.add(acc.Id);
            }
            
            Map<Id,String> storeAccOwnerEmail  = new Map<Id,String>();
            
            List<Account>newl = [Select Id, Owner.Email from Account Where Id In:accId];
            for(Account i: newl){
                storeAccOwnerEmail.put(i.id, i.Owner.Email);
            }
            System.debug(storeAccOwnerEmail);
            for(Account acc: oldList){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String>allEmail = new List<String>();
                allEmail.add(storeAccOwnerEmail.get(acc.Id));
              
                mail.setToAddresses(allEmail);    // it contais list ok, remember it
                
                mail.setSubject('Account Deleted');
                mail.setPlainTextBody('Hi'+acc.Name+'This Account Has Been Deleted');
                mailList.add(mail);
            }
            Messaging.sendEmail(mailList);
        }
        Catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    

    public static void question10(List<Account>newList){
        try{
            for(Account acc: newList){
            if(acc.Industry == NULL){
                acc.addError('Cant Create');
            }
            else if(acc.Industry == 'Media'){
                acc.Rating = 'Hot';
            }
            else{
                acc.Rating = 'Cold';
            }
            
        }
        }catch(Exception e){
            System.debug(e.getMessage());
        }
        
    }
    
    
    
    
    public static void question10_2(List<Account>newList,List<Account>oldList){
        
        
        for(Integer i=0;i<newList.size();i++){
            if(newList[i].Phone != oldList[i].Phone){
                newList[i].Description = 'Phone updated Successfully';
            }
            else{
                newList[i].addError('change the phone value');
            }
        }
        
    }
    
    public static void question10_3(List<Account>oldList){
        for(Account acc:oldList){
            if(acc.Active__c == 'Yes'){
                acc.addError('Cant delete active account');
            }
   
        }
    }
    
    public static void question10_4(List<Account>newList){
        List<Opportunity>newOpp = new List<Opportunity>();
        for(Account acc:newList){
            if(acc.Active__c == 'No'){
                acc.addError('Make it active');
            }
            else{
                Opportunity opp = new Opportunity();
                opp.AccountId = acc.Id;
                opp.Name = acc.Name;
                opp.StageName = 'Closed Won';
                opp.CloseDate = System.Today();
                newOpp.add(opp);
            }
        }
        Insert newOpp;
    }
    public static void stopCreationOfAccountHavingContact(List<Account>newList){
        for(Account acc:newList){
     		List<Contact>conList =[Select Id from Contact Where AccountId =:acc.Id];
            if(conList.size()>0){
                acc.addError('Account can not be deleted');
            }
        }
    }
    
    public static void question23(){
        List<Account>accList = [Select Name, Id from Account Where Working__c IN ('ASIA')];
        List<Id>accId = new List<Id>();
        for(Account acc:accList){
			   accId.add(acc.Id);
        }
        List<AggregateResult>sumOfProduct = [Select Sum(TotalOpportunityQuantity) totalsum from Opportunity Where AccountId IN: accId];
        for(AggregateResult i: sumOfProduct){
            System.debug((Double)i.get('totalsum'));
        }
        
    }
    
    public static void updateAccountRep(List<Account>newList){
        List<Id>accId = new List<Id>();
        for(Account acc: newList){
            accId.add(acc.OwnerId);
        }
        
        List<User>usrData = [Select Id, Name from User Where Id IN: accId];
		Map<Id,String>mapp = new Map<Id,String>();
        for(User i: usrData){
            mapp.put(i.Id,i.Name);
        }
        for(Account acc: newList){
            acc.Sales_Rep__c = mapp.get(acc.OwnerId);
        }
    }

    public static void updateOpportunity(List<Account>newList){
        List<Id>accId = new List<Id>();
        for(Account acc: newList){
        	accId.add(acc.Id);
        }
        
        List<Opportunity>allOpp = [Select Id from Opportunity Where StageName != 'Closed Won' and CreatedDate < Last_N_Days:30 And AccountId IN:accId ];
        
        for(Opportunity opp: allOpp){
            opp.StageName = 'Closed Lost';
        }
        update allOpp;
        
    }    
    
    public static void updateShippingAddressOfAccount(List<Account>newList){
        System.debug(newList);
        for(Account acc: newList){
            if(acc.BillingCity != NULL){
               
                acc.ShippingCity = acc.BillingCity;
                acc.ShippingCountry = acc.BillingCountry;
                acc.ShippingPostalCode =acc.BillingPostalCode;
                acc.ShippingState = acc.BillingState;
                acc.ShippingStreet = acc.BillingStreet;
                
                System.debug(acc);
            }
        }
    }
    
    
    public static void sendEmailToSystemAdmin(List<Account>newList){
        List<Messaging.SingleEmailMessage>mailList = new List<Messaging.SingleEmailMessage>();
        
        List<User>adminUser = [Select Id, Email from User Where Profile.Name = 'System Administrator' Limit 1];
        if(!adminUser.isEmpty()){
            List<String>adminEmail = new List<String>{adminUser[0].Email};
            for(Account acc: newList){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(adminEmail);
                mail.setSubject('New Account Created');
                mail.setPlainTextBody('An account has been created and the name is'+ acc.Name);
                mailList.add(mail);
            }
        }
        
        Messaging.sendEmail(mailList);   
    }
    
    public static void createClientContact(List<Account>newList){
        try{
            List<Contact>conList = new List<Contact>();
            Map<Id,Id>mapp = new Map<Id,Id>();
            for(Account acc: newList){
               
                Contact con = new Contact();
                con.Accountid = acc.id;
                con.LastName = acc.Name;
                conList.add(con);
            }
            
            if(!conList.isEmpty()){
                insert conList;
                for(Contact con: conList){
                    mapp.put(con.AccountId, con.Id);
                }
            }
            List<Account>accList = new List<Account>();
            for(Account acc: newList){
                Account acnt = new Account();
                acnt.id = acc.Id;
                acnt.Client_Contact__c = mapp.get(acc.Id);
                accList.add(acnt);
            }
            if(!accList.isempty()){
                update accList;
            }
            
        } 
        catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    
    public static void updateContact(List<Account>newList,List<Account>oldList){
        System.debug(newList);
        List<Id>accIds = new List<Id>();
		Map<Id,String>mapp = new Map<Id,String>();        
        for(Integer i=0;i<newList.size();i++){
            if(newList[i].Type != oldList[i].Type){
                accIds.add(newList[i].Id);
                mapp.put(newList[i].Id, newList[i].Name);
            }
        }
        System.debug(mapp);
        
        List<Messaging.SingleEmailMessage>mailList = new List<Messaging.SingleEmailMessage>();
        List<Contact>conEmail = [Select AccountId, Email from Contact Where AccountId IN:accIds and Email!=NULL];
		System.debug(conEmail);
        for(Contact con:conEmail){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String>email = new List<String>();
            email.add(con.Email);
            mail.setToAddresses(email);
            mail.setSubject('Account Update info');
            String body = 'Your Account information has been updated successfully <br> Account Name: '+mapp.get(con.AccountId);
            mail.setHTMLBody(body);
            mailList.add(mail);
        }
        System.debug(mailList);
        Messaging.sendEmail(mailList);
    }
    
    
    
    
    
    
    public static void closeOpportunity(List<Account>newList){
        List<Id>accId = new List<Id>();
        for(Account acc: newList){
            if(acc.Close_All_Opportunities__c){
                accId.add(acc.Id);
            } 
        }
        
        List<Opportunity>oppList = [Select Name, StageName,Probability from Opportunity Where AccountId IN:accId];
        for(Opportunity opp: oppList){
            if(opp.Probability > 70){
                opp.StageName = 'Closed Won';
            }
        }
        update oppList;
    }
    
    public static void DeleteOpportunity(List<Account>newList){
        List<Id>accId = new List<Id>();
        for(Account acc: newList){
            if(acc.Status__c == 'InActive'){
                accId.add(acc.Id);
            }
        }
        
        List<Opportunity>oppList = [Select Id from Opportunity Where AccountId IN: accId];
        delete oppList;
        
        List<Contact>conList = [Select Id, Do_Not_Contact__c from Contact Where AccountId IN: accId];
        for(Contact con:conList){
            con.Do_Not_Contact__c = True;
        }
        update conList;
    }
    
    
    	public static void udpateContactMailingCity(List<Account>newList){
        Map<Id,String>accMap = new Map<Id,String>();
        for(Account acc: newList){
            accMap.put(acc.Id,acc.BillingCity);
        }
        
        
        List<Contact>conList = [Select AccountId,MailingCity from Contact Where AccountId IN:accMap.keySet()];
        
        for(Contact con: conList){
            con.MailingCity = accMap.get(con.AccountId);
        }
        update conList;
    }
    
    
    public static void createContact(List<Account>newList){
        Map<Id,Id>mapp  = new Map<Id,Id>();
        List<Contact>conList = new List<Contact>();
        for(Account acc: newList){
            Contact con = new Contact();
            con.AccountId = acc.Id;
            con.LastName = 'NewCon';
            conList.add(con);
        }
        if(!conList.isEmpty()){
            insert conList;
            for(Contact con: conList){
                mapp.put(con.AccountId, con.Id);
            }
        }
        List<Account>accList = new List<Account>();
        for(Account acc: newList){
            Account newAc = new Account();
            newAc.Id = acc.Id;
            newAc.Client_Contact__c = mapp.get(acc.Id);
            accList.add(newAc);
        }
        update accList;
        
    }
    
    public static void createContactAndUpdateOnlyDefaultContactCheckBox(List<Account>newList){
        List<Contact>conList = new List<Contact>();
        List<AggregateResult>accWithCount = [Select AccountId from Contact Group by AccountId Having Count(Id)>1];
        List<id>accId = new List<id>();
        for(AggregateResult i: accWithCount){
            accId.add((Id)i.get('AccountId'));
        }
        
        List<Account>accList = [Select Id from Account Where Id IN: accId];
        List<Account>fList = new List<Account>();
        for(Account acc:accList){
            Account a = new Account();
            a.id = acc.Id;
            a.Only_Default_Contact__c = False;
            fList.add(a);
        }
        update fList;
        
        for(Account acc: newList){
            Account newacc = new Account();
            newacc.Id = acc.Id;
            Contact con  = new Contact();
            con.AccountId = acc.Id;
            con.FirstName = 'Info';
            con.LastName = 'Default';
            con.Email = 'info@websitedomain.tld';
            newacc.Only_Default_Contact__c = True;
            accList.add(newacc);
            conList.add(con);
        }
        
        insert conList;
        
		update accList;        
    }
    
    
    
    public static void que66(List<Account>newList, List<Account>oldList){
        try{
            System.debug(newList);
            System.debug(oldList);
            Map<Id,String>mapp = new Map<Id,String>();
            List<Id>accId = new List<Id>();
            for(Integer i=0;i<newList.size();i++){
                if(newList[i].BillingStreet != oldList[i].BillingStreet || newList[i].BillingCity != oldList[i].BillingCity ||newList[i].BillingState != oldList[i].BillingState||newList[i].BillingPostalCode != oldList[i].BillingPostalCode||newList[i].BillingCountry != oldList[i].BillingCountry){
                    accId.add(newList[i].Id);
                    mapp.put(newList[i].Id, newList[i].BillingPostalCode);
                }
            }
            List<Contact>conList = [Select AccountId,MailingPostalCode from Contact Where AccountId IN:accId];
            
            Set<Id>accList = new Set<Id>();
            
            for(Contact con:conList){
                System.debug(con.MailingPostalCode);
                if( con.MailingPostalCode != mapp.get(con.AccountId) ){
                    accList.add(con.AccountId);
                }
            }
            List<Account>allAccount = new List<Account>();
            for(Id i:accList){
                Account acc = new Account();
                acc.Id = i;
                acc.Out_of_zip__c = True;
                allAccount.add(acc);
            }
            update allAccount;
            
            System.debug(allAccount);
            
            
            
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
        }
    }
    
    
    public static void que68(List<Account>oldList){
        try{
            DateTime currentTime = DateTime.now();
            for(Account acc: oldList){
                DateTime lastmodifiedTime = acc.LastModifiedDate;
                
                //calculate the time difference
                Integer minuteDifference = Integer.valueOf( currentTime.getTIme()-lastmodifiedTime.getTime())/(1000*60);
                System.debug(minuteDifference);
                if(minuteDifference < 60){
                    acc.addError('Can not update');
                }
                
            }
        }
        catch(Exception e){
            System.debug(e.getMessage());
           
        }
    }
    
    
    public static void stopDeletionOfRelatedContact(List<Account>oldList){
        List<Id>accId = new List<Id>();
        for(Account acc: oldList){
            accId.add(acc.Id);
        }
        List<Contact>conList = [Select AccountId from Contact Where AccountId IN: accId];
        for(Contact con:conList){
            con.AccountId = NULL;
        }
        update conList;
    }
    
    
    public static void que71(List<Event_Distribution__c>newList){
        try{
            Map<Id,Map<Id,Decimal>>mapp =new Map<id,Map<Id,Decimal>>();
            for(Event_Distribution__c eD:newList){
                mapp.put(eD.Event__c, new Map<Id,Decimal>());
                mapp.get(eD.Event__c).put(eD.Id , eD.Distribution__c);
            }
            List<Event__c>eventList = [Select Event_Capacity__c from Event__c Where Id IN: mapp.KeySet()];
            for(Event__c i: eventList){
                if(i.Event_Capacity__c >0){
                    
                }
            }
            
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    
    public static void trigger73(List<Account>accList){
        Set<Id>accId = new Set<Id>();
         Map<Id,String>map1 = new Map<Id,String>();
        for(Account acc:accList){
            if(acc.Website != NULL){
                accId.add(acc.Id);
                map1.put(acc.Id, acc.Website);
            }
        }
        
        List<Contact>conList = [Select AccountId,LastName,FirstName, Profile__c from Contact Where AccountId IN: accId]; 
        for(Contact con:conList){
            String data = map1.get(con.AccountId)+'/';
            if(con.FirstName != NULL){
                data += con.FirstName.substring(0,1)+con.LastName;
            }
            con.Profile__c = data;
        }
        
        update conList;
    }
    
        public static void trigger75(List<Account>accList){
        set<Id>accId = new set<Id>();
        for(Account acc: accList){
            accId.add(acc.Id);
        }
		
        List<Account>allRelatedConOfAcc = [Select Id, (Select Name from Contacts) from Account Where Id IN :accId];
        Map<Id,Integer>map1 = new Map<Id,Integer>();
        for(Account acc: allRelatedConOfAcc){
            map1.put(acc.Id, acc.Contacts.size());
        }
         System.debug(map1);
        
        List<Account>allRelatedDeadConOfAcc = [Select Id, (Select Name from Contacts Where Dead__c = True) from Account Where Id IN :accId ];
        Map<Id,Integer>map2 = new Map<Id,Integer>();
        for(Account acc: allRelatedDeadConOfAcc){
            map2.put(acc.Id, acc.Contacts.size());
        }
         System.debug(map2);
        
            for(Account acc: accList){
               Integer a = map1.get(acc.Id);
               a= (a*70)/100;
               System.debug(a);
                if(map2.get(acc.Id)>=a){
                    acc.need_intel__c = True;
                }
            }
    }
    
    
    public static void exa10(List<Account>newList,List<Account>oldList){
       List<Account>finalList = new List<Account>();
        Map<Id,String>mapp = new Map<Id,String>();
        for(Integer i=0;i<newList.size();i++){
            if(newList[i].Website != oldList[i].Website){
                finalList.add(newList[i]);
                mapp.put(newList[i].Id, newList[i].Website);
            }
        }
        List<Contact>conList = [Select Name,AccountId,Website__c from Contact Where AccountId in : mapp.keyset()];
        for(Contact con:conList){
            con.Website__c = mapp.get(con.AccountId);
        }
        update conList;
        
    }
    
    public static void exa12SMS(List<Account>newList,List<Account>oldList){
        try{
            Map<Id,Integer>mapp  = new Map<Id,Integer>();
            List<Account>finalaccList = new List<Account>();
            for(Integer i=0;i<newList.size();i++){
                if(newList[i].No_of_Contacts__c > oldList[i].No_of_Contacts__c){
                    finalaccList.add(newList[i]);
                    Integer a = Integer.valueof(newList[i].No_of_Contacts__c) - Integer.valueOf(oldList[i].No_of_Contacts__c);
                    mapp.put(newList[i].Id, a);
                }
            }
            List<Contact>conList = new List<Contact>();
            
            for(Account acc: newList){
                for(Integer i=0;i<mapp.get(acc.Id);i++){
                    Contact con = new Contact();
                    con.LastName = 'ajdsfakjsd'+i;
                    con.AccountId = acc.id;
                    conList.add(con);
                }
            }
            if(!conList.isEmpty()){
                insert conList;
            }
            
            
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    
    public static void prac1brain(List<Account>newList){
        List<Id>accId = new List<Id>();
        for(Account acc: newList){
            accId.add(acc.Id);
        }
        List<Account>accList = [Select Id , (Select Id from Contacts) from Account Where Id IN: accId];
        Map<Id,Integer>mapp = new Map<Id,Integer>();
        for(Account acc: accList){
            mapp.put(acc.Id, acc.Contacts.size());
        }
    }
    
    public static void queTaskSheet17(List<Account>accList){
        try{
            set<String>names = new set<String>();
            for(Account acc: accList){
                names.add(acc.Name);
            }
            
            List<Account>accNames = [Select Name from Account Where Name IN:names];
            Set<String>allDupNames = new set<String>();
            for(Account acc: accNames){
                allDupNames.add(acc.Name);
            }
            for(Account acc: accList){
                if(allDupNames.contains(acc.Name)){
                    acc.addError('cant insert');
                }
            }
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }

    
    
}