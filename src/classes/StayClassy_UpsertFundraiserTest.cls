@isTest
public class StayClassy_UpsertFundraiserTest {
    @isTest
    public static void StayClassy_UpsertFundraiserTest_1() {
        Test.startTest();
        rC_Messaging__Message__c message = new rC_Messaging__Message__c();
        message.rC_Messaging__Endpoint__c = 'stayclassy://fundraisers';
        message.rC_Messaging__Related_Method__c = 'insert';
        message.rC_Messaging__Related_Record__c = '000002';
        message.rC_Messaging__Effective_Date__c = DateTime.now();
        insert message;
        
        /*String expectedResult = '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'
        +'<soap:Body>'
        +'{"status_code":"SUCCESS","fundraisers":[{"fundraising_campaign_id":2,"fundraiser_url":"http://staging.stayclassy.org/fundraise?fcid=000002","campaign_name":"TestCampaign","charity_id":4261,"charity_name":"Invisible Children","designation_name":"designationName","event_id":1,"event_name":"EventName","first_name":"Katlin","goal":25.5,"last_name":"Stubbs","member_address":"abc","member_city":"city","member_email":"katstubbs@students.bdhs.org","member_id":180000,"member_image_large":"http://c0394391.cdn2.cloudfiles.rackspacecloud.com/full_1299857883.jpg","member_image_medium":"http://c0394391.cdn2.cloudfiles.rackspacecloud.com/mid_1299857883.jpg","member_image_small":"http://c0394391.cdn2.cloudfiles.rackspacecloud.com/sm_1299857883.jpg","member_name":"memberName","member_state":"memberState","member_zip":"123","num_donors":123,"page_title":"Katlin Stubbs","project_id":5462,"project_name":"projectName","team_id":1,"team_name":"East Texas","total_raised":10.0}]}'
        +'</soap:Body>'
        +'</soap:Envelope>';
        Dom.Document doc = new Dom.Document();
        doc.load(expectedResult);*/
        StayClassy_UpsertFundraiser stayClassyUpsertFundraiser = new StayClassy_UpsertFundraiser();
        try {
            stayClassyUpsertFundraiser.processMessage(message, null);
        } catch (system.Exception pException){
            system.assertEquals(true,pException.getMessage().contains('Missing parent StayClassy ID: '), 'failed StayClassy_UpsertFundraiserTest_1:Retrive parent campaign failed');
        }
        Test.stopTest();
    }
    
    //@isTest
    public static void StayClassy_UpsertFundraiserTest_2() {
        Test.startTest();
        Campaign campaignParent = new Campaign();
        campaignParent.Name = 'RCSBIRD Campaign Name parent';
        campaignParent.IsActive = true;
        campaignParent.rC_Giving__Source_Code__c = 'RCSBIRD_TEST';
        campaignParent.rC_Giving__Affiliation__c = 'RCSBIRD';
        campaignParent.StayClassy_ID__c = '1';
        insert campaignParent;
        
        Contact contact = new Contact();
        contact.LastName = 'testContact';
        contact.StayClassy_ID__c = '180000';
        insert contact;
        
      
        rC_Messaging__Message__c message = new rC_Messaging__Message__c();
        message.rC_Messaging__Endpoint__c = 'stayclassy://fundraisers';
        message.rC_Messaging__Related_Method__c = 'insert';
        message.rC_Messaging__Related_Record__c = '000002';
        message.rC_Messaging__Effective_Date__c = DateTime.now();
        insert message;
        
        StayClassy_UpsertFundraiser stayClassyUpsertFundraiser = new StayClassy_UpsertFundraiser();
        stayClassyUpsertFundraiser.processMessage(message, null);
        system.assertEquals(true,[select id from rC_Connect__Batch_Upload__c where rC_Connect__Contact_1_Email_Type__c='Home' and rC_Connect__Address_Type__c  = 'Home' limit 1] != null, 'failed StayClassy_UpsertFundraiserTest_2:batchUpload insert failed');
        Test.stopTest();
    }

}