import { LightningElement, track } from 'lwc';
import accWithContacts from '@salesforce/apex/fetchAccount.accWithContacts';

export default class TreeGridLwc extends LightningElement {
    @track gridColumns = [
        {
            type: 'text',
            fieldName: 'Name',
            label: 'Name'
        },
        {
            type: 'text',
            fieldName: 'FirstName',
            label: 'First Name'
        },
        {
            type: 'text',
            fieldName: 'LastName',
            label: 'Last Name'
        }
    ];


    @track gridData;

    connectedCallback(){
        accWithContacts()
        .then(result => {
            let accData = JSON.parse(JSON.stringify(result));
            console.log(JSON.stringify(accData));
            for(let i = 0; i < accData.length; i++){
                accData[i]._children = accData[i].Contacts;
                delete accData[i].Contacts;
                
            }

            this.gridData = accData;

            
            console.log(JSON.stringify(accData));
        })
        .catch(error => {
            console.log(error);
        })
    }



    handleRowSelection(event) {
        console.log(event.detail.selectedRows);
    }

}