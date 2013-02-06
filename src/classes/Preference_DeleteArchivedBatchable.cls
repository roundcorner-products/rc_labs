global class Preference_DeleteArchivedBatchable implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext batchableContext){
        return Database.getQueryLocator([
            select Id
                 , rC_Bios__Archive_Flag__c
              from rC_Bios__Preference__c
             where rC_Bios__Archive_Flag__c = true
        ]);
    }
    
    global void execute(Database.BatchableContext batchableContext, rC_Bios__Preference__c[] preferenceList) {
        if (preferenceList != null && preferenceList.size() > 0)
            delete preferenceList;
    }
    
    global void finish(Database.BatchableContext batchableContext) {
        
    }
}