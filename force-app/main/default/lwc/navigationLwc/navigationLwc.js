import { LightningElement } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';

export default class NavigationLwc extends NavigationMixin(LightningElement) {
    
    handleNavigate(event){
          

        //navigate to account record page
        this[NavigationMixin.Navigate]({
                type: 'standard__objectPage',
                attributes: {
                    recordId: '001dL00000nCt1QQAS',
                    objectApiName: 'Account',
                    actionName: 'edit'
                }

        })
    }
}