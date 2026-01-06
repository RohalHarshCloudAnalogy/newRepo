import { LightningElement } from 'lwc';

export default class GrandParentLWC extends LightningElement {
    firedGrandParent(){
        console.log('Fired Grand Parent child component');
    
    }
    
    firedGrandParentDiv(){
        console.log('Fired Grand Parent Div component');
    }
}