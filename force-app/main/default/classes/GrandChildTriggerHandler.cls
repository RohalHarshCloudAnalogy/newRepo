public class GrandChildTriggerHandler {
    public static void totalGC(List<GrandChild__c>newList){
        Set<Id>gcId = new Set<Id>();
        for(GrandChild__c i: newList){
            gcId.add(i.Id);
        }
        System.debug(1);
        Map<Id,Integer>mapp = new Map<Id,Integer>();
        List<AggregateResult> totalCount = [Select Child__r.Parent__c parentAcc, Count(Id) totalGCCount from GrandChild__c Where Child__r.Parent__c != NULL group by Child__r.Parent__c];
        System.debug(totalCount);
        for(AggregateResult i: totalCount){
            mapp.put((Id)i.get('parentAcc'), (Integer)i.get('totalGCCount'));
        }
        System.debug(2);
        
        List<Parent__c>pList = [Select Id,Total_GrandChild__c from Parent__c Where Id IN: mapp.keyset() ];
        System.debug(pList);
        for(Parent__c i: pList){
            i.Total_GrandChild__c = mapp.get(i.Id);
        }
        
        update pList;
  
    }
}