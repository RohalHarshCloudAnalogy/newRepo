import { LightningElement,api } from 'lwc';
import sendEmail from '@salesforce/apex/fetchAccount.sendEmail';

export default class Lwc15May extends LightningElement {
    @api recordId;

    handleClick(){
        console.log('recordId');
        console.log(this.recordId);
        sendEmail({recordId : this.recordId})
        .then(result => {
            alert('Email sent successfully');
        })
        .catch(error => {
            alert('Email not sent');
        })
    }
}