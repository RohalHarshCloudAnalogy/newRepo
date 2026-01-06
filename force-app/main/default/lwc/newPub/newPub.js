import { LightningElement,wire } from 'lwc';
import { MessageContext, publish } from 'lightning/messageService';
import COUNTING_UPDATE from '@salesforce/messageChannel/CurMessageChannel__c';

export default class NewPub extends LightningElement {
    @wire(MessageContext)
        messageContext;

    
}