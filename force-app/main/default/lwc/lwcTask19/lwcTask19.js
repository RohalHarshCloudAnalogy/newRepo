import { LightningElement,track ,wire} from 'lwc';
import getAccount from '@salesforce/apex/fetchAccount.getAccount';
import  getCountAmount from '@salesforce/apex/fetchAccount.getCountAmount';

export default class LwcTask19 extends LightningElement {
    @track accounts=[];
    @track selectedAccount='';
    totalOpp=0;
    totalSum=0;

    handleChange(event){
        this.selectedAccount=event.target.value;

        getCountAmount({accId : this.selectedAccount})
        .then(result => {
            this.totalOpp = result[1];
            this.totalSum = result[0];
            if(this.totalOpp == NULL) {
                this.totalOpp = 0;
            }
            if(this.totalSum == NULL) {
                this.totalSum = 0;
            }
            console.log(result[0]);
            console.log(result[1]);
        })
        .catch(error => {
            console.log('error hai');
        });
    }

    @wire(getAccount)
    wiredAccounts({error,data}){
        if(data){
            this.accounts = data.map( acc => ({label: acc.Name, value: acc.Id}));
        }
        else if(error){
            console.log('error hai');
        }
    }
}