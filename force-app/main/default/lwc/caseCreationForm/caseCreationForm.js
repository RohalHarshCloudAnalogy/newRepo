import { LightningElement, track, wire } from 'lwc';
import createCaseRecord from '@salesforce/apex/CaseController.createCase';
import { getListUi } from 'lightning/uiListApi';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import { publish, MessageContext } from 'lightning/messageService';
import CASE_CHANNEL from '@salesforce/messageChannel/CaseMessageChannel__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CaseCreationForm extends LightningElement {
    @track subject = '';
    @track description = '';
    @track priority = '';
    @track status = 'New';
    @track contactId = '';
    @track contactOptions = [];

    priorityOptions = [
        { label: 'High', value: 'High' },
        { label: 'Medium', value: 'Medium' },
        { label: 'Low', value: 'Low' }
    ];

    statusOptions = [
        { label: 'New', value: 'New' },
        { label: 'In Progress', value: 'In Progress' },
        { label: 'Closed', value: 'Closed' }
    ];

    @wire(getListUi, {
        objectApiName: CONTACT_OBJECT,
        listViewApiName: 'AllContacts',
        pageSize: 50
    })
    wiredContacts({ data, error }) {
        if (data) {
            this.contactOptions = data.records.records.map(record => ({
                label: record.fields.Name.value,
                value: record.id
            }));
        } else if (error) {
            console.error('Error loading contacts:', error);
        }
    }

    @wire(MessageContext) messageContext;

    handleChange(event) {
        const field = event.target.dataset.id;
        this[field] = event.detail.value;
    }

    createCase() {
        createCaseRecord({
            subject: this.subject,
            description: this.description,
            priority: this.priority,
            status: this.status,
            contactId: this.contactId
        }).then(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Case created successfully',
                    variant: 'success',
                })
            );

            // Publish message to refresh case list
            publish(this.messageContext, CASE_CHANNEL, {
                action: 'refresh'
            });

            console.log('Published refresh action');
            this.resetForm();
        }).catch(error => {
            console.error(error);
        });
    }

    resetForm() {
        this.subject = '';
        this.description = '';
        this.priority = '';
        this.status = 'New';
        this.contactId = '';
    }
}