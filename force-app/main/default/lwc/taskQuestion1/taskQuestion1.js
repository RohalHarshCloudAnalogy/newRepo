import { LightningElement } from 'lwc';

export default class TaskQuestion1 extends LightningElement {
    Num1 = 0;
     Num2 = 0;
     result = 0;

     setValues(event){
        if(event.target.name == 'number1'){
            this.Num1 = event.target.value;
        }
        else{
            this.Num2 = event.target.value;
        }
     }
     handleClick(event){
        if(event.target.name == 'sum'){
            this.result = parseInt(this.Num1 )+ parseInt(this.Num2);
            console.log(typeof(this.result)+' '+this.result+' '+this.Num1+' '+this.Num2);
        }
        else if(event.target.name == 'subtract'){
            this.result = this.Num1 - this.Num2;
            console.log(this.result+' '+this.Num1+' '+this.Num2);
        }
        else if(event.target.name == 'multiply'){
            this.result = this.Num1 * this.Num2;
            console.log(this.result+' '+this.Num1+' '+this.Num2);
        }
     }
}