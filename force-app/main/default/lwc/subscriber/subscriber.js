import { LightningElement,wire } from 'lwc';
import MyMessageChannel from '@salesforce/messageChannel/myMessageChannel__c';
import { MessageContext, subscribe, unsubscribe } from 'lightning/messageService';




export default class Subscriber extends LightningElement {

    conId='';
    subscription=null;
    @wire(MessageContext) messageContext;

    connectedCallback()
    {
        if(this.subscription == null)
        {
            this.subscription = subscribe(this.messageContext,MyMessageChannel,(payload)=>
            {
                this.conId = payload.Id;
            });
        }
    }

    disconnectedCallback()
    {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

}