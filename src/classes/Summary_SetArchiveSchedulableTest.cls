@isTest
public class Summary_SetArchiveSchedulableTest {
    @isTest
    public static void test() {
        Test.startTest();
        Summary_SetArchiveSchedulable summarySchedulable = new Summary_SetArchiveSchedulable();
        SchedulableContext SC;
        summarySchedulable.execute(SC);
        Test.stopTest();
    }
}