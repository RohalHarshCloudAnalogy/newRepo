import { LightningElement ,api,wire} from 'lwc';
import {getRecord} from 'lightning/uiRecordApi';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';




const FIELDS = ['Account.Name','Account.Industry','Account.Phone'];

export default class LwcTaskLds extends LightningElement {
    @api recordId;

    isEditMode=false;

    @wire(getRecord,{recordId: '$recordId', fields: FIELDS}) account;



    handleEditClick(){
        this.isEditMode=true;
    }

    handleCancel(){
        this.isEditMode=false;
    }

    handleSuccess(){
        this.isEditMode=false;
        this.dispatchEvent(
            new ShowToastEvent({
                title:'Success',
                message:'The record has been updated',
                variant: 'success'
            })
        )
    }

}