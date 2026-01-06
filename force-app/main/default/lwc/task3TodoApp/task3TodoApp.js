import { LightningElement,track } from 'lwc';

export default class Task3TodoApp extends LightningElement {
    taskName ='';
    tasks = [];
    nextId = 1;

    handleInputChange(event){
        this.taskName = event.target.value;
    }

    addTask(){
        if(this.taskName.trim()==='') return;

        const task = {
            id:this.nextId++,
            name:this.taskName,
            completed:false
        };
        this.tasks.push(task);
        this.taskName = '';
    
    }

    toggleTask(event){
        const taskId = parseInt(event.target.dataset.id);

        this.tasks = this.tasks.map(taks =>
            task.id === taskId ? {...task,completed:!task.completed} : task
        );

    }

    deleteTask(event){
        const taskId = parseInt(event.target.dataset.id);
        this.tasks = this.tasks.filter(task=> task.id!==taskId);
    }
    
}