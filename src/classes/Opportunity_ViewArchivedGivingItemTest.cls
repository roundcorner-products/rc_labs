@IsTest
public class Opportunity_ViewArchivedGivingItemTest {
    @IsTest
    public static void testViewArchivedData() {
        rC_LabsGivingTests rc = new rC_LabsGivingTests();
        rc.initializeAccount();
        rc.initializeCampaign(true);
        rc.initializeOpportunity(true);
        
        Archival__c archivalSetting = Archival__c.getInstance();
        archivalSetting.Database__c = 'RC_LABS';
        archivalSetting.RESTful_Host__c = 'http://54.243.143.26:8080/rC_Archival/';
        archivalSetting.RESTapi_OpportunityLineItem__c = '/OpportunityLineItem/GetOpportunity?OpportunityID=';
        upsert archivalSetting;
        
        Account_ManageGivingArchival accountArchival = new Account_ManageGivingArchival(new ApexPages.StandardController(rc.account));
        accountArchival.initialize();
        PageReference archivedDataViewRef = accountArchival.getItemsLink();
        system.assertNotEquals(null, archivedDataViewRef, 'Opportunity_ViewArchivedGivingItemTest.testViewArchivedData() : Invalid redirection');
        
        Test.setCurrentPageReference(archivedDataViewRef);
        Opportunity_ViewArchivedGivingItem opportunityExtension = new Opportunity_ViewArchivedGivingItem(new ApexPages.StandardController(rc.opportunity));
        
        opportunityExtension.initialize();
        system.assertNotEquals(null, opportunityExtension.dataList, 'Opportunity_ViewArchivedGivingItemTest.testViewArchivedData() : Data initialization failed');
    }
}