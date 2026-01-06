import { LightningElement,track } from 'lwc';

export default class AccountChild1 extends LightningElement {

    @track searchTextChild1;
    handleChange(event){
        this.searchTextChild1 = event.target.value;
    }

    handleButtonClick(event){            
         this.dispatchEvent( new CustomEvent('getsearchevent',{detail:this.searchTextChild1}));
    }
}