global class Task_SetArchiveSchedulable implements Schedulable {
    global void execute(SchedulableContext schedulableContext) {
        Database.executeBatch(new Task_SetArchiveBatchable());
    }
}