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
        
        System.assertEquals(false, [select rC_Bios__Archive_Flag__c from Case where Id =: caseObj.Id].rC_Bios__Archive_Flag__c, 'Case_SetArchiveBatchableTest.test() : Archived Case record inserted'+caseObj);
        Test.startTest();
        System.assert(true, Database.executeBatch(new Case_SetArchiveBatchable(), 1) != null);
        Test.stopTest();
        
        // RCSBIRD-3021
        // 
        // Unable to test: The "ClosedDate" field on Case is read only, so we can not specify that during insert call.
        // It automatically takes generated date and time when the case was closed.
        
        System.assertEquals(true, [select rC_Bios__Archive_Flag__c from Case where Id =: caseObj.Id].rC_Bios__Archive_Flag__c, 'Case_SetArchiveBatchableTest.test() : Case record updation is failed'+caseObj);
    }
}