public class LeadTriggerHandler {
    public static void preventDuplicate(List<Lead>newLead){
        for(Lead l:newLead){
            List<Lead>email = [Select Email from Lead Where Email = :l.Email];
            if(email.size()>=1){
                l.addError('Email Exist');
            }
        } 
    }
    
    
    public static void createFollowUpTask(List<Lead>newLead, Map<Id,Lead>oldMapp){
       
        
        List<Task>allTask = new List<Task>();
        for(Lead i:newLead){
            if(i.IsConverted){
                Task newTask = new Task();
                newTask.whoId = i.ConvertedContactId;
                newTask.WhatId = i.ConvertedAccountId;
                newTask.OwnerId = i.Ownerid;
                newTask.Subject = 'Other';
                newTask.Status = 'Not Started';
                allTask.add(newTask);
            }
        }
        insert allTask;
        
    }
}