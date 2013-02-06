@isTest
public class Case_DeleteArchivedSchedulableTest {
    @isTest
    public static void test() {
        Test.startTest();
        Case_DeleteArchivedSchedulable caseScheduler = new Case_DeleteArchivedSchedulable();
        SchedulableContext SC;
        caseScheduler.execute(SC);
        Test.stopTest();
    }
}