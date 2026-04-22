trigger ContactAfterInsert on Contact (after insert) {
    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

    for (Contact c : Trigger.new) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new List<String>{ 'kgsnaga@gmail.com' });
        email.setSubject('New Customer Created: ' + c.FirstName + ' ' + c.LastName);
        email.setPlainTextBody(
            'A new customer contact has been created.\n\n' +
            'Name: ' + c.FirstName + ' ' + c.LastName + '\n' +
            'Email: ' + (c.Email != null ? c.Email : 'N/A') + '\n' +
            'Phone: ' + (c.Phone != null ? c.Phone : 'N/A') + '\n' +
            'Created: ' + String.valueOf(c.CreatedDate)
        );
        emails.add(email);
    }

    if (!emails.isEmpty()) {
        Messaging.sendEmail(emails);
    }
}
