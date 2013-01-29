@isTest
public class rC_Bios_ArchiveCaseSchedulableTest {
    @isTest
    public static void test() {
        Test.startTest();
        rC_Bios_ArchiveCaseSchedulable archiveCase = new rC_Bios_ArchiveCaseSchedulable();
        SchedulableContext SC;
        archiveCase.execute(SC);
        Test.stopTest();
    }
}