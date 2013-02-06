global class Summary_DeleteArchivedBatchable implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext batchableContext){
        return Database.getQueryLocator([
            select Id
                 , rC_Giving__Archive_Flag__c
              from rC_Giving__Summary__c
             where rC_Giving__Archive_Flag__c = true
        ]);
    }
    
    global void execute(Database.BatchableContext batchableContext, rC_Giving__Summary__c[] summaryList) {
        if (summaryList != null && summaryList.size() > 0)
            delete summaryList;
    }
    
    global void finish(Database.BatchableContext batchableContext) {
        
    }
}