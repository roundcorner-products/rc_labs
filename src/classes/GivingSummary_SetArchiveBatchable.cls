global class GivingSummary_SetArchiveBatchable implements Database.Batchable<sObject> {
	public static Map<String, Schema.SObjectField> summaryFieldsMap = schema.SObjectType.rC_Giving__Summary__c.fields.getMap();
    public static List<Schema.SObjectField> summaryFieldsMapValues = summaryFieldsMap.values();
    public String startYear;
    public String endYear;
    
    public GivingSummary_SetArchiveBatchable(String startYear, String endYear){
        this.startYear = startYear;    
        this.endYear = endYear;	
    }
    
    public GivingSummary_SetArchiveBatchable(Integer startYear, Integer endYear){
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
                
            system.debug('_____________account = ' + account); 
            system.debug('_____________.rC_Giving__Account_Memberships__r = ' + account.rC_Giving__Account_Memberships__r.size());   	
        }
    }
    
    global void finish(Database.BatchableContext batchableContext) {
        
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
        return query;
    }
    
}