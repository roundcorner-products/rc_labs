global class Opportunity_DeleteArchivedBatchable implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext batchableContext){
        return Database.getQueryLocator([
            select Id
                 , rC_Giving__Archive_Flag__c
              from Opportunity
             where rC_Giving__Archive_Flag__c = true
        ]);
    }
    
    global void execute(Database.BatchableContext batchableContext, Opportunity[] opportunityList) {
        if (opportunityList != null && opportunityList.size() > 0)
            delete opportunityList;
    }
    
    global void finish(Database.BatchableContext batchableContext) {
        
    }
}