import { LightningElement ,wire} from 'lwc';
import getAccount from '@salesforce/apex/fetchAccount.getAccount';

export default class LifeCycleHooks extends LightningElement {

    isVisible = true;
    constructor(){
        super();
        console.log('Contructor call');
    }

    connectedCallback(){
        console.log('Connected callback');
    }

    renderedCallback(){
        console.log('Rendered callback');
    }

    disconnectedCallback(){
        console.log('Disconnected callback');
    }

    @wire(getAccount)  wiredAccount({error, data}){
        if(data){
            console.log('Data received');
            
        }
        else if(error){
            console.log('Error received');
        }
        console.log('Wire completed');
    }

    handleClick(event){
        console.log('Button CLicked');
        this.isVisible = false;
    }



    get checkOrder(){
        console.log('get RUN 1');
    }



}