@isTest
public class Task_SetArchiveSchedulableTest {
    @isTest
    public static void test() {
        Test.startTest();
        Task_SetArchiveSchedulable archiveTask = new Task_SetArchiveSchedulable();
        SchedulableContext SC;
        archiveTask.execute(SC);
        Test.stopTest();
    }
}