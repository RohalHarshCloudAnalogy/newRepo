import { LightningElement,wire,track } from 'lwc';
import getAccount from '@salesforce/apex/fetchAccount.getAccount';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class LwcTask13 extends LightningElement {
    columns=[
        {label: 'Name', fieldName: 'Name', sortable:true}
    ];

    sortedBy ='Name';
    sortedDirection = 'asc';
    @track accounts=[];
    originalData = [];
    

    @wire(getAccount)
    wiredAccount({error,data})
    {
        if(data){
            this.accounts = data;
            this.originalData = [...data];
        }
        else if(error){
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: error.body.message,
                variant: 'error'
            }));
        }
    }


    handleSort(event){
        const {fieldName: sortedBy, sortDirection} = event.detail;
        const cloneData = [...this.originalData];
        cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
        this.accounts = cloneData;
        this.sortedBy = sortedBy;
        this.sortedDirection = sortDirection;

    }

    sortBy(field, reverse) {
        return function (a, b) {
            const aVal = a[field] ? a[field].toLow13erCase() : '';
            const bVal = b[field] ? b[field].toLowerCase() : '';
            return reverse * ((aVal > bVal) - (bVal > aVal));
        };
    }

    
}