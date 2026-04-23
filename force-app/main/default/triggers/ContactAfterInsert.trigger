trigger ContactAfterInsert on Contact (after insert) {
    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

    for (Contact c : Trigger.new) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new List<String>{ 'kgsnaga@gmail.com' });
        email.setSubject('New Member Created: ' + c.FirstName + ' ' + c.LastName);
        email.setHtmlBody(
            '<p>A new member contact has been created.</p>' +
            '<table>' +
            '<tr><td><b>Name:</b></td><td>' + c.FirstName + ' ' + c.LastName + '</td></tr>' +
            '<tr><td><b>Email:</b></td><td>' + (c.Email != null ? c.Email : 'N/A') + '</td></tr>' +
            '<tr><td><b>Phone:</b></td><td>' + (c.Phone != null ? c.Phone : 'N/A') + '</td></tr>' +
            '<tr><td><b>Street:</b></td><td>' + (c.MailingStreet != null ? c.MailingStreet : 'N/A') + '</td></tr>' +
            '<tr><td><b>City:</b></td><td>' + (c.MailingCity != null ? c.MailingCity : 'N/A') + '</td></tr>' +
            '<tr><td><b>State:</b></td><td>' + (c.MailingState != null ? c.MailingState : 'N/A') + '</td></tr>' +
            '<tr><td><b>Zip:</b></td><td>' + (c.MailingPostalCode != null ? c.MailingPostalCode : 'N/A') + '</td></tr>' +
            '<tr><td><b>Country:</b></td><td>' + (c.MailingCountry != null ? c.MailingCountry : 'N/A') + '</td></tr>' +
            '</table>'
        );
        email.setSaveAsActivity(false);
        emails.add(email);
    }

    if (!emails.isEmpty()) {
        try {
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(emails, false);
            for (Messaging.SendEmailResult r : results) {
                if (!r.isSuccess()) {
                    for (Messaging.SendEmailError err : r.getErrors()) {
                        System.debug('Email send error: ' + err.getMessage());
                    }
                }
            }
        } catch (Exception e) {
            System.debug('Exception sending email: ' + e.getMessage());
        }
    }
}
