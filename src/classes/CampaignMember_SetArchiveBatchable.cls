global class CampaignMember_SetArchiveBatchable implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext batchableContext){
        return Database.getQueryLocator([
            select Id
                 , rC_Giving__Archive_Flag__c
                 , Contact.Account.rC_Giving__Lifetime_Is_Major_Giver__c
                 , LastModifiedDate
              from CampaignMember
             where LastModifiedDate >= :Date.today().addYears(-2)
               and Contact.Account.rC_Giving__Lifetime_Is_Major_Giver__c = false
        ]);
    }
    
    global void execute(Database.BatchableContext batchableContext, CampaignMember[] campaignMemberList) {
        for(CampaignMember campaignMember : campaignMemberList)
            campaignMember.rC_Giving__Archive_Flag__c = true;
        update campaignMemberList;
    }
    
    global void finish(Database.BatchableContext batchableContext) {
        
    }
}