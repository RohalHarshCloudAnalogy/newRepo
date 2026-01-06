import { LightningElement } from 'lwc';

export default class ParentLWC extends LightningElement {
    firedParent(){
        console.log('Fired Parent child component');
    }

    firedParentDiv(){
        console.log('Fired Parent Div component');
    }

    
}