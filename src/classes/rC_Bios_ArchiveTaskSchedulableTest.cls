@isTest
public class rC_Bios_ArchiveTaskSchedulableTest {
    @isTest
    public static void test() {
        Test.startTest();
        rC_Bios_ArchiveTaskSchedulable archiveTask = new rC_Bios_ArchiveTaskSchedulable();
        SchedulableContext SC;
        archiveTask.execute(SC);
        Test.stopTest();
    }
}