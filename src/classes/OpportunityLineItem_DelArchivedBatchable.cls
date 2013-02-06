global class OpportunityLineItem_DelArchivedBatchable implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext batchableContext){
        return Database.getQueryLocator([
            select Id
                 , rC_Giving__Archive_Flag__c
              from OpportunityLineItem
             where rC_Giving__Archive_Flag__c = true
        ]);
    }
    
    global void execute(Database.BatchableContext batchableContext, OpportunityLineItem[] opportunityLineItemList) {
        if (opportunityLineItemList != null && opportunityLineItemList.size() > 0)
            delete opportunityLineItemList;
    }
    
    global void finish(Database.BatchableContext batchableContext) {
        
    }
}