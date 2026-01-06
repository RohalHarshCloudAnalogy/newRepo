import getContacts from '@salesforce/apex/AccountLWCOne.getContacts';
import { createRecord } from 'lightning/uiRecordApi';
import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { MessageContext, publish } from 'lightning/messageService';
import CASE_UPDATE_CHANNEL from '@salesforce/messageChannel/CaseRecordUpdate__c';


export default class CreateCaseCom extends LightningElement {
    subject;
    description;
    priorityVal;
    statusVal;
    contVal;

    priorityOptions = [
        { label: 'High', value: 'High' },
        { label: 'Medium', value: 'Medium' },
        { label: 'Low', value: 'Low' }
    ];

    statusOptions = [
        { label: 'New', value: 'New' },
        { label: 'In Progress', value: 'In Progress' },
        { label: 'Closed', value: 'Closed' },
    ];

    contactOptions = [];

    @wire(MessageContext) messageContext;

    @wire(getContacts)
    wiredContacts({ data, error }) {
        if (data) {
            console.log('sdjlksd',data);
            this.contactOptions = data.map(cont => ({
                label: cont.Name,
                value: cont.Id
            }));
        } else if (error) {
            console.error(error);
        }
    }

    handleSubjectChange(e) {
        this.subject = e.detail.value;
    }
    handleDescriptionChange(e) {
        this.description = e.detail.value;
    }
    handlePriorityChange(e) {
        this.priorityVal = e.detail.value;
    }
    handleStatusChange(e) {
        this.statusVal = e.detail.value;
    }
    handleContactChange(e) {
        this.contVal = e.detail.value;
    }

    handleSubmit(e) {
        e.preventDefault();

        const caseFields = {
            Subject: this.subject,
            Description: this.description,
            Priority: this.priorityVal,
            Status: this.statusVal,
            ContactId: this.contVal
        };

        // Check for empty values
        const missingFields = Object.entries(caseFields).filter(([key, value]) => !value);
        if (missingFields.length > 0) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Missing Fields',
                    message: 'Please fill out all the fields before submitting.',
                    variant: 'warning'
                })
            );
            return;
        }

        // Proceed to create case if all fields are filled
        createRecord({ apiName: 'Case', fields: caseFields })
            .then(caseRecord => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Case created successfully',
                        variant: 'success'
                    })
                );

                // Reset fields
                this.subject = '';
                this.description = '';
                this.priorityVal = undefined;
                this.statusVal = undefined;
                this.contVal = undefined;

                const payload = { caseId: caseRecord.id };
                publish(this.messageContext, CASE_UPDATE_CHANNEL, payload);
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating case',
                        message: 'Error!',
                        variant: 'error'
                    })
                );
                console.error('Error creating case:', error);
            });
    }
}