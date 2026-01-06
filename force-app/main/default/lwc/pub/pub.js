import { LightningElement ,wire} from 'lwc';
import { MessageContext, publish } from 'lightning/messageService';
import COUNTING_UPDATE from '@salesforce/messageChannel/CurMessageChannel__c';

export default class Pub extends LightningElement {

    @wire(MessageContext)
    messageContext;
    
    handleIncrement(event){
        const payload = {
            operator: 'add',
            constant:1
        }

        publish(this.messageContext, COUNTING_UPDATE, payload);
    }

    handleDecrement(event){
        const payload = {
            operator: 'subtract',
            constant:1
        }

        publish(this.messageContext, COUNTING_UPDATE, payload);
    }

    handleMultiply(event){
        const payload = {
            operator: 'multiply',
            constant:3
        }

        publish(this.messageContext, COUNTING_UPDATE, payload);
    }

}