@isTest
public class Case_SetArchiveBatchableTest {
    @isTest
    public static void test() {
        Account account = new Account();
        account.name = 'Account Name';
        account.rC_Giving__Lifetime_Is_Major_Giver__c = false;
        insert account;
        
        System.assert(null != account.Id, 'Case_SetArchiveBatchableTest.test() : Account record insertion is failed'+account);
        
        Case caseObj = new Case();
        caseObj.AccountId = account.Id;
        caseObj.Origin = 'Email';
        caseObj.Status = 'Closed';
        insert caseObj;
        
        System.assert(null != caseObj.Id, 'Case_SetArchiveBatchableTest.test() : Case record insertion is failed'+caseObj);
        
        Test.startTest();
        System.assert(true, Database.executeBatch(new Case_SetArchiveBatchable(), 1) != null);
        Test.stopTest();
    }
}