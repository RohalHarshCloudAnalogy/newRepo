import { LightningElement, wire, api } from 'lwc';
import getAccount from '@salesforce/apex/fetchAccount.getAccount';

export default class LwcTask7 extends LightningElement {
    accounts;
    error;

    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Industry', fieldName: 'Industry' }
    ];

    @wire(getAccount)
    wiredaccount({ data, error }) {
        if (data) {
            this.accounts = data;
            this.error = undefined;
            console.log(this.accounts);
        } else if (error) {
            this.error = error;
            this.accounts = undefined;
            console.error(error);
        }
    }
}