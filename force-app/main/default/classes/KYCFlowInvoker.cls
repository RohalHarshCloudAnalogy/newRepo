public class KYCFlowInvoker {
    @InvocableMethod
    public static void verifyKYC(List<Id> recordIds){ // ← ye List of KYC_Document__c Ids
        for(Id recId : recordIds){
            System.enqueueJob(new KYCVerificationQueueable(recId));
        }
    }
}