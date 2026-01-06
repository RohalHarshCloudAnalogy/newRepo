import { LightningElement,api,track } from 'lwc';

import sendEmail from '@salesforce/apex/fetchAccount.sendEmail'
import Subject from '@salesforce/schema/Case.Subject';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import LightningModal from 'lightning/modal';

export default class ModalComponent extends LightningElement {
    @api isEmailSend;

     @track sendingEmail = '';
        @track setSubject = '';
        @track setBody = '';
    
        handleChangeOfData(event){
            if(event.target.name === 'email'){
                this.sendingEmail = event.target.value;
            }
            else if(event.target.name === 'subject'){
                    this.setSubject = event.target.value;
            }
            else{
                    this.setBody = event.target.value;
            }
            
        }
    
        
        handleClickClose(){
            this.dispatchEvent(new CustomEvent('closemodel'));
        }
    
        handleSendEmail(event){
            sendEmail({email: this.sendingEmail, Subject: this.setSubject, Body: this.setBody})
            .then(()=>{
                this.isEmailSend = false;
                this.sendingEmail = '';
                this.setSubject = '';
                this.setBody = '';
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success',
                    message: 'The Email has been sent',
                    variant: 'success'
                }))

                this.dispatchEvent(new CustomEvent('closemodel'));
            })
            .catch(error =>{
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error',
                    message: error.body.message,
                    variant: 'error'
                })) 
            })
        }
}