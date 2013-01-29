@isTest
public class CampaignMember_SetArchiveSchedulableTest {
    @isTest
    public static void test() {
        Test.startTest();
        CampaignMember_SetArchiveSchedulable campaignMemberSchedulable = new CampaignMember_SetArchiveSchedulable();
        SchedulableContext SC;
        campaignMemberSchedulable.execute(SC);
        Test.stopTest();
    }
}