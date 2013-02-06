global class Preference_DeleteArchivedSchedulable implements Schedulable {
    global void execute(SchedulableContext schedulableContext) {
        //Preferences
        Database.executeBatch(new Preference_DeleteArchivedBatchable());
    }
}