@IsTest
public class Account_ManageGivingArchivalTest {
    @IsTest
    public static void testManageGivingArchival() {
        Account account = new Account();
        account.name = 'Account Name';
        insert account;
        
        Archival__c archivalSetting = Archival__c.getInstance();
        archivalSetting.Database__c = 'RC_LABS';
        archivalSetting.RESTful_Host__c = 'http://54.243.143.26:8080/rC_Archival/';
        archivalSetting.RESTapi_Opportunity__c = '/Opportunity/GetAccount?accountId=';
        upsert archivalSetting;
        
        System.assert(null != account.Id, 'Account_ViewArchivedDataTest.testViewArchivedData() : Account record insertion is failed'+account);
        
        Account_ManageGivingArchival accountExtension = new Account_ManageGivingArchival(new ApexPages.StandardController(account));
        
        accountExtension.putParam('objectName','Opportunity');
        accountExtension.initialize();
        
        system.assertNotEquals(null, accountExtension.dataList, 'Account_ViewArchivedDataTest.testViewArchivedData() : Data list initialization failed');
    }
}