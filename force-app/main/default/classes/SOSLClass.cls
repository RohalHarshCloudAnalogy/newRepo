public class SOSLClass {
    public static void firstExm(){
        List<List<sObject>> searchList = [Find 'One' IN ALL FIELDS 
                                      RETURNING ACCOUNT(NAME),CONTACT(FIRSTNAME,LASTNAME,EMAIL)
                                     ];
       /* List<Account>accList = new List<Account>();
        List<Contact>conList = new List<Contact>();
        
        accList = (List<Account>)searchList[0];
        conList = (List<Contact>)searchList[1];
        
        System.debug(accList);
        System.debug(conList);*/
        System.debug(searchList);
        }
    
}