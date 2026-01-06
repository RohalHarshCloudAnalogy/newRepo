@isTest
public class ScenerioBasedQuestion1Test {
    
    @testSetup
    static void setupData() {
        // Create instructors
        List<Instrucctor__c> instructors = new List<Instrucctor__c>();
        for (Integer i = 0; i < 2; i++) {
            instructors.add(new Instrucctor__c(Name = 'Instructor ' + i, Email__c = 'instructor' + i + '@test.com'));
        }
        insert instructors;

        // Create students
        List<Studentt__c> students = new List<Studentt__c>();
        for (Integer i = 0; i < 2; i++) {
            students.add(new Studentt__c(Email__c = 'student' + i + '@test.com'));
        }
        insert students;

        // Create initial course
        List<Course__c> courses = new List<Course__c>();
        for (Integer i = 0; i < 2; i++) {
            courses.add(new Course__c(Name = 'Course ' + i, Instrucctor__c = instructors[i].Id, Schedule_Class__c = System.now()));
        }
        insert courses;

        // Create Enrolled Students with Enrolled & Dropped statuses
        List<Enrolled_Student__c> enrolled = new List<Enrolled_Student__c>{
            new Enrolled_Student__c(Course__c = courses[0].Id, Studentt__c = students[0].Id, Instrucctor__c = instructors[0].Id, Status__c = 'Enrolled'),
            new Enrolled_Student__c(Course__c = courses[1].Id, Studentt__c = students[1].Id, Instrucctor__c = instructors[1].Id, Status__c = 'Dropped')
        };
        insert enrolled;
    }

    @isTest
    static void testQuestion1_ScheduleChange() {
        List<Course__c> oldList = [SELECT Id, Instrucctor__c, Schedule_Class__c FROM Course__c];
        List<Course__c> updatedList = new List<Course__c>();

        for (Course__c c : oldList) {
            Course__c updated = c.clone(false);
            updated.Schedule_Class__c = System.now().addDays(1);
            updatedList.add(updated);
        }

        Test.startTest();
        ScenerioBasedQuestion1.question1(updatedList, oldList);
        Test.stopTest();
    }

    @isTest
    static void testQuestion3_DroppedStatus() {
        List<Enrolled_Student__c> dropped = [SELECT Id, Status__c, Studentt__c, Instrucctor__c FROM Enrolled_Student__c WHERE Status__c = 'Dropped'];

        Test.startTest();
        ScenerioBasedQuestion1.question3(dropped);
        Test.stopTest();
    }

    @isTest
    static void testQuestion4_EnrolledStatus() {
        List<Enrolled_Student__c> enrolled = [SELECT Id, Status__c, Studentt__c, Instrucctor__c FROM Enrolled_Student__c WHERE Status__c = 'Enrolled'];

        Test.startTest();
        ScenerioBasedQuestion1.question4(enrolled);
        Test.stopTest();
    }
}