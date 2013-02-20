@isTest
public class Preference_DeleteArchivedBatchableTest {
    @isTest
    public static void test() {
        Account account = new Account();
        account.name = 'Account Name';
        account.rC_Giving__Lifetime_Is_Major_Giver__c = false;
        insert account;
        
        System.assert(null != account.Id, 'Preference_DeleteArchivedBatchableTest.test() : Account record insertion is failed'+account);
        
        rC_Bios__Preference__c preference = new rC_Bios__Preference__c();
        preference.rC_Bios__Account__c = account.Id;
        preference.rC_Bios__Category__c = 'Education';
        preference.rC_Bios__Active__c = false;
        preference.rC_Bios__Archive_Flag__c = true;
        insert preference;       
        
        System.assert(null != preference.Id, 'Preference_DeleteArchivedBatchableTest.test() : Preference record insertion is failed'+preference);
        
        Test.startTest();
        System.assert(true, Database.executeBatch(new Preference_DeleteArchivedBatchable(), 1) != null);
        Test.stopTest();
        System.assertEquals(0, [select Id from rC_Bios__Preference__c where Id =: preference.Id].size(), 'Preference_DeleteArchivedBatchableTest.test() : Preference record deletion failed');
    }
}