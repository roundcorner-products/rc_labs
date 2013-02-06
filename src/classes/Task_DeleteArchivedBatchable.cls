global class Task_DeleteArchivedBatchable implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext batchableContext){
        return Database.getQueryLocator([
            select Id
                 , rC_Bios__Archive_Flag__c
              from Task
             where rC_Bios__Archive_Flag__c = true
        ]);
    }
    
    global void execute(Database.BatchableContext batchableContext, Task[] taskList) {
        if (taskList != null && taskList.size() > 0)
            delete taskList;
    }
    
    global void finish(Database.BatchableContext batchableContext) {
        
    }
}