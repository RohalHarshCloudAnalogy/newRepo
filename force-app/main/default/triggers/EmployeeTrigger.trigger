trigger EmployeeTrigger on Emplyee__c (before insert,before delete) {
    if(Trigger.isDelete && Trigger.isBefore){
        EmployeeTriggerhandler.decreaseDeleteCount(Trigger.old);
    }
}