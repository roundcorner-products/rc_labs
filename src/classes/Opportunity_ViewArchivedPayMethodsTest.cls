@IsTest
public class Opportunity_ViewArchivedPayMethodsTest {
    @IsTest
    public static void testViewArchivedData() {
        Account account = new Account();
        account.Name = 'RCSBIRD Account';
        account.rC_Giving__Track_Hard_Credits__c = true;
        account.rC_Giving__Track_Soft_Credits__c = true;
        account.rC_Giving__Track_Summaries__c = true;
        insert account;
        
        Campaign campaign = new Campaign();
        campaign.Name = 'RCSBIRD Campaign Name';
        campaign.IsActive = true;
        campaign.rC_Giving__Source_Code__c = 'RCSBIRD_TEST';
        campaign.rC_Giving__Affiliation__c = 'RCSBIRD';
        insert campaign;
        
        rC_Giving__Payment_Method__c paymentMethod = new rC_Giving__Payment_Method__c();
        paymentMethod.rC_Giving__Account__c = account.Id;
        paymentMethod.rC_Giving__Billing_Street__c = '123 Main St #1001';
        paymentMethod.rC_Giving__Billing_City__c = 'Lone Tree';
        paymentMethod.rC_Giving__Billing_State__c = 'CO';
        paymentMethod.rC_Giving__Billing_Postal_Code__c = '80124';
        paymentMethod.rC_Giving__Billing_Country__c = 'US';
        paymentMethod.rC_Giving__Card_Holder_Name__c = 'RCSBIRD';
        paymentMethod.rC_Giving__Card_Expiration_Month__c = '01';
        paymentMethod.rC_Giving__Card_Expiration_Year__c = '02';
        paymentMethod.rC_Giving__Card_Number__c = '4111111111111111';
        paymentMethod.rC_Giving__Is_Active__c = true;
        paymentMethod.rC_Giving__Is_Default__c = false;
        insert paymentMethod;
        
        Opportunity opportunity = new Opportunity();
        opportunity.rC_Giving__Affiliation__c = 'RCSBIRD';
        opportunity.AccountId = account.Id;
        opportunity.Amount = 0;
        opportunity.CampaignId = campaign.Id;
        opportunity.CloseDate = Date.today();
        opportunity.rC_Giving__Giving_Amount__c = 100;
        opportunity.rC_Giving__Giving_Frequency__c = 'One Payment';
        opportunity.rC_Giving__Giving_Years__c = 1;
        opportunity.rC_Giving__Giving_Type_Engine__c = 'Standard';
        opportunity.rC_Giving__Payment_Frequency__c = 'One Payment';
        opportunity.RecordTypeId = rC_Giving.OpportunityRecordTypes.RT_MEMBERSHIP_ID;
        opportunity.StageName = 'Open';
        insert opportunity;
        
        Archival__c archivalSetting = Archival__c.getInstance();
        archivalSetting.Database__c = 'RC_LABS';
        archivalSetting.RESTful_Host__c = 'http://54.243.143.26:8080/rC_Archival/';
        archivalSetting.RESTapi_rC_Giving_Payment_Method__c = '/rC_Giving__Payment_Method/GetPaymentMethod?Id=';
        upsert archivalSetting;
        
        Account_ManageGivingArchival accountArchival = new Account_ManageGivingArchival(new ApexPages.StandardController(account));
        accountArchival.initialize();
        PageReference archivedDataViewRef = accountArchival.getPaymentMethodsLink();
        system.assertNotEquals(null, archivedDataViewRef, 'Opportunity_ViewArchivedPayMethodsTest.testViewArchivedData() : Invalid redirection');
        
        Test.setCurrentPageReference(archivedDataViewRef);
        Opportunity_ViewArchivedPayMethods opportunityExtension = new Opportunity_ViewArchivedPayMethods(new ApexPages.StandardController(paymentMethod));
        
        opportunityExtension.initialize();
        system.assertNotEquals(null, opportunityExtension.archivedDataMap, 'Opportunity_ViewArchivedPayMethodsTest.testViewArchivedData() : Data initialization failed');
    }
}