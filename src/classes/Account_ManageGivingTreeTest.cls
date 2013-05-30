@IsTest
public class Account_ManageGivingTreeTest {
    @IsTest
    public static void test() {
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
        archivalSetting.RESTapi_Opportunity__c = '/Opportunity/GetAccount?accountId=';
        upsert archivalSetting;
        
        Account_ManageGivingTree accountExtension = new Account_ManageGivingTree(new ApexPages.StandardController(account));
        accountExtension.initialize();
        
        system.assertEquals(true, accountExtension.showOpportunityArchival, 'Account_ManageGivingTree.initialize() Archival setting Initialisation check fails');
        system.assertEquals(true, accountExtension.account != null, 'Account_ManageGivingTree.initialize() Account Initialisation check fails');
        system.assertEquals(true, accountExtension.opportunityList != null, 'Account_ManageGivingTree.initialize() opportunityList Initialisation check fails');
        system.assertEquals(true, accountExtension.opportunityDataList != null, 'Account_ManageGivingTree.initialize() opportunityDataList Initialisation check fails');
        system.assertEquals(true, accountExtension.timelineDataList != null, 'Account_ManageGivingTree.initialize() timelineDataList Initialisation check fails');
        
        accountExtension.redirectToHideTransactions();
        accountExtension.redirectToShowTransactions();
        system.assertNotEquals(null, accountExtension.redirectToShowArchivedGiving().getUrl(), 'Account_ManageGivingTreeTest.test() : Redirection to Archived Giving View page fails');
    }
}