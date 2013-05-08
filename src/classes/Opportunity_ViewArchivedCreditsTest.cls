@IsTest
public class Opportunity_ViewArchivedCreditsTest {
    @IsTest
    public static void testViewArchivedData() {
        rC_LabsGivingTests rc = new rC_LabsGivingTests();
        rc.initializeAccount();
        rc.initializeCampaign(true);
        rc.initializeOpportunity(true);
        
        Archival__c archivalSetting = Archival__c.getInstance();
        archivalSetting.Database__c = 'RC_LABS';
        archivalSetting.RESTful_Host__c = 'http://54.243.143.26:8080/rC_Archival/';
        archivalSetting.RESTapi_rC_Giving_Opportunity_Credit__c = '/rC_Giving__Opportunity_Credit/GetOpportunity?OpportunityID=';
        upsert archivalSetting;
        
        Account_ManageGivingArchival accountArchival = new Account_ManageGivingArchival(new ApexPages.StandardController(rc.account));
        accountArchival.initialize();
        PageReference archivedDataViewRef = accountArchival.getCreditsLink();
        system.assertNotEquals(null, archivedDataViewRef, 'Opportunity_ViewArchivedCreditsTest.testViewArchivedData() : Invalid redirection');
        
        Test.setCurrentPageReference(archivedDataViewRef);
        Opportunity_ViewArchivedCredits opportunityExtension = new Opportunity_ViewArchivedCredits(new ApexPages.StandardController(rc.opportunity));
        
        opportunityExtension.initialize();
        system.assertNotEquals(null, opportunityExtension.dataList, 'Opportunity_ViewArchivedCreditsTest.testViewArchivedData() : Data initialization failed');
    }
}