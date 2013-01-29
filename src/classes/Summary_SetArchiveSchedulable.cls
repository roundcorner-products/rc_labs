global class Summary_SetArchiveSchedulable implements Schedulable {
    global void execute(SchedulableContext schedulableContext) {
        //Summary
        Database.executeBatch(new Summary_SetArchiveBatchable());
    }
}