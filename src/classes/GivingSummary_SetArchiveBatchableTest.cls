@isTest
public class GivingSummary_SetArchiveBatchableTest {
    @isTest
    public static void test1() {
        rC_Giving__Giving_Level__c[] givingLevelList = new rC_Giving__Giving_Level__c[] {};
        
        for(Decimal i = 0; i < 3000; i += 1000) {
            rC_Giving__Giving_Level__c givingLevel = new rC_Giving__Giving_Level__c();
            givingLevel.Name = 'RCSBIRD Giving Level ' + i;
            givingLevel.rC_Giving__Activity_Type__c = 'Membership';
            givingLevel.rC_Giving__Affiliation__c = 'RCSBIRD';
            givingLevel.rC_Giving__Min_Amount__c = i;
            givingLevel.rC_Giving__Max_Amount__c = i + 1000 - 0.01;
            givingLevel.rC_Giving__Major_Donor_Level__c = givingLevel.rC_Giving__Min_Amount__c >= 1500;
            givingLevel.rC_Giving__Active_Months__c = '12';
            givingLevel.rC_Giving__Renewal_Months__c = '2';
            givingLevel.rC_Giving__Grace_Months__c = '2';
            givingLevelList.add(givingLevel);
        }
        
        insert givingLevelList;
        
        Account account = new Account();
        account.Name = 'RCSBIRD Account';
        account.rC_Giving__Track_Hard_Credits__c = true;
        account.rC_Giving__Track_Soft_Credits__c = true;
        account.rC_Giving__Track_Summaries__c = true;
        insert account;
        System.assert(null != account.Id, 'GivingSummary_SetArchiveBatchableTest.test1() : Account record insertion is failed'+account);
         
        Campaign campaign = new Campaign();
        campaign.Name = 'RCSBIRD Campaign Name';
        campaign.IsActive = true;
        campaign.rC_Giving__Source_Code__c = 'RCSBIRD_TEST';
        campaign.rC_Giving__Affiliation__c = 'RCSBIRD';
        insert campaign;
        System.assert(null != campaign.Id, 'GivingSummary_SetArchiveBatchableTest.test1() : Campaign record insertion is failed'+campaign);
        
        Opportunity opportunity1 = new Opportunity();
        opportunity1.rC_Giving__Affiliation__c = 'RCSBIRD';
        opportunity1.AccountId = account.Id;
        opportunity1.Amount = 0;
        opportunity1.CampaignId = campaign.Id;
        opportunity1.CloseDate = Date.today();
        opportunity1.rC_Giving__Giving_Amount__c = 220;
        opportunity1.rC_Giving__Giving_Frequency__c = 'One Payment';
        opportunity1.rC_Giving__Giving_Years__c = 1;
        opportunity1.rC_Giving__Giving_Type_Engine__c = 'Standard';
        opportunity1.rC_Giving__Payment_Frequency__c = 'One Payment';
        opportunity1.RecordTypeId = rC_Giving.OpportunityRecordTypes.RT_MEMBERSHIP_ID;
        opportunity1.StageName = 'Open';
        
        Opportunity opportunity2 = new Opportunity();
        opportunity2.rC_Giving__Affiliation__c = 'RCSBIRD';
        opportunity2.AccountId = account.Id;
        opportunity2.Amount = 0;
        opportunity2.CampaignId = campaign.Id;
        opportunity2.CloseDate = Date.today().addYears(-15);
        opportunity2.rC_Giving__Giving_Amount__c = 100;
        opportunity2.rC_Giving__Giving_Frequency__c = 'One Payment';
        opportunity2.rC_Giving__Giving_Years__c = 1;
        opportunity2.rC_Giving__Giving_Type_Engine__c = 'Standard';
        opportunity2.rC_Giving__Payment_Frequency__c = 'One Payment';
        opportunity2.RecordTypeId = rC_Giving.OpportunityRecordTypes.RT_MEMBERSHIP_ID;
        opportunity2.StageName = 'Open';
        
        insert new Opportunity[]{opportunity1,opportunity2};
        System.assert(null != opportunity1.Id, 'GivingSummary_SetArchiveBatchableTest.test1() : Opportunity record insertion is failed'+opportunity1);
        System.assert(null != opportunity2.Id, 'GivingSummary_SetArchiveBatchableTest.test1() : Opportunity record insertion is failed'+opportunity2);
        
        system.assertEquals(2, [
            select count()
              from rC_Giving__Summary__c
             where rC_Giving__Account__c = :account.Id
               and RecordTypeId = :GivingSummary_SetArchiveBatchable.RT_ANNUAL_ID
        ], 'GivingSummary_SetArchiveBatchableTest.test1() : Invalid Count of Summaries');
        
        String fieldString = sObjectGetFieldList(Schema.SobjectType.Opportunity);
        ID id = opportunity1.id;
        opportunity1 =  Database.query('select '+fieldString+' from Opportunity where id=:id');
        
        id = opportunity2.id;
        opportunity2 =  Database.query('select '+fieldString+' from Opportunity where id=:id');
        
        fieldString = sObjectGetFieldList(Schema.SobjectType.rC_Giving__Summary__c);
        id = opportunity1.rC_Giving__Summary__c; 
        rC_Giving__Summary__c summary1 =  Database.query('select '+fieldString+' from rC_Giving__Summary__c where id=:id');
        
        id = opportunity2.rC_Giving__Summary__c; 
        rC_Giving__Summary__c summary2 =  Database.query('select '+fieldString+' from rC_Giving__Summary__c where id=:id');
        
        system.assertEquals(summary1.rC_Giving__Current_Year__c,String.valueof(Date.today().year()));
        
        Test.starttest();
        Database.executeBatch(new GivingSummary_SetArchiveBatchable(1590,2113,account.Id), 100);
        Test.stoptest();
        
        String accountId = account.id;
        String AggregatedId = GivingSummary_SetArchiveBatchable.RT_ANNUAL_AGGREGATE_ID;
        fieldString = sObjectGetFieldList(Schema.SobjectType.rC_Giving__Summary__c);
        rC_Giving__Summary__c[] summaryList =  Database.query('select '+fieldString+' from rC_Giving__Summary__c where rC_Giving__Account__c =:accountId And RecordtypeId =:AggregatedId');
        
        system.assertEquals(1,summaryList.size(),'GivingSummary_SetArchiveBatchableTest.test1() : Aggregated Summary is not created');
        
        assertEqualsSobjectFieldMatch(summaryList[0], new Map<String,object> {
            'rC_Giving__Current_Additional_Amount__c' => 0,
            'rC_Giving__Current_Amount__c' => 320,
            'rC_Giving__Current_Annual_Amount__c' => 0,
            'rC_Giving__Current_Best_Case_Amount__c' => 0,
            'rC_Giving__Current_Closed_Amount__c' => 0,
            'rC_Giving__Current_Commit_Amount__c' => 0,
            'rC_Giving__Current_Hard_Credit_Count__c' => 2,
            'rC_Giving__Current_Omitted_Amount__c' => 0,
            'rC_Giving__Current_Pipeline_Amount__c' => 320,
            'rC_Giving__Current_Renewal_Amount__c' => 320,
            'rC_Giving__Current_Shopper_Count__c' => 0,
            'rC_Giving__Entered_Current_Additional_Amount__c' => 0,
            'rC_Giving__Largest_Giving_Amount__c' => 220,
            'rC_Giving__Most_Recent_Non_Add_Giving_Date__c' => Date.today(),
            'rC_Giving__Most_Recent_Non_Add_Payment_Date__c' => null, 
            'rC_Giving__Giving_Level_Renewable_Date__c' => Date.today().addMonths(10),
            'rC_Giving__Giving_Level_Renewed_Date__c' => Date.today(),
            'rC_Giving__Giving_Level_Lapse_Date__c' => Date.today().addMonths(14).addDays(-1),
            'rC_Giving__Giving_Level_Active_Date__c' => Date.today(),
            'rC_Giving__Giving_Level_Expiration_Date__c' => Date.today().addMonths(12).addDays(-1),
            'rC_Giving__First_Giving_Date__c' => Date.today().addyears(-15),
            'rC_Giving__First_Closed_Payment_Date__c' => null,
            'rC_Giving__Giving_Level_Status__c' => 'Active',
            'rC_Giving__Largest_Giving_Date__c' => Date.today(),
            'rC_Giving__First_Payment_Date__c' => Date.today(),
            'rC_Giving__Gift_Membership_Opportunity__c' => null,
            'rC_Giving__Most_Recent_Giving_Amount__c' => 220,
            'rC_Giving__Most_Recent_Giving_Date__c' => Date.today(),
            'rC_Giving__Entered_Current_Amount__c' => 0,
            'rC_Giving__Entered_Current_Renewal_Amount__c' => 0,
            'rC_Giving__Entered_Current_Annual_Amount__c' => 0,
            'rC_Giving__Entered_First_Giving_Amount__c' => 0,
            'rC_Giving__Entered_Largest_Giving_Amount__c' => 0,
            'rC_Giving__Entered_Most_Recent_Giving_Amount__c' => 0,
            'rC_Giving__Archive_Flag__c' => false,
            'rC_Giving__Is_Lifetime__c' => false,
            'rC_Giving__Is_Historical__c' => true,
            'rC_Giving__Account__c' => account.Id,
            'rC_Giving__Activity_Type__c' => 'Membership',
            'rC_Giving__Affiliation__c' => 'RCSBIRD',
            'rC_Giving__Lifetime_Summary__c' => summary1.rC_Giving__Lifetime_Summary__c,
            'rC_Giving__Historical_Year__c' => '1590 To 2113',
            'rC_Giving__Entered_Currency__c' => null,
            'rC_Giving__Is_Major_Giver__c' => false,
            'rC_Giving__Is_Sustaining_Giver__c' => false,
            'rC_Giving__Is_Most_Recent__c' => true,
            'rC_Giving__Is_Shopper__c' => false
                         
        });
        
        system.assertEquals(0, [
            select count()
              from rC_Giving__Summary__c
             where rC_Giving__Account__c = :account.Id
               and RecordTypeId = :GivingSummary_SetArchiveBatchable.RT_ANNUAL_ID
        ], 'GivingSummary_SetArchiveBatchableTest.test1() : Invalid Count of Summaries');
        
        fieldString = sObjectGetFieldList(Schema.SobjectType.Opportunity);
        id = opportunity1.id;
        opportunity1 =  Database.query('select '+fieldString+' from Opportunity where id=:id');
        
        id = opportunity2.id;
        opportunity2 =  Database.query('select '+fieldString+' from Opportunity where id=:id');
        
        system.assertEquals(opportunity1.rC_Giving__Summary__c,summaryList[0].Id,'GivingSummary_SetArchiveBatchableTest.test1() : Aggregated Summary is not updated to Opportunities');
        system.assertEquals(opportunity2.rC_Giving__Summary__c,summaryList[0].Id,'GivingSummary_SetArchiveBatchableTest.test1() : Aggregated Summary is not updated to Opportunities');
    }
    
    public static String sObjectGetFieldList(Schema.DescribeSObjectResult sobj){
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
    
    public static void assertEqualsSobjectFieldMatch(Sobject sObj ,Map<String,object> fieldMap){
        for(String fieldName:fieldMap.keySet()){
            system.assertEquals(fieldMap.get(fieldName),sObj.get(fieldName),'rC_GivingTests.assertEqualsOpportunityFieldMatch :'+sObj.getSObjectType()+'.'+fieldName+' check failed '+ fieldMap.get(fieldName) +' != ' + sObj.get(fieldName));
        }
    }

}