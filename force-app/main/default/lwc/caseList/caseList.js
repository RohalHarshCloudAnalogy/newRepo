import { LightningElement, track, wire } from 'lwc';
import getOpenCases from '@salesforce/apex/CaseController.getOpenCases';
import { subscribe, MessageContext } from 'lightning/messageService';
import CASE_CHANNEL from '@salesforce/messageChannel/CaseMessageChannel__c';
import { refreshApex } from '@salesforce/apex';

const COLUMNS = [
    { label: 'Case Number', fieldName: 'CaseNumber', sortable: true },
    { label: 'Subject', fieldName: 'Subject', sortable: true },
    { label: 'Priority', fieldName: 'Priority', sortable: true },
    { label: 'Status', fieldName: 'Status', sortable: true },
    { label: 'Created Date', fieldName: 'CreatedDate', type: 'date', sortable: true },
    { label: 'Actions', type: 'button', typeAttributes: { label: 'View', name: 'view', variant: 'brand' } }
];

export default class CaseList extends LightningElement {
    @track searchKey = '';
    @track priorityFilter = 'All';
    @track statusFilter = 'All';
    @track sortedBy = 'CreatedDate';
    @track sortedDirection = 'desc';
    @track cases = [];
    @track filteredCases = [];
    @track selectedCase = null;
    @track isModalOpen = false;
    @track subscription;

    caseId;
    columns = COLUMNS;
    wiredCasesResult;

    priorityOptions = [
        { label: 'All', value: 'All' },
        { label: 'High', value: 'High' },
        { label: 'Medium', value: 'Medium' },
        { label: 'Low', value: 'Low' }
    ];

    statusOptions = [
        { label: 'All', value: 'All' },
        { label: 'New', value: 'New' },
        { label: 'In Progress', value: 'In Progress' },
        { label: 'Closed', value: 'Closed' }
    ];

    @wire(MessageContext)
    messageContext;

    get normalizedPriority() {
        return this.priorityFilter === 'All' ? '' : this.priorityFilter;
    }

    get normalizedStatus() {
        return this.statusFilter === 'All' ? '' : this.statusFilter;
    }

    get isAscending() {
        return this.sortedDirection === 'asc';
    }

    @wire(getOpenCases, {
        searchKey: '$searchKey',
        priorityFilter: '$normalizedPriority',
        statusFilter: '$normalizedStatus',
        sortField: '$sortedBy',
        isAsc: '$isAscending'
    })
    wiredCases(result) {
        this.wiredCasesResult = result;
        if (result.data) {
            this.cases = result.data;
            this.applyFilters();
        } else if (result.error) {
            console.error('Error fetching cases:', result.error);
        }
    }

    connectedCallback() {
        this.subscribeToCaseUpdates();
    }

    subscribeToCaseUpdates() {
        this.subscription = subscribe(
            this.messageContext,
            CASE_CHANNEL,
            (message) => {
                console.log('Received LMS message:', message);
                this.handleCaseUpdate(message);
            }
        );
    }

    handleCaseUpdate(message) {
        if (message.action === 'refresh') {
            refreshApex(this.wiredCasesResult);
        }
    }

    handleSearch(event) {
        this.searchKey = event.target.value;
    }

    handlePriorityChange(event) {
        this.priorityFilter = event.detail.value;
    }

    handleStatusChange(event) {
        this.statusFilter = event.detail.value;
    }

    handleSort(event) {
        this.sortedBy = event.detail.fieldName;
        this.sortedDirection = event.detail.sortDirection;
    }

    handleViewCase(event) {
        this.caseId = event.detail.row.Id;
        this.isModalOpen = true;
    }

    handleCloseModal(event) {
        this.isModalOpen = false;
        this.selectedCase = null;

        if (event?.detail?.updated) {
            refreshApex(this.wiredCasesResult);
        }
    }

    applyFilters() {
        let filtered = [...this.cases];

        if (this.searchKey) {
            filtered = filtered.filter(c =>
                c.Subject && c.Subject.toLowerCase().includes(this.searchKey.toLowerCase())
            );
        }

        if (this.priorityFilter !== 'All') {
            filtered = filtered.filter(c => c.Priority === this.priorityFilter);
        }

        if (this.statusFilter !== 'All') {
            filtered = filtered.filter(c => c.Status === this.statusFilter);
        }

        this.filteredCases = filtered;
    }
}