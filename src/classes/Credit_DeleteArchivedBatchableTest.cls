@isTest
public class Credit_DeleteArchivedBatchableTest {
    @isTest
    public static void test() {
        Account account = new Account();
        account.name = 'Account Name';
        account.rC_Giving__Lifetime_Is_Major_Giver__c = false;
        insert account;
        
        System.assert(null != account.Id, 'Credit_DeleteArchivedBatchableTest.test() : Account record insertion is failed'+account);
        
        Opportunity opportunity = new Opportunity();
        opportunity.AccountId = account.Id;
        opportunity.Name = 'Opportunity Name';
        opportunity.StageName = 'Closed';
        opportunity.CloseDate = Date.today();
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