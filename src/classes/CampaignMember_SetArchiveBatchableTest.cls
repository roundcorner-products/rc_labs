@isTest
public class CampaignMember_SetArchiveBatchableTest {
    @isTest
    public static void test() {
        Account account = new Account();
        account.name = 'Account Name';
        account.rC_Giving__Lifetime_Is_Major_Giver__c = false;
        insert account;
        
        System.assert(null != account.Id, 'CampaignMember_SetArchiveBatchableTest.test() : Account record insertion is failed'+account);
        
        Contact contact = new Contact(FirstName = 'Contact FirstName', LastName = 'Contact LastName', AccountId = account.Id);
        insert contact;
        System.assert(null != contact.Id, 'CampaignMember_SetArchiveBatchableTest.test() : Contact record insertion is failed'+contact);
        
        Campaign campaign = new Campaign(Name = 'Campaign Name');
        insert campaign;
        
        System.assert(null != campaign.Id, 'CampaignMember_SetArchiveBatchableTest.test() : Campaign record insertion is failed'+campaign);
        
        CampaignMember campaignMember = new CampaignMember();
        campaignMember.CampaignId = campaign.Id;
        campaignMember.ContactId = contact.Id;
        insert campaignMember;
        
        System.assert(null != campaignMember.Id, 'CampaignMember_SetArchiveBatchableTest.test() : CampaignMember record insertion is failed'+campaignMember);
        
        System.assertEquals(false, [select rC_Giving__Archive_Flag__c from CampaignMember where Id =: campaignMember.Id].rC_Giving__Archive_Flag__c, 'CampaignMember_SetArchiveBatchableTest.test() : Archived CampaignMember record inserted'+campaignMember);
        Test.startTest();
        System.assert(true, Database.executeBatch(new CampaignMember_SetArchiveBatchable(), 1) != null);
        Test.stopTest();
        
        System.assertEquals(true, [select rC_Giving__Archive_Flag__c from CampaignMember where Id =: campaignMember.Id].rC_Giving__Archive_Flag__c, 'CampaignMember_SetArchiveBatchableTest.test() : CampaignMember record updation is failed'+campaignMember);
    }
}