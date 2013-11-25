@isTest
public class StayClassy_UpsertTeamTest {
    @isTest
    public static void StayClassy_UpsertTeamTest_1() {
        Test.startTest();
        rC_Messaging__Message__c message = new rC_Messaging__Message__c();
        message.rC_Messaging__Endpoint__c = 'stayclassy://teams//name';
        message.rC_Messaging__Related_Method__c = 'insert';
        message.rC_Messaging__Related_Record__c = '000002';
        message.rC_Messaging__Effective_Date__c = DateTime.now();
        insert message;
        
        StayClassy_UpsertTeam stayClassyUpsertTeam = new StayClassy_UpsertTeam();
        try {
            stayClassyUpsertTeam.processMessage(message, null);
        } catch (system.Exception pException){
            system.assertEquals(true,pException.getMessage().contains('Missing parent StayClassy ID:'), 'failed StayClassy_UpsertTeamTest_1:Retrive parent campaign failed');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void StayClassy_UpsertTeamTest_2() {
        Test.startTest();
        Campaign campaign = new Campaign();
        campaign.Name = 'RCSBIRD Campaign Name';
        campaign.IsActive = true;
        campaign.rC_Giving__Source_Code__c = 'RCSBIRD_TEST';
        campaign.rC_Giving__Affiliation__c = 'RCSBIRD';
        campaign.StayClassy_ID__c = '000002';
        insert campaign;
        
        
        Campaign campaignParent = new Campaign();
        campaignParent.Name = 'RCSBIRD Campaign Name parent';
        campaignParent.IsActive = true;
        campaignParent.rC_Giving__Source_Code__c = 'RCSBIRD_TEST';
        campaignParent.rC_Giving__Affiliation__c = 'RCSBIRD';
        campaignParent.StayClassy_ID__c = '0';
        insert campaignParent;
        
        rC_Messaging__Message__c message = new rC_Messaging__Message__c();
        message.rC_Messaging__Endpoint__c = 'stayclassy://teams//name';
        message.rC_Messaging__Related_Method__c = 'insert';
        message.rC_Messaging__Related_Record__c = '000002';
        message.rC_Messaging__Effective_Date__c = DateTime.now();
        insert message;
        
        StayClassy_UpsertTeam stayClassyUpsertTeam = new StayClassy_UpsertTeam();
        stayClassyUpsertTeam.processMessage(message, null);
        system.assertEquals('StayClassy Team',[select Type from Campaign where id =: campaign.id].Type, 'failed StayClassy_UpsertTeamTest_2:campaign upsert failed');
        Test.stopTest();
    }
    
    @isTest
    public static void StayClassy_UpsertTeamTest_3() {
        Test.startTest();
        Campaign campaign = new Campaign();
        campaign.Name = 'RCSBIRD Campaign Name';
        campaign.IsActive = true;
        campaign.rC_Giving__Source_Code__c = 'RCSBIRD_TEST';
        campaign.rC_Giving__Affiliation__c = 'RCSBIRD';
        campaign.StayClassy_ID__c = '0';
        insert campaign;
        
        rC_Messaging__Message__c message = new rC_Messaging__Message__c();
        message.rC_Messaging__Endpoint__c = 'stayclassy://teams//name';
        message.rC_Messaging__Related_Method__c = 'insert';
        message.rC_Messaging__Related_Record__c = '00000211111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111155555555555555555555555555555555555555555555555555555555555555555555555555555555555555555';
        message.rC_Messaging__Effective_Date__c = DateTime.now();
        //insert message;
        
        StayClassy_UpsertTeam stayClassyUpsertTeam = new StayClassy_UpsertTeam();
        try {
            stayClassyUpsertTeam.processMessage(message, null);
        } catch (system.Exception pException){
            system.assertEquals('System.DmlException',pException.getTypeName(), 'failed StayClassy_UpsertTeamTest_3:Exception is not DmlException');
        }
        Test.stopTest();
    }
}