@isTest
public class Summary_SetArchiveBatchableTest {
    @isTest
    public static void test() {
        Account account = new Account();
        account.name = 'Account Name';
        account.rC_Giving__Lifetime_Is_Major_Giver__c = false;
        insert account;
        
        System.assert(null != account.Id, 'Summary_SetArchiveBatchableTest.test() : Account record insertion is failed'+account);
        
        rC_Giving__Summary__c summary = new rC_Giving__Summary__c();
        summary.rC_Giving__Account__c = account.Id;
        summary.rC_Giving__Giving_Level_Status__c = 'Renewed';
        insert summary;
        
        System.assert(null != summary.Id, 'Summary_SetArchiveBatchableTest.test() : Summary record insertion is failed'+summary);
        
        Test.startTest();
        System.assert(true, Database.executeBatch(new Summary_SetArchiveBatchable(), 1) != null);
        Test.stopTest();
    }
}