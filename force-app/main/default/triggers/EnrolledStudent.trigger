trigger EnrolledStudent on Enrolled_Student__c (After update,After insert) {
    if( Trigger.isUpdate && Trigger.isAfter){
        ScenerioBasedQuestion1.question3(Trigger.new);
    }
       
    if( Trigger.isInsert && Trigger.isAfter){
        ScenerioBasedQuestion1.question4(Trigger.new);
    }
    
}