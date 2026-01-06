public class ApexTriggerHandler {
    public static void updateRating(List<Account> data){
        for(Account acc : data){
            if(acc.Industry == 'Media'){
                
                acc.Rating = 'Hot';
        	}
        }
    }
}