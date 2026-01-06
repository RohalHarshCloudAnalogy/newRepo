import { LightningElement,wire } from 'lwc';
import getAccount from '@salesforce/apex/fetchAccount.getAccount';
import getContact from '@salesforce/apex/fetchAccount.getContacts';
import getOpportunity from '@salesforce/apex/fetchAccount.getOpportunity';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class LwcTask11 extends LightningElement {
    accounts=[];
    selectedValue;
    contacts=[];
    opportunities=[];

    @wire(getAccount)
    wiredAccounts({error, data}){
        if(data){
            this.accounts = data.map(account => ({ label: account.Name , value: account.Id}));
        }
        else if(error){
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: error.body.message,
                variant: 'error'
            }));
        }
    }

    handleChange(event){
        this.selectedValue = event.target.value;
        
        getContact({ accountId: this.selectedValue})
            .then(result => {
                this.contacts = result.map(contact =>({label:contact.LastName, value:contact.Id}));
            })
            .catch(error => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error loading contacts',
                    message: error.body.message,
                    variant: 'error'
                }))
            })
        
        getOpportunity({ accountId: this.selectedValue})
            .then(result => {
                this.opportunities = result.map(opportunity =>({label:opportunity.Name, value:opportunity.Id}));
            })
            .catch(error => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error loading opportunities',
                    message: error.body.message,
                    variant: 'error'
                }))
            })
    }


}