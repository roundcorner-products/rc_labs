@isTest
public class StayClassy_DeleteCampaignTest {
    public static Boolean throwException = false; 
    @IsTest
    public static void StayClassy_DeleteCampaignTest1() {
        Test.startTest();
        Campaign campaign = new Campaign();
        campaign.Name = 'test campaign';
        campaign.StayClassy_ID__c = '1';
        insert campaign;
        
        rC_Messaging__Message__c message1 = new rC_Messaging__Message__c();
        message1.rC_Messaging__Endpoint__c = 'test message1';
        message1.rC_Messaging__Related_Record__c = '1';
        insert message1;
        
        system.assert(null != message1.Id, 'StayClassy_DeleteCampaignTest : rC_Messaging__Message__c record insertion is failed'+message1);
        StayClassy_DeleteCampaign stayClassyDeleteCampaign = new StayClassy_DeleteCampaign();
        throwException = false;
        stayClassyDeleteCampaign.processMessage(message1, null);
        system.assertEquals(true,[select id from Campaign where id=: campaign.id].size() == 0, 'failed StayClassy_DeleteCampaignTest1:campaign delete failed');
        Test.stopTest();
    }
    
    @IsTest
    public static void StayClassy_DeleteCampaignTest2() {
        Test.startTest();
        Campaign campaign = new Campaign();
        campaign.Name = 'test campaign';
        insert campaign;
        
        campaign.StayClassy_ID__c = campaign.Id;
        update campaign;
        
        rC_Messaging__Message__c message1 = new rC_Messaging__Message__c();
        message1.rC_Messaging__Endpoint__c = 'test message1';
        message1.rC_Messaging__Related_Record__c = campaign.Id;
        insert message1;
        
        system.assert(null != message1.Id, 'StayClassy_DeleteCampaignTest : rC_Messaging__Message__c record insertion is failed'+message1);
        StayClassy_DeleteCampaign stayClassyDeleteCampaign = new StayClassy_DeleteCampaign();
        throwException = true;
        try {
            stayClassyDeleteCampaign.processMessage(message1, null);
        } catch (System.Exception pException) { 
            system.assertEquals(true,[select id from Campaign where id=: campaign.id] != null, 'failed StayClassy_DeleteCampaignTest2:campaign deleted rollback failed');
        }
        Test.stopTest();
    }
}