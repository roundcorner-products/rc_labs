@isTest
public class Case_SetArchiveSchedulableTest {
    @isTest
    public static void Case_SetArchiveSchedulableTest() {
        Test.startTest();
        
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
        
        Case_SetArchiveSchedulable archiveCase = new Case_SetArchiveSchedulable();
        SchedulableContext SC;
        archiveCase.execute(SC);
        Test.stopTest();
    }
}