public with sharing class CreateContactAction {
    public class ContactInput {
        @InvocableVariable(label='First Name' required=true)
        public String firstName;

        @InvocableVariable(label='Last Name' required=true)
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

    public class ContactOutput {
        @InvocableVariable(label='Result Message')
        public String resultMessage;
    }

    @InvocableMethod(label='Create Member Contact' description='Creates a Contact record with the provided member details and returns a confirmation message.')
    public static List<ContactOutput> createContact(List<ContactInput> inputs) {
        List<ContactOutput> outputs = new List<ContactOutput>();

        for (ContactInput input : inputs) {
            ContactOutput output = new ContactOutput();
            try {
                Contact c = new Contact(
                    FirstName = input.firstName,
                    LastName = input.lastName,
                    Email = input.email,
                    Phone = input.phone,
                    MailingStreet = input.mailingStreet,
                    MailingCity = input.mailingCity,
                    MailingState = input.mailingState,
                    MailingPostalCode = input.mailingPostalCode,
                    MailingCountry = input.mailingCountry
                );
                insert c;

                output.resultMessage =
                    'Member contact created successfully!\n\n' +
                    'Name: ' + input.firstName + ' ' + input.lastName + '\n' +
                    'Email: ' + (input.email != null ? input.email : 'N/A') + '\n' +
                    'Phone: ' + (input.phone != null ? input.phone : 'N/A') + '\n' +
                    'Address: ' + (input.mailingStreet != null ? input.mailingStreet + ', ' : '') +
                                  (input.mailingCity != null ? input.mailingCity + ', ' : '') +
                                  (input.mailingState != null ? input.mailingState + ' ' : '') +
                                  (input.mailingPostalCode != null ? input.mailingPostalCode + ', ' : '') +
                                  (input.mailingCountry != null ? input.mailingCountry : '') + '\n' +
                    'Record ID: ' + c.Id;
            } catch (Exception e) {
                output.resultMessage = 'Error creating contact: ' + e.getMessage();
            }
            outputs.add(output);
        }
        return outputs;
    }
}
