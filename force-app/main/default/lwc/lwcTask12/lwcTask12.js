import { LightningElement, wire, track } from 'lwc';
import getAccount from '@salesforce/apex/fetchAccount.getAccount';
import deleteAccount from '@salesforce/apex/fetchAccount.deleteAccounts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class LwcTask12 extends LightningElement {
    @track accounts = [];
    @track selectedRowIds = [];
    @track isDeleteDisabled = true;

    wiredAccountResult;

    columns = [
        { label: 'Name', fieldName: 'Name' }
    ];

    @wire(getAccount)
    wiredAccounts(result) {
        this.wiredAccountResult = result; // Save the wire reference for refresh
        if (result.data) {
            this.accounts = result.data;
        } else if (result.error) {
            this.showToast('Error', 'Error fetching accounts', 'error');
        }
    }

    handleRowSelection(event) {
        this.isDeleteDisabled = false;
        this.selectedRowIds = event.detail.selectedRows.map(
            (row) => row.Id);
        console.log(JSON.stringify(this.selectedRowIds));
    }

    handleClick() {

        if (this.selectedRowIds.length === 0) {
            this.showToast('Error', 'Please select at least one row', 'error');
            return;
        }

        deleteAccount({ accounts: this.selectedRowIds })
            .then((res) => {
                
                this.showToast('Success', 'Accounts Deleted', 'success');
                this.selectedRowIds = [];
                this.isDeleteDisabled = true;
                return refreshApex(this.wiredAccountResult); // Refresh data properly
            })
            .catch((error) => {
                this.showToast('Error', error.body.message, 'error');
            });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({
            title,
            message,
            variant
        }));
    }
}