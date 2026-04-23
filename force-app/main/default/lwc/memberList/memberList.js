import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';
import getContacts from '@salesforce/apex/MemberFormController.getContacts';

const COLUMNS = [
    { label: 'First Name', fieldName: 'firstName' },
    { label: 'Last Name', fieldName: 'lastName' },
    { label: 'Email', fieldName: 'email', type: 'email' },
    { label: 'Phone', fieldName: 'phone', type: 'phone' },
    { label: 'City', fieldName: 'mailingCity' },
    { label: 'State', fieldName: 'mailingState' },
    {
        type: 'action',
        typeAttributes: {
            rowActions: [{ label: 'View', name: 'view' }]
        }
    }
];

export default class MemberList extends NavigationMixin(LightningElement) {
    @track contacts = [];
    @track isLoading = true;
    columns = COLUMNS;
    wiredContactsResult;

    @wire(getContacts)
    wiredContacts(result) {
        this.wiredContactsResult = result;
        this.isLoading = false;
        if (result.data) {
            this.contacts = result.data.map(c => ({
                id: c.Id,
                firstName: c.FirstName,
                lastName: c.LastName,
                email: c.Email,
                phone: c.Phone,
                mailingCity: c.MailingCity,
                mailingState: c.MailingState
            }));
        }
    }

    get hasContacts() {
        return this.contacts && this.contacts.length > 0;
    }

    handleNewMember() {
        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                apiName: 'New_Member'
            }
        });
    }

    handleRowAction(event) {
        const row = event.detail.row;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: row.id,
                objectApiName: 'Contact',
                actionName: 'view'
            }
        });
    }
}
