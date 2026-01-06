public class ZapierOutbound {
    	@future(callout = true)
        public static void sendDeleteNotification(Id leadId, String email) {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setMethod('POST');
            request.setHeader('Content-Type','application/json');
            request.setEndpoint('https://hooks.zapier.com/hooks/catch/23131697/2vdjttj/');
            
            Map<String,Object> payload = new Map<String,Object>();
            payload.put('Id',leadId);
            payload.put('Deleted',true);
            
            request.setBody(JSON.serialize(payload));
            try{
                HttpResponse response = http.send(request);
                System.debug(response.getBody());
            }
            catch(Exception e){
                System.debug(e.getlinenumber());
                System.debug(e.getMessage());
            }    
        }
   }