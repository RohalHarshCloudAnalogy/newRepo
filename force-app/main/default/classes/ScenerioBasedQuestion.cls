public with sharing class ScenerioBasedQuestion {
    public static void deleteRecord() {
        List<Contact>conList = new List<Contact>();

        
        //Question 1 : Suppose there are 10 duplicate records in an object and you want to delete 9 records and retain the latest record, how would you do it?u
      
        List<Contact>accRecord = [Select Id from Contact Where Name Like 'Akshat%' ORDER BY CreatedDate DESC LIMIT 9 OFFSET 1];
        if(!accRecord.isEmpty()){
            delete accRecord;
        }

    }
}