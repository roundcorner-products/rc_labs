public class Opportunity_ViewGivingDetails extends SobjectExtension {
    public Opportunity opportunity { set; get; }
    public Integer iCount { set; get; }
    
    public String[] headerList { set; get; }
    public List<List<String>> dataList { set; get; }
    public String allObjectKeyPrefix { set; get; }
    
    public Archival__c archivalSetting { set; get; }
    
    public Map<String,String> archivedDataMap { set; get; }
    public Map<String,String> archivedDataMap1 { set; get; }
    
    public Opportunity_ViewGivingDetails(ApexPages.StandardController controller) {
        super(controller);
        opportunity = (Opportunity) controller.getRecord();
    }
    
    public override PageReference initialize() {
        archivalSetting = Archival__c.getInstance();
        iCount = 0;
        String strURL;
        if (archivalSetting != null) {
            strURL = (archivalSetting.RESTful_Host__c != null && archivalSetting.Database__c != null) ? '' + archivalSetting.RESTful_Host__c + archivalSetting.Database__c : null;
        }
        
        for (Schema.SObjectType objectType : Schema.getGlobalDescribe().values()) {
            String prefix = objectType.getDescribe().getKeyPrefix();
            if (prefix != null) {
                if (allObjectKeyPrefix == null)
                    allObjectKeyPrefix = prefix;
                else
                    allObjectKeyPrefix += ', '+prefix;
            }
        }
        
        if (strURL != null) {
                strURL += archivalSetting.restapi_Opportunity_Detail__c;
            
            strURL += account.Id;
            
            HttpRequest request = new HttpRequest();
            request.setEndpoint(strURL);
            request.setMethod('GET');
            String body;
            
            //if (!Test.isRunningTest()) {
                //body = (new Http()).send(request).getBody();
            //} else {
                 body = getTestResponse();
            //}
            
            JSONParser parser = JSON.createParser(body);
            
            String[] tempHeaderList = new String[]{};
            Set<String> headerSet = new Set<String>();
            Map<String, String> labelNameMap = new Map<String, String>();
            
            for (Schema.FieldSetMember fieldSetMember : SObjectType.Opportunity.FieldSets.getMap().get('Opportunity_ViewGivingDetails').getFields()) {
                headerSet.add(fieldSetMember.getLabel().toLowerCase().replace(' ', '_'));
                tempHeaderList.add(fieldSetMember.getLabel().toLowerCase().replace(' ', '_'));
                labelNameMap.put(fieldSetMember.getLabel().toLowerCase().replace(' ', '_'), fieldSetMember.getLabel());
            }
            
            dataList = new List<List<String>>();
            List<String> strList = new List<String>();
            archivedDataMap = new Map<String,String>();
            archivedDataMap1 = new Map<String,String>();
            
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.START_OBJECT){
                    strList = new List<String>();
                    archivedDataMap = new Map<String,String>();
                    for(String header : tempHeaderList) {
                        archivedDataMap.put(header,'');
                        archivedDataMap1.put(labelNameMap.get(header),'');
                    }
                    continue;
                }
                if (parser.getCurrentToken() == JSONToken.END_OBJECT){
                	for(String header : tempHeaderList)
                	    strList.add(archivedDataMap.get(header));
                    dataList.add(strList);
                    continue;
                }
                if (parser.getCurrentName() != null) {
                    parser.nextValue();
                    if (archivedDataMap.containskey(parser.getCurrentName())) {
                        archivedDataMap.put(parser.getCurrentName(),parser.getText());
                        archivedDataMap1.put(labelNameMap.get(parser.getCurrentName()),parser.getText());
                    }
                }
            }
        }
        return null;
    }
    
    public static String getTestResponse() {
        return '[{"close_date":"2010-10-25 00:00:00.0","fiscal_period":"2007 3","force_canceled":"false","force_completed":"false","force_suspended":"false","force_uncollectible":"false","giving":"false","giving_transaction":"false","is_archived":"false","matching":"false","name":"Edge SLA","opportunity_id":"006G000000KO345IAD","payment_refunded":"false","refundable":"false","restricted":"false","stage":"Closed Won","sustainer":"false"}]';
    }
    
}