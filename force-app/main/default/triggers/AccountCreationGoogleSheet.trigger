trigger AccountCreationGoogleSheet on Account (before insert,after insert, after update, before delete) {
	if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter){
        List<Id>accId = new List<Id>();
        for(Integer i=0;i<Trigger.new.size();i++){
            accId.add(Trigger.new[i].Id);
            System.debug('Trigger is running');
        }
        //GoogleSheetSyncHandler.syncToGoogleSheet('Account', new List<Id>(Trigger.newMap.keySet()));
    }
    
    else if(Trigger.isDelete && Trigger.isBefore){
        
        // GoogleSheetSyncHandler.deleteFromGoogleSheet('Account', new List<Id>(Trigger.oldMap.keySet()));
    }
}