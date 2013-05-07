@IsTest
public class Opportunity_ViewGivingDetailsTest {
    @IsTest
    public static void testViewArchivedData() {
        rC_LabsGivingTests rc = new rC_LabsGivingTests();
        rc.initializeAccount();
        rc.initializeCampaign(true);
        rc.initializeOpportunity(true);
        
        Archival__c archivalSetting = Archival__c.getInstance();
        archivalSetting.Database__c = 'RC_LABS';
        archivalSetting.RESTful_Host__c = 'http://54.243.143.26:8080/rC_Archival/';
        archivalSetting.restapi_Opportunity_Detail__c = '/OpportunityDetail/GetOpportunity?opportunityId=';
        upsert archivalSetting;
        
        Account_ManageGivingArchival accountArchival = new Account_ManageGivingArchival(new ApexPages.StandardController(rc.account));
        accountArchival.initialize();
        PageReference archivedDataViewRef = accountArchival.getDetailsLink();
        system.assertNotEquals(null, archivedDataViewRef, 'Opportunity_ViewGivingDetailsTest.testViewArchivedData() : Invalid redirection');
        
        Test.setCurrentPageReference(archivedDataViewRef);
        Opportunity_ViewGivingDetails opportunityExtension = new Opportunity_ViewGivingDetails(new ApexPages.StandardController(rc.opportunity));
        
        opportunityExtension.initialize();
        system.assertNotEquals(null, opportunityExtension.archivedDataMap, 'Opportunity_ViewGivingDetailsTest.testViewArchivedData() : Data initialization failed');
    }
}