global class Credit_SetArchiveBatchable implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext batchableContext){
        return Database.getQueryLocator([
            select Id
                 , rC_Giving__Archive_Flag__c
              from rC_Giving__Opportunity_Credit__c
             where rC_Giving__Opportunity__r.rC_Giving__Archive_Flag__c = true
        ]);
    }
    
    global void execute(Database.BatchableContext batchableContext, rC_Giving__Opportunity_Credit__c[] creditList) {
        for(rC_Giving__Opportunity_Credit__c credit : creditList)
            credit.rC_Giving__Archive_Flag__c = true;
        update creditList;
    }
    
    global void finish(Database.BatchableContext batchableContext) {
        
    }
}