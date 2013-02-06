@isTest
public class Opportunity_DeleteArchivedBatchableTest {
    @isTest
    public static void test() {
        Account account = new Account();
        account.name = 'Account Name';
        account.rC_Giving__Lifetime_Is_Major_Giver__c = false;
        insert account;
        
        System.assert(null != account.Id, 'Opportunity_DeleteArchivedBatchableTest.test() : Account record insertion is failed'+account);
        
        Opportunity opportunity = new Opportunity();
        opportunity.AccountId = account.Id;
        opportunity.Name = 'Opportunity Name';
        opportunity.StageName = 'Closed';
        opportunity.CloseDate = Date.today();
        opportunity.rC_Giving__Archive_Flag__c = true;
        insert opportunity;
        
        System.assert(null != opportunity.Id, 'Opportunity_DeleteArchivedBatchableTest.test() : Opportunity record insertion is failed'+opportunity);
        
        Test.startTest();
        System.assert(true, Database.executeBatch(new Opportunity_DeleteArchivedBatchable(), 1) != null);
        Test.stopTest();
        System.assertEquals(0, [select Id from Opportunity where Id =: opportunity.Id].size(), 'Opportunity_DeleteArchivedBatchableTest.test() : Opportunity record deletion failed');
    }
}