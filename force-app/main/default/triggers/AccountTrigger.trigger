trigger AccountTrigger on Account(before Insert, After Insert,before delete, Before Update, After Update){
    if(Trigger.isBefore && Trigger.isInsert){
        AccountTriggerHandler.queTaskSheet17(Trigger.new); 
    }
}