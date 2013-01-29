global class Opportunity_SetArchiveBatchable implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext batchableContext){
        return Database.getQueryLocator([
            select Id
                 , rC_Giving__Archive_Flag__c
                 , Account.rC_Giving__Lifetime_Is_Major_Giver__c
                 , CloseDate
              from Opportunity
             where CloseDate >= :Date.today().addYears(-5)
               and Account.rC_Giving__Lifetime_Is_Major_Giver__c = false
        ]);
    }
    
    global void execute(Database.BatchableContext batchableContext, Opportunity[] opportunityList) {
        for(Opportunity opportunity : opportunityList)
            opportunity.rC_Giving__Archive_Flag__c = true;
        update opportunityList;
    }
    
    global void finish(Database.BatchableContext batchableContext) {
        
    }
}