@IsTest
public class Opportunity_ViewArchivedAllocationsTest {
    @IsTest
    public static void testViewArchivedData() {
        rC_LabsGivingTests rc = new rC_LabsGivingTests();
        rc.initializeAccount();
        rc.initializeCampaign(true);
        rc.initializeOpportunity(true);
        
        Archival__c archivalSetting = Archival__c.getInstance();
        archivalSetting.Database__c = 'RC_LABS';
        archivalSetting.RESTful_Host__c = 'http://54.243.143.26:8080/rC_Archival/';
        archivalSetting.RESTapi_rC_Giving_Opportunity_Allocation__c = '/rC_Giving__Opportunity_Allocation/GetOpportunity?OpportunityID=';
        upsert archivalSetting;
        
        Account_ManageGivingArchival accountArchival = new Account_ManageGivingArchival(new ApexPages.StandardController(rc.account));
        accountArchival.initialize();
        PageReference archivedDataViewRef = accountArchival.getAllocationsLink();
        system.assertNotEquals(null, archivedDataViewRef, 'Opportunity_ViewArchivedAllocationsTest.testViewArchivedData() : Invalid redirection');
        
        Test.setCurrentPageReference(archivedDataViewRef);
        Opportunity_ViewArchivedAllocations opportunityExtension = new Opportunity_ViewArchivedAllocations(new ApexPages.StandardController(rc.opportunity));
        
        opportunityExtension.initialize();
        system.assertNotEquals(null, opportunityExtension.dataList, 'Opportunity_ViewArchivedAllocationsTest.testViewArchivedData() : Data initialization failed');
    }
}