global class CampaignMember_SetArchiveSchedulable implements Schedulable {
    global void execute(SchedulableContext schedulableContext) {
        //CampaignMember
        Database.executeBatch(new CampaignMember_SetArchiveBatchable());
    }
}