trigger ContactCreationGoogleSheet on Contact (before insert,after insert, after update, before delete) {
	if ((Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))) {
        GoogleSheetSyncHandler.syncToGoogleSheet('Contact', new List<Id>(Trigger.newMap.keySet()));
    } else if (Trigger.isBefore && Trigger.isDelete) {
        List<String> emails = new List<String>();
        for (Contact l : Trigger.old) {
            emails.add(l.Email);
        }
        GoogleSheetSyncHandler.deleteFromGoogleSheet('Contact', new List<Id>(Trigger.oldMap.keySet()));
    }
}