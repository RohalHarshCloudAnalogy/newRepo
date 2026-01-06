public class LeadToGoogleSheetHandler {
    
    @future(callout=true)
    public static void insertLeadToGoogleSheet(List<Id> newLeadIds) {
        try{
            List<Lead> newLeads = [SELECT FirstName, LastName, Company, Email, Phone, LeadSource, Status FROM Lead WHERE Id IN :newLeadIds];

        // get current sheet data
        Http http = new Http();
        HttpRequest getReq = new HttpRequest();
        getReq.setEndpoint('callout:GoogleSheetNC/v4/spreadsheets/10xdvHgW8FPYTkJT4C8Zv8VPywv-aiiraF94n5IaQ0uE/values/Lead!A2:Z1000'); // Skip header
        getReq.setMethod('GET');
        getReq.setHeader('Content-Type', 'application/json');

        HttpResponse getRes = http.send(getReq);


        System.debug('BODY'+getRes.getBody());
        Map<String, Object> sheetData = (Map<String, Object>) JSON.deserializeUntyped(getRes.getBody());
        System.debug('SHEETDATA'+sheetData);
        List<Object> rows = (List<Object>) sheetData.get('values');
        System.debug('ROW'+rows);
        
        // Create map to match email with row number
        Map<String, Integer> emailToRowMap = new Map<String, Integer>();
        Integer rowNum = 2; // Since data starts from row 2
        for (Object rowObj : rows) {
            List<Object> row = (List<Object>) rowObj;
            if (row.size() >= 4) {
                String email = (String) row[3]; // Email is in column D (index 3)
                emailToRowMap.put(email, rowNum);
            }
            rowNum++;
        }

        for (Lead lead : newLeads) {
            List<String> rowData = new List<String>{
                lead.FirstName,
                lead.LastName,
                lead.Company,
                lead.Email,
                lead.Phone,
                lead.LeadSource,
                lead.Status
            };

            if (emailToRowMap.containsKey(lead.Email)) {
                // Step 2a: Email exists then update existing row
                Integer targetRow = emailToRowMap.get(lead.Email);
                String range = 'Lead!A' + targetRow + ':G' + targetRow;
                HttpRequest putReq = new HttpRequest();
                putReq.setEndpoint('callout:GoogleSheetNC/v4/spreadsheets/10xdvHgW8FPYTkJT4C8Zv8VPywv-aiiraF94n5IaQ0uE/values/' + range + '?valueInputOption=RAW');
                putReq.setMethod('PUT');
                putReq.setHeader('Content-Type', 'application/json');

                Map<String, Object> bodyMap = new Map<String, Object>{ 'values' => new List<List<String>>{ rowData } };
                putReq.setBody(JSON.serialize(bodyMap));

                HttpResponse putRes = http.send(putReq);
                System.debug('Updated row for email: ' + lead.Email + ' => Status: ' + putRes.getStatus());
            } 
            
            else {
                //  Email not exitst then insert new row
                HttpRequest postReq = new HttpRequest();
                postReq.setEndpoint('callout:GoogleSheetNC/v4/spreadsheets/10xdvHgW8FPYTkJT4C8Zv8VPywv-aiiraF94n5IaQ0uE/values/Lead!A1:append?valueInputOption=RAW');
                postReq.setMethod('POST');
                postReq.setHeader('Content-Type', 'application/json');

                Map<String, Object> bodyMap = new Map<String, Object>{ 'values' => new List<List<String>>{ rowData } };
                postReq.setBody(JSON.serialize(bodyMap));

                HttpResponse postRes = http.send(postReq);
                System.debug('Inserted new row for email: ' + lead.Email + ' => Status: ' + postRes.getStatus());
            }
        }
        }catch(Exception e){
            System.debug(e.getLineNumber());
            System.debug(e.getMessage());
        }
        
    }
    
    
    @future(callout=true)
    public static void deleteLeadToGoogleSheet(List<String> deletedEmails) {
        try {
            Http http = new Http();
    
            // Get current sheet data
            HttpRequest getReq = new HttpRequest();
            getReq.setEndpoint('callout:GoogleSheetNC/v4/spreadsheets/10xdvHgW8FPYTkJT4C8Zv8VPywv-aiiraF94n5IaQ0uE/values/Lead!A2:Z1000');
            getReq.setMethod('GET');
            getReq.setHeader('Content-Type', 'application/json');
            HttpResponse getRes = http.send(getReq);
    
            Map<String, Object> sheetData = (Map<String, Object>) JSON.deserializeUntyped(getRes.getBody());
            System.debug('SheetData'+sheetData);
            List<Object> rows = (List<Object>) sheetData.get('values');
            System.debug('rows'+rows);
    
            // Map email to row number
            Map<String, Integer> emailToRowMap = new Map<String, Integer>();
            Integer rowNum = 2; // data starts from row 2 (after header)
            for (Object rowObj : rows) {
                List<Object> row = (List<Object>) rowObj;
                System.debug('ROWDATA'+row);
                if (row.size() >= 4) {
                    String email = (String) row[3]; // Email is column D, index 3
                    emailToRowMap.put(email, rowNum);
                }
                rowNum++;
            }
    
            // Loop through deletedEmails and delete matching rows in the sheet
            for (String email : deletedEmails) {
                if (emailToRowMap.containsKey(email)) {
                    Integer targetRow = emailToRowMap.get(email);
    
                    Map<String, Object> deleteRequest = new Map<String, Object>{
                        'requests' => new List<Object>{
                            new Map<String, Object>{
                                'deleteDimension' => new Map<String, Object>{
                                    'range' => new Map<String, Object>{
                                        'sheetId' => 0, // adjust if needed
                                        'dimension' => 'ROWS',
                                        'startIndex' => targetRow - 1, // zero-based index
                                        'endIndex' => targetRow
                                    }
                                }
                            }
                        }
                    };
    
                    HttpRequest delReq = new HttpRequest();
                    delReq.setEndpoint('callout:GoogleSheetNC/v4/spreadsheets/10xdvHgW8FPYTkJT4C8Zv8VPywv-aiiraF94n5IaQ0uE:batchUpdate');
                    delReq.setMethod('POST');
                    delReq.setHeader('Content-Type', 'application/json');
                    delReq.setBody(JSON.serialize(deleteRequest));
    
                    HttpResponse delRes = http.send(delReq);
                    System.debug('Deleted row for email: ' + email + ' => Status: ' + delRes.getStatus());
                } else {
                    System.debug('Email not found in sheet: ' + email);
                }
            }
        } catch (Exception e) {
            System.debug(e.getLineNumber());
            System.debug('Error in deleteLeadToGoogleSheet: ' + e.getMessage());
        }
    }

}