global class rC_Bios_ArchiveTaskSchedulable implements Schedulable {
    global void execute(SchedulableContext schedulableContext) {
        //Tasks
        Database.executeBatch(new Task_SetArchiveBatchable());
    }
}