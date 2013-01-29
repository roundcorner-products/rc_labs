global class Credit_SetArchiveSchedulable implements Schedulable {
    global void execute(SchedulableContext schedulableContext) {
        //Credit
        Database.executeBatch(new Credit_SetArchiveBatchable());
    }
}