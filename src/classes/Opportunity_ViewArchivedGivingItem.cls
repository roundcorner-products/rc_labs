public class Opportunity_ViewArchivedGivingItem extends SobjectExtension {
    public Opportunity opportunity { set; get; }
    public Integer iCount { set; get; }
    public String objectName { set; get; }
    
    public String[] headerList { set; get; }
    public List<List<String>> dataList { set; get; }
    public String allObjectKeyPrefix { set; get; }
    
    public Archival__c archivalSetting { set; get; }
    
    public Opportunity_ViewArchivedGivingItem(ApexPages.StandardController controller) {
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
                strURL += archivalSetting.RESTapi_OpportunityLineItem__c;
            
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
            headerList = new String[]{};
            Set<String> headerSet = new Set<String>();
            
            for (Schema.FieldSetMember fieldSetMember : SObjectType.OpportunityLineItem.FieldSets.getMap().get('Opportunity_ViewArchivedGivingItem').getFields()) {
                headerSet.add(fieldSetMember.getLabel().toLowerCase().replace(' ', '_'));
                tempHeaderList.add(fieldSetMember.getLabel().toLowerCase().replace(' ', '_'));
                headerList.add(fieldSetMember.getLabel());
            }
            
            dataList = new List<List<String>>();
            List<String> strList = new List<String>();
            Map<String,String> archivedDataMap = new Map<String,String>();
            
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.START_OBJECT){
                    strList = new List<String>();
                    archivedDataMap = new Map<String,String>();
                    for(String header : tempHeaderList) {
                        archivedDataMap.put(header,'');
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
                    if (archivedDataMap.containskey(parser.getCurrentName()))
                        archivedDataMap.put(parser.getCurrentName(),parser.getText());
                }
            }
        }
        return null;
    }
}