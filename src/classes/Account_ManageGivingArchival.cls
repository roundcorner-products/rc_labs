public class Account_ManageGivingArchival extends SobjectExtension {
    public Account account { set; get; }
    public Integer iCount { set; get; }
    public String objectName { set; get; }
    
    public String[] headerList { set; get; }
    public List<List<String>> dataList { set; get; }
    public String allObjectKeyPrefix { set; get; }
    public Opportunity[] opportunityList { set; get; }
    
    public Archival__c archivalSetting { set; get; }
    
    public Account_ManageGivingArchival(ApexPages.StandardController controller) {
        super(controller);
        account = (Account) controller.getRecord();
    }
    
    public override PageReference initialize() {
        archivalSetting = Archival__c.getInstance();
        objectName = 'Opportunity';
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
        
        if (objectName != null && strURL != null) {
                strURL += archivalSetting.RESTapi_Opportunity__c;
            
            strURL += account.Id;
            
            HttpRequest request = new HttpRequest();
            request.setEndpoint(strURL);
            request.setMethod('GET');
            String body;
            
            if (!Test.isRunningTest()) {
                body = (new Http()).send(request).getBody();
            } else {
                 body = getTestResponse();
            }
            
            JSONParser parser = JSON.createParser(body);
            
            String[] tempHeaderList = new String[]{};
            headerList = new String[]{};
            Set<String> headerSet = new Set<String>();
            
            for (Schema.FieldSetMember fieldSetMember : SObjectType.Opportunity.FieldSets.getMap().get('rc_giving__account_managegivingtree').getFields()) {
                headerSet.add(fieldSetMember.getLabel().toLowerCase().replace(' ', '_'));
                tempHeaderList.add(fieldSetMember.getLabel().toLowerCase().replace(' ', '_'));
                headerList.add(fieldSetMember.getLabel());
            }
            
            opportunityList = new Opportunity[]{};
            
            dataList = new List<List<String>>();
            List<String> strList = new List<String>();
            Map<String,String> archivedDataMap = new Map<String,String>();
            Opportunity opportunity = new Opportunity();
            
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.START_OBJECT){
                    strList = new List<String>();
                    archivedDataMap = new Map<String,String>();
                    opportunity = new Opportunity();
                    for(String header : tempHeaderList) {
                        archivedDataMap.put(header,'');
                    }
                    continue;
                }
                if (parser.getCurrentToken() == JSONToken.END_OBJECT){
                	for(String header : tempHeaderList)
                	    strList.add(archivedDataMap.get(header));
                    dataList.add(strList);
                    opportunityList.add(opportunity);
                    continue;
                }
                if (parser.getCurrentName() != null) {
                    parser.nextValue();
                    if (parser.getCurrentName().equalsIgnoreCase('name'))
                        opportunity.Name = parser.getText();
                    if (parser.getCurrentName().equalsIgnoreCase('opportunity_id'))
                        opportunity = new Opportunity(Name = opportunity.Name, Id = parser.getText());
                    if (archivedDataMap.containskey(parser.getCurrentName()))
                        archivedDataMap.put(parser.getCurrentName(),parser.getText());
                }
            }
        }
        return null;
    }
    
    private String capitalizeEachWord(String headerName) {
        String actualHeader = '';
        for(String str : headerName.split('_')) {
            actualHeader += str.capitalize();
            actualHeader += '_';
        }
        return actualHeader.replace('_',' ').trim();
    }
    
    public static String getTestResponse() {
        return '[{"close_date":"2010-10-25 00:00:00.0","fiscal_period":"2007 3","force_canceled":"false","force_completed":"false","force_suspended":"false","force_uncollectible":"false","giving":"false","giving_transaction":"false","is_archived":"false","matching":"false","name":"Edge SLA","opportunity_id":"006G000000KO345IAD","payment_refunded":"false","refundable":"false","restricted":"false","stage":"Closed Won","sustainer":"false"}]';
    }
    
}