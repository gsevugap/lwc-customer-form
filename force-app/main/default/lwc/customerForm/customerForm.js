import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import saveContact from '@salesforce/apex/CustomerFormController.saveContact';

export default class CustomerForm extends NavigationMixin(LightningElement) {
    @track firstName = '';
    @track lastName = '';
    @track email = '';
    @track phone = '';
    @track shippingStreet = '';
    @track shippingCity = '';
    @track shippingState = '';
    @track shippingPostalCode = '';
    @track shippingCountry = '';
    @track isSaving = false;
    @track successMessage = '';
    @track errorMessage = '';

    handleChange(event) {
        const field = event.target.name;
        this[field] = event.target.value;
    }

    async handleSave() {
        this.successMessage = '';
        this.errorMessage = '';

        if (!this.isValid()) return;

        this.isSaving = true;
        try {
            const contactId = await saveContact({
                firstName: this.firstName,
                lastName: this.lastName,
                email: this.email,
                phone: this.phone,
                shippingStreet: this.shippingStreet,
                shippingCity: this.shippingCity,
                shippingState: this.shippingState,
                shippingPostalCode: this.shippingPostalCode,
                shippingCountry: this.shippingCountry
            });

            this[NavigationMixin.Navigate]({
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: 'Contact',
                    actionName: 'list'
                },
                state: {
                    filterName: 'Recent'
                }
            });
        } catch (error) {
            this.errorMessage = error?.body?.message || 'An unexpected error occurred.';
        } finally {
            this.isSaving = false;
        }
    }

    handleReset() {
        this.firstName = '';
        this.lastName = '';
        this.email = '';
        this.phone = '';
        this.shippingStreet = '';
        this.shippingCity = '';
        this.shippingState = '';
        this.shippingPostalCode = '';
        this.shippingCountry = '';
        this.template.querySelectorAll('lightning-input').forEach(input => {
            input.value = '';
        });
    }

    isValid() {
        const inputs = this.template.querySelectorAll('lightning-input');
        let valid = true;
        inputs.forEach(input => {
            if (!input.checkValidity()) {
                input.reportValidity();
                valid = false;
            }
        });
        return valid;
    }
}