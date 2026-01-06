import { LightningElement ,api ,wire} from 'lwc';
import getContactList from '@salesforce/apex/fetchAccount.getContacts';

export default class ShowContact extends LightningElement {
    @api accountId;
    contacts ;
    error;

    columns =[
        {label: 'First Name', fieldName: 'FirstName'},
        {label: 'Last Name', fieldName: 'LastName'},
        {label: 'Email', fieldName: 'Email'}
        
    ]

    @wire(getContactList, { accountId: '$accountId' })
    wiredContacts({error, data}){
        if(data){
            console.log ('data is : ' + data );
            this.contacts=data;
            console.log('Data h ye ',
                this.contacts);
            this.error=undefined;
        }
        else if(error){
            this.error=error;
            this.contacts=undefined;
            console.log(error);
            
        }
    }
}