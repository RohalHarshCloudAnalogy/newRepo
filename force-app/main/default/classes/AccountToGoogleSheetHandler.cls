public class AccountToGoogleSheetHandler {
    
    @future(callout=true)
    public static void insertAccountToGoogleSheet(List<Id> newAccountIds) {
        try{
            System.debug('Handler Class');
            List<Account> newAcc = [SELECT Name, Industry, Phone, Website FROM Account WHERE Id IN :newAccountIds];

        // get current sheet data
            Http http = new Http();
            HttpRequest getReq = new HttpRequest();
            getReq.setEndpoint('callout:GoogleSheetNC/v4/spreadsheets/10xdvHgW8FPYTkJT4C8Zv8VPywv-aiiraF94n5IaQ0uE/values/Account!A2:Z1000'); // Skip header
            getReq.setMethod('GET');
            getReq.setHeader('Content-Type', 'application/json');
    
            HttpResponse getRes = http.send(getReq);
    
            System.debug(getRes.getStatusCode());
            System.debug('BODY'+getRes.getBody());
            Map<String, Object> sheetData = (Map<String, Object>) JSON.deserializeUntyped(getRes.getBody());
            System.debug('SHEETDATA'+sheetData);
            List<Object> rows = (List<Object>) sheetData.get('values');
            System.debug('ROW'+rows);
            
            // Create map to match name with row number
            Map<String, Integer> nameToRowMap = new Map<String, Integer>();
            Integer rowNum = 2; // Since data starts from row 2
            for (Object rowObj : rows) {
                List<Object> row = (List<Object>) rowObj;
                if (row.size() >= 1) {
                    String name = (String) row[0]; // Name is in column A (index 0)
                    nameToRowMap.put(name, rowNum);
                }
                rowNum++;
            }
    
            for (Account acc : newAcc) {
                List<String> rowData = new List<String>{
                    acc.Name,
                    acc.Industry,
                    acc.Phone,
                    acc.Website
                        
                    
                };
    
                if (nameToRowMap.containsKey(acc.Name)) {
                    // Step 2a: Name exists then update existing row
                    Integer targetRow = nameToRowMap.get(acc.Name);
                    String range = 'Account!A' + targetRow + ':G' + targetRow;
                    HttpRequest putReq = new HttpRequest();
                    putReq.setEndpoint('callout:GoogleSheetNC/v4/spreadsheets/10xdvHgW8FPYTkJT4C8Zv8VPywv-aiiraF94n5IaQ0uE/values/' + range + '?valueInputOption=RAW');
                    putReq.setMethod('PUT');
                    putReq.setHeader('Content-Type', 'application/json');
    
                    Map<String, Object> bodyMap = new Map<String, Object>{ 'values' => new List<List<String>>{ rowData } };
                    putReq.setBody(JSON.serialize(bodyMap));
    
                    HttpResponse putRes = http.send(putReq);
                    System.debug('Updated row for email: ' + acc.Name + ' => Status: ' + putRes.getStatus());
                } 
                
                else {
                    //  Email not exitst then insert new row
                    HttpRequest postReq = new HttpRequest();
                    postReq.setEndpoint('callout:GoogleSheetNC/v4/spreadsheets/10xdvHgW8FPYTkJT4C8Zv8VPywv-aiiraF94n5IaQ0uE/values/Account!A1:append?valueInputOption=RAW');
                    postReq.setMethod('POST');
                    postReq.setHeader('Content-Type', 'application/json');
    
                    Map<String, Object> bodyMap = new Map<String, Object>{ 'values' => new List<List<String>>{ rowData } };
                    postReq.setBody(JSON.serialize(bodyMap));
    
                    HttpResponse postRes = http.send(postReq);
                    System.debug('Inserted new row for Name: ' + acc.Name + ' => Status: ' + postRes.getStatus());
                }
            }
        }catch(Exception e){
            System.debug(e.getLineNumber());
            System.debug(e.getMessage());
        }
        
    }
    
    
    @future(callout=true)
    public static void deleteAccountToGoogleSheet(List<String> deletedNames) {
        try {
            Http http = new Http();
    
            // Get current sheet data
            HttpRequest getReq = new HttpRequest();
            getReq.setEndpoint('callout:GoogleSheetNC/v4/spreadsheets/10xdvHgW8FPYTkJT4C8Zv8VPywv-aiiraF94n5IaQ0uE/values/Account!A2:Z1000');
            getReq.setMethod('GET');
            getReq.setHeader('Content-Type', 'application/json');
            HttpResponse getRes = http.send(getReq);
    
            Map<String, Object> sheetData = (Map<String, Object>) JSON.deserializeUntyped(getRes.getBody());
            System.debug('SheetData'+sheetData);
            List<Object> rows = (List<Object>) sheetData.get('values');
            System.debug('rows'+rows);
    
            // Map email to row number
            Map<String, Integer> nameToRowMap = new Map<String, Integer>();
            Integer rowNum = 2; // data starts from row 2 (after header)
            for (Object rowObj : rows) {
                List<Object> row = (List<Object>) rowObj;
                System.debug('ROWDATA'+row);
                if (row.size() >= 4) {
                    String name = (String) row[0]; // Email is column D, index 3
                    nameToRowMap.put(name, rowNum);
                }
                rowNum++;
            }
    
            // Loop through deletedEmails and delete matching rows in the sheet
            for (String name : deletedNames) {
                if (nameToRowMap.containsKey(name)) {
                    Integer targetRow = nameToRowMap.get(name);
    
                    Map<String, Object> deleteRequest = new Map<String, Object>{
                        'requests' => new List<Object>{
                            new Map<String, Object>{
                                'deleteDimension' => new Map<String, Object>{
                                    'range' => new Map<String, Object>{
                                        'sheetId' => 1354594838, 
                                        'dimension' => 'ROWS',
                                        'startIndex' => targetRow - 1, 
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
                    System.debug('Deleted row for name: ' + ' => Status: ' + delRes.getStatus());
                } else {
                    System.debug('Email not found in sheet: ');
                }
            }
        } catch (Exception e) {
            System.debug(e.getLineNumber());
            System.debug('Error in deleteToGoogleSheet: ' + e.getMessage());
        }
    }

}