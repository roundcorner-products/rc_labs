global class Credit_DeleteArchivedSchedulable implements Schedulable {
    global void execute(SchedulableContext schedulableContext) {
        Database.executeBatch(new Credit_DeleteArchivedBatchable());
    }
}