public class Opportunity_ViewArchivedPayMethods extends SobjectExtension {
    public rC_Giving__Payment_Method__c paymentMethod { set; get; }
    public Archival__c archivalSetting { set; get; }
    public String allObjectKeyPrefix { set; get; }
    public Map<String,String> archivedDataMap { set; get; }
    
    public Opportunity_ViewArchivedPayMethods(ApexPages.StandardController controller) {
        super(controller);
        paymentMethod = (rC_Giving__Payment_Method__c) controller.getRecord();
    }
    
    public override PageReference initialize() {
        archivalSetting = Archival__c.getInstance();
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
            strURL += archivalSetting.RESTapi_rC_Giving_Payment_Method__c;
            
            strURL += paymentMethod.Id;
            
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
            archivedDataMap = new Map<String,String>();
            
            while (parser.nextToken() != null) {
                parser.nextValue();
                if (parser.getCurrentName() != null) {
                    if (archivedDataMap.containsKey(capitalizeEachWord(parser.getCurrentName())) == false) {
                        archivedDataMap.put(capitalizeEachWord(parser.getCurrentName()),'');
                    }
                }
            }
            
            parser = JSON.createParser(body);
            
            while (parser.nextToken() != null) {
                if (parser.getCurrentName() != null) {
                    parser.nextValue();
                    if (archivedDataMap.containskey(capitalizeEachWord(parser.getCurrentName())))
                        archivedDataMap.put(capitalizeEachWord(parser.getCurrentName()),parser.getText());
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
}