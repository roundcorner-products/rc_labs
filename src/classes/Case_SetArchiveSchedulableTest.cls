@isTest
public class Case_SetArchiveSchedulableTest {
    @isTest
    public static void Case_SetArchiveSchedulableTest() {
        Test.startTest();
        Case_SetArchiveSchedulable archiveCase = new Case_SetArchiveSchedulable();
        SchedulableContext SC;
        archiveCase.execute(SC);
        Test.stopTest();
    }
}