import { LightningElement, wire } from 'lwc';
import getAccounts from '@salesforce/apex/fetchAccount.getAccount';
import getContact from '@salesforce/apex/fetchAccount.getContacts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class LwcTask10 extends LightningElement {
    options = [];
    selectedValue;
    contacts;
    
    columns = [
        { label: 'Name', fieldName: 'LastName' },
        { label: 'Email', fieldName: 'Email' }
    ];

    @wire(getAccounts)
    wiredAccounts({ error, data }) {
        if (data) {
            this.options = data.map(account => ({
                label: account.Name,
                value: account.Id
            }));
        } else if (error) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: error.body.message,
                variant: 'error'
            }));
        }
    }

    handleChange(event) {
        this.selectedValue = event.target.value;
        getContact({ accountId: this.selectedValue})
            .then(result => {
                this.contacts = result;
            })
            .catch(error => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error loading contacts',
                    message: error.body.message,
                    variant: 'error'
                }));
            });
    }
}