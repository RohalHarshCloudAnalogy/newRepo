public class EmployeeTriggerhandler {
    public static void decreaseDeleteCount(List<Emplyee__c>newList){
        List<Id>accId = new List<Id>();
        for(Emplyee__c emp: newList){
            accId.add(emp.Account__c);
        }
        
        List<Account>acnt = [Select Id, Deleted_Employee_Count__c from Account Where Id IN:accId];
        for(Account acc: acnt){
            acc.Deleted_Employee_Count__c -=1;
        }
        update acnt;
    }
}