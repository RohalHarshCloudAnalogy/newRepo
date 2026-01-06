import { LightningElement, wire, track, api } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import getProducts from '@salesforce/apex/StripePaymentHelper.getOpportunityLineItems';
import sendPaymentRequest from '@salesforce/apex/StripePaymentHelper.sendPaymentRequest';

export default class StripePaymentCmp extends LightningElement {


    records;
    totalPrice = 0;
    @api recordId='';
    isProcess;
    isDisabled;

    connectedCallback() {
        console.log('Record Id' + this.recordId);
        if (this.recordId) {
            console.log('Inside if');
            getProducts({ parentId: this.recordId }).then((result) => {
                console.log('Results : '+result);
                let totalProductsPrice = 0;
                result.forEach(prod => {
                    totalProductsPrice += prod.TotalPrice;
                });
                this.totalPrice = "Pay($" + totalProductsPrice + ")";
                this.records = result;
            }).catch((error) => {
                console.log('Error fetching products: ' + JSON.stringify(error));
            });
        }
    }


    handlePay() {
        this.isProcess = true;
        this.isDisabled = true;
        const dataJson = JSON.stringify(this.records);
        console.log('record'+dataJson);
        sendPaymentRequest({ productsJson: dataJson }).then((result) => {
            this.isProcess = false;
            this.showToastMessage('Request Success', 'Payment request sucessfully sent', 'success');
        }).catch((error) => {
            this.isProcess = false;
            this.isDisabled = false;
            this.showToastMessage('Request Error', 'Something went wrong' + error, 'error');
        });
    }

    showToastMessage(title, mes, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: mes,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }


}