@IsTest
public class Opportunity_ViewArchivedAllocationsTest {
    @IsTest
    public static void testViewArchivedData() {
        Account account = new Account();
        account.Name = 'RCSBIRD Account';
        account.rC_Giving__Track_Hard_Credits__c = true;
        account.rC_Giving__Track_Soft_Credits__c = true;
        account.rC_Giving__Track_Summaries__c = true;
        insert account;
        
        Campaign campaign = new Campaign();
        campaign.Name = 'RCSBIRD Campaign Name';
        campaign.IsActive = true;
        campaign.rC_Giving__Source_Code__c = 'RCSBIRD_TEST';
        campaign.rC_Giving__Affiliation__c = 'RCSBIRD';
        insert campaign;
        
        Opportunity opportunity = new Opportunity();
        opportunity.rC_Giving__Affiliation__c = 'RCSBIRD';
        opportunity.AccountId = account.Id;
        opportunity.Amount = 0;
        opportunity.CampaignId = campaign.Id;
        opportunity.CloseDate = Date.today();
        opportunity.rC_Giving__Giving_Amount__c = 100;
        opportunity.rC_Giving__Giving_Frequency__c = 'One Payment';
        opportunity.rC_Giving__Giving_Years__c = 1;
        opportunity.rC_Giving__Giving_Type_Engine__c = 'Standard';
        opportunity.rC_Giving__Payment_Frequency__c = 'One Payment';
        opportunity.RecordTypeId = rC_Giving.OpportunityRecordTypes.RT_MEMBERSHIP_ID;
        opportunity.StageName = 'Open';
        insert opportunity;
        
        Archival__c archivalSetting = Archival__c.getInstance();
        archivalSetting.Database__c = 'RC_LABS';
        archivalSetting.RESTful_Host__c = 'http://54.243.143.26:8080/rC_Archival/';
        archivalSetting.RESTapi_rC_Giving_Opportunity_Allocation__c = '/rC_Giving__Opportunity_Allocation/GetOpportunity?OpportunityID=';
        upsert archivalSetting;
        
        Account_ManageGivingArchival accountArchival = new Account_ManageGivingArchival(new ApexPages.StandardController(account));
        accountArchival.initialize();
        PageReference archivedDataViewRef = accountArchival.getAllocationsLink();
        system.assertNotEquals(null, archivedDataViewRef, 'Opportunity_ViewArchivedAllocationsTest.testViewArchivedData() : Invalid redirection');
        
        Test.setCurrentPageReference(archivedDataViewRef);
        Opportunity_ViewArchivedAllocations opportunityExtension = new Opportunity_ViewArchivedAllocations(new ApexPages.StandardController(opportunity));
        
        opportunityExtension.initialize();
        system.assertNotEquals(null, opportunityExtension.dataList, 'Opportunity_ViewArchivedAllocationsTest.testViewArchivedData() : Data initialization failed');
    }
}