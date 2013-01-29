global class Allocation_SetArchiveSchedulable implements Schedulable {
    global void execute(SchedulableContext schedulableContext) {
        //Allocation
        Database.executeBatch(new Allocation_SetArchiveBatchable());
    }
}