global class GivingSummary_SetArchiveBatchable implements Database.Batchable<sObject> {
	public static Map<String, Schema.SObjectField> FIELDSMAP = schema.SObjectType.rC_Giving__Summary__c.fields.getMap();
    public static List<Schema.SObjectField> FIELDSMAPVALUES= FIELDSMAP.values();
    public static Map<string,schema.RecordTypeInfo> RT_MAP = rC_Giving__Summary__c.SObjectType.getDescribe().getRecordTypeInfosByName();
    
    public static string RT_ANNAUL_NAME = 'Annual';
    public static string RT_ANNAUL_AGGREGATE_NAME = 'Annual Aggregate';
    
    public static Id RT_ANNUAL_ID = getRecordTypeId(RT_ANNAUL_NAME);
    public static Id RT_ANNUAL_AGGREGATE_ID = getRecordTypeId(RT_ANNAUL_AGGREGATE_NAME);
    
    
    static Id getRecordTypeId(String name) {
        return RT_MAP.get(name) != null ? RT_MAP.get(name).getRecordTypeId() : null;
    }
    
    
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
            
            //rC_Giving__Summary__c summary = new rC_Giving__Summary__c();
            Map<String,rC_Giving__Summary__c> aggregatedSummaryMap = new Map<String,rC_Giving__Summary__c>();
            
            for (rC_Giving__Summary__c summary: summaryList) {
                if (aggregatedSummaryMap.containskey(summary.rC_Giving__Affiliation__c) == false)
                    aggregatedSummaryMap.put(summary.rC_Giving__Affiliation__c,new rC_Giving__Summary__c());	
            }
            
            // Reset Summary with values =  0 
            for(rC_Giving__Summary__c aggregatedSummary :aggregatedSummaryMap.values())
                resetSummary(aggregatedSummary); 
            
            //Summarize the value for Fields
            getsummarizeValues(aggregatedSummaryMap,summaryList);
            
            //Maximize the value for Fields
            getMaximumValues(aggregatedSummaryMap,summaryList);
            
            //Minimize the value for Fields
            getMinimumValues(aggregatedSummaryMap,summaryList);
            
            // Most Recent value for Fields
            getMostRecentValues(aggregatedSummaryMap,summaryList);
            
            // Miscellaneous calculation for fields
            getMiscellaneousValues(aggregatedSummaryMap,summaryList);
            
            insert aggregatedSummaryMap.values();
            
            updateOpportunities(aggregatedSummaryMap,summaryList);
            
            delete summaryList;
        }
    }
    
    global void finish(Database.BatchableContext batchableContext) {
        
    }
    
    public void getsummarizeValues(Map<String,rC_Giving__Summary__c> aggregatedSummaryMap, rC_Giving__Summary__c[] summaryList) {
        if (summaryList == null || summaryList.size() == 0)   	
            return;
        
        for (rC_Giving__Summary__c summary :summaryList){
        	
        	rC_Giving__Summary__c aggregatedSummary = aggregatedSummaryMap.get(summary.rC_Giving__Affiliation__c);
        	
            aggregatedSummary.rC_Giving__Current_Additional_Amount__c	+= defaultZero(summary.rC_Giving__Current_Additional_Amount__c);
            aggregatedSummary.rC_Giving__Current_Amount__c += defaultZero(summary.rC_Giving__Current_Amount__c);
            aggregatedSummary.rC_Giving__Current_Annual_Amount__c += defaultZero(summary.rC_Giving__Current_Annual_Amount__c);
            aggregatedSummary.rC_Giving__Current_Best_Case_Amount__c += defaultZero(summary.rC_Giving__Current_Best_Case_Amount__c);
            aggregatedSummary.rC_Giving__Current_Closed_Amount__c += defaultZero(summary.rC_Giving__Current_Closed_Amount__c);
            aggregatedSummary.rC_Giving__Current_Commit_Amount__c += defaultZero(summary.rC_Giving__Current_Commit_Amount__c);
            aggregatedSummary.rC_Giving__Current_Hard_Credit_Count__c += defaultZero(summary.rC_Giving__Current_Hard_Credit_Count__c);
            aggregatedSummary.rC_Giving__Current_Omitted_Amount__c += defaultZero(summary.rC_Giving__Current_Omitted_Amount__c);
            aggregatedSummary.rC_Giving__Current_Pipeline_Amount__c += defaultZero(summary.rC_Giving__Current_Pipeline_Amount__c);
            aggregatedSummary.rC_Giving__Current_Renewal_Amount__c += defaultZero(summary.rC_Giving__Current_Renewal_Amount__c);
            aggregatedSummary.rC_Giving__Current_Shopper_Count__c += defaultZero(summary.rC_Giving__Current_Shopper_Count__c);
            aggregatedSummary.rC_Giving__Entered_Current_Additional_Amount__c += defaultZero(summary.rC_Giving__Entered_Current_Additional_Amount__c);
            
        }    
    }
    
    public void getMaximumValues(Map<String,rC_Giving__Summary__c> aggregatedSummaryMap, rC_Giving__Summary__c[] summaryList) {
        if (summaryList == null || summaryList.size() == 0)   	
            return;
        
        for (rC_Giving__Summary__c summary :summaryList){
        	
        	rC_Giving__Summary__c aggregatedSummary = aggregatedSummaryMap.get(summary.rC_Giving__Affiliation__c);
        	
        	if (aggregatedSummary.rC_Giving__Largest_Giving_Amount__c == 0 
        	   || (summary.rC_Giving__Largest_Giving_Amount__c != null && aggregatedSummary.rC_Giving__Largest_Giving_Amount__c < summary.rC_Giving__Largest_Giving_Amount__c))
                aggregatedSummary.rC_Giving__Largest_Giving_Amount__c	= defaultZero(summary.rC_Giving__Largest_Giving_Amount__c);
            
            if (aggregatedSummary.rC_Giving__Most_Recent_Non_Add_Giving_Date__c == null 
                || (summary.rC_Giving__Most_Recent_Non_Add_Giving_Date__c != null && aggregatedSummary.rC_Giving__Most_Recent_Non_Add_Giving_Date__c < summary.rC_Giving__Most_Recent_Non_Add_Giving_Date__c))
                aggregatedSummary.rC_Giving__Most_Recent_Non_Add_Giving_Date__c = summary.rC_Giving__Most_Recent_Non_Add_Giving_Date__c;
            
            if (aggregatedSummary.rC_Giving__Most_Recent_Non_Add_Payment_Date__c == null 
                || (summary.rC_Giving__Most_Recent_Non_Add_Payment_Date__c != null && aggregatedSummary.rC_Giving__Most_Recent_Non_Add_Payment_Date__c < summary.rC_Giving__Most_Recent_Non_Add_Payment_Date__c))
                aggregatedSummary.rC_Giving__Most_Recent_Non_Add_Payment_Date__c = summary.rC_Giving__Most_Recent_Non_Add_Payment_Date__c;
            
            if (aggregatedSummary.rC_Giving__Giving_Level_Renewable_Date__c == null 
                || (summary.rC_Giving__Giving_Level_Renewable_Date__c != null && aggregatedSummary.rC_Giving__Giving_Level_Renewable_Date__c < summary.rC_Giving__Giving_Level_Renewable_Date__c))
                aggregatedSummary.rC_Giving__Giving_Level_Renewable_Date__c = summary.rC_Giving__Giving_Level_Renewable_Date__c;
            
            if (aggregatedSummary.rC_Giving__Giving_Level_Renewed_Date__c == null 
                || (summary.rC_Giving__Giving_Level_Renewed_Date__c != null && aggregatedSummary.rC_Giving__Giving_Level_Renewed_Date__c < summary.rC_Giving__Giving_Level_Renewed_Date__c))
                aggregatedSummary.rC_Giving__Giving_Level_Renewed_Date__c = summary.rC_Giving__Giving_Level_Renewed_Date__c;
            
            if (aggregatedSummary.rC_Giving__Giving_Level_Lapse_Date__c == null 
                || (summary.rC_Giving__Giving_Level_Lapse_Date__c != null && aggregatedSummary.rC_Giving__Giving_Level_Lapse_Date__c < summary.rC_Giving__Giving_Level_Lapse_Date__c))
                aggregatedSummary.rC_Giving__Giving_Level_Lapse_Date__c = summary.rC_Giving__Giving_Level_Lapse_Date__c;
            
            if (aggregatedSummary.rC_Giving__Giving_Level_Active_Date__c == null 
                || (summary.rC_Giving__Giving_Level_Active_Date__c != null && aggregatedSummary.rC_Giving__Giving_Level_Active_Date__c < summary.rC_Giving__Giving_Level_Active_Date__c))
                aggregatedSummary.rC_Giving__Giving_Level_Active_Date__c = summary.rC_Giving__Giving_Level_Active_Date__c;
            
            if (aggregatedSummary.rC_Giving__Giving_Level_Expiration_Date__c == null 
                || (summary.rC_Giving__Giving_Level_Expiration_Date__c != null && aggregatedSummary.rC_Giving__Giving_Level_Expiration_Date__c < summary.rC_Giving__Giving_Level_Expiration_Date__c))
                aggregatedSummary.rC_Giving__Giving_Level_Expiration_Date__c = summary.rC_Giving__Giving_Level_Expiration_Date__c;
                        
        }    
    }
    
    public void getMinimumValues(Map<String,rC_Giving__Summary__c> aggregatedSummaryMap, rC_Giving__Summary__c[] summaryList) {
        if (summaryList == null || summaryList.size() == 0)   	
            return;
        
        for (rC_Giving__Summary__c summary :summaryList){
        	
        	rC_Giving__Summary__c aggregatedSummary = aggregatedSummaryMap.get(summary.rC_Giving__Affiliation__c);
        	
            if (aggregatedSummary.rC_Giving__First_Giving_Date__c == null
        	   || (summary.rC_Giving__First_Giving_Date__c != null && aggregatedSummary.rC_Giving__First_Giving_Date__c > summary.rC_Giving__First_Giving_Date__c)) {
                aggregatedSummary.rC_Giving__First_Giving_Date__c = summary.rC_Giving__First_Giving_Date__c;
                aggregatedSummary.rC_Giving__First_Giving_Amount__c = summary.rC_Giving__First_Giving_Amount__c;
            }
                	
            if (aggregatedSummary.rC_Giving__First_Closed_Payment_Date__c == null
        	   || (summary.rC_Giving__First_Closed_Payment_Date__c != null && aggregatedSummary.rC_Giving__First_Closed_Payment_Date__c > summary.rC_Giving__First_Closed_Payment_Date__c))
                aggregatedSummary.rC_Giving__First_Closed_Payment_Date__c	= summary.rC_Giving__First_Closed_Payment_Date__c;
                	
        }
    }
    
    public void getMostRecentValues(Map<String,rC_Giving__Summary__c> aggregatedSummaryMap, rC_Giving__Summary__c[] summaryList) {
        if (summaryList == null || summaryList.size() == 0)   	
            return;
            
        rC_Giving__Summary__c mostRecentSummary = null; 
        
        for (rC_Giving__Summary__c summary :summaryList){
        	       	
            if (summary.rC_Giving__Is_Most_Recent__c == false)
                continue;
                
            rC_Giving__Summary__c aggregatedSummary = aggregatedSummaryMap.get(summary.rC_Giving__Affiliation__c);
            
            aggregatedSummary.rC_Giving__Giving_Level_Status__c = summary.rC_Giving__Giving_Level_Status__c; 
            aggregatedSummary.rC_Giving__Giving_Level__c = summary.rC_Giving__Giving_Level__c;
            aggregatedSummary.rC_Giving__Largest_Giving_Date__c = summary.rC_Giving__Largest_Giving_Date__c;
            aggregatedSummary.rC_Giving__First_Payment_Date__c = summary.rC_Giving__First_Payment_Date__c;
            aggregatedSummary.rC_Giving__Gift_Membership_Opportunity__c = summary.rC_Giving__Gift_Membership_Opportunity__c;
            aggregatedSummary.rC_Giving__Most_Recent_Giving_Amount__c = summary.rC_Giving__Most_Recent_Giving_Amount__c;
            aggregatedSummary.rC_Giving__Most_Recent_Giving_Date__c = summary.rC_Giving__Most_Recent_Giving_Date__c;
            aggregatedSummary.rC_Giving__Entered_Current_Amount__c = summary.rC_Giving__Entered_Current_Amount__c;
            aggregatedSummary.rC_Giving__Entered_Current_Annual_Amount__c = summary.rC_Giving__Entered_Current_Annual_Amount__c;
            
            aggregatedSummary.rC_Giving__Entered_Current_Renewal_Amount__c = summary.rC_Giving__Entered_Current_Renewal_Amount__c;
            aggregatedSummary.rC_Giving__Entered_Current_Annual_Amount__c = summary.rC_Giving__Entered_Current_Annual_Amount__c;
            aggregatedSummary.rC_Giving__Entered_First_Giving_Amount__c = summary.rC_Giving__Entered_First_Giving_Amount__c;
            aggregatedSummary.rC_Giving__Entered_Largest_Giving_Amount__c = summary.rC_Giving__Entered_Largest_Giving_Amount__c;
            aggregatedSummary.rC_Giving__Entered_Most_Recent_Giving_Amount__c = summary.rC_Giving__Entered_Most_Recent_Giving_Amount__c;
                
        }
                
    }
    
    public void getMiscellaneousValues(Map<String,rC_Giving__Summary__c> aggregatedSummaryMap, rC_Giving__Summary__c[] summaryList) {
        if (summaryList == null || summaryList.size() == 0)   	
            return;
        
        // Static values 
        for (rC_Giving__Summary__c aggregatedSummary : aggregatedSummaryMap.values()) {
            aggregatedSummary.rC_Giving__Archive_Flag__c = false;
            aggregatedSummary.rC_Giving__Is_Lifetime__c = false;
            aggregatedSummary.rC_Giving__Is_Historical__c = true;
            //aggregatedSummary.rC_Giving__Type__c = 'Aggregate';
            
        }
        
        
        for (rC_Giving__Summary__c summary :summaryList){
            rC_Giving__Summary__c aggregatedSummary = aggregatedSummaryMap.get(summary.rC_Giving__Affiliation__c);
            
            // Recordtype
            aggregatedSummary.RecordtypeId = RT_ANNUAL_AGGREGATE_ID;
            
            // Valus which are remains same
            aggregatedSummary.rC_Giving__Account__c = summary.rC_Giving__Account__c;
            aggregatedSummary.rC_Giving__Activity_Type__c = summary.rC_Giving__Activity_Type__c;
            aggregatedSummary.rC_Giving__Affiliation__c = summary.rC_Giving__Affiliation__c;
            aggregatedSummary.rC_Giving__Is_Annual__c = summary.rC_Giving__Is_Annual__c;
            aggregatedSummary.rC_Giving__Lifetime_Summary__c = summary.rC_Giving__Lifetime_Summary__c;
            /*aggregatedSummary.Name = aggregatedSummary.rC_Giving__Affiliation__c
                                           + ', ' + aggregatedSummary.rC_Giving__Activity_Type__c
                                           + ', ' + startYear
                                           + ', ' + 'To'
                                           + ', ' + endYear;*/
            aggregatedSummary.rC_Giving__Historical_Year__c = startYear + ' to ' + endYear;   
                                      
            
            // CSV values
            aggregatedSummary.rC_Giving__Entered_Currency__c = aggregatedSummary.rC_Giving__Entered_Currency__c == null ? summary.rC_Giving__Entered_Currency__c : '';
            if (aggregatedSummary.rC_Giving__Entered_Currency__c != null
             && summary.rC_Giving__Entered_Currency__c != null
             && aggregatedSummary.rC_Giving__Entered_Currency__c.contains(summary.rC_Giving__Entered_Currency__c) == false)
                aggregatedSummary.rC_Giving__Entered_Currency__c += ',' + summary.rC_Giving__Entered_Currency__c; 
                
            // If any record is true then set as true 
            aggregatedSummary.rC_Giving__Is_Major_Giver__c = summary.rC_Giving__Is_Major_Giver__c == true ? true : aggregatedSummary.rC_Giving__Is_Major_Giver__c;  
            aggregatedSummary.rC_Giving__Is_Sustaining_Giver__c = summary.rC_Giving__Is_Sustaining_Giver__c == true ? true : aggregatedSummary.rC_Giving__Is_Sustaining_Giver__c;
            aggregatedSummary.rC_Giving__Is_Most_Recent__c = summary.rC_Giving__Is_Most_Recent__c == true ? true : aggregatedSummary.rC_Giving__Is_Most_Recent__c;
            aggregatedSummary.rC_Giving__Is_Shopper__c = summary.rC_Giving__Is_Shopper__c == true ? true : aggregatedSummary.rC_Giving__Is_Shopper__c;
            
        }
                      
        for(rC_Giving__Summary__c summary : summaryList)
            summary.rC_Giving__Entered_Currency__c = null;
                
    }
    
    public void updateOpportunities(Map<String,rC_Giving__Summary__c> aggregatedSummaryMap, rC_Giving__Summary__c[] summaryList) {
        if (summaryList == null || summaryList.size() == 0 || aggregatedSummaryMap == null || aggregatedSummaryMap.size() == 0)   	
            return;
        
        Opportunity[] OpportunityList = [
            select Id
                 , rC_Giving__Summary__c
                 , rC_Giving__Affiliation__c
              from Opportunity
             where rC_Giving__Summary__c =: summaryList
               and rC_Giving__Affiliation__c IN :aggregatedSummaryMap.keyset()   
            ];
        
        for (Opportunity opportunity :OpportunityList) {
        	rC_Giving__Summary__c aggregatedSummary = aggregatedSummaryMap.get(opportunity.rC_Giving__Affiliation__c);
        	if (aggregatedSummary.Id != null) {
                opportunity.Original_Summary__c = opportunity.rC_Giving__Summary__c;
                opportunity.rC_Giving__Summary__c = aggregatedSummary.Id;
        	}    	
        }
        
        update OpportunityList;    
            	
    }
    
    public string getQuery(){
        String query = '';
        
        for(Schema.SObjectField summaryField: FIELDSMAPVALUES){
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
                          + '    And ' + 'RecordtypeId =: RT_ANNUAL_ID'      

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
    	
    	// Summarize the value for following Fields
        summary.rC_Giving__Current_Additional_Amount__c = 0;
        summary.rC_Giving__Current_Amount__c = 0;
        summary.rC_Giving__Current_Annual_Amount__c = 0;
        summary.rC_Giving__Current_Best_Case_Amount__c = 0;
        summary.rC_Giving__Current_Closed_Amount__c = 0;
        summary.rC_Giving__Current_Hard_Credit_Count__c = 0;
        summary.rC_Giving__Current_Commit_Amount__c = 0;
        summary.rC_Giving__Current_Omitted_Amount__c = 0;
        summary.rC_Giving__Current_Pipeline_Amount__c = 0;
        summary.rC_Giving__Current_Renewal_Amount__c = 0;	
        summary.rC_Giving__Current_Shopper_Count__c = 0;	
        summary.rC_Giving__Entered_Current_Additional_Amount__c = 0;
        
        // Find Maximum value for following fields
        summary.rC_Giving__Largest_Giving_Amount__c = 0;
        summary.rC_Giving__Most_Recent_Non_Add_Giving_Date__c = null;
        summary.rC_Giving__Most_Recent_Non_Add_Payment_Date__c = null;
        summary.rC_Giving__Giving_Level_Renewable_Date__c = null;
        summary.rC_Giving__Giving_Level_Renewed_Date__c = null;
        summary.rC_Giving__Giving_Level_Lapse_Date__c = null;
        summary.rC_Giving__Giving_Level_Active_Date__c = null;
        summary.rC_Giving__Giving_Level_Expiration_Date__c = null;
        
        // Find Minimum value for follwing fields
        summary.rC_Giving__First_Giving_Date__c = null;
        summary.rC_Giving__First_Closed_Payment_Date__c = null;
        summary.rC_Giving__First_Giving_Amount__c = 0;
        
        // Find Most Recent value for following fields
        summary.rC_Giving__Giving_Level_Status__c = null;
        summary.rC_Giving__Giving_Level__c = null;
        summary.rC_Giving__Largest_Giving_Date__c = null;
        summary.rC_Giving__First_Payment_Date__c = null;
        summary.rC_Giving__Previous_Summary__c = null;
        summary.rC_Giving__Gift_Membership_Opportunity__c = null;
        summary.rC_Giving__Most_Recent_Giving_Amount__c = null;
        summary.rC_Giving__Most_Recent_Giving_Date__c = null;
        summary.rC_Giving__Entered_Current_Amount__c = 0;
        summary.rC_Giving__Entered_Current_Annual_Amount__c = 0;
        summary.rC_Giving__Entered_Current_Renewal_Amount__c = 0;
        summary.rC_Giving__Entered_First_Giving_Amount__c = 0;
        summary.rC_Giving__Entered_Largest_Giving_Amount__c = 0;
        summary.rC_Giving__Entered_Most_Recent_Giving_Amount__c = 0;
        
        // Miscellaneous Fields
        summary.rC_Giving__Current_Active_Date__c = null;
        summary.rC_Giving__Current_Year__c = null;
        summary.rC_Giving__Track__c = null;
        summary.rC_Giving__External_ID__c = null;
        summary.rC_Giving__Is_Prior__c = false;
        summary.rC_Giving__Is_Gift_Membership__c = false;
        
        summary.rC_Giving__Account__c = null;
        summary.rC_Giving__Activity_Type__c = null;
        summary.rC_Giving__Affiliation__c = null;
        //summary.rC_Giving__Channel__c = null;
        summary.rC_Giving__Is_Annual__c = null;
        summary.rC_Giving__Lifetime_Summary__c = null;
        
        // 
        //summary.rC_Giving__Type__c = null;
        summary.rC_Giving__Archive_Flag__c = null;
        summary.rC_Giving__Is_Lifetime__c = null;
        summary.rC_Giving__Is_Historical__c = null;
        //summary.rC_Giving__Title__c = null;
        
        // CSV value
        summary.rC_Giving__Entered_Currency__c = null;
        
        summary.rC_Giving__Is_Major_Giver__c = false;  
        summary.rC_Giving__Is_Sustaining_Giver__c = false;
        summary.rC_Giving__Is_Most_Recent__c = false;
        summary.rC_Giving__Is_Shopper__c = false;        
	
    }
    
}