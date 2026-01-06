@RestResource(urlMapping = '/myClass/*')
global class MyApiController {
	@HttpPost
    global static string dataCreation(String name, String rating){
        Account acc = new Account();
        acc.Name = name;
        acc.Rating = rating;
        insert acc;
        return acc.Id;
    }
    
    
    
    @HttpPut
    global static Account updateAcc(Account acc){
        RestRequest req = RestContext.request;
        string accId = req.params.get('id');
        Account updateAcc = [Select Id, Name from Account Where Id = :accId];
        updateAcc.Name = acc.Name;
        updateAcc.Phone = acc.Phone;
        updateAcc.Website = acc.Website;
        update updateAcc;
        return updateAcc;
    }
    
    
    @HttpDelete
    global static String deleteAcc(){
        RestRequest req = RestContext.request;
        string accId = req.params.get('id');
        Account acc = [Select Id from Account Where Id = :accId];
        delete acc;
        return accId;
    }
}