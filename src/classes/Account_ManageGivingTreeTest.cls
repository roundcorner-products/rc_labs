@IsTest
public class Account_ManageGivingTreeTest {
    @IsTest
    public static void test() {
        rC_LabsGivingTests rc = new rC_LabsGivingTests();
        rc.initializeAccount();
        rc.initializeCampaign(true);
        rc.initializeOpportunity(true);
        
        Archival__c archivalSetting = Archival__c.getInstance();
        archivalSetting.Database__c = 'RC_LABS';
        archivalSetting.RESTful_Host__c = 'http://54.243.143.26:8080/rC_Archival/';
        archivalSetting.RESTapi_Opportunity__c = '/Opportunity/GetAccount?accountId=';
        upsert archivalSetting;
        
        Account_ManageGivingTree accountExtension = new Account_ManageGivingTree(new ApexPages.StandardController(rc.account));
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