global class Credit_DeleteArchivedBatchable implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext batchableContext){
        return Database.getQueryLocator([
            select Id
                 , rC_Giving__Archive_Flag__c
              from rC_Giving__Opportunity_Credit__c
             where rC_Giving__Archive_Flag__c = true
        ]);
    }
    
    global void execute(Database.BatchableContext batchableContext, rC_Giving__Opportunity_Credit__c[] creditList) {
        if (creditList != null && creditList.size() > 0)
            delete creditList;
    }
    
    global void finish(Database.BatchableContext batchableContext) {
        
    }
}