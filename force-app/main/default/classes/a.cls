public class a{
    public static void b(){
        List<AsyncApexJob>lis = [Select Id,ParentJobId from AsyncApexJob Where JobType = 'Queueable' and Status = 'Failed'];
        for(AsyncApexJob i: lis ){
            System.abortjob(i.Id);
        }
    }
}