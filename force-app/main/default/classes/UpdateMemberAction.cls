public with sharing class UpdateMemberAction {
    public class UpdateRequest {
        @InvocableVariable(label='Member Id' required=true)
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

        @InvocableVariable(label='Join Date')
        public String joinDate;

        @InvocableVariable(label='Tier')
        public String tier;
    }

    public class UpdateResult {
        @InvocableVariable(label='Success')
        public Boolean success;

        @InvocableVariable(label='Updated Member Id')
        public String updatedMemberId;

        @InvocableVariable(label='Updated First Name')
        public String updatedFirstName;

        @InvocableVariable(label='Updated Last Name')
        public String updatedLastName;

        @InvocableVariable(label='Updated Email')
        public String updatedEmail;

        @InvocableVariable(label='Updated Phone')
        public String updatedPhone;

        @InvocableVariable(label='Updated Status')
        public String updatedStatus;

        @InvocableVariable(label='Updated Tier')
        public String updatedTier;

        @InvocableVariable(label='Updated Join Date')
        public String updatedJoinDate;

        @InvocableVariable(label='Error')
        public String error;
    }

    @InvocableMethod(label='Update Member' description='Updates an existing Contact member record with provided fields.')
    public static List<UpdateResult> updateMember(List<UpdateRequest> requests) {
        List<UpdateResult> results = new List<UpdateResult>();
        for (UpdateRequest req : requests) {
            UpdateResult result = new UpdateResult();
            try {
                Contact c = new Contact(Id = req.memberId);
                if (String.isNotBlank(req.firstName)) c.FirstName = req.firstName;
                if (String.isNotBlank(req.lastName)) c.LastName = req.lastName;
                if (String.isNotBlank(req.email)) c.Email = req.email;
                if (String.isNotBlank(req.phone)) c.Phone = req.phone;
                if (String.isNotBlank(req.status)) c.Member_Status__c = req.status;
                if (String.isNotBlank(req.tier)) c.Member_Tier__c = req.tier;
                if (String.isNotBlank(req.joinDate)) c.Member_Join_Date__c = Date.valueOf(req.joinDate);
                update c;

                Contact updated = [
                    SELECT FirstName, LastName, Email, Phone,
                           Member_Status__c, Member_Tier__c, Member_Join_Date__c
                    FROM Contact WHERE Id = :req.memberId
                ];
                result.success = true;
                result.updatedMemberId = req.memberId;
                result.updatedFirstName = updated.FirstName;
                result.updatedLastName = updated.LastName;
                result.updatedEmail = updated.Email;
                result.updatedPhone = updated.Phone;
                result.updatedStatus = updated.Member_Status__c;
                result.updatedTier = updated.Member_Tier__c;
                result.updatedJoinDate = updated.Member_Join_Date__c != null
                    ? String.valueOf(updated.Member_Join_Date__c) : null;
            } catch (Exception e) {
                result.success = false;
                result.error = e.getMessage();
            }
            results.add(result);
        }
        return results;
    }
}
