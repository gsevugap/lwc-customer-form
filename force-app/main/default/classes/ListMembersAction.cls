public with sharing class ListMembersAction {
    public class ListRequest {
        @InvocableVariable(label='Status Filter')
        public String statusFilter;

        @InvocableVariable(label='Tier Filter')
        public String tierFilter;
    }

    public class ListResult {
        @InvocableVariable(label='Results JSON')
        public String results;

        @InvocableVariable(label='Count')
        public Integer count;
    }

    @InvocableMethod(label='List Members' description='Returns a JSON list of Contact members with optional status and tier filters.')
    public static List<ListResult> listMembers(List<ListRequest> requests) {
        List<ListResult> results = new List<ListResult>();
        for (ListRequest req : requests) {
            ListResult result = new ListResult();
            try {
                String query = 'SELECT Id, FirstName, LastName, Email, Phone, ' +
                    'Member_Status__c, Member_Tier__c, Member_Join_Date__c FROM Contact WHERE Id != null';
                if (String.isNotBlank(req.statusFilter)) {
                    query += ' AND Member_Status__c = \'' + String.escapeSingleQuotes(req.statusFilter) + '\'';
                }
                if (String.isNotBlank(req.tierFilter)) {
                    query += ' AND Member_Tier__c = \'' + String.escapeSingleQuotes(req.tierFilter) + '\'';
                }
                query += ' ORDER BY LastName, FirstName LIMIT 200';

                List<Contact> contacts = Database.query(query);
                List<Map<String, Object>> memberList = new List<Map<String, Object>>();
                for (Contact c : contacts) {
                    Map<String, Object> m = new Map<String, Object>{
                        'member_id' => c.Id,
                        'name' => (c.FirstName != null ? c.FirstName + ' ' : '') + c.LastName,
                        'email' => c.Email,
                        'phone' => c.Phone,
                        'status' => c.Member_Status__c,
                        'tier' => c.Member_Tier__c,
                        'join_date' => c.Member_Join_Date__c != null ? String.valueOf(c.Member_Join_Date__c) : null
                    };
                    memberList.add(m);
                }
                result.results = JSON.serialize(memberList);
                result.count = contacts.size();
            } catch (Exception e) {
                result.results = '[]';
                result.count = 0;
            }
            results.add(result);
        }
        return results;
    }
}
