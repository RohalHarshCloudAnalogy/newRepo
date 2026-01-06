import { LightningElement ,api} from 'lwc';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import ACCOUNT_NUMBER from '@salesforce/schema/Account.AccountNumber';
import ACCOUNT_RATING from '@salesforce/schema/Account.Rating';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class LwcLdsFirst extends LightningElement {
    objectApiName = ACCOUNT_OBJECT;
    @api recordId;
    nameField = NAME_FIELD;
    accountNumber = ACCOUNT_NUMBER;
    accountRating = ACCOUNT_RATING;
    playerId = 'It is record Id';


    handleSuccess(event){
        this.playerId = event.detail.id;
        console.log('detail',event.detail);
        console.log('record ID',event.detail.id);
        this.dispatchEvent(new ShowToastEvent({
            title: 'Success',
            message:'Data Created',
            variant: 'success'
        }))
    }
}