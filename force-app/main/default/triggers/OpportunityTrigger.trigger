trigger OpportunityTrigger on Opportunity (before insert,before update,After insert, After update) {
    if(Trigger.isInsert && Trigger.isAfter){
        if(stopRecurstion.isFirstTime){
            stopRecurstion.isFirstTime = False;
           
            //OpportunityTriggerHandler.taskSheet41(Trigger.new);
        }
    }
}