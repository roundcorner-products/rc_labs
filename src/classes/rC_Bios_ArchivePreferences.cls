global class rC_Bios_ArchivePreferences implements Schedulable {
    global void execute(SchedulableContext schedulableContext) {
        //Preferences
        Database.executeBatch(new Preference_SetArchiveBatchable());
    }
}