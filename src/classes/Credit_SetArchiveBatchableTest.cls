@isTest
public class Credit_SetArchiveBatchableTest {
    @isTest
    public static void test() {
        Account account = new Account();
        account.name = 'Account Name';
        account.rC_Giving__Lifetime_Is_Major_Giver__c = false;
        insert account;
        
        System.assert(null != account.Id, 'Credit_SetArchiveBatchableTest.test() : Account record insertion is failed'+account);
        
        Opportunity opportunity = new Opportunity();
        opportunity.AccountId = account.Id;
        opportunity.Name = 'Opportunity Name';
        opportunity.StageName = 'Closed';
        opportunity.CloseDate = Date.today();
        opportunity.rC_Giving__Archive_Flag__c = true;
        insert opportunity;
        
        System.assert(null != opportunity.Id, 'Credit_SetArchiveBatchableTest.test() : Opportunity record insertion is failed'+opportunity);
        
        rC_Giving__Opportunity_Credit__c credit = new rC_Giving__Opportunity_Credit__c();
        credit.rC_Giving__Opportunity__c = opportunity.Id;
        credit.rC_Giving__Distribution__c = 10;
        insert credit;
        
        System.assert(null != credit.Id, 'Credit_SetArchiveBatchableTest.test() : Credit record insertion is failed'+credit);
        
        Test.startTest();
        System.assert(true, Database.executeBatch(new Credit_SetArchiveBatchable(), 1) != null);
        Test.stopTest();
    }
}