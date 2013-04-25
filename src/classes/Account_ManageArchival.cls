public class Account_ManageArchival extends SobjectExtension{
    public Account account { set; get; }
    public Boolean showCampaignMemberLink { set; get; }
    public Boolean showCaseLink { set; get; }
    public Boolean showPreferenceLink { set; get; }
    public Boolean showTaskLink { set; get; }
    
    public String strURL { set; get; }
    
    public Archival__c archivalSetting { set; get; }
    
    public Account_ManageArchival(ApexPages.StandardController controller) {
        super(controller);
        account = (Account) controller.getRecord();
    }
    
    public override PageReference initialize() {
        archivalSetting = Archival__c.getInstance();
        if (archivalSetting != null) {
            showCampaignMemberLink = archivalSetting.RESTapi_CampaignMember__c != null;
            showCaseLink = archivalSetting.RESTapi_Case__c != null;
            showPreferenceLink = archivalSetting.RESTapi_rC_Bios_Preference__c != null;
            showTaskLink = archivalSetting.RESTapi_Task__c != null;
            
            strURL = (archivalSetting.RESTful_Host__c != null && archivalSetting.Database__c != null) ? '' + archivalSetting.RESTful_Host__c + archivalSetting.Database__c : null;
        }
        return null;
    }
    
    public PageReference displayArchivedData() {
        String objectName = Apexpages.currentPage().getParameters().get('objectName');
        
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
            return new PageReference(strURL);
        }
        return null;
    }
}