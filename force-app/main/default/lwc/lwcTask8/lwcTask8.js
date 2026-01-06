import { LightningElement } from 'lwc';
import insertAccount from '@salesforce/apex/createAccount.insertAccount';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class LwcTask8 extends LightningElement {
    name;
    rating;
    phone;
    industry;
    location;

    handleChange(event){

        if(event.target.name === 'name'){
            this.name = event.target.value;
            console.log('aksdf;as;');
            console.log(this.name);
        }
        else if(event.target.name === 'rating'){
            this.rating = event.target.value;
            console.log(this.rating);
        }
        else if(event.target.name === 'phone'){
            this.phone = event.target.value;
            console.log(this.phone);
        }
        
        else if(event.target.name === 'industry'){
            this.industry = event.target.value;
            console.log(this.industry);
        }

        else if(event.target.name === 'location'){
            this.location = event.target.value;
            console.log(this.location);
        }
    }

    handleSave(event){

        insertAccount({
            name: this.name,
            rating: this.rating,
            phone: this.phone,
            industry: this.industry,
            location: this.location
        }).then(() => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success',
                message: 'Account has been created',
                variant: 'success'
            }))
            this.name = '';
            this.rating = '';
            this.phone = '';   
            this.industry = '';
            this.location = '';
        })
        .catch(error => {
            this.dispatchEvent(new ShowToastEvent({
                title:'Error',
                message: error.body.message,
                 variant: 'error'
            }));
        });
    }





}