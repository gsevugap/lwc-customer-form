import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import saveContact from '@salesforce/apex/CustomerFormController.saveContact';

export default class CustomerForm extends NavigationMixin(LightningElement) {
    @track firstName = '';
    @track lastName = '';
    @track email = '';
    @track phone = '';
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
                phone: this.phone
            });

            this.successMessage = 'Contact saved successfully! Redirecting...';
            this.handleReset();

            setTimeout(() => {
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: contactId,
                        objectApiName: 'Contact',
                        actionName: 'view'
                    }
                });
            }, 1500);
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
