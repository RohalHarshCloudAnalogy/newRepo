public with sharing class createAccount {
    @AuraEnabled
    public static void insertAccount(String name , String rating , String phone, String industry, String location) {
        Account acc = new Account(
            Name  =name,
            Rating = rating,
            Industry = industry,
            Phone = phone,
            BillingCity = location
        );

        insert acc;
    }
}