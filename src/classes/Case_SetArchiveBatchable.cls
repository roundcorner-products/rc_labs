global class Case_SetArchiveBatchable implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext batchableContext){
        return Database.getQueryLocator([
            select Id
                 , rC_Bios__Archive_Flag__c
                 , Account.rC_Giving__Lifetime_Is_Major_Giver__c
                 , ClosedDate
              from Case
             where ClosedDate < :Date.today().addYears(-2)
               and Account.rC_Giving__Lifetime_Is_Major_Giver__c = false
        ]);
    }
    
    global void execute(Database.BatchableContext batchableContext, Case[] caseList) {
        for(Case caseObj : caseList)
            caseObj.rC_Bios__Archive_Flag__c = true;
        update caseList;
    }
    
    global void finish(Database.BatchableContext batchableContext) {
        
    }
}