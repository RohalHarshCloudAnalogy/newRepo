import { LightningElement, wire, track, api } from 'lwc';
import { getListUi } from 'lightning/uiListApi';
import CASE_OBJECT from '@salesforce/schema/Case';
import PRIORITY_FIELD from '@salesforce/schema/Case.Priority';
import STATUS_FIELD from '@salesforce/schema/Case.Status';
import SUBJECT_FIELD from '@salesforce/schema/Case.Subject';
import DESCRIPTION_FIELD from '@salesforce/schema/Case.Description';
import CREATEDDATE_FIELD from '@salesforce/schema/Case.CreatedDate';
import caseDetailModal from 'c/caseDetailModal';
import { refreshApex } from '@salesforce/apex';
import CASE_UPDATE_CHANNEL from '@salesforce/messageChannel/CaseRecordUpdate__c';
import { MessageContext, subscribe, unsubscribe } from 'lightning/messageService';
export default class CaseListComp extends LightningElement {}