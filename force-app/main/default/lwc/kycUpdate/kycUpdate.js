import { LightningElement, track } from 'lwc';
import createKYCRecord from '@salesforce/apex/KYCController.createKYCRecord';

export default class KycUpdate extends LightningElement {
    @track docType = '';
    @track acceptedFormats = ['.pdf','.jpg','.png'];
    dummyRecordId; // dynamically created record Id

    handleDocTypeChange(event){
        this.docType = event.target.value;
    }

    handleDocTypeChange(event){
        this.docType = event.target.value;
    }

    createRecordAndUpload(){
        if(!this.docType){
            alert('Please enter new type!');
            return;
        }

        createKYCRecord({ docType: this.docType })
            .then(result => {
                this.dummyRecordId = result;
                console.log('KYC Document Record Created: ' + this.dummyRecordId);
            })
            .catch(error => {
                console.error('Error creating KYC record: ', error);
            });
    }

    handleUploadFinished(event){
        const uploadedFiles = event.detail.files;
        if(uploadedFiles.length > 0){
            alert('File uploaded successfully: ' + uploadedFiles[0].name);
            // Record-Triggered Flow will fire automatically
        }
    }


}