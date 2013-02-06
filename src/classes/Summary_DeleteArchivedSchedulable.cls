global class Summary_DeleteArchivedSchedulable implements Schedulable {
    global void execute(SchedulableContext schedulableContext) {
        //Summary
        Database.executeBatch(new Summary_DeleteArchivedBatchable());
    }
}