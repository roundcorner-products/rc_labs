global class Case_SetArchiveSchedulable {
    global void execute(SchedulableContext schedulableContext) {
        Database.executeBatch(new Case_SetArchiveBatchable());
    }
}