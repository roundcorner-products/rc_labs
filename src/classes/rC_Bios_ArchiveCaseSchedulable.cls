global class rC_Bios_ArchiveCaseSchedulable implements Schedulable {
    global void execute(SchedulableContext schedulableContext) {
        //Cases
        Database.executeBatch(new Case_SetArchiveBatchable());
    }
}