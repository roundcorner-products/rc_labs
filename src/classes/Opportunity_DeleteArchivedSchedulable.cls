global class Opportunity_DeleteArchivedSchedulable implements Schedulable {
    global void execute(SchedulableContext schedulableContext) {
        //Opportunity
        Database.executeBatch(new Opportunity_DeleteArchivedBatchable());
    }
}