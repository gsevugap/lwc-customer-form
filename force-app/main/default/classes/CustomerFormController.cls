public with sharing class CustomerFormController {
    @AuraEnabled
    public static Id saveContact(String firstName, String lastName, String email, String phone) {
        Contact c = new Contact(
            FirstName = firstName,
            LastName = lastName,
            Email = email,
            Phone = phone
        );
        insert c;
        return c.Id;
    }
}
