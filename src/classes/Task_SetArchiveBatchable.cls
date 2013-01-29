global class Task_SetArchiveBatchable implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext batchableContext){
        return Database.getQueryLocator([
            select Id
                 , rC_Bios__Archive_Flag__c
                 , Account.rC_Giving__Lifetime_Is_Major_Giver__c
                 , ActivityDate
              from Task
             where ActivityDate >= :Date.today().addYears(-2)
               and Account.rC_Giving__Lifetime_Is_Major_Giver__c = false
               and Status = 'Completed'
        ]);
    }
    
    global void execute(Database.BatchableContext batchableContext, Task[] taskList) {
        for(Task task : taskList)
            task.rC_Bios__Archive_Flag__c = true;
        update taskList;
    }
    
    global void finish(Database.BatchableContext batchableContext) {
        
    }
}