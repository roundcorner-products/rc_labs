global class Allocation_DeleteArchivedSchedulable implements Schedulable {
    global void execute(SchedulableContext schedulableContext) {
        Database.executeBatch(new Allocation_DeleteArchivedBatchable());
    }
}