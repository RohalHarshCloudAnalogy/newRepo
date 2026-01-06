import { LightningElement,wire } from 'lwc';
import fetchAccount from '@salesforce/apex/fetchAccount.fetchAccount';

export default class ChooseAccount extends LightningElement {
    options = [];
    selectedValue = '';

    @wire(fetchAccount) 
    wiredAccount({error , data}){
        if(data){
            this.options = data.map(record => ({label : record.Name , value : record.Id}));
        }
        else if(error){
            console.log('error occured'+error);
        }
    }

    handleChange(event){
        this.selectedValue = event.target.value;
    }

}