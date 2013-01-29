global class rC_Bios_ArchivePreferencesSchedulable implements Schedulable {
    global void execute(SchedulableContext schedulableContext) {
        //Preferences
        Database.executeBatch(new Preference_SetArchiveBatchable());
    }
}