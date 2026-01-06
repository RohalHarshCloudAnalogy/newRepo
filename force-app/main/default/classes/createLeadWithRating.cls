public class createLeadWithRating {
    public static void createLead(List<Lead>newList){
        for(Lead nL : newList){
            if(nL.LeadSource == 'Web'){
                nL.Rating = 'Cold';
            }
            else{
                nL.Rating = 'Hot';
            }
        }
    }
}