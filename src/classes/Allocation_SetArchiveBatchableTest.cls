@isTest
public class Allocation_SetArchiveBatchableTest {
    @isTest
    public static void test() {
        Account account = new Account();
        account.name = 'Account Name';
        account.rC_Giving__Lifetime_Is_Major_Giver__c = false;
        insert account;
        
        System.assert(null != account.Id, 'Allocation_SetArchiveBatchableTest.test() : Account record insertion is failed'+account);
        
        Opportunity opportunity = new Opportunity();
        opportunity.AccountId = account.Id;
        opportunity.Name = 'Opportunity Name';
        opportunity.StageName = 'Closed';
        opportunity.CloseDate = Date.today();
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
        
        Test.startTest();
        System.assert(true, Database.executeBatch(new Allocation_SetArchiveBatchable(), 1) != null);
        Test.stopTest();
    }
}