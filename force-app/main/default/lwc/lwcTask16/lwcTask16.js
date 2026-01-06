import { LightningElement,wire,track } from 'lwc';
import getAccount from '@salesforce/apex/fetchAccount.getAccount';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class LwcTask16 extends LightningElement {
    searchVal;
    @track account=[];


    columns = [
        {label: 'Name', fieldName: 'Name', sortable:true},
        {label: 'Account Number', fieldName: 'AccountNumber', sortable:true},
        {label: 'Phone',fieldName: 'Phone',sortable:true}
    ]

 
    sortedBy = 'Name';
    sortedDirection = 'asc';

    originalData = [];


    @wire(getAccount)
    wiredAccount({error,data}){
        if(data){
            this.account=data;
            this.originalData= [...data];
        }
        else if(error){
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: error.body.message,
                variant: 'error'
            }));
        }
    }

    // sorting funcitionality

    handleSort(event){
        const {fieldName: sortedBy, sortDirection} = event.detail;
        console.log(event.detail);
        const cloneData = [...this.originalData];
        cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1: -1));
        this.account = cloneData;
        this.sortedBy = sortedBy;
        this.sortedDirecion = sortDirection;
    }

    sortBy(field, reverse){
        return function (a,b){
            console.log(a);
            console.log(b);
            const aVal = a[field] ? a[field].toLowerCase(): '';
            const bVal  = b[field]? b[field].toLowerCase():'';
            return reverse * ((aVal>bVal) - (bVal > aVal));
        };
    }

    // searching functionality
    setVal(event){
        this.searchVal = event.target.value;
    }

    searchThis(event){
        
        const regex = RegExp(`^${this.searchVal}`);
        const data = this.originalData.filter( (el) => {
            return regex.test(el.Name);
        })

        this.account = data;
    }


}