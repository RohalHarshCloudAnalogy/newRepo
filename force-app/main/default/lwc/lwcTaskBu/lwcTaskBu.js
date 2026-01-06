import { LightningElement,track ,api} from 'lwc';
import sendEmail from '@salesforce/apex/fetchAccount.sendEmail';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';



export default class LwcTaskBu extends LightningElement {

    @track isEmailSend = false;
    sendingEmail = '';
    setSubject = '';
    setBody = '';
    isFormatVisible = false;


    handleChangeOfData(event){
        if(event.target.name == 'email'){
            this.sendingEmail = event.target.value;
        }
        if(event.target.name == 'subject'){
            this.setSubject = event.target.value;
        }
        if(event.target.name == 'body'){
            this.setBody = event.target.value;
        }
    }
    
    handleFormattedText(){
        this.isFormatVisible = !this.isFormatVisible;
    }
    handleSendEmail(){
        sendEmail({email: this.sendingEmail,Subject:this.setSubject,Body:this.setBody})
        this.dispatchEvent(new ShowToastEvent({
            title: 'Success',
            message: 'Email Sent Successfully',
            variant: 'success',
        }))
        


    }

    handleUploadClick(){
        alert('Upload Button Clicked');
    }

    

    handleClick(){
        this.isEmailSend = true;    
    }

    handleModalClose(){
        this.isEmailSend = false;
    }
    

}