public with sharing class QueryContactAction {
    public class QueryRequest {
        @InvocableVariable(label='Last Name' required=true)
        public String lastName;
    }

    public class ContactResult {
        @InvocableVariable(label='Found')
        public Boolean found;

        @InvocableVariable(label='Contact Summary')
        public String contactSummary;

        @InvocableVariable(label='Contact IDs')
        public String contactIds;
    }

    @InvocableMethod(label='Query Contacts By Last Name' description='Searches Contact records by last name and returns a formatted summary.')
    public static List<ContactResult> queryContacts(List<QueryRequest> requests) {
        List<ContactResult> results = new List<ContactResult>();
        for (QueryRequest req : requests) {
            ContactResult result = new ContactResult();
            List<Contact> contacts = [
                SELECT Id, FirstName, LastName, Email, Phone,
                       MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry
                FROM Contact
                WHERE LastName = :req.lastName
                ORDER BY FirstName
                LIMIT 50
            ];

            if (contacts.isEmpty()) {
                result.found = False;
                result.contactSummary = 'No members found with last name "' + req.lastName + '".';
                result.contactIds = '';
            } else {
                result.found = True;
                List<String> ids = new List<String>();
                List<String> lines = new List<String>();
                lines.add('Found ' + contacts.size() + ' member(s) with last name "' + req.lastName + '":\n');
                Integer idx = 1;
                for (Contact c : contacts) {
                    ids.add(c.Id);
                    String line = idx + '. ' + c.FirstName + ' ' + c.LastName
                        + '\n   Email: ' + (c.Email != null ? c.Email : 'N/A')
                        + '\n   Phone: ' + (c.Phone != null ? c.Phone : 'N/A')
                        + '\n   Address: '
                        + (c.MailingStreet != null ? c.MailingStreet + ', ' : '')
                        + (c.MailingCity != null ? c.MailingCity + ', ' : '')
                        + (c.MailingState != null ? c.MailingState + ' ' : '')
                        + (c.MailingPostalCode != null ? c.MailingPostalCode + ', ' : '')
                        + (c.MailingCountry != null ? c.MailingCountry : '')
                        + '\n   Record ID: ' + c.Id;
                    lines.add(line);
                    idx++;
                }
                result.contactSummary = String.join(lines, '\n');
                result.contactIds = String.join(ids, ',');
            }
            results.add(result);
        }
        return results;
    }
}
