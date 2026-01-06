import { LightningElement ,api,wire} from 'lwc';
import getAccount from '@salesforce/apex/fetchAccount.getAccount';
import MyMessageChannel from '@salesforce/messageChannel/AccountRelatedContact__c';
import { MessageContext, publish } from 'lightning/messageService';



    
export default class AccountChild2 extends LightningElement {

    @wire(MessageContext) messageContext;
    accId='';
    accName='';
    @api searchTextChild2='';
    data=[];
    columns= [
        {label: 'Id' , fieldName: 'Id'},
        {label: 'Name', fieldName: 'Name'},
        {label: 'Actions', fieldName: 'Actions',type:'button', typeAttributes:{
            label: 'View Contacts',
            value: 'view_contacts'
        }}
        
    ];
    
    connectedCallback(){
        getAccount({searchKey:''})
        .then(data => {
            this.data = data;
        })
        .catch(error => {
            this.data = [];
            console.log('error',error);
        });
    }

    @wire(getAccount,{searchKey: '$searchTextChild2'})
    wiredAccount({data,error}){
        if(data){
            this.data = data;
        }
        else{
            this.data = [];
            console.log('error',error);
        }
    }


    handleRowAction(event){
        console.log(event.detail.row);
        if(event.detail.action.value == 'view_contacts'){
            this.accId = event.detail.row.Id;
            this.accName = event.detail.row.Name;
            this.accPhone = event.detail.row.Phone;

            let payload = {
                Id : this.accId,
                Name : this.accName,
                Phone: this.accPhone
            }
            publish(this.messageContext,MyMessageChannel,payload);
        }
        

    }


}