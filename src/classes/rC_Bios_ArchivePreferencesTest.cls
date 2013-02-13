public class rC_Bios_ArchivePreferencesTest {
    @isTest
    public static void test() {
        Test.startTest();
        rC_Bios_ArchivePreferences archivePreferences = new rC_Bios_ArchivePreferences();
        SchedulableContext SC;
        archivePreferences.execute(SC);
        Test.stopTest();
    }
}