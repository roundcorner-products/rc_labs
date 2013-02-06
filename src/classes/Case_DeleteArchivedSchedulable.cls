global class Case_DeleteArchivedSchedulable implements Schedulable {
    global void execute(SchedulableContext schedulableContext) {
        Database.executeBatch(new Case_DeleteArchivedBatchable());
    }
}