global class GivingSummary_SetArchiveBatchable implements Database.Batchable<sObject> {
	public static Map<String, Schema.SObjectField> summaryFieldsMap = schema.SObjectType.rC_Giving__Summary__c.fields.getMap();
    public static List<Schema.SObjectField> summaryFieldsMapValues = summaryFieldsMap.values();
    public String startYear;
    public String endYear;
    public String AccountId;
    
    public GivingSummary_SetArchiveBatchable(String startYear, String endYear){
        this.startYear = startYear;    
        this.endYear = endYear;	
    }
    
    public GivingSummary_SetArchiveBatchable(Integer startYear, Integer endYear){
        this.startYear = String.valueof(startYear);    
        this.endYear = String.valueof(endYear);	
    }
    
    public GivingSummary_SetArchiveBatchable(Integer startYear, Integer endYear,String AccountId){
    	this.AccountId = AccountId;
        this.startYear = String.valueof(startYear);    
        this.endYear = String.valueof(endYear);	
    }
    
    global Database.QueryLocator start(Database.BatchableContext batchableContext){
        return Database.getQueryLocator(getQuery());
    }
    
    global void execute(Database.BatchableContext batchableContext, Account[] accountList) {
        For(Account account: accountList) {
        	rC_Giving__Summary__c[] summaryList = account.rC_Giving__Account_Memberships__r;
        	
            if (summaryList.size() == 0)
                continue;
            
            rC_Giving__Summary__c summary = new rC_Giving__Summary__c();
            // Reset Summary with values =  0 
            resetSummary(summary); 
            
            getsummarizevalues(summary,summaryList);
                
            system.debug('_____________summary = ' + summary); 
            //system.debug('_____________.rC_Giving__Account_Memberships__r = ' + account.rC_Giving__Account_Memberships__r.size());   	
        }
    }
    
    global void finish(Database.BatchableContext batchableContext) {
        
    }
    
    public void getsummarizevalues(rC_Giving__Summary__c archivedSummary, rC_Giving__Summary__c[] summaryList) {
        if (summaryList == null || summaryList.size() == 0)   	
            return;
        
        for (rC_Giving__Summary__c summary :summaryList){
            archivedSummary.rC_Giving__Current_Additional_Amount__c	+= defaultZero(summary.rC_Giving__Current_Additional_Amount__c);
            archivedSummary.rC_Giving__Current_Amount__c += defaultZero(summary.rC_Giving__Current_Amount__c);
            archivedSummary.rC_Giving__Current_Annual_Amount__c += defaultZero(summary.rC_Giving__Current_Annual_Amount__c);
            archivedSummary.rC_Giving__Current_Best_Case_Amount__c += defaultZero(summary.rC_Giving__Current_Best_Case_Amount__c);
            archivedSummary.rC_Giving__Current_Closed_Amount__c += defaultZero(summary.rC_Giving__Current_Closed_Amount__c);
            archivedSummary.rC_Giving__Current_Commit_Amount__c += defaultZero(summary.rC_Giving__Current_Commit_Amount__c);
            archivedSummary.rC_Giving__Current_Omitted_Amount__c += defaultZero(summary.rC_Giving__Current_Omitted_Amount__c);
            archivedSummary.rC_Giving__Current_Pipeline_Amount__c += defaultZero(summary.rC_Giving__Current_Pipeline_Amount__c);
            archivedSummary.rC_Giving__Current_Renewal_Amount__c += defaultZero(summary.rC_Giving__Current_Renewal_Amount__c);
            archivedSummary.rC_Giving__Current_Shopper_Count__c += defaultZero(summary.rC_Giving__Current_Shopper_Count__c);
            
        }    
    }
    
    public string getQuery(){
        String query = '';
        
        for(Schema.SObjectField summaryField: summaryFieldsMapValues){
            if (summaryField.getDescribe().isAccessible()) {
                if (query.length() != 0)
                    query += ', ';
                query += summaryField.getDescribe().getName();
            }
        }
        
        query = 'Select ' + 'Id'
              + '     , ' + 'Name'
              
              + '     ,(' + ' Select ' +  query
                          + '   From ' + 'rC_Giving__Account_Memberships__r'
                          + '  Where ' + 'rC_Giving__Current_Year__c >= :startYear'
                          + '    And ' + 'rC_Giving__Current_Year__c <= :endYear'      
              + '      )'
              
              + '  From ' + SobjectType.Account.Name ;
        
        if (AccountId != null && AccountId != '')
            query = query + ' Where Id = :AccountId';
        return query;
    }
    
    public Decimal defaultZero(Decimal value) {
        return value == null ? 0 : value;
    }
    
    public Void resetSummary(rC_Giving__Summary__c summary) {
        summary.rC_Giving__Current_Additional_Amount__c = 0;
        summary.rC_Giving__Current_Amount__c = 0;
        summary.rC_Giving__Current_Annual_Amount__c = 0;
        summary.rC_Giving__Current_Best_Case_Amount__c = 0;
        summary.rC_Giving__Current_Closed_Amount__c = 0;
        summary.rC_Giving__Current_Commit_Amount__c = 0;
        summary.rC_Giving__Current_Omitted_Amount__c = 0;
        summary.rC_Giving__Current_Pipeline_Amount__c = 0;
        summary.rC_Giving__Current_Renewal_Amount__c = 0;	
        summary.rC_Giving__Current_Shopper_Count__c = 0;	
	
    }
    
}