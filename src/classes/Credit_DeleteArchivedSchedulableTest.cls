@isTest
public class Credit_DeleteArchivedSchedulableTest {
    @isTest
    public static void test() {
        Test.startTest();
        Credit_DeleteArchivedSchedulable creditScheduler = new Credit_DeleteArchivedSchedulable();
        SchedulableContext SC;
        creditScheduler.execute(SC);
        Test.stopTest();
    }
}