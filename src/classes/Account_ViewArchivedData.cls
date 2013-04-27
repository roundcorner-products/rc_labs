public class Account_ViewArchivedData extends SobjectExtension {
    public Account account { set; get; }
    public Integer iCount { set; get; }
    
    public String[] headerList { set; get; }
    public List<List<String>> dataList { set; get; }
    
    public Archival__c archivalSetting { set; get; }
    
    public Account_ViewArchivedData(ApexPages.StandardController controller) {
        super(controller);
        account = (Account) controller.getRecord();
    }
    
    public override PageReference initialize() {
        archivalSetting = Archival__c.getInstance();
        String objectName = Apexpages.currentPage().getParameters().get('objectName');
        iCount = 0;
        String strURL;
        if (archivalSetting != null) {
            strURL = (archivalSetting.RESTful_Host__c != null && archivalSetting.Database__c != null) ? '' + archivalSetting.RESTful_Host__c + archivalSetting.Database__c : null;
        }
        
        if (objectName != null && strURL != null) {
            if (objectName.equalsIgnoreCase('CampaignMember'))
                strURL += archivalSetting.RESTapi_CampaignMember__c;
            else if (objectName.equalsIgnoreCase('Case'))
                strURL += archivalSetting.RESTapi_Case__c;
            else if (objectName.equalsIgnoreCase('Preference'))
                strURL += archivalSetting.RESTapi_rC_Bios_Preference__c;
            else if (objectName.equalsIgnoreCase('Task'))
                strURL += archivalSetting.RESTapi_Task__c;
            
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
            
            Set<String> headerSet = new Set<String>();
            String[] tempHeaderList = new String[]{};
            headerList = new String[]{};
            
            while (parser.nextToken() != null) {
                parser.nextValue();
                if (parser.getCurrentName() != null) {
                    if (headerSet.contains(parser.getCurrentName()) == false) {
                        headerSet.add(parser.getCurrentName());
                        headerList.add(capitalizeEachWord(parser.getCurrentName()));
                        tempHeaderList.add(parser.getCurrentName());
                        iCount++;
                    }
                }
                
            }
            
            parser = JSON.createParser(body);
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
    
    private String capitalizeEachWord(String headerName) {
        String actualHeader = '';
        for(String str : headerName.split('_')) {
            actualHeader += str.capitalize();
            actualHeader += '_';
        }
        return actualHeader.replace('_',' ').trim();
    }
    
    public static String getTestResponse() {
        return '[{"case_number":"012345","is_archived":"true"}]';
    }
    
}