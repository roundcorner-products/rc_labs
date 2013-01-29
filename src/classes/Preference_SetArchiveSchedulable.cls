global class Preference_SetArchiveSchedulable implements Schedulable {
    global void execute(SchedulableContext schedulableContext) {
        //Preferences
        Database.executeBatch(new Preference_SetArchiveBatchable());
    }
}