import { LightningElement, track, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getAccounts from '@salesforce/apex/accountListService.getAccounts';
import getAccountInfo from '@salesforce/apex/accountListService.getAccountInfo';

const columns = [
    { label: 'Name', fieldName: 'Name', hideDefaultActions: true },
];

export default class accountList extends LightningElement {
    columns = columns;
    error;
    selectedAccountId;
    @track accounts;
    @track error;
    
    @track accountName;
    @track isProcessing = true;
    @track isShowingList = true;
    account;

    @wire(getAccounts) 
    wiredAccounts(value) {
        this.isProcessing = false;
        this.wiredAccountList = value;
        const { data, error } = value;  
        if (data) {
            this.accounts = data;
            this.isShowingList = true;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.accounts = undefined;
        }
    }

    connectedCallback() {
        this.isProcessing = true;
    }

    getSelectedRowData(event) {
        const selectedRow = event.detail.selectedRows;
        this.selectedAccountId = selectedRow[0].Id;
    }

    getAccountData(){
        this.isProcessing = true;
        getAccountInfo({accountId: this.selectedAccountId})
        .then(result=>{
            this.account = result;
            this.accountName = this.account.Name;
            this.isProcessing = false;
            this.isShowingList = false;
            this.error = undefined;
        })
        .catch(error => {
            this.error = error;
            this.account = undefined;
        });
    }

    refreshAccountList() {
        this.isProcessing = true;
        refreshApex(this.wiredAccountList);
        this.isProcessing = false;
        this.isShowingList = true;
        this.accountName = '';
    }

    navigateToAccountRecord() {
        window.open(
            '/'+this.account.Id,
            '_blank'
          );
    }
}