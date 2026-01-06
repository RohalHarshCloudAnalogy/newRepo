public class Spoonacular {
    
    private static final String SPOONACULAR_API = 'https://api.spoonacular.com';
    private static final String API_KEY = '8f3bd06fa12a4a45ae728965e5c4d602';
    public static void getRandomRecipe(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndPoint(SPOONACULAR_API + '/recipes/random?apiKey='+API_KEY);
       // request.setEndPoint('https://api.spoonacular.com/recipes/random?apiKey=8f3bd06fa12a4a45ae728965e5c4d602');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200 ){
            System.debug('response '+response.getBody());
        }
    }
    
    public static void getRecipe(String recipeId){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndPoint(SPOONACULAR_API + '/recipes/'+recipeId+'/information?apiKey='+API_KEY);
       // request.setEndPoint('https://api.spoonacular.com/recipes/random?apiKey=8f3bd06fa12a4a45ae728965e5c4d602');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200 ){
            System.debug('response '+response.getBody());
        }
    }
    
    public static void getRecipeByIngredients(String ingredients){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndPoint(SPOONACULAR_API + '/recipes/findByIngredients?apiKey='+API_KEY +'&ingredients='+ingredients);
       // request.setEndPoint('https://api.spoonacular.com/recipes/random?apiKey=8f3bd06fa12a4a45ae728965e5c4d602');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200 ){
            System.debug('response '+response.getBody());
        }
    }
}