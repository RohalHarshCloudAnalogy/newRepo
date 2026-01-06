import { LightningElement } from 'lwc';

export default class TaskQuestion2 extends LightningElement {
    First_Name='';
    Last_Name='';
    Email='';
    Phone='';
    Title='';

    handleChange(event){
        if(event.target.name === 'First_Name'){
            this.First_Name = event.target.value;
        }
        else if(event.target.name === 'Last_Name'){
            this.Last_Name = event.target.value;
        }
        else if(event.target.name === 'Email'){
            this.Email = event.target.value;
        }
        else if(event.target.name === 'Phone'){
            this.Phone = event.target.value;
        }
        else if(event.target.name === 'Title'){
            this.Title = event.target.value;
        }
    }
    
}