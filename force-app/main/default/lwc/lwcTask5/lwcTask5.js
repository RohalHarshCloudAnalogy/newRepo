import { LightningElement } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class LwcTask5 extends LightningElement {
    handleClick(){
        const evt = new ShowToastEvent({
            title: 'Success',
            message: 'Clicked',
            variant: 'success',
            mode: 'dismissable'
        });

        this.dispatchEvent(evt);
    }
}