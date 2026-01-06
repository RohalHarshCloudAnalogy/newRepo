trigger GrandCHild on GrandChild__c (After insert) {
    if(Trigger.isInsert && Trigger.isAfter ){
        GrandChildTriggerHandler.totalGC(Trigger.new);
    }
}