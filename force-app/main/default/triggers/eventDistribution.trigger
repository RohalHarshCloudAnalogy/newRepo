trigger eventDistribution on Event_Distribution__c (before insert,before update) {
    if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore){
        //AccountTriggerHandler.que71(Trigger.new);
    }
}