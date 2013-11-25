@isTest
public class StayClassy_UpsertCampaignTest {
    @isTest
    public static void StayClassy_UpsertCampaignTest_1() {
        Test.startTest();
        rC_Messaging__Message__c message = new rC_Messaging__Message__c();
        message.rC_Messaging__Endpoint__c = 'test message1';
        message.rC_Messaging__Related_Record__c = '1';
        insert message;
        
        StayClassy_UpsertCampaign stayClassyUpsertCampaign = new StayClassy_UpsertCampaign();
        stayClassyUpsertCampaign.processMessage(message, null);
        test.stopTest();
    }
    
    @isTest
    public static void StayClassy_UpsertCampaignTest_2() {
        Test.startTest();
        rC_Messaging__Message__c message = new rC_Messaging__Message__c();
        message.rC_Messaging__Endpoint__c = 'test message1';
        message.rC_Messaging__Related_Record__c = '1222222222222222222222222222222222222222222222222222222222222222'
        +'2222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222'
        +'2222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222';
        
        StayClassy_UpsertCampaign stayClassyUpsertCampaign = new StayClassy_UpsertCampaign();
        try {
            stayClassyUpsertCampaign.processMessage(message, null);
        } catch (System.Exception pException){
            system.assertEquals(true,[select id from Campaign].size() == 0, 'failed StayClassy_UpsertCampaignTest_2:campaign upsert rollback failed');
        }
        Test.stopTest();
    }
}