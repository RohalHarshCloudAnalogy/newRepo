import { LightningElement } from 'lwc';

export default class ChildLWC extends LightningElement {

    handleClick(){

        this.dispatchEvent(new CustomEvent('fire',{
            bubbles:true,
            composed:true
        }));
        console.log('Button clicked');

    }
}