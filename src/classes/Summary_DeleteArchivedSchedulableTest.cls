@isTest
public class Summary_DeleteArchivedSchedulableTest {
    @isTest
    public static void test() {
        Test.startTest();
        Summary_DeleteArchivedSchedulable summarySchedulable = new Summary_DeleteArchivedSchedulable();
        SchedulableContext SC;
        summarySchedulable.execute(SC);
        Test.stopTest();
    }
}