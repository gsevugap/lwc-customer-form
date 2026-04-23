public with sharing class MemberFormController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts() {
        return [
            SELECT Id, FirstName, LastName, Email, Phone, MailingCity, MailingState
            FROM Contact
            ORDER BY CreatedDate DESC
        ];
    }

    @AuraEnabled
    public static Id saveContact(String firstName, String lastName, String email, String phone,
        String shippingStreet, String shippingCity, String shippingState,
        String shippingPostalCode, String shippingCountry) {
        Contact c = new Contact(
            FirstName = firstName,
            LastName = lastName,
            Email = email,
            Phone = phone,
            MailingStreet = shippingStreet,
            MailingCity = shippingCity,
            MailingState = shippingState,
            MailingPostalCode = shippingPostalCode,
            MailingCountry = shippingCountry
        );
        insert c;
        return c.Id;
    }
}
