@isTest
public class Allocation_DeleteArchivedBatchableTest {
    @isTest
    public static void test() {
        Account account = new Account();
        account.name = 'Account Name';
        account.rC_Giving__Lifetime_Is_Major_Giver__c = false;
        insert account;
        System.assert(null != account.Id, 'Allocation_DeleteArchivedBatchableTest.test() : Account record insertion is failed'+account);
        
        Campaign campaign = new Campaign();
        campaign.Name = 'RCSBIRD Campaign Name';
        campaign.IsActive = true;
        campaign.rC_Giving__Source_Code__c = 'RCSBIRD_TEST';
        campaign.rC_Giving__Affiliation__c = 'RCSBIRD';
        insert campaign;
        System.assert(null != campaign.Id, 'Allocation_DeleteArchivedBatchableTest.test() : Campaign record insertion is failed'+campaign);
        
        Opportunity opportunity = new Opportunity();
        opportunity.rC_Giving__Affiliation__c = 'RCSBIRD';
        opportunity.AccountId = account.Id;
        opportunity.Amount = 0;
        opportunity.CampaignId = campaign.Id;
        opportunity.CloseDate = Date.today();
        opportunity.rC_Giving__Giving_Amount__c = 10;
        opportunity.rC_Giving__Giving_Frequency__c = 'One Payment';
        opportunity.rC_Giving__Giving_Years__c = 1;
        opportunity.rC_Giving__Giving_Type_Engine__c = 'Standard';
        opportunity.rC_Giving__Payment_Frequency__c = 'One Payment';
        opportunity.StageName = 'Closed';
        opportunity.Name = 'Opportunity Name';
        opportunity.rC_Giving__Archive_Flag__c = true;
        insert opportunity;
        
        System.assert(null != opportunity.Id, 'Allocation_DeleteArchivedBatchableTest.test() : Opportunity record insertion is failed'+opportunity);
        rC_Giving__GAU__c GAU = new rC_Giving__GAU__c();
        GAU.Name = 'GAU Name';
        insert GAU;
        System.assert(null != GAU.Id, 'Allocation_DeleteArchivedBatchableTest.test() : GAU record insertion is failed'+GAU);
        
        rC_Giving__Opportunity_Allocation__c allocation = new rC_Giving__Opportunity_Allocation__c();
        allocation.rC_Giving__Opportunity__c = opportunity.Id;
        allocation.rC_Giving__GAU__c = GAU.Id;
        allocation.rC_Giving__Distribution__c = 10;
        allocation.rC_Giving__Archive_Flag__c = true;
        insert allocation;
        
        System.assert(null != allocation.Id, 'Allocation_DeleteArchivedBatchableTest.test() : Allocation record insertion is failed'+allocation);
        
        Test.startTest();
        System.assert(true, Database.executeBatch(new Allocation_DeleteArchivedBatchable(), 1) != null);
        Test.stopTest();
        
        System.assertEquals(0, [select Id from rC_Giving__Opportunity_Allocation__c where Id =: allocation.Id].size(), 'Allocation_DeleteArchivedBatchableTest.test() : Allocation record deletion failed');
    }
}