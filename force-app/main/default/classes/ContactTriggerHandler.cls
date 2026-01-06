public class ContactTriggerHandler {
    public static void sendEmailContact(List<Contact>newList){
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        
        for(Contact con:newList){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String>sendTo = new List<String>();
            sendTo.add(con.Email);
            mail.setToAddresses(sendTo);
            mail.setSubject('New contact created');
            mail.setPlainTextBody('Hi,'+con.LastName+'New contact has been created');
            mailList.add(mail);
        }
        Messaging.sendEmail(mailList);
        
    }
    
    public static void createContactRelationship(List<Contact>newList){
        List<Contact_Relationship__c>insertField = new List<Contact_Relationship__c>();
        for(Contact con: newList){
            if(con.Contact_Relationship__c){
                Contact_Relationship__c cR = new Contact_Relationship__c();
                cR.Name = 'New CR';
                cR.Contact__c = con.Id;
                insertField.add(cR);
                System.debug(cR);
            }
            
        }
        insert insertField;
    } 
    
    
    
    
    
    public static void updateTotalContactCount(List<Contact>newList){
        List<Id>listid = new List<Id>();
        for(Contact con:newList){
         	listid.add(con.AccountId);
        }
        List<AggregateResult>ls = [Select AccountId, Count(Id) Total_Count from Contact Where AccountId!=NULL  and AccountId In:listid Group By AccountId];
        List<Account>accdata = [Select Id, Contact_Count__c from Account Where Id IN:listid];
            
        Map<Id, Integer>mapp = new Map<Id,Integer>();
        for(AggregateResult ar:ls){
            mapp.put((Id)ar.get('AccountId'), (Integer)ar.get('Total_Count'));
        }
        for(Account acc:accdata){
            acc.Contact_Count__c = mapp.get(acc.Id);
        }
       update accdata;
	}
    
    
    
    public static void updateAccountOtherPhone(List<Contact>newList){
       
        
        for(Contact con:newList){
            if(con.AccountId != NULL){
                List<Account> accList = [Select Id, Phone from Account Where Id = :con.AccountId];
                con.OtherPhone = accList[0].Phone;
            }
            
        }
         
    }
    
    
    
    public static void updateParentAccountDescription(List<Contact>newList, List<Contact>oldList){
        for(Integer i=0;i<newList.size();i++){
            if(newList[i].Description != oldList[i].Description){
                Id accId = newList[i].AccountId;
                Account acc = [Select Id,Description from Account Where Id = :accId ];
                acc.Description = newList[i].Description;
                update acc;
            }
            
        }
    }
    
    public static void checkDuplicate(List<Contact>newList){
        for(Contact con:newList){
         
            List<Contact>conList = [Select Email,Phone,MobilePhone from Contact Where Email =:con.Email OR Phone = :con.Phone OR MobilePhone =: con.MobilePhone];
            if(conList.size()>0){
                con.addError('Can not create duplicate Contact');
            }
        }
    }
    
    public static void checkCountOfContact(List<Contact>newList){
        try{
            List<Id>idList = new List<Id>();
            for(Contact con:newList){
                idList.add(con.AccountId);
            }
            List<AggregateResult>conList = [Select AccountId,Count(Id) Total_Count from Contact Where AccountId IN: idList Group by AccountId];
            Map<Id,Integer>mapp = new Map<Id,Integer>();
            for(AggregateResult con:conList){
                mapp.put((Id)con.get('AccountId'),(Integer)con.get('Total_Count'));
            }
            
            for(Contact con:newList){
                if(mapp.get(con.AccountId) >=2){
                    con.addError('Cant create more than two contact');
                }
            }
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    
    
    public static void preventDuplicate(List<Contact>newList){
        try{
			Set<String>emailSet = new Set<String>();
            Set<String>phoneSet = new Set<String>();
            for(Contact con: newList){
                if(con.Email!=NULL){
                    emailSet.add(con.Email);
                }
                if(con.Phone!=NULL){
                    phoneSet.add(con.Phone);
                }
            }
            
            List<Contact>existingContact = [Select Id, Email, Phone from Contact Where Email IN:emailSet OR Phone IN: phoneSet];
            
            for(Contact excon: existingContact){
                for(Contact con: newList){
                    if(excon.id == con.id) continue;
                    if(con.Email !=NULL && excon.Email == con.Email || con.Phone!=NULL && excon.Phone == con.Phone){
                        con.addError('Duplicate Contact found');
                    }
                }
            }
        }
        catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    
    public static void createAccount(List<Contact>newList){
        List<Account>insertAcc =new List<Account>();
        for(Contact con: newList){
            if(con.AccountId == NULL){
                Account acc  = new Account();
                acc.Name = con.LastName;
                insertAcc.add(acc);
            }
        }
        Map<String,Id>mapp  = new Map<String,Id>();
        if(!insertAcc.isEmpty()){
            insert insertAcc;
            for(Account acc: insertAcc){
                mapp.put(acc.Name, acc.Id);
            }
        }
        for(Contact con: newList){
            if(con.AccountId == NULL){
                con.AccountId = mapp.get(con.LastName);
            }
        }
        
    }
    
    public static void putSumAmountInAccount(List<Contact>newList){
        List<Id>accId = new List<Id>();
        for(Contact con: newList){
            if(con.AccountId != NULL){
                accId.add(con.AccountId);
            }
        }
        List<Account>accList = [Select Id, Total_Opportunity_Amount__c from Account Where Id IN:accId];
        
        List<AggregateResult>maxAmnt = [Select AccountId, Sum(Amount) Total_Amount from Opportunity Where AccountId IN : accId Group by AccountId];
        
        Map<Id,Decimal>mapp = new Map<Id,Decimal>();
        
        for(AggregateResult aR: maxAmnt){
            mapp.put((Id)aR.get('AccountId'), (Decimal)aR.get('Total_Amount'));
            
        }
        
        for(Account acc: accList){
            acc.Total_Opportunity_Amount__c = mapp.get(acc.Id);
        }
        update accList;
        
        
        
    }
    
    
    public static void que65(List<Contact>newList){
        System.debug(1);
        set<Id>accId = new Set<Id>();
        for(Contact con: newList){
            if(con.AccountId != NULL){
                accId.add(con.AccountId);
            }
        }
        
        List<Account>accList = new List<Account>();
        for(Id i: accId){
            Account acc = new Account();
            acc.Id= i;
            acc.Contact_Created__c = True;
            accList.add(acc);
        }
        update accList;
        System.debug(accList);
    }
    
    
    public static void q1(List<Contact>conList){
      
        Map<String,Contact>mapp = new Map<String,Contact>();
        for(Contact con: conList){
            if(con.Email != NULL){
           
                mapp.put(con.Email,con);
            }
        }
        System.Debug(mapp);
        List<contact>duplicateCon = [Select Id, Email from Contact Where Email IN: mapp.keySet()];
        List<String>emailList  = new List<String>();
        List<Contact>updateCon = new List<Contact>();
        for(Contact con: duplicateCon){
            con.FirstName = mapp.get(con.Email).FirstName;
            con.LastName = mapp.get(con.Email).LastName;
            updateCon.add(con);
            emailList.add(con.Email);
        }
        System.debug(updateCon);
        if(!updateCon.isEmpty()){
            update updateCon;
        }
        List<Id>DeleteCon = new List<Id>();
        for(Contact con: conList){
            if(emailList.contains(con.Email)){
                //con.addError('Duplicate');
                DeleteCon.add(con.Id);
            }
        }
        List<Contact> lastCon = [Select Id from Contact Where Id In: DeleteCon];
        if(!DeleteCon.isEmpty()){
            Delete lastCon;
        }
    }  
    
    
    public static void rajatInterview2(List<Contact>newConList , Map<Id,Contact>oldMap){
		List<Id>accId = new List<Id>();
        for(Contact con: newConList){
            accId.add(con.AccountId);
            
            if(oldMap!=NULL && oldMap.containsKey(con.Id)){
                if(oldMap.get(con.Id).AccountId != con.AccountId && oldMap.get(con.Id).AccountId !=NULL){
                    accId.add(oldMap.get(con.Id).AccountId);
                }
            }
        }
        
        List<Account>allAcc = [Select Id, No_of_Contacts__c ,(Select Id from Contacts) from Account Where Id IN: accId];
        
        for(Account acc: allAcc){
            acc.No_of_Contacts__c = acc.Contacts.size();
        }
        
        update allAcc;
        
    }
    
    
    public static void brainOne1(List<Contact>conList){
        set<string>emails = new set<string>();
        for(Contact con: conList){
            emails.add(con.Email);
        }
        
        List<Contact>duplicateConList = [Select Email from Contact Where Email IN: emails];
        
        List<String>emailList = new List<String>();
        for(Contact con: duplicateConList){
            emailList.add(con.Email);
        }
        for(Contact con: conList){
            if(emailList.contains(con.Email)){
                con.addError('cant insert');
            }
        }
        
        
        
    }
    
    public static void updateAccountWithNoOfContact(List<Contact>conList , Map<Id, Contact>oldMap){
        System.debug(1);
        set<Id>accId = new set<Id>();
        for(Contact con:conList){
            if(con.AccountId != NULL){
                accId.add(con.Accountid);
            }
            System.debug(2);
            if(oldMap != NULL && oldMap.get(con.Id).AccountId != con.AccountId && oldMap.get(con.Id).AccountId != NULL){
                accId.add(oldMap.get(con.Id).AccountId);
            }
        }
        List<Account>accList = [Select Name, No_of_Contacts__c ,(Select Name from Contacts) from Account Where Id IN: accId ];
        System.debug(accList);
        for(Account acc: accList){
            acc.No_of_Contacts__c = acc.Contacts.size();
            System.debug(acc.No_of_Contacts__c);
        }
        update accList;
        
    }
}