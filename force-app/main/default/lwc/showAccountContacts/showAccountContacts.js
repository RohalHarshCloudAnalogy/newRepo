import { LightningElement ,api,wire} from 'lwc';
import MyMessageChannel from '@salesforce/messageChannel/AccountRelatedContact__c';
import { MessageContext, subscribe,unsubscribe } from 'lightning/messageService';
import getContacts from '@salesforce/apex/fetchAccount.getContacts';

export default class ShowAccountContacts extends LightningElement {

    title = "Contacts";
    hasContacts;

    editableContactId;
    selectedAccount=true;

    @api recordId;

    addContact = false;
    editContact = false;
 
    columns=[
        {label: 'Id' , fieldName: 'Id'},
        {label: 'First Name', fieldName: 'FirstName'},
        {label: 'Last Name', fieldName: 'LastName'}
    ]

    data=[];
    accIdFromPub;
    accNameFromPub;
    accPhoneFromPub;
    subscription=null;
    @wire(MessageContext) messageContext;

    connectedCallback(){
        this.handleSubscribe();
    }

    disconnectedCallback(){
        this.handleUnsubscribe();
    }

    handleSubscribe(){
        if(!this.subscription){
            this.subscription = subscribe(this.messageContext, MyMessageChannel, (message) => this.handleMessage(message));
            console.log('handleSubscribe');
        }
    }

    handleMessage(message){
        console.log('handleMessage');
        console.log('A',message.Id);
        console.log('B',message.Name);
        console.log('C',message);
        console.log('hM2');

        this.title = message.Name +"'s Contacts";
        
        this.accIdFromPub = message.Id;
        console.log(this.accIdFromPub);

        this.selectedAccount = false;

        getContacts({accountId:this.accIdFromPub})
        .then(data =>{
            // console.log(data);
            this.data = data;
            this.hasContacts = this.data.length>0 ? true: false;

        })
        .catch(error => {
            console.log('error hai',error);
        })



    }

    handleSuccess(){
        this.addContact = false;
        
    }

    handleAddContactClick(){
        this.addContact = true;
    }

    handleCancelClick(){
        this.addContact = false;
    }
    
    handleEditClick(event){
        this.editContact = true;
        // this.editableContactId = event.target.dataset.contactId;
    }

    handleDeleteClick(event){
        console.log(event);
    }

    handleEditSuccess(){
        this.editContact = false;
    
    }
    
    handleUnsubscribe(){
        unsubscribe(this.subscription);
        this.subscription = null;
    }

}