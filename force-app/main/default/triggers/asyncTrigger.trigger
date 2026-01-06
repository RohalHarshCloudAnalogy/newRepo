trigger asyncTrigger on Task (After Update) {
    if(Trigger.isAfter && Trigger.isUpdate){
        //asyncClass.handleTaskCheckBoxUpdate(Trigger.new);
    }
}