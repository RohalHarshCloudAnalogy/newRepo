public class ScenerioBasedQuestion1 {
    public static void question1(List<Course__c>newCourseList, List<Course__c>oldCourseList){
		Set<Id>studentId = new Set<Id>();
        set<Id>courseid = new set<id>();
        Map<Id,DateTime>instructorId = new Map<Id,DateTime>();
        for(Integer i=0;i<newCourseList.size();i++){
            if((newCourseList[i].Schedule_Class__c != oldCourseList[i].Schedule_Class__c)  ){
                instructorId.put(newCourseList[i].Instrucctor__c,newCourseList[i].Schedule_Class__c);
                courseid.add(newCourseList[i].id);
            }
        }
        System.debug(courseId);
        List<Enrolled_Student__c>eStudent = [Select Studentt__c from Enrolled_Student__c Where Course__c IN: courseId];
       	List<id>studentIds = new List<Id>();
        for(Enrolled_Student__c i: eStudent){
            studentIds.add(i.Studentt__c);
        }
        List<Studentt__c>allStudent = [Select Email__c from Studentt__c Where Id IN:studentIds];
        System.debug(allStudent);
        List<Instrucctor__c>instructor = [Select Id,Name,Email__c from Instrucctor__c where Id IN:instructorId.keySet()];
        
        System.enqueuejob(new callasyncviaqueueable(allStudent,instructor));
       
        
    }
    
   
    public static void question3(List<Enrolled_Student__c>newList){
        List<Enrolled_Student__c>data = new List<Enrolled_Student__c>();
        List<Id>studentid = new List<Id>();
        List<Id>instructorId = new List<Id>();
        for(Enrolled_Student__c i: newList){
            if(i.Status__c == 'Dropped'){
                Enrolled_Student__c a = new Enrolled_Student__c(id = i.id);
                studentid.add(i.Studentt__c);
                instructorId.add(i.Instrucctor__c);
                data.add(a);
            }
            
        }
        
        

        List<Studentt__c>sList = [Select Email__c from Studentt__c Where Id IN: studentid];
        System.debug(sList);
        List<Instrucctor__c>iList = [Select Email__c from Instrucctor__c Where Id IN:instructorId];
        System.debug(iList);
        system.enqueuejob(new queuebleclassforquestion3(sList,iList));
        delete data;
    }
    
    
    public static void question4(List<Enrolled_Student__c>newList){
        List<Enrolled_Student__c>data = new List<Enrolled_Student__c>();
        List<Id>studentid = new List<Id>();
        List<Id>instructorId = new List<Id>();
        for(Enrolled_Student__c i: newList){
            if(i.Status__c == 'Enrolled'){
                Enrolled_Student__c a = new Enrolled_Student__c(id = i.id);
                studentid.add(i.Studentt__c);
                instructorId.add(i.Instrucctor__c);
                data.add(a);
            }
           
        }
        

        List<Studentt__c>sList = [Select Email__c from Studentt__c Where Id IN: studentid];
        System.debug(sList);
        List<Instrucctor__c>iList = [Select Email__c from Instrucctor__c Where Id IN:instructorId];
        System.debug(iList);
        system.enqueuejob(new queueableclassforquestion4(sList,iList));

        delete data;
    }
}