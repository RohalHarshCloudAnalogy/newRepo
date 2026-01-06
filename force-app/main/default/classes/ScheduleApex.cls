public class ScheduleApex implements Schedulable {
    public void execute(SchedulableContext ctx){
        List<Opportunity>oppList= [Select Id,LeadSource from Opportunity Where LeadSource = null limit 200];
        for(Opportunity opp:oppList){
            opp.LeadSource = 'Web';
        }
        update oppList;
        System.debug(ctx);
    }
}