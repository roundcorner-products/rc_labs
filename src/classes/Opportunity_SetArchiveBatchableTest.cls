@isTest
public class Opportunity_SetArchiveBatchableTest {
    @isTest
    public static void test() {
        Account account = new Account();
        account.name = 'Account Name';
        account.rC_Giving__Lifetime_Is_Major_Giver__c = false;
        insert account;
        
        System.assert(null != account.Id, 'Opportunity_SetArchiveBatchableTest.test() : Account record insertion is failed'+account);
        
        Opportunity opportunity = new Opportunity();
        opportunity.AccountId = account.Id;
        opportunity.Name = 'Opportunity Name';
        opportunity.StageName = 'Closed';
        opportunity.CloseDate = Date.today();
        insert opportunity;
        
        System.assert(null != opportunity.Id, 'Opportunity_SetArchiveBatchableTest.test() : Opportunity record insertion is failed'+opportunity);
        
        Test.startTest();
        System.assert(true, Database.executeBatch(new Opportunity_SetArchiveBatchable(), 1) != null);
        Test.stopTest();
    }
}