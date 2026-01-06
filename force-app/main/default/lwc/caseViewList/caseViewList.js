import { LightningElement, wire, track, api } from 'lwc';
import { getListUi } from 'lightning/uiListApi';
import CASE_OBJECT from '@salesforce/schema/Case';
import PRIORITY_FIELD from '@salesforce/schema/Case.Priority';
import STATUS_FIELD from '@salesforce/schema/Case.Status';
import SUBJECT_FIELD from '@salesforce/schema/Case.Subject';
import DESCRIPTION_FIELD from '@salesforce/schema/Case.Description';
import CREATEDDATE_FIELD from '@salesforce/schema/Case.CreatedDate';

import { refreshApex } from '@salesforce/apex';
import CASE_UPDATE_CHANNEL from '@salesforce/messageChannel/CaseRecordUpdate__c';
import { MessageContext, subscribe, unsubscribe } from 'lightning/messageService';

export default class CaseViewList extends LightningElement {

    subscription = null;
    @api newCaseRecord
    @track cases = [];
    @track filteredCases = [];
    @track searchKey = '';
    @track selectedPriority = '';
    @track selectedStatus = 'New';  // Default to New
    @track sortBy = 'CreatedDate';
    @track sortDirection = 'asc';
    wiredCasesResult; 

    priorityOptions = [
        { label: 'All', value: '' },
        { label: 'High', value: 'High' },
        { label: 'Medium', value: 'Medium' },
        { label: 'Low', value: 'Low' },
    ];

    statusOptions = [
        { label: 'All', value: '' },
        { label: 'New', value: 'New' },
        { label: 'In Progress', value: 'In Progress' },
        { label: 'Working', value: 'Working' },
        { label: 'Escalated', value: 'Escalated' },
        { label: 'Closed', value: 'Closed' }, // add Closed because records might come as closed from backend
    ];

    columns = [
        { label: 'Subject', fieldName: 'Subject', sortable: true },
        { label: 'Priority', fieldName: 'Priority', sortable: true },
        { label: 'Status', fieldName: 'Status', sortable: true },
        { label: 'Created Date', fieldName: 'CreatedDate', type: 'date', sortable: true },
        { label: 'Action', type: 'button', typeAttributes: { label: 'View', name: 'view', variant: 'brand' } }
    ];

    @wire(MessageContext)messageContext;
    @wire(getListUi, {
        objectApiName: CASE_OBJECT,
        listViewApiName: 'AllCases', // Use a broader view or create custom Apex
        fields: [PRIORITY_FIELD, STATUS_FIELD, SUBJECT_FIELD, DESCRIPTION_FIELD, CREATEDDATE_FIELD]
    })
    wiredCases(result) {
        console.log('hi' ,result);
        this.wiredCasesResult = result;
        const { data, error } = result;
        if (data) {
            this.cases = data.records.records.map(record => ({
                Id: record.id,
                Subject: record.fields.Subject?.value,
                Priority: record.fields.Priority?.value,
                Status: record.fields.Status?.value,
                Description: record.fields.Description?.value,
                CreatedDate: record.fields.CreatedDate?.value
            }));
            this.filterCases(); // Apply filter after load
        } else if (error) {
            console.error('Error retrieving cases:', error);
        }
    }

   connectedCallback(){
        this.refreshListOnNewCase();
    }
    disconnectedCallback() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }
    refreshListOnNewCase(){
        if(!this.subscription){
            this.subscription = subscribe(this.messageContext, CASE_UPDATE_CHANNEL, (data)=>{
                console.log(data);
                refreshApex(this.wiredCasesResult);
            })
        }
    }
    handleSearch(event) {
        this.searchKey = event.target.value.toLowerCase();
        this.filterCases();
    }

    handlePriorityFilter(event) {
        this.selectedPriority = event.target.value;
        this.filterCases();
    }

    handleStatusFilter(event) {
        this.selectedStatus = event.target.value;
        this.filterCases();
    }

    handleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        this.sortBy = sortedBy;
        this.sortDirection = sortDirection;
        this.sortCases();
    }

    filterCases() {
        this.filteredCases = this.cases.filter(item => {
            const searchMatch = 
                (!this.searchKey || (item.Subject && item.Subject.toLowerCase().includes(this.searchKey)) ||
                (item.Description && item.Description.toLowerCase().includes(this.searchKey)));

            const priorityMatch = !this.selectedPriority || item.Priority === this.selectedPriority;
            const statusMatch = !this.selectedStatus || item.Status === this.selectedStatus;
            return searchMatch && priorityMatch && statusMatch;
        });
        this.sortCases();
    }

    sortCases() {
        let sortedResult = [...this.filteredCases];
        sortedResult.sort((a, b) => {
            let valA = a[this.sortBy] || '';
            let valB = b[this.sortBy] || '';
            if (this.sortDirection === 'asc') {
                return valA > valB ? 1 : -1;
            } else {
                return valA < valB ? 1 : -1;
            }
        });
        this.filteredCases = sortedResult;
    }

    handleRowAction(event) {
        const eventName = event.detail.action.name;
        const row = event.detail.row;

        if (eventName === 'view') {
            this.openCaseDetailModal(row.Id);
            console.log('Hi');
        }
    }

    openCaseDetailModal(caseId) {
        try {
            caseDetailModal.open({
                size: 'medium',
                description: 'Case View Modal',
                caseId: caseId
            }).then((result) => {
                console.log('Modal closed with result:', result);
            }).catch((error) => {
                console.error('Error opening modal:', error);
            });
        } catch (error) {
            console.log(JSON.stringify(error));
        }
    }

}