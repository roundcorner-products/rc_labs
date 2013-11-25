@IsTest
public class StayClassyTest {
    
    @IsTest
    public static void stayClassyTest_InnerClasses() {
        Test.startTest();
        StayClassy.Campaign campaign = new StayClassy.Campaign();
        StayClassy.CampaignResponseList campaignResponseList= new StayClassy.CampaignResponseList();
        
        StayClassy.CampaignTicket campaignTicket = new StayClassy.CampaignTicket();
        
        StayClassy.FundraiserResponseList fundraiserResponseList = new StayClassy.FundraiserResponseList();
        StayClassy.Fundraiser fundraiser = new StayClassy.Fundraiser();
        
        StayClassy.DonationResponseList donationResponseList = new StayClassy.DonationResponseList();
        StayClassy.Donation donation = new StayClassy.Donation();
        DateTime dt = donation.donation_date_time;
        
        StayClassy.TeamResponseList teamResponseList = new StayClassy.TeamResponseList();
        StayClassy.Team team = new StayClassy.Team();
        Test.stopTest();
    }
    @IsTest
    public static void stayClassyTest_NullResponseBody() {
        Test.startTest();
        try {
            StayClassy.getEndpointResponse('testEnd', new map<string,string>());
        }
        catch (system.Exception pException) {
            system.assertEquals(true,pException.getMessage().containsIgnoreCase('Empty response body!'));
        }    
        Test.stopTest();
    }
    
    @IsTest
    public static void stayClassyTest_NullProcessMessage() {
        Test.startTest();
        StayClassy stayClassy = new StayClassy();
        stayClassy.processMessage(null, null);
        rC_Messaging__Message__c message1 = new rC_Messaging__Message__c();
        message1.rC_Messaging__Related_Method__c = 'insert';
        message1.rC_Messaging__Related_Record__c = '000001';
        message1.rC_Messaging__Effective_Date__c = DateTime.now();
        stayClassy.processMessage(message1, null);
        Test.stopTest();
    }
    
    @IsTest
    public static void stayClassyTest_EmptyProcessMessageFuture() {
        Test.startTest();
        StayClassy.processMessageFuture(null);
        Test.stopTest();
    }
    @IsTest
    public static void testCampaign_Insert() {
        Test.startTest();
        
        rC_Messaging__Message__c message1 = new rC_Messaging__Message__c();
        message1.rC_Messaging__Endpoint__c = 'stayclassy://campaigns';
        message1.rC_Messaging__Related_Method__c = 'insert';
        message1.rC_Messaging__Related_Record__c = '000001';
        message1.rC_Messaging__Effective_Date__c = DateTime.now();
        insert message1;
        
        StayClassy.schedule();
        StayClassy.addMinutes(DateTime.now(), 0);
        
        Test.stopTest();
    }
    
    @IsTest
    public static void stayClassyTest_NullRelatedMethod() {
        Test.startTest();
        
        rC_Messaging__Message__c message1 = new rC_Messaging__Message__c();
        message1.rC_Messaging__Endpoint__c = 'stayclassy://campaigns';
        message1.rC_Messaging__Related_Record__c = '000001';
        message1.rC_Messaging__Effective_Date__c = DateTime.now();
        insert message1;
        
        StayClassy.schedule();
        StayClassy.addMinutes(DateTime.now(), 0);
        
        Test.stopTest();
    }
    
    @IsTest
    public static void stayClassyTest_UnknownEndpoint() {
        Test.startTest();
        
        rC_Messaging__Message__c message1 = new rC_Messaging__Message__c();
        message1.rC_Messaging__Endpoint__c = 'stayclassy://test';
        message1.rC_Messaging__Related_Method__c = 'insert';
        message1.rC_Messaging__Related_Record__c = '000001';
        message1.rC_Messaging__Effective_Date__c = DateTime.now();
        insert message1;
        
        StayClassy.schedule();
        StayClassy.addMinutes(DateTime.now(), 0);
        
        Test.stopTest();
    }
    
    @IsTest
    public static void stayClassyTest_NullRelatedRecord() {
        Test.startTest();
        
        rC_Messaging__Message__c message1 = new rC_Messaging__Message__c();
        message1.rC_Messaging__Endpoint__c = 'stayclassy://campaigns';
        message1.rC_Messaging__Related_Method__c = 'insert';
        message1.rC_Messaging__Effective_Date__c = DateTime.now();
        insert message1;
        
        StayClassy.schedule();
        StayClassy.addMinutes(DateTime.now(), 0);
        
        Test.stopTest();
    }
    
    @IsTest
    public static void stayClassyTest_UnknownEndpointType() {
        Test.startTest();
        
        rC_Messaging__Message__c message1 = new rC_Messaging__Message__c();
        message1.rC_Messaging__Endpoint__c = 'stayclassy://campaigns';
        message1.rC_Messaging__Related_Method__c = 'test';
        message1.rC_Messaging__Related_Record__c = '000001';
        message1.rC_Messaging__Effective_Date__c = DateTime.now();
        insert message1;
        
        StayClassy.schedule();
        StayClassy.addMinutes(DateTime.now(), 0);
        
        Test.stopTest();
    }
    @IsTest
    public static void testFundraiser_Insert() {
        Test.startTest();
        
        rC_Messaging__Message__c message2 = new rC_Messaging__Message__c();
        message2.rC_Messaging__Endpoint__c = 'stayclassy://fundraisers';
        message2.rC_Messaging__Related_Method__c = 'insert';
        message2.rC_Messaging__Related_Record__c = '000002';
        message2.rC_Messaging__Effective_Date__c = DateTime.now();
        insert message2;
        
        Test.stopTest();
    }
    
    @IsTest
    public static void testTeam_Insert1() {
        Test.startTest();
        
        rC_Messaging__Message__c message3 = new rC_Messaging__Message__c();
        message3.rC_Messaging__Endpoint__c = 'stayclassy://teams';
        message3.rC_Messaging__Related_Method__c = 'insert';
        message3.rC_Messaging__Related_Record__c = '000003';
        message3.rC_Messaging__Effective_Date__c = DateTime.now();
        insert message3;
        
        Test.stopTest();
    }
    
    //@IsTest
    public static void testTeam_Insert2() {
        Test.startTest();
        
        rC_Messaging__Message__c message4 = new rC_Messaging__Message__c();
        message4.rC_Messaging__Endpoint__c = 'stayclassy://teams';
        insert message4;
        
        Test.stopTest();
    }
    
    @IsTest
    public static void testDonation_Insert() {
        Test.startTest();
        
        Account account4 = new Account();
        account4.Name = 'RCSBIRD Account';
        account4.rC_Giving__Track_Hard_Credits__c = true;
        account4.rC_Giving__Track_Soft_Credits__c = true;
        account4.rC_Giving__Track_Summaries__c = true;
        insert account4;
        
        Campaign campaign4 = new Campaign();
        campaign4.Name = 'RCSBIRD Campaign Name';
        campaign4.IsActive = true;
        campaign4.rC_Giving__Source_Code__c = 'RCSBIRD_TEST';
        campaign4.rC_Giving__Affiliation__c = 'RCSBIRD';
        insert campaign4;
        
        Opportunity opportunity4 = new Opportunity();
        opportunity4.rC_Giving__Affiliation__c = 'RCSBIRD';
        opportunity4.AccountId = account4.Id;
        opportunity4.Amount = 0;
        opportunity4.CampaignId = campaign4.Id;
        opportunity4.CloseDate = Date.today();
        opportunity4.rC_Giving__Giving_Amount__c = 100;
        opportunity4.rC_Giving__Giving_Frequency__c = 'One Payment';
        opportunity4.rC_Giving__Giving_Years__c = 1;
        opportunity4.rC_Giving__Giving_Type_Engine__c = 'Standard';
        opportunity4.rC_Giving__Payment_Frequency__c = 'One Payment';
        opportunity4.RecordTypeId = rC_Giving.OpportunityRecordTypes.RT_MEMBERSHIP_ID;
        opportunity4.StageName = 'Open';
        insert opportunity4;
        
        opportunity4.StayClassy_ID__c = opportunity4.Id;
        update opportunity4;
        
        rC_Messaging__Message__c message5 = new rC_Messaging__Message__c();
        message5.rC_Messaging__Endpoint__c = 'stayclassy://donations';
        message5.rC_Messaging__Related_Method__c = 'insert';
        message5.rC_Messaging__Related_Record__c = opportunity4.Id;
        insert message5;
        
        Test.stopTest();
    }
}