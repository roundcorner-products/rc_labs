@isTest
public class Opportunity_DelArchivedSchedulableTest {
    @isTest
    public static void Opportunity_DeleteArchivedSchedulable_test() {
        Test.startTest();
        Opportunity_DeleteArchivedSchedulable opportunitySchedulable = new Opportunity_DeleteArchivedSchedulable();
        SchedulableContext SC;
        opportunitySchedulable.execute(SC);
        Test.stopTest();
    }
}