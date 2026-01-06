trigger CaseTrigger on Case (before insert,After insert,After update) {
	if(Trigger.isBefore && Trigger.isInsert){
        caseTriggerHandler.handleAfterUpdate(Trigger.new);
    }
}