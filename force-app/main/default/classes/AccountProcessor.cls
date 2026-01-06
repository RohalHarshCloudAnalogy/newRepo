public class AccountProcessor {
	@future
    public static void countContacts(List<Id>accid){
        System.debug(1);
        List<Account>accList = [Select Id , (select Id from Contacts) from Account Where Id in:accId];
        for(Account acc: accList){
          
            acc.Total_Contact_Count__c = acc.Contacts.size();
        }
        if(!accList.isempty()){
            update accList;
            
        }
        
    }
    
    @future
    public static void countCase(List<Id>accIds){
        List<AggregateResult>caseRecord = [Select AccountId , Origin, Count(Id) Total_Count from Case Group by AccountId, Origin];
		Map<Id, Account> accMap = new Map<Id, Account>();
        for(AggregateResult cs: caseRecord){
            Id accId = (Id)cs.get('AccountId');
            String origin = (String)cs.get('Origin');
            Integer count = (Integer)cs.get('Total_Count');
    
            // If account already in map, use it. Otherwise create new one.
            Account acc;
            if (accMap.containsKey(accId)) {
                acc = accMap.get(accId);
            } else {
                acc = new Account(Id = accId);
            }

            if (origin == 'Email') {
            acc.Email_Case__c = count;
            } else if (origin == 'Phone') {
                acc.Phone_Case__c = count;
            } else if (origin == 'Web') {
                acc.Web_Case__c = count;
            }
            accMap.put(accId,acc);
            System.debug(acc);
        }
        update accMap.values();

    }
    
    
}