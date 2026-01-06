trigger LeadCreationGoogleSheet on Lead (after insert, after update, before delete) {
    if ((Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))) {
        GoogleSheetSyncHandler.syncToGoogleSheet('Lead', new List<Id>(Trigger.newMap.keySet()));
    } else if (Trigger.isBefore && Trigger.isDelete) {
        
        GoogleSheetSyncHandler.deleteFromGoogleSheet('Lead', new List<Id>(Trigger.oldMap.keySet()));
    }
}