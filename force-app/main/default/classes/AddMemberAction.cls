public with sharing class AddMemberAction {
    public class AddRequest {
        @InvocableVariable(label='First Name' required=true)
        public String firstName;

        @InvocableVariable(label='Last Name' required=true)
        public String lastName;

        @InvocableVariable(label='Email')
        public String email;

        @InvocableVariable(label='Phone')
        public String phone;

        @InvocableVariable(label='Status')
        public String status;

        @InvocableVariable(label='Join Date')
        public String joinDate;

        @InvocableVariable(label='Tier')
        public String tier;
    }

    public class AddResult {
        @InvocableVariable(label='Success')
        public Boolean success;

        @InvocableVariable(label='Member Id')
        public String memberId;

        @InvocableVariable(label='Error')
        public String error;
    }

    @InvocableMethod(label='Add Member' description='Creates a new Contact record as a member and returns the new Record ID.')
    public static List<AddResult> addMember(List<AddRequest> requests) {
        List<AddResult> results = new List<AddResult>();
        for (AddRequest req : requests) {
            AddResult result = new AddResult();
            try {
                Contact c = new Contact(
                    FirstName = req.firstName,
                    LastName = req.lastName,
                    Email = req.email,
                    Phone = req.phone,
                    Member_Status__c = String.isNotBlank(req.status) ? req.status : 'Active',
                    Member_Tier__c = req.tier
                );
                if (String.isNotBlank(req.joinDate)) {
                    c.Member_Join_Date__c = Date.valueOf(req.joinDate);
                }
                insert c;
                result.success = true;
                result.memberId = c.Id;
            } catch (Exception e) {
                result.success = false;
                result.error = e.getMessage();
            }
            results.add(result);
        }
        return results;
    }
}
