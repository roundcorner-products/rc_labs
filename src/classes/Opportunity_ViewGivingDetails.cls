public class Opportunity_ViewGivingDetails extends SobjectExtension {
    public Opportunity opportunity { set; get; }
    public Integer iCount { set; get; }
    
    public String[] headerList { set; get; }
    public String allObjectKeyPrefix { set; get; }
    
    public Archival__c archivalSetting { set; get; }
    
    public Map<String,String> archivedDataMap { set; get; }
    
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
            
            strURL += opportunity.Id;
            
            HttpRequest request = new HttpRequest();
            request.setEndpoint(strURL);
            request.setMethod('GET');
            String body;
            
            if (!Test.isRunningTest()) {
                body = (new Http()).send(request).getBody();
            } else {
                 body = Account_ManageGivingArchival.getTestResponse();
            }
            
            JSONParser parser = JSON.createParser(body);
            
            String[] tempHeaderList = new String[]{};
            Set<String> headerSet = new Set<String>();
            Map<String, String> labelNameMap = new Map<String, String>();
            
            for (Schema.FieldSetMember fieldSetMember : SObjectType.Opportunity.FieldSets.getMap().get('Opportunity_ViewGivingDetails').getFields()) {
                headerSet.add(fieldSetMember.getLabel().toLowerCase().replace(' ', '_'));
                tempHeaderList.add(fieldSetMember.getLabel().toLowerCase().replace(' ', '_'));
                labelNameMap.put(fieldSetMember.getLabel().toLowerCase().replace(' ', '_'), fieldSetMember.getLabel());
            }
            
            List<String> strList = new List<String>();
            archivedDataMap = new Map<String,String>();
            
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.START_OBJECT){
                    strList = new List<String>();
                    archivedDataMap = new Map<String,String>();
                    for(String header : tempHeaderList) {
                        archivedDataMap.put(labelNameMap.get(header),'');
                    }
                    continue;
                }
                if (parser.getCurrentName() != null) {
                    parser.nextValue();
                    if (archivedDataMap.containskey(labelNameMap.get(parser.getCurrentName()))) {
                        archivedDataMap.put(labelNameMap.get(parser.getCurrentName()),parser.getText());
                    }
                }
            }
        }
        return null;
    }
}