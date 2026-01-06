trigger ProductCreationGoogleSheet on Product2 (before insert,after insert, after update, before delete) {
	if ((Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))) {
        GoogleSheetSyncHandler.syncToGoogleSheet('Product2', new List<Id>(Trigger.newMap.keySet()));
    } else if (Trigger.isBefore && Trigger.isDelete) {
        
        GoogleSheetSyncHandler.deleteFromGoogleSheet('Product2', new List<Id>(Trigger.oldMap.keySet()));
    }
}