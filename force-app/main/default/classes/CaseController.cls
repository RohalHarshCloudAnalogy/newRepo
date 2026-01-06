public with sharing class CaseController {
    @AuraEnabled
    public static Id createCase(String subject, String description, String priority, String status, Id contactId) {
        Case c = new Case(Subject=subject, Description=description, Priority=priority, Status=status, ContactId=contactId);
        insert c;
        return c.Id;
    }

    @AuraEnabled(cacheable=true)
    public static List<Case> getOpenCases(
        String searchKey,
        String priorityFilter,
        String statusFilter,
        String sortField,
        Boolean isAsc
    ) {
        String baseQuery = 'SELECT Id, CaseNumber, Subject, Priority, Status, CreatedDate FROM Case WHERE IsClosed = FALSE';
        List<String> filters = new List<String>();

        // Search
        if (String.isNotBlank(searchKey)) {
            filters.add('Subject LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\'');
        }

        // Priority
        if (String.isNotBlank(priorityFilter)) {
            filters.add('Priority = :priorityFilter');
        }

        // Status
        if (String.isNotBlank(statusFilter)) {
            filters.add('Status = :statusFilter');
        }

        // Combine filters
        if (!filters.isEmpty()) {
            baseQuery += ' AND ' + String.join(filters, ' AND ');
        }

        // Sorting
        if (String.isNotBlank(sortField)) {
            baseQuery += ' ORDER BY ' + sortField + (isAsc ? ' ASC' : ' DESC');
        }

        return Database.query(baseQuery);
    }

    @AuraEnabled
    public static void updateCaseStatus(Id caseId, String status) {
        try {
            Case caseToUpdate = [SELECT Id, Status FROM Case WHERE Id = :caseId LIMIT 1];
            caseToUpdate.Status = status;
            update caseToUpdate;
        } catch (Exception e) {
            throw new AuraHandledException('Error updating case status: ' + e.getMessage());
        }
    }
}