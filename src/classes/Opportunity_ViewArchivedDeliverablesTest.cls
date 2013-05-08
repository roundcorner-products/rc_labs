@IsTest
public class Opportunity_ViewArchivedDeliverablesTest {
    @IsTest
    public static void testViewArchivedData() {
        rC_LabsGivingTests rc = new rC_LabsGivingTests();
        rc.initializeAccount();
        rc.initializeCampaign(true);
        rc.initializeOpportunity(true);
        
        Archival__c archivalSetting = Archival__c.getInstance();
        archivalSetting.Database__c = 'RC_LABS';
        archivalSetting.RESTful_Host__c = 'http://54.243.143.26:8080/rC_Archival/';
        archivalSetting.RESTapi_rC_Giving_Deliverable__c = '/rC_Giving__Deliverable/GetOpportunity?OpportunityID=';
        upsert archivalSetting;
        
        Account_ManageGivingArchival accountArchival = new Account_ManageGivingArchival(new ApexPages.StandardController(rc.account));
        accountArchival.initialize();
        PageReference archivedDataViewRef = accountArchival.getDeliverablesLink();
        system.assertNotEquals(null, archivedDataViewRef, 'Opportunity_ViewArchivedDeliverablesTest.testViewArchivedData() : Invalid redirection');
        
        Test.setCurrentPageReference(archivedDataViewRef);
        Opportunity_ViewArchivedDeliverables opportunityExtension = new Opportunity_ViewArchivedDeliverables(new ApexPages.StandardController(rc.opportunity));
        
        opportunityExtension.initialize();
        system.assertNotEquals(null, opportunityExtension.dataList, 'Opportunity_ViewArchivedDeliverablesTest.testViewArchivedData() : Data initialization failed');
    }
}