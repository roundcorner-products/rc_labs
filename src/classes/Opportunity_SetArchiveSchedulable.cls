global class Opportunity_SetArchiveSchedulable implements Schedulable {
    global void execute(SchedulableContext schedulableContext) {
        //Opportunity
        Database.executeBatch(new Opportunity_SetArchiveBatchable());
    }
}