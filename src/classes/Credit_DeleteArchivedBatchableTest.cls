@isTest
public class Credit_DeleteArchivedBatchableTest {
    @isTest
    public static void test() {
        Account account = new Account();
        account.name = 'Account Name';
        account.rC_Giving__Lifetime_Is_Major_Giver__c = false;
        insert account;
        
        System.assert(null != account.Id, 'Credit_DeleteArchivedBatchableTest.test() : Account record insertion is failed'+account);
        
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
        
        System.assert(null != opportunity.Id, 'Credit_DeleteArchivedBatchableTest.test() : Opportunity record insertion is failed'+opportunity);
        
        rC_Giving__Opportunity_Credit__c credit = new rC_Giving__Opportunity_Credit__c();
        credit.rC_Giving__Opportunity__c = opportunity.Id;
        credit.rC_Giving__Distribution__c = 10;
        credit.rC_Giving__Archive_Flag__c = true;
        insert credit;
        
        System.assert(null != credit.Id, 'Credit_DeleteArchivedBatchableTest.test() : Credit record insertion is failed'+credit);
        
        Test.startTest();
        System.assert(true, Database.executeBatch(new Credit_DeleteArchivedBatchable(), 1) != null);
        Test.stopTest();
        System.assertEquals(0, [select Id from rC_Giving__Opportunity_Credit__c where Id =: credit.Id].size(), 'Credit_DeleteArchivedBatchableTest.test() : Credit record deletion failed');
    }
}