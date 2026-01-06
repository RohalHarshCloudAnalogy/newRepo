import { LightningElement } from 'lwc';
import getAccounts from '@salesforce/apex/fetchAccount.getAccount';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class LwcTask9 extends LightningElement {
    options=[];


    connectedCallback(){
        getAccounts()
        .then(result => {
            this.options = result.map(account => ({label: account.Name, value: account.Id}));
        })
        .catch(error => {   
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: error.body.message,
                variant: 'error'
            }))
        })
    }
}