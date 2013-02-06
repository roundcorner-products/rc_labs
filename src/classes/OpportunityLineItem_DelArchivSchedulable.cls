global class OpportunityLineItem_DelArchivSchedulable implements Schedulable {
    global void execute(SchedulableContext schedulableContext) {
        //OpportunityLineItem
        Database.executeBatch(new OpportunityLineItem_DelArchivedBatchable());
    }
}