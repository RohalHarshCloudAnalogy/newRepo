import { LightningElement,wire,track } from 'lwc';
import getObject from '@salesforce/apex/fetchAccount.getObjects'; 
import getRelatedField from '@salesforce/apex/fetchAccount.getRelatedField';

export default class LwcTask17 extends LightningElement {
    @track selectedValue='';
    @track fields;
    @track objects=[];
    @track selectedField='';
    @track fieldDetails;

    handleChange(event){
        
        this.selectedValue=event.target.value;
        this.selectedField = '';
        this.fieldDetails = null;

        console.log('selectedValue',this.selectedValue);

        getRelatedField({objectApiName : this.selectedValue})
        .then( result => {
            this.fields = result.map(field => ({label: field.label, value: field.apiName, type: field.type}))
        })
        .catch( error => {
            console.log('error',error);
        });


    }

    handleFieldChange(event){
        this.selectedField = event.target.value;

        const selectedFieldData = this.fields.find( f => f.value === this.selectedField);


        console.log('selectedFieldData',selectedFieldData);

        if(selectedFieldData){
            this.fieldDetails = {
                    apiName: selectedFieldData.value,
                    type: selectedFieldData.type
            };
        }

    }


    @wire(getObject)
    wiredObjects({error,data}) {
        if(data){
            console.log('aata hai');
            // console.log('data hai?',JSON.stringify(data));
            this.objects = data.map(
                obj => ({label: obj.SObjectType, value: obj.Id})
               
            );

            console.log(JSON.stringify(this.objects));
            
        }
        else if(error){
            console.log('error hai');
            console.log('line 26 errir',error);
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: error.body.message,
                variant: 'error'
            }));
        }
    }




}