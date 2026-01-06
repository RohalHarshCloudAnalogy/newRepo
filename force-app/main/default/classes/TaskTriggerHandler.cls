public class TaskTriggerHandler {
    public static void controlDeletion(List<Task>oldList){
		Id profileid = UserInfo.getProfileId();
		Profile pid = [Select Id from Profile Where Name ='System Administrator'];
            for(Task i:oldList){
                if(pid.Id != profileid){
                    i.addError('Only System Admin Can Delete it....');
                }
            }
    }
}