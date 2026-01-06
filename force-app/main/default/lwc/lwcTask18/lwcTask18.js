import {LightningElement , track} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';



export default class LwcTask18 extends LightningElement {
   @track userName = '';
   @track password = '';
   @track successMessage = '';
   @track errorMessage = '';

    handleUNChange(event){
        console.log('a');
        this.userName = event.target.value;
    }

    handlePasswordChange(event){
        console.log('b');
        this.password = event.target.value;
    }


    handleSubmit(){
        try{
            console.log('c');
          
            
            

            console.log('e');
            

        }
        catch(err){
            console.error('An error occurred in handleSubmit:', err);
        }
        console.log('f');

    }
}