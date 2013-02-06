@isTest
public class CampaignMember_DelArchiveSchedulableTest {
    @isTest
    public static void test() {
        Test.startTest();
        CampaignMember_DeleteArchivedSchedulable campaignMemberScheduler = new CampaignMember_DeleteArchivedSchedulable();
        SchedulableContext SC;
        campaignMemberScheduler.execute(SC);
        Test.stopTest();
    }
}