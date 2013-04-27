@isTest
public class Account_ManageArchivalTest {
    @IsTest
    public static void testManageArchival() {
        Account account = new Account();
        account.name = 'Account Name';
        insert account;
        
        System.assert(null != account.Id, 'Account_ManageArchivalTest.testManageArchival() : Account record insertion is failed'+account);
        Account_ManageArchival accountArchival = new Account_ManageArchival(new ApexPages.StandardController(account));
        accountArchival.initialize();
        accountArchival.getCampaignMemberLink();
        accountArchival.getCaseLink();
        accountArchival.getPreferenceLink();
        
        system.assertNotEquals(null, accountArchival.getTaskLink(), 'Account_ManageArchivalTest.testManageArchival() : Invalid redirection');
    }
}