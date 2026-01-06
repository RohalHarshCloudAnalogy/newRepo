import { LightningElement, track, api } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import CLOSEDATE_FIELD from '@salesforce/schema/Opportunity.CloseDate';
import ID_FIELD from '@salesforce/schema/Opportunity.Id';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class LwcTask15 extends LightningElement {
    @api recordId;
    closeDate;
    @track isModalOpen = false;

    openModal(){
        this.isModalOpen = true;
        console.log('opennnnnnnnnnnnnnnn');
    }


    handleChange(event){
        this.closeDate = event.target.value;
    
    }

    closeModal(){
        this.isModalOpen = false;
    }

    handleSave(){
        const field ={};

        field[CLOSEDATE_FIELD.fieldApiName] = this.closeDate;
        field[ID_FIELD.fieldApiName] = this.recordId

        updateRecord({fields: field})
        .then(() => {
            this.closeModal();
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Opportunity closed successfully',
                    variant: 'success'
                })
            );  
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