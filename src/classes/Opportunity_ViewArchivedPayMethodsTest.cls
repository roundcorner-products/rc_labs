@IsTest
public class Opportunity_ViewArchivedPayMethodsTest {
    @IsTest
    public static void testViewArchivedData() {
        rC_LabsGivingTests rc = new rC_LabsGivingTests();
        rc.initializeAccount();
        rc.initializeCampaign(true);
        rc.initializePaymentMethod(true);
        rc.initializeOpportunity(true);
        
        Archival__c archivalSetting = Archival__c.getInstance();
        archivalSetting.Database__c = 'RC_LABS';
        archivalSetting.RESTful_Host__c = 'http://54.243.143.26:8080/rC_Archival/';
        archivalSetting.RESTapi_rC_Giving_Payment_Method__c = '/rC_Giving__Payment_Method/GetPaymentMethod?Id=';
        upsert archivalSetting;
        
        Account_ManageGivingArchival accountArchival = new Account_ManageGivingArchival(new ApexPages.StandardController(rc.account));
        accountArchival.initialize();
        PageReference archivedDataViewRef = accountArchival.getPaymentMethodsLink();
        system.assertNotEquals(null, archivedDataViewRef, 'Opportunity_ViewArchivedPayMethodsTest.testViewArchivedData() : Invalid redirection');
        
        Test.setCurrentPageReference(archivedDataViewRef);
        Opportunity_ViewArchivedPayMethods opportunityExtension = new Opportunity_ViewArchivedPayMethods(new ApexPages.StandardController(rc.paymentMethod));
        
        opportunityExtension.initialize();
        system.assertNotEquals(null, opportunityExtension.archivedDataMap, 'Opportunity_ViewArchivedPayMethodsTest.testViewArchivedData() : Data initialization failed');
    }
}