public with sharing class UpdateContactAction {
    public class UpdateRequest {
        @InvocableVariable(label='Contact Id' required=true)
        public String contactId;

        @InvocableVariable(label='First Name')
        public String firstName;

        @InvocableVariable(label='Last Name')
        public String lastName;

        @InvocableVariable(label='Email')
        public String email;

        @InvocableVariable(label='Phone')
        public String phone;

        @InvocableVariable(label='Mailing Street')
        public String mailingStreet;

        @InvocableVariable(label='Mailing City')
        public String mailingCity;

        @InvocableVariable(label='Mailing State')
        public String mailingState;

        @InvocableVariable(label='Mailing Postal Code')
        public String mailingPostalCode;

        @InvocableVariable(label='Mailing Country')
        public String mailingCountry;
    }

    public class UpdateResult {
        @InvocableVariable(label='Result Message')
        public String resultMessage;
    }

    @InvocableMethod(label='Update Customer Contact' description='Updates an existing Contact record with the provided details and returns a confirmation message.')
    public static List<UpdateResult> updateContact(List<UpdateRequest> requests) {
        List<UpdateResult> results = new List<UpdateResult>();
        for (UpdateRequest req : requests) {
            UpdateResult result = new UpdateResult();
            try {
                Contact c = new Contact(Id = req.contactId);
                if (req.firstName != null) c.FirstName = req.firstName;
                if (req.lastName != null) c.LastName = req.lastName;
                if (req.email != null) c.Email = req.email;
                if (req.phone != null) c.Phone = req.phone;
                if (req.mailingStreet != null) c.MailingStreet = req.mailingStreet;
                if (req.mailingCity != null) c.MailingCity = req.mailingCity;
                if (req.mailingState != null) c.MailingState = req.mailingState;
                if (req.mailingPostalCode != null) c.MailingPostalCode = req.mailingPostalCode;
                if (req.mailingCountry != null) c.MailingCountry = req.mailingCountry;
                update c;

                Contact updated = [
                    SELECT FirstName, LastName, Email, Phone,
                           MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry
                    FROM Contact WHERE Id = :req.contactId
                ];
                result.resultMessage =
                    'Customer updated successfully!\n\n' +
                    'Name: ' + updated.FirstName + ' ' + updated.LastName + '\n' +
                    'Email: ' + (updated.Email != null ? updated.Email : 'N/A') + '\n' +
                    'Phone: ' + (updated.Phone != null ? updated.Phone : 'N/A') + '\n' +
                    'Address: ' +
                    (updated.MailingStreet != null ? updated.MailingStreet + ', ' : '') +
                    (updated.MailingCity != null ? updated.MailingCity + ', ' : '') +
                    (updated.MailingState != null ? updated.MailingState + ' ' : '') +
                    (updated.MailingPostalCode != null ? updated.MailingPostalCode + ', ' : '') +
                    (updated.MailingCountry != null ? updated.MailingCountry : '') + '\n' +
                    'Record ID: ' + req.contactId;
            } catch (Exception e) {
                result.resultMessage = 'Error updating contact: ' + e.getMessage();
            }
            results.add(result);
        }
        return results;
    }
}
