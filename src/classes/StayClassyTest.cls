@IsTest
public class StayClassyTest {
    @IsTest
    public static void testCampaign_Insert() {
        Test.startTest();
        
        rC_Messaging__Message__c message = new rC_Messaging__Message__c();
        message.rC_Messaging__Endpoint__c = 'stayclassy://campaigns';
        message.rC_Messaging__Related_Method__c = 'insert';
        message.rC_Messaging__Related_Record__c = '000000';
        message.rC_Messaging__Effective_Date__c = DateTime.now();
        insert message;
        
        message.rC_Messaging__Errors__c = true;
        update message;
        
        Test.stopTest();
    }
    
    @IsTest
    public static void testDonation_Insert() {
        Test.startTest();
        
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
        
        opportunity.StayClassy_ID__c = opportunity.Id;
        update opportunity;
        
        rC_Messaging__Message__c message1 = new rC_Messaging__Message__c();
        message1.rC_Messaging__Endpoint__c = 'stayclassy://donations';
        message1.rC_Messaging__Related_Method__c = 'insert';
        message1.rC_Messaging__Related_Record__c = opportunity.Id;
        insert message1;
        
        Test.stopTest();
    }
    
    
}