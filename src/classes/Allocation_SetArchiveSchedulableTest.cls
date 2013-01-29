@isTest
public class Allocation_SetArchiveSchedulableTest {
    @isTest
    public static void test() {
        Test.startTest();
        Allocation_SetArchiveSchedulable allocationSchedulable = new Allocation_SetArchiveSchedulable();
        SchedulableContext SC;
        allocationSchedulable.execute(SC);
        Test.stopTest();
    }
}