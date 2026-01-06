trigger OpportunityLineItemTrigger on OpportunityLineItem (After Insert){
	OpportunityLineItemHandler.takSheet44(Trigger.new);   
}