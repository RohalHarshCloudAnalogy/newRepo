public class GoogleSheetSyncHandler {

    @future(callout=true)
    public static void syncToGoogleSheet(String sObjectType, List<Id> recordIds) {
        try {
            //get instance of metaData
            googleSheetUrl__mdt objectMetaData = googleSheetUrl__mdt.getInstance(sObjectType);
            
            String endUrl = objectMetaData.EndPointBaseUrl__c;
            String range = objectMetaData.Range__c;
            
            System.debug(sObjectType);
            
            Integer sheetIds = getSheetIdByObjectType(sObjectType);
            System.debug('RECORDIDS'+recordIds);
            
            //fetch query with Database.query();
            List<SObject> records = Database.query(buildQuery(sObjectType, recordIds));
            System.debug('RECORDS '+records);
            String sheetName = sObjectType;
            Map<String, Integer> keyToRowMap = new Map<String, Integer>();
            List<List<String>> sheetRows = new List<List<String>>();

            Http http = new Http();

            // Get existing data from sheet
            HttpRequest getReq = new HttpRequest();
            getReq.setEndpoint(endUrl + sheetName + range);
            getReq.setMethod(objectMetaData.GetMethod__c);
            getReq.setHeader(objectMetaData.HeaderKey__c, objectMetaData.HeaderValue__c);
            HttpResponse getRes = http.send(getReq);

            Map<String, Object> sheetData = (Map<String, Object>) JSON.deserializeUntyped(getRes.getBody());
            List<Object> rows = (List<Object>) sheetData.get('values');
            
            
            //check if, sheet has no data then insert directly otherwise go to else part
            if(rows == null || rows.isEmpty()){
                for(SObject obj : records){
                    List<String> rowData = getRowData(obj,sObjectType);
                    HttpRequest postReq = new HttpRequest();
                    postReq.setEndpoint(endUrl + sheetName + objectMetaData.RangeToInsertNewData__c);
                    postReq.setMethod(objectMetaData.PostMethod__c);
                    postReq.setHeader(objectMetaData.HeaderKey__c, objectMetaData.HeaderValue__c);
                    postReq.setBody(JSON.serialize(new Map<String, Object>{ 'values' => new List<List<String>>{ rowData } }));
                    http.send(postReq);
                }
                	
            }
            
           // if sheet has data, then check if it has current data or not, if yes then update, otherwise insert
            else{
                Integer rowNum = 2;
                for (Object rowObj : rows) {
                    List<Object> row = (List<Object>) rowObj;
                    String key = getKeyFromRow(row, sObjectType);
                    if (key != null) {
                        keyToRowMap.put(key, rowNum);
                    }
                    rowNum++;
                }
    
                // Step 2: Insert or Update
                for (SObject obj : records) {
                    List<String> rowData = getRowData(obj,sObjectType);
                    String key = getKeyFromSObject(obj,sObjectType);
                    if (keyToRowMap.containsKey(key)) {
                        Integer targetRow = keyToRowMap.get(key);
                        Integer columnCount = rowData.size();
                        Integer lastColumnIndex = columnCount - 1;
                        String lastColumn = getColumnLetter(lastColumnIndex);
                        
                        String rangeToUpdate = sheetName + '!A' + targetRow + ':' + lastColumn + targetRow;
    
                        HttpRequest putReq = new HttpRequest();
                        putReq.setEndpoint(endUrl + rangeToUpdate + objectMetaData.EndPointUrlParameterForUpdate__c);
                        putReq.setMethod(objectMetaData.PutMethod__c);
                        putReq.setHeader(objectMetaData.HeaderKey__c, objectMetaData.HeaderValue__c);
                        putReq.setBody(JSON.serialize(new Map<String, Object>{ 'values' => new List<List<String>>{ rowData } }));
                        http.send(putReq);
                    } else {
                        HttpRequest postReq = new HttpRequest();
                        postReq.setEndpoint(endUrl + sheetName + objectMetaData.RangeToInsertNewData__c);
                        postReq.setMethod(objectMetaData.PostMethod__c);
                        postReq.setHeader(objectMetaData.HeaderKey__c, objectMetaData.HeaderValue__c);
                        postReq.setBody(JSON.serialize(new Map<String, Object>{ 'values' => new List<List<String>>{ rowData } }));
                        http.send(postReq);
                    }
                }
            }

        } 
        catch (Exception e) {
            System.debug(e.getLineNumber());
            System.debug('Error in syncToGoogleSheet: ' + e.getMessage());
        }
    
    }

    //For Deletion
    
    @future(callout=true)
    public static void deleteFromGoogleSheet(String sObjectType, List<Id> keys) {
        try {
            System.debug('keys'+keys);
            googleSheetUrl__mdt objectMetaData = googleSheetUrl__mdt.getInstance(sObjectType);  //get metaData access
            Integer sheetIds = getSheetIdByObjectType(sObjectType); //get Sheet Id for Deletion from metadata
            String endUrl = objectMetaData.EndPointBaseUrl__c; //get EndPointBaseUrl from metadata
            String endUrlForDelete = objectMetaData.EndPointUrlForDelete__c;  //Get EndpointUrl for Delete from metadata
          
            String sheetName = sObjectType;
            Http http = new Http();
            
			String range = objectMetaData.Range__c;
            // Fetch existing sheet data
            HttpRequest getReq = new HttpRequest();
            getReq.setEndpoint(endUrl + sheetName + range);
            getReq.setMethod(objectMetaData.GetMethod__c);
            getReq.setHeader(objectMetaData.HeaderKey__c, objectMetaData.HeaderValue__c); //use HeaderKey and HeaderValue from Metadata
            HttpResponse getRes = http.send(getReq); //send the request

            Map<String, Object> sheetData = (Map<String, Object>) JSON.deserializeUntyped(getRes.getBody());
            List<Object> rows = (List<Object>) sheetData.get('values');

            Map<String, Integer> keyToRowMap = new Map<String, Integer>();
            Integer rowNum = 2;
            
            //store the key and row number in map , it will help to create the range for delete
            for (Object rowObj : rows) {
                List<Object> row = (List<Object>) rowObj;
                String key = getKeyFromRow(row, sObjectType);
                if (key != null) {
                    keyToRowMap.put(key, rowNum);
                }
                rowNum++;
            }

            for (Id key : keys) {
                System.debug('in for loop' + key);
                if (keyToRowMap.containsKey(key)) {
                    Integer targetRow = keyToRowMap.get(key);
                    Map<String, Object> deleteRequest = new Map<String, Object>{
                        'requests' => new List<Object>{
                            new Map<String, Object>{
                                'deleteDimension' => new Map<String, Object>{
                                    'range' => new Map<String, Object>{
                                        'sheetId' => sheetIds,
                                        'dimension' => 'ROWS',
                                        'startIndex' => targetRow - 1,
                                        'endIndex' => targetRow
                                    }
                                }
                            }
                        }
                    };

                    HttpRequest delReq = new HttpRequest();
                    delReq.setEndpoint(endUrlForDelete);
                    delReq.setMethod(objectMetaData.PostMethod__c);
                    delReq.setHeader(objectMetaData.HeaderKey__c, objectMetaData.HeaderValue__c);
                    delReq.setBody(JSON.serialize(deleteRequest));
                    http.send(delReq);
                }
            }
        } catch (Exception e) {
            System.debug('Error in deleteFromGoogleSheet: ' + e.getMessage());
        }
    }

    
    
    
    private static String buildQuery(String sObjectType, List<Id> ids) {
        System.debug('Under buildquery');
         // Convert List<Id> to a comma-separated string of quoted Ids
        List<String> quotedIds = new List<String>();
        for (Id recordId : ids) {
            quotedIds.add('\'' + String.valueOf(recordId) + '\'');
        }
        System.debug('QuoteID'+quotedIds);
        String idSet = '(' + String.join(quotedIds, ',') + ')';
        System.debug('IDSET'+idset);
        
        String fieldsToSelect = googleSheetUrl__mdt.getInstance(sObjectType).FieldsToSelect__c;
    	System.debug('Fields to select: ' + fieldsToSelect);
        
        if (fieldsToSelect == null || String.isBlank(fieldsToSelect)) {
            throw new IllegalArgumentException('No fields configured for object type: ' + sObjectType);
        }
        
        return 'SELECT ' + fieldsToSelect + ' FROM ' + sObjectType + ' WHERE Id IN ' + idSet;
            
        
    }

    
    
    
    private static List<String> getRowData(SObject record,String sObjectType) {
        
        String fieldsToSelect = googleSheetUrl__mdt.getInstance(sObjectType).FieldsToSelect__c;
    	System.debug('Fields to select: ' + fieldsToSelect);
        
        if (fieldsToSelect == null || String.isBlank(fieldsToSelect)) {
            throw new IllegalArgumentException('No fields configured for object type: ' + sObjectType);
        }
        
        List<String>rows = new List<String>();
        for(String fieldName: fieldsToSelect.split(',')){
            fieldName = fieldName.trim();
            rows.add(String.valueof(record.get(fieldName)));
        }
        return rows;
    }

    private static String getKeyFromSObject(SObject record,String sObjectType) {
        String keyField = googleSheetUrl__mdt.getInstance(sObjectType).KeyField__c;
        return String.valueOf(record.get(keyField));
    }

    private static String getKeyFromRow(List<Object> row, String sObjectType) {
        String keyField = googleSheetUrl__mdt.getInstance(sObjectType).KeyField__c;
        List<String>allField = googleSheetUrl__mdt.getInstance(sObjectType).FieldsToSelect__c.split(',');
        Integer index = -1;
        
        for(Integer i=0;i<row.size();i++){
            if(keyField.trim() == allField[i].trim()){
                index = i;
                break;
            }
        }
        
        if(index != -1 && index < row.size()){
            return String.valueOf(row[index]);
        }
        return null;
    }
    
    public static Integer getSheetIdByObjectType(String sObjectType){
        for (googleSheetUrl__mdt config : [SELECT ObjectType__c, SheetId__c FROM googleSheetUrl__mdt]) {
            if (config.ObjectType__c == sObjectType) {
                return Integer.valueOf(config.SheetId__c);
            }
    	}
    return null; 
    }
    
    public static String getColumnLetter(Integer index) {
        String col = '';
        while (index >= 0) {
            Integer remainder = Math.mod(index, 26);
            col = String.fromCharArray(new List<Integer>{65 + remainder}) + col;
            index = (index / 26) - 1;
        }
        return col;
	}
}