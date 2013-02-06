global class CampaignMember_DeleteArchivedSchedulable implements Schedulable {
    global void execute(SchedulableContext schedulableContext) {
        Database.executeBatch(new CampaignMember_DeleteArchivedBatchable());
    }
}