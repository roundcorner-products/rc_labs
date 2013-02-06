global class Allocation_DeleteArchivedBatchable implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext batchableContext){
        return Database.getQueryLocator([
            select Id
                 , rC_Giving__Archive_Flag__c
              from rC_Giving__Opportunity_Allocation__c
             where rC_Giving__Archive_Flag__c = true
        ]);
    }
    
    global void execute(Database.BatchableContext batchableContext, rC_Giving__Opportunity_Allocation__c[] allocationList) {
        if (allocationList != null && allocationList.size() > 0)
            delete allocationList;
    }
    
    global void finish(Database.BatchableContext batchableContext) {
        
    }
}