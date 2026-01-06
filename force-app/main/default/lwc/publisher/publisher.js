import { LightningElement,wire } from 'lwc';
import getContacts from '@salesforce/apex/ContactController.getContacts';
import MyMessageChannel from '@salesforce/messageChannel/myMessageChannel__c';
import { MessageContext, publish } from 'lightning/messageService';


export default class Publisher extends LightningElement 
{

    contactsList=[];
    isLoaded = false;
    @wire(getContacts,{}) getCont({data,error}){
        
        if(data){
            for(const cont of data){
                this.contactsList.push({label: cont.LastName, value:cont.Id});
            }
            this.isLoaded = true;
        }
        if(error){
            console.log('error while fetching data');
            
        }
    }

    @wire(MessageContext) messageContext;
    handleChange(event)
    {
        publish(this.messageContext,MyMessageChannel,{Id:event.target.value})
    }
}
    // contactsList=[];
    // isLoaded=false;

    // @wire(getContacts,{}) getCont({data,error})
    // {
    //     console.log('here',data,error);
    //     if(data)
    //     {
    //         console.log(data);
    //         for(const cont of data)
    //         {
    //             this.contactsList.push({label:cont.LastName,value:cont.Id});
    //         }
    //         this.isLoaded=true;
    //     }
    //     if(error)
    //     {
    //         console.log('error while fetching data');
    //     }
    // }

    // @wire(MessageContext) messageContext;
    // handleChange(event)
    // {
    //     publish(this.messageContext,MyMessageChannel,{Id:event.target.value})
    // }


//}