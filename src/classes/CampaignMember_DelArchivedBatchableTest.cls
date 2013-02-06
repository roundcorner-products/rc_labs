@isTest
public class CampaignMember_DelArchivedBatchableTest {
    @isTest
    public static void test() {
        Account account = new Account();
        account.name = 'Account Name';
        account.rC_Giving__Lifetime_Is_Major_Giver__c = false;
        insert account;
        
        System.assert(null != account.Id, 'CampaignMember_DelArchivedBatchableTest.test() : Account record insertion is failed'+account);
        
        Contact contact = new Contact(FirstName = 'Contact FirstName', LastName = 'Contact LastName', AccountId = account.Id);
        insert contact;
        System.assert(null != contact.Id, 'CampaignMember_DelArchivedBatchableTest.test() : Contact record insertion is failed'+contact);
        
        Campaign campaign = new Campaign(Name = 'Campaign Name');
        insert campaign;
        
        System.assert(null != campaign.Id, 'CampaignMember_DelArchivedBatchableTest.test() : Campaign record insertion is failed'+campaign);
        
        CampaignMember campaignMember = new CampaignMember();
        campaignMember.CampaignId = campaign.Id;
        campaignMember.ContactId = contact.Id;
        campaignMember.rC_Giving__Archive_Flag__c = true;
        insert campaignMember;
        
        System.assert(null != campaignMember.Id, 'CampaignMember_DelArchivedBatchableTest.test() : CampaignMember record insertion is failed'+campaignMember);
        
        Test.startTest();
        System.assert(true, Database.executeBatch(new CampaignMember_DeleteArchivedBatchable(), 1) != null);
        Test.stopTest();
        
        System.assertEquals(0, [select Id from CampaignMember where Id =: campaignMember.Id].size(), 'CampaignMember_DelArchivedBatchableTest.test() : CampaignMember record deletion failed');
    }
}