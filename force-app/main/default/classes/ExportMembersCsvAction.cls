public with sharing class ExportMembersCsvAction {
    public class ExportRequest {
        @InvocableVariable(label='Rows JSON')
        public String rowsJson;
    }

    public class ExportResult {
        @InvocableVariable(label='CSV')
        public String csv;
    }

    @InvocableMethod(label='Export Members CSV' description='Converts a JSON list of members into a CSV string.')
    public static List<ExportResult> exportMembersCsv(List<ExportRequest> requests) {
        List<ExportResult> results = new List<ExportResult>();
        String header = 'member_id,name,email,phone,status,join_date,tier';
        for (ExportRequest req : requests) {
            ExportResult result = new ExportResult();
            try {
                List<String> lines = new List<String>{ header };
                if (String.isNotBlank(req.rowsJson)) {
                    List<Object> rows = (List<Object>) JSON.deserializeUntyped(req.rowsJson);
                    for (Object row : rows) {
                        Map<String, Object> m = (Map<String, Object>) row;
                        lines.add(
                            csvEscape(String.valueOf(m.get('member_id'))) + ',' +
                            csvEscape(String.valueOf(m.get('name'))) + ',' +
                            csvEscape(String.valueOf(m.get('email'))) + ',' +
                            csvEscape(String.valueOf(m.get('phone'))) + ',' +
                            csvEscape(String.valueOf(m.get('status'))) + ',' +
                            csvEscape(String.valueOf(m.get('join_date'))) + ',' +
                            csvEscape(String.valueOf(m.get('tier')))
                        );
                    }
                }
                result.csv = String.join(lines, '\n');
            } catch (Exception e) {
                result.csv = header + '\n# Error generating CSV: ' + e.getMessage();
            }
            results.add(result);
        }
        return results;
    }

    private static String csvEscape(String val) {
        if (val == null || val == 'null') return '';
        if (val.contains(',') || val.contains('"') || val.contains('\n')) {
            return '"' + val.replace('"', '""') + '"';
        }
        return val;
    }
}
