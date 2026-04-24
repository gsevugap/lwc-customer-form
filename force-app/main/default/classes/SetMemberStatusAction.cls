public with sharing class SetMemberStatusAction {
    public class StatusRequest {
        @InvocableVariable(label='Member Id' required=true)
        public String memberId;

        @InvocableVariable(label='Status' required=true)
        public String status;
    }

    public class StatusResult {
        @InvocableVariable(label='Success')
        public Boolean success;

        @InvocableVariable(label='Updated Status')
        public String updatedStatus;

        @InvocableVariable(label='Updated First Name')
        public String updatedFirstName;

        @InvocableVariable(label='Updated Last Name')
        public String updatedLastName;

        @InvocableVariable(label='Error')
        public String error;
    }

    @InvocableMethod(label='Set Member Status' description='Sets a Contact member status to Active or Inactive.')
    public static List<StatusResult> setMemberStatus(List<StatusRequest> requests) {
        List<StatusResult> results = new List<StatusResult>();
        for (StatusRequest req : requests) {
            StatusResult result = new StatusResult();
            try {
                if (req.status != 'Active' && req.status != 'Inactive') {
                    result.success = false;
                    result.error = 'Status must be "Active" or "Inactive". Received: ' + req.status;
                    results.add(result);
                    continue;
                }
                Contact c = new Contact(Id = req.memberId, Member_Status__c = req.status);
                update c;

                Contact updated = [
                    SELECT FirstName, LastName, Member_Status__c
                    FROM Contact WHERE Id = :req.memberId
                ];
                result.success = true;
                result.updatedStatus = updated.Member_Status__c;
                result.updatedFirstName = updated.FirstName;
                result.updatedLastName = updated.LastName;
            } catch (Exception e) {
                result.success = false;
                result.error = e.getMessage();
            }
            results.add(result);
        }
        return results;
    }
}
