trigger UserTrigger on User(after update) {
    
    if(Trigger.isUpdate && Trigger.isAfter){
        System.debug('Hi akshat');
        UserTriggerHandler.sendEmailToManager(Trigger.new);
    }
}