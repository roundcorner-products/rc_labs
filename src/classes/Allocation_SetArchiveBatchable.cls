global class Allocation_SetArchiveBatchable implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext batchableContext){
        return Database.getQueryLocator([
            select Id
                 , rC_Giving__Archive_Flag__c
              from rC_Giving__Opportunity_Allocation__c
             where rC_Giving__Opportunity__r.rC_Giving__Archive_Flag__c = true
        ]);
    }
    
    global void execute(Database.BatchableContext batchableContext, rC_Giving__Opportunity_Allocation__c[] allocationList) {
        for(rC_Giving__Opportunity_Allocation__c allocation : allocationList)
            allocation.rC_Giving__Archive_Flag__c = true;
        update allocationList;
    }
    
    global void finish(Database.BatchableContext batchableContext) {
        
    }
}