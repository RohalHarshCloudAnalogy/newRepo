import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CaseDetailModal extends LightningElement {
    @api caseId; 
    @api isModalOpen = false; 

    closeModal() {
        const closeEvent = new CustomEvent('modalclose', {
            detail: { updated: false } // default if closed manually
        });
        this.dispatchEvent(closeEvent);
    }

    handleSuccess(event) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Case updated successfully',
                variant: 'success',
            })
        );
        const closeEvent = new CustomEvent('modalclose', {
            detail: { updated: true } // tells parent to refresh list
        });
        this.dispatchEvent(closeEvent);
    }

    handleError(event) {
        console.error('Error updating case in line 30', event.detail);
    }
}