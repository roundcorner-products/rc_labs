@isTest
public class Task_DeleteArchivedSchedulableTest {
    @isTest
    public static void test() {
        Test.startTest();
        Task_DeleteArchivedSchedulable taskScheduler = new Task_DeleteArchivedSchedulable();
        SchedulableContext SC;
        taskScheduler.execute(SC);
        Test.stopTest();
    }
}