trigger ContactTrigger on Contact(before insert ,After Update,After Insert,After Delete) {
    if((Trigger.isAfter && Trigger.isInsert) ||( Trigger.isAfter && Trigger.isUpdate ) || (Trigger.isAfter && Trigger.isDelete)){
		//ContactTriggerHandler.updateAccountWithNoOfContact(Trigger.new,Trigger.oldMap);
    }   
}