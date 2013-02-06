@isTest
public class Case_DeleteArchivedBatchableTest {
    @isTest
    public static void test() {
        Account account = new Account();
        account.name = 'Account Name';
        account.rC_Giving__Lifetime_Is_Major_Giver__c = false;
        insert account;
        
        System.assert(null != account.Id, 'Case_DeleteArchivedBatchableTest.test() : Account record insertion is failed'+account);
        
        Case caseObj = new Case();
        caseObj.AccountId = account.Id;
        caseObj.Origin = 'Email';
        caseObj.Status = 'Closed';
        caseObj.rC_Bios__Archive_Flag__c = true;
        insert caseObj;
        
        System.assert(null != caseObj.Id, 'Case_DeleteArchivedBatchableTest.test() : Case record insertion is failed'+caseObj);
        
        Test.startTest();
        System.assert(true, Database.executeBatch(new Case_DeleteArchivedBatchable(), 1) != null);
        Test.stopTest();
        System.assertEquals(0, [select Id from Case where Id =: caseObj.Id].size(), 'Case_DeleteArchivedBatchableTest.test() : Case record deletion failed');
    }
}