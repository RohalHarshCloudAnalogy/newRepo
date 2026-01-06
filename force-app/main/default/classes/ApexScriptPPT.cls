public class ApexScriptPPT {
    public static void changePhoneNumber(){
        List<Contact> con = [Select Account.Name ,Name, Phone, Account.Phone from Contact Where Account.Name != NULL];
        for(Contact i : con){
            i.Phone = i.Account.Phone;
        }
        update con;
    }
    
    public static void fetchAccount(){
        List<Account>acc = [Select Name from Account Where Id In(Select AccountId from Contact)];
        for(Account i: acc){
            System.debug(i.Name);
        }
    }
    
    
    public static void fetchAccountWithNoContact(){
        List<Account>acc = [Select Name from Account Where Id Not In (Select AccountId from Contact)];
        for(Account i:acc){
            System.debug(i.Name);
        }
    }
    
    
    
    
    
    public static void fun4(){
        List<AggregateResult>acc = [Select Account.Name , Count(Id) from Contact Group by Account.Name];
        for(AggregateResult i: acc){
            System.debug(i);
        }
    } 
    
    public static void fun5(){
        List<Account> acc = [Select Name, (Select Name from Opportunities) from Account Where Id IN (Select AccountId from Contact)];
        Map<String,List<Opportunity>> mapp  = new Map<String, List<Opportunity>>();
        for(Integer i=0;i<acc.size();i++){
            mapp.put(acc[i].Name,acc[i].Opportunities);
        }
        for(String key : mapp.keySet()){
            System.debug(key + '   '+ mapp.get(key));
        }
     
    }
    
    public static void fun6(){
        List<Opportunity>opp = [Select Account.Name , Name, StageName from Opportunity Where Account.Name != NULL AND StageName = 'Closed Won'];
        for(Integer i=0;i<opp.size();i++){
            System.debug(opp[i].Account.Name + '      '+opp[i].Name +'      '+opp[i].StageName);
        }
    }
    
    public static void fun7(){
        List<AggregateResult> opp = [Select Account.Name , Count(Id) 
                                 from Opportunity 
                                 Where StageName = 'Closed Won' And Account.Name != null 
                                 GROUP BY Account.Name order by Account.Name
                                ];
        for(AggregateResult i:opp){
            System.debug(i);
        }
        
    }
    
    public static void fun8(){
        List<Account>opp = [Select Name,(select Stagename from Opportunities) from Account
								where Id Not IN 
								(Select AccountId  from Opportunity Where StageName != 'CLosed Won') and Id In (Select AccountId from Opportunity) 
        ];
        
        for(Account i:opp){
            System.debug(i);
        }
    }
    
    public static void fun9(){
        List<Account>opp = [ Select Name  from Account 
							Where Id Not In (Select AccountId from Opportunity Where StageName != 'Closed Won' and StageName != 'Closed Lost')
 							AND Id In (Select AccountId from Opportunity)
        				  ];
        
        for(Account i:opp){
            System.debug(i);
        }
    }
    
    public static void fun10(){
        List<AggregateResult> acc = [Select Count_Distinct(AccountId) from Opportunity Where StageName = 'Closed Won' And CloseDate = Last_Year];
        for(AggregateResult i: acc){
            System.debug(i);
        }
    }
    
    public static void fun11(){
        List<Opportunity>opp = [Select Name from Opportunity Where Probability != 0];
        for(Opportunity i: opp){
            system.debug(i);
        }
    }
    
    public static void fun12(){
        List<Opportunity> opp = [Select Name,Description, StageName from Opportunity Where CreatedDate = Last_WEEK];
        for(Opportunity i:opp){
            if(i.StageName == 'Closed Won'){
                i.Description = 'Opportunity is closed Won';
            }
            else if(i.StageName == 'Closed Lost'){
                i.Description = 'Opportunity is closed Lost';
            }
        }
        update opp;
    }


    public static void q14(){
        List<AggregateResult>data = [Select AccountId , Count(Id) Total_Count from Contact Where AccountId!=NULL Group by AccountId];
        List<Account>acc = [Select Id , Contact_Count__c from Account Where ID!=NULL];
        Map<Id,Integer> mapp = new Map<Id,Integer>();
        for(AggregateResult c:data){
            mapp.put((Id)c.get('AccountId'), (Integer)c.get('Total_Count'));
        }
        for(Account a:acc){
            a.Contact_Count__c = mapp.get(a.Id);
        }   
        update acc;
    }    
    
    
    
    
    
    
    
}