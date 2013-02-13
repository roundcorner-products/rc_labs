@isTest
public class rC_Bios_ArchiveCaseTest {
    @isTest
    public static void test() {
        Test.startTest();
        rC_Bios_ArchiveCase archiveCase = new rC_Bios_ArchiveCase();
        SchedulableContext SC;
        archiveCase.execute(SC);
        Test.stopTest();
    }
}