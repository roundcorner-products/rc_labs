@isTest
public class rC_Bios_ArchiveTaskTest {
    @isTest
    public static void test() {
        Test.startTest();
        rC_Bios_ArchiveTask archiveTask = new rC_Bios_ArchiveTask();
        SchedulableContext SC;
        archiveTask.execute(SC);
        Test.stopTest();
    }
}