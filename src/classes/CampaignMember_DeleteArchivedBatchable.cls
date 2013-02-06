global class CampaignMember_DeleteArchivedBatchable implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext batchableContext){
        return Database.getQueryLocator([
            select Id
                 , rC_Giving__Archive_Flag__c
              from CampaignMember
             where rC_Giving__Archive_Flag__c = true
        ]);
    }
    
    global void execute(Database.BatchableContext batchableContext, CampaignMember[] campaignMemberList) {
        if (campaignMemberList != null && campaignMemberList.size() > 0)
            delete campaignMemberList;
    }
    
    global void finish(Database.BatchableContext batchableContext) {
        
    }
}