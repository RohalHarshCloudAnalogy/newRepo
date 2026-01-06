public with sharing class KYCController {

    @AuraEnabled
    public static Id createKYCRecord(String docType){
        KYC_Document__c doc = new KYC_Document__c();
        doc.Name = docType != null ? docType : 'New KYC Document';
        doc.Verification_Status__c = 'Not Checked';
        doc.KYC_Status__c = 'Pending';
        insert doc;
        return doc.Id;
    }
}