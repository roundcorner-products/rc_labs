global class rC_Bios_ArchiveTask implements Schedulable {
    global void execute(SchedulableContext schedulableContext) {
        //Tasks
        Database.executeBatch(new Task_SetArchiveBatchable());
    }
}