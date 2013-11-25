@isTest
public class StayClassy_UpsertDonationTest {
    @isTest
    public static void StayClassy_UpsertDonationTest_1() {
        Test.startTest();
        rC_Messaging__Message__c message = new rC_Messaging__Message__c();
        message.rC_Messaging__Endpoint__c = 'stayclassy://donations';
        message.rC_Messaging__Related_Method__c = 'insert';
        message.rC_Messaging__Related_Record__c = '000002';
        message.rC_Messaging__Effective_Date__c = DateTime.now();
        insert message;
        
        StayClassy_UpsertDonation stayClassyUpsertDonation = new StayClassy_UpsertDonation();
        try {
            stayClassyUpsertDonation.processMessage(message, null);
        } catch (system.Exception pException){
            system.assertEquals(true,pException.getMessage().contains('Missing parent StayClassy ID:'), 'failed StayClassy_UpsertDonationTest_1:Retrive parent campaign failed');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void StayClassy_UpsertDonationTest_2() {
        Test.startTest();
        Campaign campaignParent = new Campaign();
        campaignParent.Name = 'RCSBIRD Campaign Name parent';
        campaignParent.IsActive = true;
        campaignParent.rC_Giving__Source_Code__c = 'RCSBIRD_TEST';
        campaignParent.rC_Giving__Affiliation__c = 'RCSBIRD';
        campaignParent.StayClassy_ID__c = '2';
        insert campaignParent;
        
        Contact contact = new Contact();
        contact.LastName = 'testContact';
        contact.StayClassy_ID__c = '1';
        insert contact;
        
        rC_Messaging__Message__c message = new rC_Messaging__Message__c();
        message.rC_Messaging__Endpoint__c = 'stayclassy://donations';
        message.rC_Messaging__Related_Method__c = 'insert';
        message.rC_Messaging__Related_Record__c = '000002';
        message.rC_Messaging__Effective_Date__c = DateTime.now();
        insert message;
        
        StayClassy_UpsertDonation stayClassyUpsertDonation = new StayClassy_UpsertDonation();
        system.assertEquals(true,[select id from rC_Connect__Batch_Upload__c where rC_Connect__Contact_1_Email_Type__c='Home' and rC_Connect__Address_Type__c  = 'Home' limit 1] != null, 'failed StayClassy_UpsertDonationTest_2:batchUpload insert failed');
        Test.stopTest();
    }
}