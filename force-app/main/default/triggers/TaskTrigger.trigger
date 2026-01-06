trigger TaskTrigger on Task (before insert) {
    if(Trigger.isInsert && Trigger.isBefore){
        for(Task records : Trigger.New){
            records.Priority = 'High';
        }
    }
}