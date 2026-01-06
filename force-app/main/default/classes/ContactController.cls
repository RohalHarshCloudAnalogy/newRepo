public with sharing class ContactController {
    
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts()
    {
        return [Select Id,LastName From Contact Limit 10];
    }
}