trigger CourseTrigger on Course__c (before insert,before Update) {
    if(Trigger.isUpdate && Trigger.isBefore){
       // ScenerioBasedQuestion1.question1(Trigger.new,Trigger.old);
    }
}