global class Preference_SetArchiveBatchable implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext batchableContext){
        return Database.getQueryLocator([
            select Id
                 , rC_Bios__Archive_Flag__c
                 , rC_Bios__Account__r.rC_Giving__Lifetime_Is_Major_Giver__c
                 , rC_Bios__End_Date__c
              from rC_Bios__Preference__c
             where rC_Bios__Status__c = 'Inactive'
               and ( rC_Bios__End_Date__c < :Date.today()
                   or rC_Bios__End_Date__c = null )
               and rC_Bios__Account__r.rC_Giving__Lifetime_Is_Major_Giver__c = false
        ]);
    }
    
    global void execute(Database.BatchableContext batchableContext, rC_Bios__Preference__c[] preferenceList) {
        for(rC_Bios__Preference__c preference : preferenceList)
            preference.rC_Bios__Archive_Flag__c = true;
        update preferenceList;
    }
    
    global void finish(Database.BatchableContext batchableContext) {
        
    }
}