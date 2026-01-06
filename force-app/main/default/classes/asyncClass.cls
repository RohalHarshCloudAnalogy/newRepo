public class asyncClass {
   /* public static void handleTaskCheckBoxUpdate(List<Task>taskList){
        List<String>ownerIds = new List<String>();
        for(Task eachTask:taskList){
            if(eachTask.Status == 'Completed'){
                ownerIds.add(eachTask.ownerId);
            }
        }
        
        updateUserFlad(ownerIds);
        
    }
    @future
    public static void updateUserFlad(List<String>ownerIds){
        List<User>userList = [Select Id,Complete__c from User Where ID IN: ownerIds];
        for(User userRec: userList){
            userRec.complete__c = True;
        }
        update userList;
    }*/
}