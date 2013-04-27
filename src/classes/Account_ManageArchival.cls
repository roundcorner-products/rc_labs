public class Account_ManageArchival extends SobjectExtension {
    public Account account { set; get; }
    public Boolean showCampaignMemberLink { set; get; }
    public Boolean showCaseLink { set; get; }
    public Boolean showPreferenceLink { set; get; }
    public Boolean showTaskLink { set; get; }
    
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
        }
        return null;
    }
    
    private PageReference buildLink(String objectName) {
        Pagereference reference = Page.Account_ViewArchivedData;
        reference.getParameters().put('id', account.Id);
        reference.getParameters().put('objectName', objectName);
        reference.setRedirect(true);
        return reference;
    }
    
    public PageReference getCampaignMemberLink() {
        return buildLink('CampaignMember');
    }
    
    public PageReference getCaseLink() {
        return buildLink('Case');
    }
    
    public PageReference getPreferenceLink() {
        return buildLink('Preference');
    }
    
    public PageReference getTaskLink() {
        return buildLink('Task');
    }
}