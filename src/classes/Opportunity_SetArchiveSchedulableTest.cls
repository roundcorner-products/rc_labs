@isTest
public class Opportunity_SetArchiveSchedulableTest {
    @isTest
    public static void test() {
        Test.startTest();
        Opportunity_SetArchiveSchedulable opportunitySchedulable = new Opportunity_SetArchiveSchedulable();
        SchedulableContext SC;
        opportunitySchedulable.execute(SC);
        Test.stopTest();
    }
}