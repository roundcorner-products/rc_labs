global class Task_DeleteArchivedSchedulable implements Schedulable {
    global void execute(SchedulableContext schedulableContext) {
        Database.executeBatch(new Task_DeleteArchivedBatchable());
    }
}