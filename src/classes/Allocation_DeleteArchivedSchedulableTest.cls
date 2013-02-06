@isTest
public class Allocation_DeleteArchivedSchedulableTest {
    @isTest
    public static void test() {
        Test.startTest();
        Allocation_DeleteArchivedSchedulable allocationScheduler = new Allocation_DeleteArchivedSchedulable();
        SchedulableContext SC;
        allocationScheduler.execute(SC);
        Test.stopTest();
    }
}