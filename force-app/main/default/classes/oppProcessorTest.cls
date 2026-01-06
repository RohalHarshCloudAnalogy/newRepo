@isTest
public class oppProcessorTest {
	@isTest
    private static void testBatchClass(){
        List<Opportunity>oppList = new List<Opportunity>();
        for(Integer i=0;i<200;i++){
            oppList.add(new Opportunity(Name = 'Test'+i, StageName = 'Prospecting',CloseDate = System.Today()));
            
        }
        insert oppList;
        
        Test.startTest();
        OppPrecessor newOppPro = new OppPrecessor();
        Id batchId = Database.executeBatch(newOppPro,200);
        Test.stopTest();
        
        List<Opportunity>listopp = [Select Id from Opportunity where LeadSource = 'Web'];
        System.assertEquals(200,listopp.size());
    }
}