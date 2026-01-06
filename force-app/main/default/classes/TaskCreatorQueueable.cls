public class TaskCreatorQueueable implements Queueable {
    public List<Case>caseRecords;
    public TaskCreatorQueueable(List<Case>escalatedCase){
        caseRecords = escalatedCase;
    }
    public void execute(QueueableContext context){
        List<Task>taskList = new List<Task>();
        for(Case c: caseRecords){
            Task t = new Task();
            t.Subject = 'newTest';
            t.Priority = 'Medium';
            t.ActivityDate = System.Today()+30;
            t.WhatId = c.Id;
            t.OwnerId = c.OwnerId;
            taskList.add(t);
        }
        insert taskList;
        
    }
}