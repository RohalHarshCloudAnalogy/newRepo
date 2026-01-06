public class OppPrecessor implements Database.batchable<sObject>, Database.stateful{
	public integer recordCount = 0;
    
    public Database.QueryLocator start(Database.BatchableContext bc){

        return Database.getQueryLocator([Select Id, Name from Opportunity]);
    }
    
    public void execute(Database.BatchableContext bc, List<Opportunity>opps){
        for(Opportunity opp: opps){
            opp.LeadSource = 'Web';
        }
        update opps;
        recordCount+=opps.size();
    }
    
    public void finish(Database.BatchableContext bc){
        System.debug(recordCount);
    }
}