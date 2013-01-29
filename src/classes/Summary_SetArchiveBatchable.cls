global class Summary_SetArchiveBatchable implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext batchableContext){
        return Database.getQueryLocator([
            select Id
                 , rC_Giving__Archive_Flag__c
                 , rC_Giving__Account__r.rC_Giving__Lifetime_Is_Major_Giver__c
                 , rC_Giving__Current_Year__c
              from rC_Giving__Summary__c
             where rC_Giving__Giving_Level_Status__c = 'Renewed'
               and rC_Giving__Lifetime_Summary__c = null
               and rC_Giving__Current_Year__c <= :String.valueOf(Date.today().year()-2)
               and rC_Giving__Account__r.rC_Giving__Lifetime_Is_Major_Giver__c = false
        ]);
    }
    
    global void execute(Database.BatchableContext batchableContext, rC_Giving__Summary__c[] summaryList) {
        for(rC_Giving__Summary__c summary : summaryList)
            summary.rC_Giving__Archive_Flag__c = true;
        update summaryList;
    }
    
    global void finish(Database.BatchableContext batchableContext) {
        
    }
}