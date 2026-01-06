import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class LwcPractice extends LightningElement {

    myTitle = 'LWC Title';

    connectedCallback(){
        console.log('Connected Callback');
        let callMyFunction = this.myFunction(10,2);
       // window.alert('Result of myFunction: '+callMyFunction);
    }
    
    myFunction = (dividend,divisor) =>{
        return (dividend/divisor).toFixed(2);
    }
}