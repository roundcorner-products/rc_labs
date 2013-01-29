@isTest
public class Credit_SetArchiveSchedulableTest {
    @isTest
    public static void test() {
        Test.startTest();
        Credit_SetArchiveSchedulable creditSchedulable = new Credit_SetArchiveSchedulable();
        SchedulableContext SC;
        creditSchedulable.execute(SC);
        Test.stopTest();
    }
}