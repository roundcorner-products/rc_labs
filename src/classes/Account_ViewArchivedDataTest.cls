@IsTest
public class Account_ViewArchivedDataTest {
    @IsTest
    public static void testViewArchivedData() {
        Account account = new Account();
        account.name = 'Account Name';
        insert account;
        
        Archival__c archivalSetting = Archival__c.getInstance();
        archivalSetting.Database__c = 'RC_LABS';
        archivalSetting.RESTful_Host__c = 'http://54.243.143.26:8080/rC_Archival/';
        archivalSetting.RESTapi_CampaignMember__c = '/CampaignMember/GetAccount?accountId=';
        archivalSetting.RESTapi_Case__c = '/Case/GetAccount?accountId=';
        archivalSetting.RESTapi_rC_Bios_Preference__c = '/rC_Bios_Preference__c/GetAccount?accountId=';
        archivalSetting.RESTapi_Task__c = '/Task/GetAccount?accountId=';
        upsert archivalSetting;
        
        System.assert(null != account.Id, 'Account_ViewArchivedDataTest.testViewArchivedData() : Account record insertion is failed'+account);
        
        Account_ManageArchival accountArchival = new Account_ManageArchival(new ApexPages.StandardController(account));
        accountArchival.initialize();
        PageReference archivedDataViewRef = accountArchival.getCaseLink();
        system.assertNotEquals(null, archivedDataViewRef, 'Account_ViewArchivedDataTest.testViewArchivedData() : Invalid redirection');
        
        Test.setCurrentPageReference(archivedDataViewRef);
        Account_ViewArchivedData accountExtension = new Account_ViewArchivedData(new ApexPages.StandardController(account));
        
        accountExtension.initialize();
        accountExtension.putParam('objectName','Campaign Member');
        accountExtension.initialize();
        
        accountExtension.putParam('objectName','Task');
        accountExtension.initialize();
        
        accountExtension.putParam('objectName','Preference');
        accountExtension.initialize();
        system.assertNotEquals(null, accountExtension.dataList, 'Account_ViewArchivedDataTest.testViewArchivedData() : Data list initialization failed');
    }
}