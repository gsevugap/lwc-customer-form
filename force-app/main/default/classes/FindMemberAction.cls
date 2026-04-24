public with sharing class FindMemberAction {
    public class FindRequest {
        @InvocableVariable(label='Member Id')
        public String memberId;

        @InvocableVariable(label='Email')
        public String email;
    }

    public class FindResult {
        @InvocableVariable(label='Found')
        public Boolean found;

        @InvocableVariable(label='Member Id')
        public String memberId;

        @InvocableVariable(label='First Name')
        public String firstName;

        @InvocableVariable(label='Last Name')
        public String lastName;

        @InvocableVariable(label='Email')
        public String email;

        @InvocableVariable(label='Phone')
        public String phone;

        @InvocableVariable(label='Status')
        public String status;

        @InvocableVariable(label='Tier')
        public String tier;

        @InvocableVariable(label='Join Date')
        public String joinDate;
    }

    @InvocableMethod(label='Find Member' description='Finds a Contact member by Record ID or email and returns their details.')
    public static List<FindResult> findMember(List<FindRequest> requests) {
        List<FindResult> results = new List<FindResult>();
        for (FindRequest req : requests) {
            FindResult result = new FindResult();
            try {
                List<Contact> contacts;
                if (String.isNotBlank(req.memberId)) {
                    contacts = [
                        SELECT Id, FirstName, LastName, Email, Phone,
                               Member_Status__c, Member_Tier__c, Member_Join_Date__c
                        FROM Contact WHERE Id = :req.memberId LIMIT 1
                    ];
                } else if (String.isNotBlank(req.email)) {
                    contacts = [
                        SELECT Id, FirstName, LastName, Email, Phone,
                               Member_Status__c, Member_Tier__c, Member_Join_Date__c
                        FROM Contact WHERE Email = :req.email LIMIT 1
                    ];
                } else {
                    contacts = new List<Contact>();
                }

                if (!contacts.isEmpty()) {
                    Contact c = contacts[0];
                    result.found = true;
                    result.memberId = c.Id;
                    result.firstName = c.FirstName;
                    result.lastName = c.LastName;
                    result.email = c.Email;
                    result.phone = c.Phone;
                    result.status = c.Member_Status__c;
                    result.tier = c.Member_Tier__c;
                    result.joinDate = c.Member_Join_Date__c != null
                        ? String.valueOf(c.Member_Join_Date__c) : null;
                } else {
                    result.found = false;
                }
            } catch (Exception e) {
                result.found = false;
            }
            results.add(result);
        }
        return results;
    }
}
