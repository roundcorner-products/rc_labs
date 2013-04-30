@isTest
public class Allocation_SetArchiveBatchableTest {
    @isTest
    public static void test() {
        Account account = new Account();
        account.name = 'Account Name';
        account.rC_Giving__Lifetime_Is_Major_Giver__c = false;
        insert account;
        
        System.assert(null != account.Id, 'Allocation_SetArchiveBatchableTest.test() : Account record insertion is failed'+account);
        
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
        
        System.assert(null != opportunity.Id, 'Allocation_SetArchiveBatchableTest.test() : Opportunity record insertion is failed'+opportunity);
        rC_Giving__GAU__c GAU = new rC_Giving__GAU__c();
        GAU.Name = 'GAU Name';
        insert GAU;
        System.assert(null != GAU.Id, 'Allocation_SetArchiveBatchableTest.test() : GAU record insertion is failed'+GAU);
        
        rC_Giving__Opportunity_Allocation__c allocation = new rC_Giving__Opportunity_Allocation__c();
        allocation.rC_Giving__Opportunity__c = opportunity.Id;
        allocation.rC_Giving__GAU__c = GAU.Id;
        allocation.rC_Giving__Distribution__c = 10;
        insert allocation;
        
        System.assert(null != allocation.Id, 'Allocation_SetArchiveBatchableTest.test() : Allocation record insertion is failed'+allocation);
        
        System.assertEquals(false, [select rC_Giving__Archive_Flag__c from rC_Giving__Opportunity_Allocation__c where Id =: allocation.Id].rC_Giving__Archive_Flag__c, 'Allocation_SetArchiveBatchableTest.test() : Archived Allocation record inserted'+allocation);
        Test.startTest();
        System.assert(true, Database.executeBatch(new Allocation_SetArchiveBatchable(), 1) != null);
        Test.stopTest();
        
        System.assertEquals(true, [select rC_Giving__Archive_Flag__c from rC_Giving__Opportunity_Allocation__c where Id =: allocation.Id].rC_Giving__Archive_Flag__c, 'Allocation_SetArchiveBatchableTest.test() : Allocation record updation is failed'+allocation);
    }
}