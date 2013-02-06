global class Case_DeleteArchivedBatchable implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext batchableContext){
        return Database.getQueryLocator([
            select Id
                 , rC_Bios__Archive_Flag__c
              from Case
             where rC_Bios__Archive_Flag__c = true
        ]);
    }
    
    global void execute(Database.BatchableContext batchableContext, Case[] caseList) {
        if (caseList != null && caseList.size() > 0)
            delete caseList;
    }
    
    global void finish(Database.BatchableContext batchableContext) {
        
    }
}