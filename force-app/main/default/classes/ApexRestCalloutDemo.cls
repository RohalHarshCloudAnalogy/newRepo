public class ApexRestCalloutDemo {
    public static void getUsersFromExternalSystem(){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://reqres.in/api/users');
req.setHeader('x-api-key', 'reqres-free-v1');
       // req.setMethod('GET');
        req.setMethod('POST');
        req.setBody('{"name": "morpheus","job": "leader"}');
        
        HttpResponse res = http.send(req);
        System.debug(res.getBody());
        System.debug(res.getStatusCode());
        
    }
}