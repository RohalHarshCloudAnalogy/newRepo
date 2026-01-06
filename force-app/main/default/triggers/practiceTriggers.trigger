trigger practiceTriggers on Case (before insert, After insert) {
    if(Trigger.isbefore && Trigger.isInsert){
        //practice.trigger1(Trigger.new);
    }
}