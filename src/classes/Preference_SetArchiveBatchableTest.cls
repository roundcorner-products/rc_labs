@isTest
public class Preference_SetArchiveBatchableTest {
    @isTest
    public static void test() {
        Account account = new Account();
        account.name = 'Account Name';
        account.rC_Giving__Lifetime_Is_Major_Giver__c = false;
        insert account;
        
        System.assert(null != account.Id, 'Preference_SetArchiveBatchableTest.test() : Account record insertion is failed'+account);
        
        rC_Bios__Preference__c preference = new rC_Bios__Preference__c();
        preference.rC_Bios__Account__c = account.Id;
        preference.rC_Bios__Category__c = 'Education';
        preference.rC_Bios__Active__c = false;
        insert preference;
        
        System.assert(null != preference.Id, 'Preference_SetArchiveBatchableTest.test() : Preference record insertion is failed'+preference);
        
        System.assertEquals(false, [select rC_Bios__Archive_Flag__c from rC_Bios__Preference__c where Id =: preference.Id].rC_Bios__Archive_Flag__c, 'Preference_SetArchiveBatchableTest.test() : Archived Preference record inserted'+preference);
        Test.startTest();
        System.assert(true, Database.executeBatch(new Preference_SetArchiveBatchable(), 1) != null);
        Test.stopTest();
        System.assertEquals(true, [select rC_Bios__Archive_Flag__c from rC_Bios__Preference__c where Id =: preference.Id].rC_Bios__Archive_Flag__c, 'Preference_SetArchiveBatchableTest.test() : Preference record updation is failed'+preference);
    }
}