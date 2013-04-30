@isTest
public class Opportunity_SetArchiveBatchableTest {
    @isTest
    public static void test() {
        rC_Giving__Opportunity_Setting__c setting = rC_Giving__Opportunity_Setting__c.getInstance();
        setting.rC_Giving__Disable_All__c = true;
        upsert setting;
        
        Account account = new Account();
        account.name = 'Account Name';
        account.rC_Giving__Lifetime_Is_Major_Giver__c = false;
        insert account;
        
        System.assert(null != account.Id, 'Opportunity_SetArchiveBatchableTest.test() : Account record insertion is failed'+account);
        
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
        opportunity.CloseDate = Date.today().addYears(-6);
        opportunity.rC_Giving__Giving_Amount__c = 10;
        opportunity.rC_Giving__Giving_Frequency__c = 'One Payment';
        opportunity.rC_Giving__Giving_Years__c = 1;
        opportunity.rC_Giving__Giving_Type_Engine__c = 'Standard';
        opportunity.rC_Giving__Payment_Frequency__c = 'One Payment';
        opportunity.StageName = 'Closed';
        opportunity.Name = 'Opportunity Name';
        insert opportunity;
        
        System.assert(null != opportunity.Id, 'Opportunity_SetArchiveBatchableTest.test() : Opportunity record insertion is failed'+opportunity);
        
        System.assertEquals(false, [select rC_Giving__Archive_Flag__c from Opportunity where Id =: opportunity.Id].rC_Giving__Archive_Flag__c, 'Opportunity_SetArchiveBatchableTest.test() : Archived Opportunity record inserted'+opportunity);
        Test.startTest();
        System.assert(true, Database.executeBatch(new Opportunity_SetArchiveBatchable(), 1) != null);
        Test.stopTest();
        System.assertEquals(true, [select rC_Giving__Archive_Flag__c from Opportunity where Id =: opportunity.Id].rC_Giving__Archive_Flag__c, 'Opportunity_SetArchiveBatchableTest.test() : Opportunity record updation is failed'+opportunity);
    }
}