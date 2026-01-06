import { LightningElement,track } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import saveAccounts from '@salesforce/apex/fetchAccount.saveAccounts';

export default class LwcTask14 extends LightningElement {

    @track rows=[];
    rowId = 1;

    connectedCallback(){
        this.handleAddRow();
    }


    indexPlusOne(index){
        return index +1;
    }

    handleAddRow(){
        this.rows = [...this.rows , {
            Id: this.rowId++,
            name: '',
            number: '',
            phone: '',
            website: ''

        }]
    }

    handleInputChange(event){
        console.log(event.target.dataset);
        const field = event.target.getAttribute('data-field');
         const value = event.target.value;
         const index = Number(event.target.getAttribute('data-id'));

         this.rows = this.rows.map((row) => {
             if(row.Id === index){
                 return {
                    ...row,
                    [field]: value
                 };
             }
             return row;
         })

    }


    handleDeleteRow(event){
        console.log('asldkfjasldkfjas;djfadsfjad;lkaj');
        console.log(event.target.getAttribute('data-id'));
        this.rows = this.rows.filter(row => row.Id != event.target.getAttribute('data-id'));
      
        
    }

    handleSave(){
        const saveResult  = this.rows.map(row => ({
            Name: row.name,
            AccountNumber: row.number,
            Phone: row.phone,
            Website: row.website  
        }));


        saveAccounts({accList : saveResult})
        .then(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Accounts saved successfully',
                    variant: 'success'
                })
            );
            this.rows = [];
            this.handleAddRow();
        }) 
        .catch(error => {
            console.log(error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        });
    }
}