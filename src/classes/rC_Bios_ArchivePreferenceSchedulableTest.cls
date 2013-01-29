@isTest
public class rC_Bios_ArchivePreferenceSchedulableTest {
    @isTest
    public static void test() {
        Test.startTest();
        rC_Bios_ArchivePreferencesSchedulable archivePreferences = new rC_Bios_ArchivePreferencesSchedulable();
        SchedulableContext SC;
        archivePreferences.execute(SC);
        Test.stopTest();
    }
}