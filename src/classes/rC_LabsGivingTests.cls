public class rC_LabsGivingTests {
    // Instance properties
    public static final Decimal GIVING_LEVEL_MAJOR_DONOR_THRESHOLD = 1500;
    public static final Decimal GIVING_LEVEL_MIN = 0;
    public static final Decimal GIVING_LEVEL_INCREMENT = 1000;
    public static final Decimal GIVING_LEVEL_MAX = 3000;
    public static final Decimal OPPORTUNITY_GIVING_AMOUNT = 950;
    public static final Map<String, Schema.RecordTypeInfo> RT_MAP = Opportunity.SobjectType.getDescribe().getRecordTypeInfosByName();
    
    public rC_Giving__Giving_Level__c[] givingLevelList ;
    public Campaign campaign ;
    public Account account;
    public Opportunity opportunity;
     
    public rC_Giving__Giving_Level__c[] initializeGivingLevelList() {
        givingLevelList = new rC_Giving__Giving_Level__c[] {};
        
        for(Decimal i = GIVING_LEVEL_MIN; i < GIVING_LEVEL_MAX; i += GIVING_LEVEL_INCREMENT) {
            rC_Giving__Giving_Level__c givingLevel = new rC_Giving__Giving_Level__c();
            givingLevel.Name = 'RCSBIRD Giving Level ' + i;
            givingLevel.rC_Giving__Activity_Type__c = 'Membership';
            givingLevel.rC_Giving__Affiliation__c = 'RCSBIRD';
            givingLevel.rC_Giving__Min_Amount__c = i;
            givingLevel.rC_Giving__Max_Amount__c = i + GIVING_LEVEL_INCREMENT - 0.01;
            givingLevel.rC_Giving__Major_Donor_Level__c = givingLevel.rC_Giving__Min_Amount__c >= GIVING_LEVEL_MAJOR_DONOR_THRESHOLD;
            givingLevel.rC_Giving__Active_Months__c = '12';
            givingLevel.rC_Giving__Renewal_Months__c = '2';
            givingLevel.rC_Giving__Grace_Months__c = '2';
            givingLevelList.add(givingLevel);
        }
        
        insert givingLevelList;
        return givingLevelList;
    }
    
    public Account initializeAccount() {
        account = new Account();
        account.Name = 'RCSBIRD Account';
        account.rC_Giving__Track_Hard_Credits__c = true;
        account.rC_Giving__Track_Soft_Credits__c = true;
        account.rC_Giving__Track_Summaries__c = true;
        insert account;
        return account;
    }
      
    public Campaign initializeCampaign(Boolean isInsertable) {
        campaign = new Campaign();
        campaign.Name = 'RCSBIRD Campaign Name';
        campaign.IsActive = true;
        campaign.rC_Giving__Source_Code__c = 'RCSBIRD_TEST';
        campaign.rC_Giving__Affiliation__c = 'RCSBIRD';
        
        if (isInsertable == true)
            insert campaign;
        return campaign;
    }
    
    public rC_Giving__Giving_Level__c initializeGivingLevel(Decimal min, Decimal max) {
        rC_Giving__Giving_Level__c givingLevel = new rC_Giving__Giving_Level__c();
        givingLevel.Name = 'RCSBIRD Giving Level ' + String.valueOf(min) + ' - ' + String.valueOf(max);
        givingLevel.rC_Giving__Activity_Type__c = 'Membership';
        givingLevel.rC_Giving__Affiliation__c = 'RCSBIRD';
        givingLevel.rC_Giving__Min_Amount__c = min;
        givingLevel.rC_Giving__Max_Amount__c = max;
        givingLevel.rC_Giving__Major_Donor_Level__c = false;
        givingLevel.rC_Giving__Active_Months__c = '12';
        givingLevel.rC_Giving__Renewal_Months__c = '2';
        givingLevel.rC_Giving__Grace_Months__c = '2';
        insert givingLevel;
        return givingLevel;
    }
    
    public Opportunity initializeOpportunity(Boolean isInsertable) {
        system.assert(null != account, 'rC_LabsGivingTests.initializeOpportunity(Boolean): Precheck Failed: null == account');
        system.assert(null != account.Id, 'rC_LabsGivingTests.initializeOpportunity(Boolean): Precheck Failed: null == account.Id');
        system.assert(null != campaign, 'rC_LabsGivingTests.initializeOpportunity(Boolean): Precheck Failed: null == campaign');
        system.assert(null != campaign.Id, 'rC_LabsGivingTests.initializeOpportunity(Boolean): Precheck Failed: null == campaign.Id');

        opportunity = new Opportunity();
        opportunity.rC_Giving__Affiliation__c = 'RCSBIRD';
        opportunity.AccountId = account.Id;
        opportunity.Amount = 0;
        opportunity.CampaignId = campaign.Id;
        opportunity.CloseDate = Date.today();
        opportunity.rC_Giving__Giving_Amount__c = 100;
        opportunity.rC_Giving__Giving_Frequency__c = 'One Payment';
        opportunity.rC_Giving__Giving_Years__c = 1;
        opportunity.rC_Giving__Giving_Type_Engine__c = 'Standard';
        opportunity.rC_Giving__Payment_Frequency__c = 'One Payment';
        opportunity.RecordTypeId = rC_Giving.OpportunityRecordTypes.RT_MEMBERSHIP_ID;
        opportunity.StageName = 'Open';
        
        if (isInsertable == true)
            insert opportunity;
        return opportunity;
    }
    
    public void assertCountLifetimeSummaries(Integer expectedCount) {
        system.assert(null != account, 'rC_LabsGivingTests.assertCountLifetimeSummaries(Integer): Precheck Failed: null == account');
        system.assert(null != account.Id, 'rC_LabsGivingTests.assertCountLifetimeSummaries(Integer): Precheck Failed: null == account.Id');
        system.assert(null != expectedCount, 'rC_LabsGivingTests.assertCountLifetimeSummaries(Integer): Precheck Failed: null == expectedCount');
        
        system.assertEquals(expectedCount, [
            select count()
              from rC_Giving__Summary__c
             where rC_Giving__Account__c = :account.Id
               and RecordTypeId = :GivingSummary_SetArchiveBatchable.RT_LIFETIME_ID
        ], 'rC_LabsGivingTests.assertCountLifetimeSummaries(Integer)');
    }
    
    public void assertCountAnnualSummaries(Integer expectedCount) {
        system.assert(null != account, 'rC_GivingTests.assertCountSummaries(Integer): Precheck Failed: null == account');
        system.assert(null != account.Id, 'rC_GivingTests.assertCountSummaries(Integer): Precheck Failed: null == account.Id');
        system.assert(null != expectedCount, 'rC_GivingTests.assertCountSummaries(Integer): Precheck Failed: null == expectedCount');
        
        system.assertEquals(expectedCount, [
            select count()
              from rC_Giving__Summary__c
             where rC_Giving__Account__c = :account.Id
               and RecordTypeId = :GivingSummary_SetArchiveBatchable.RT_ANNUAL_ID
        ], 'rC_GivingTests.assertCountSummaries(Integer)');
    }
    
    public void assertCountAnnualAggregateSummaries(Integer expectedCount) {
        system.assert(null != account, 'rC_GivingTests.assertCountSummaries(Integer): Precheck Failed: null == account');
        system.assert(null != account.Id, 'rC_GivingTests.assertCountSummaries(Integer): Precheck Failed: null == account.Id');
        system.assert(null != expectedCount, 'rC_GivingTests.assertCountSummaries(Integer): Precheck Failed: null == expectedCount');
        
        system.assertEquals(expectedCount, [
            select count()
              from rC_Giving__Summary__c
             where rC_Giving__Account__c = :account.Id
               and RecordTypeId = :GivingSummary_SetArchiveBatchable.RT_ANNUAL_AGGREGATE_ID
        ], 'rC_GivingTests.assertCountSummaries(Integer)');
    }
    
    public rC_Giving__Summary__c refreshSummary(rC_Giving__Summary__c summary){
        system.assertNotEquals(null,summary);
        system.assertNotEquals(null,summary.id);
        List<String> fieldList = new List<String>{};
        fieldList.addAll( rC_Giving__Summary__c.getSobjectType().getDescribe().fields.getMap().keySet());
        
        String fieldString='';
        ID id = summary.id;
        for(Integer i=0;i<fieldList.size();i++){
            if(i==0)
                fieldString+=fieldList[i];
            else
                fieldString+=','+fieldList[i];
        }
        summary = Database.query('select '+fieldString+' from rC_Giving__Summary__c where id=:id');
        return summary;
    }
     
    public Opportunity refreshOpportunity(){
        system.assertNotEquals(null,opportunity);
        system.assertNotEquals(null,opportunity.id);
        String fieldString = sObjectGetFieldList(Schema.SobjectType.Opportunity);
        ID id = opportunity.id;
        opportunity =  Database.query('select '+fieldString+' from Opportunity where id=:id');
        return opportunity;
    }
    
    public Opportunity refreshOpportunity(Opportunity opportunity){
        system.assertNotEquals(null,opportunity);
        system.assertNotEquals(null,opportunity.id);
        String fieldString = sObjectGetFieldList(Schema.SobjectType.Opportunity);
        ID id = opportunity.id;
        opportunity =  Database.query('select '+fieldString+' from Opportunity where id=:id');
        return opportunity;
    }
    
    public rC_Giving__Summary__c refreshGivingSummary(Opportunity opportunity){
        system.assertNotEquals(null,opportunity);
        system.assertNotEquals(null,opportunity.id);
        system.assertNotEquals(null,opportunity.rC_Giving__Summary__c);
        String fieldString = sObjectGetFieldList(Schema.SobjectType.rC_Giving__Summary__c);
        ID id = opportunity.rC_Giving__Summary__c; 
        rC_Giving__Summary__c summary =  Database.query('select '+fieldString+' from rC_Giving__Summary__c where id=:id');
        return summary;
    }
    
    public rC_Giving__Summary__c[] getAggregatedGivingSummary(Account accountnew){
        system.assertNotEquals(null,accountnew);
        system.assertNotEquals(null,accountnew.id);
        String accountId = accountnew.id;
        String AggregatedId = GivingSummary_SetArchiveBatchable.RT_ANNUAL_AGGREGATE_ID;
        String fieldString = sObjectGetFieldList(Schema.SobjectType.rC_Giving__Summary__c);
        rC_Giving__Summary__c[] summaryList =  Database.query('select '+fieldString+' from rC_Giving__Summary__c where rC_Giving__Account__c =:accountId And RecordtypeId =:AggregatedId');
        return summaryList;
    } 
    
    public String sObjectGetFieldList(Schema.DescribeSObjectResult sobj){
        List<String> fieldList = new List<String>{};
        fieldList.addAll(sobj.fields.getMap().keySet());
        
        String fieldString='';

        for(Integer i=0;i<fieldList.size();i++){
            if(i==0)
                fieldString+=fieldList[i];
            else
                fieldString+=','+fieldList[i];
        }
        return fieldString;
    }
    
    public void assertEqualsSobjectFieldMatch(Sobject sObj ,Map<String,object> fieldMap){
        for(String fieldName:fieldMap.keySet()){
            system.assertEquals(fieldMap.get(fieldName),sObj.get(fieldName),'rC_GivingTests.assertEqualsOpportunityFieldMatch :'+sObj.getSObjectType()+'.'+fieldName+' check failed '+ fieldMap.get(fieldName) +' != ' + sObj.get(fieldName));
        }
    }
        
}