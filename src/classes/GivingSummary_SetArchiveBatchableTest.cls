@isTest
public class GivingSummary_SetArchiveBatchableTest {
	@isTest
    public static void test1() {
        rC_LabsGivingTests rc = new rC_LabsGivingTests();
        rc.initializeGivingLevelList();
        
        Account account = rc.initializeAccount();
        System.assert(null != account.Id, 'GivingSummary_SetArchiveBatchableTest.test1() : Account record insertion is failed'+account);
         
        Campaign campaign = rc.initializeCampaign(true);
        System.assert(null != campaign.Id, 'GivingSummary_SetArchiveBatchableTest.test1() : Campaign record insertion is failed'+campaign);
        
        Opportunity opportunity1 = rc.initializeOpportunity(false);
        opportunity1.rC_Giving__Giving_Amount__c = 100;
        Opportunity opportunity2 = rc.initializeOpportunity(false);
        opportunity1.rC_Giving__Giving_Amount__c = 220;
        opportunity2.closedate = Date.today().addYears(-15);
        
        insert new Opportunity[]{opportunity1,opportunity2};
        System.assert(null != opportunity1.Id, 'GivingSummary_SetArchiveBatchableTest.test1() : Opportunity record insertion is failed'+opportunity1);
        System.assert(null != opportunity2.Id, 'GivingSummary_SetArchiveBatchableTest.test1() : Opportunity record insertion is failed'+opportunity2);
        
        rc.assertCountAnnualSummaries(2);      
        opportunity1 = rc.refreshOpportunity(opportunity1);   
        rC_Giving__Summary__c summary1 = rc.refreshGivingSummary(opportunity1);     
        
        opportunity2 = rc.refreshOpportunity(opportunity2);   
        rC_Giving__Summary__c summary2 = rc.refreshGivingSummary(opportunity2);
        system.assertEquals(summary1.rC_Giving__Current_Year__c,String.valueof(Date.today().year()));
         
        Test.starttest();
        Database.executeBatch(new GivingSummary_SetArchiveBatchable(1590,2113,account.Id), 100);
        Test.stoptest();
        
        rC_Giving__Summary__c[] summaryList = rc.getAggregatedGivingSummary(account);
        system.assertEquals(1,summaryList.size(),'GivingSummary_SetArchiveBatchableTest.test1() : Aggregated Summary is not created');
        
        rc.assertEqualsSobjectFieldMatch(summaryList[0], new Map<String,object> {
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
        
        rc.assertCountAnnualSummaries(0);
        
        opportunity1 = rc.refreshOpportunity(opportunity1);
        opportunity2 = rc.refreshOpportunity(opportunity2);
        
        system.assertEquals(opportunity1.rC_Giving__Summary__c,summaryList[0].Id,'GivingSummary_SetArchiveBatchableTest.test1() : Aggregated Summary is not updated to Opportunities');
        system.assertEquals(opportunity2.rC_Giving__Summary__c,summaryList[0].Id,'GivingSummary_SetArchiveBatchableTest.test1() : Aggregated Summary is not updated to Opportunities');   
        
    }
    
    //@isTest
    public static void test2() {
        rC_LabsGivingTests rc = new rC_LabsGivingTests();
        rc.initializeGivingLevelList();
        rC_Giving__Giving_Level__c givingLevel = rc.initializeGivingLevel(0, 1000);
        givingLevel.rC_Giving__Affiliation__c = 'RCSBIRD2';
        update givingLevel;
        
        Account account = rc.initializeAccount();
        System.assert(null != account.Id, 'GivingSummary_SetArchiveBatchableTest.test2() : Account record insertion is failed'+account);
         
        Campaign campaign1 = rc.initializeCampaign(false);
        campaign1.rC_Giving__Affiliation__c = 'RCSBIRD1';
        Campaign campaign2 = rc.initializeCampaign(false);
        campaign2.rC_Giving__Affiliation__c = 'RCSBIRD2';
        insert new Campaign[]{campaign1,campaign2};
        System.assert(null != campaign1.Id, 'GivingSummary_SetArchiveBatchableTest.test2() : Campaign record insertion is failed'+campaign1);
        System.assert(null != campaign2.Id, 'GivingSummary_SetArchiveBatchableTest.test2() : Campaign record insertion is failed'+campaign2);
        
        Opportunity opportunity1 = rc.initializeOpportunity(false);
        opportunity1.CampaignId = campaign1.Id;
        opportunity1.rC_Giving__Affiliation__c = 'RCSBIRD1';
        opportunity1.rC_Giving__Giving_Amount__c = 100;
        Opportunity opportunity2 = rc.initializeOpportunity(false);
        opportunity2.rC_Giving__Giving_Amount__c = 220;
        opportunity2.rC_Giving__Affiliation__c = 'RCSBIRD2';
        opportunity2.closedate = Date.today().addYears(-15);
        opportunity2.CampaignId = campaign2.Id;
        
        //insert opportunity2;
        insert new Opportunity[]{opportunity2,opportunity1};
        System.assert(null != opportunity1.Id, 'GivingSummary_SetArchiveBatchableTest.test2() : Opportunity record insertion is failed'+opportunity1);
        System.assert(null != opportunity2.Id, 'GivingSummary_SetArchiveBatchableTest.test2() : Opportunity record insertion is failed'+opportunity2);
        
        rc.assertCountAnnualSummaries(2);      
        opportunity1 = rc.refreshOpportunity(opportunity1);   
        rC_Giving__Summary__c summary1 = rc.refreshGivingSummary(opportunity1);     
        
        opportunity2 = rc.refreshOpportunity(opportunity2);   
        rC_Giving__Summary__c summary2 = rc.refreshGivingSummary(opportunity2);
        
        system.assert(summary1.rC_Giving__Giving_Level__c != summary2.rC_Giving__Giving_Level__c);
        system.assertNotEquals(summary1.rC_Giving__Affiliation__c,summary2.rC_Giving__Affiliation__c);
        //system.assertEquals(summary1.rC_Giving__Current_Year__c,String.valueof(Date.today().year()));
        system.assertEquals(summary2.rC_Giving__Current_Year__c,String.valueof(Date.today().addYears(-15).year()));
          
        Test.starttest();
        Database.executeBatch(new GivingSummary_SetArchiveBatchable(1590,2113,account.Id), 100);
        Test.stoptest();
        
        rc.assertCountAnnualSummaries(0);
        
        rC_Giving__Summary__c[] summaryList = rc.getAggregatedGivingSummary(account);
        system.assertEquals(1,summaryList.size(),'GivingSummary_SetArchiveBatchableTest.test1() : Aggregated Summary is not created');
        
        rc.assertEqualsSobjectFieldMatch(summaryList[0], new Map<String,object> {
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
        
        rc.assertCountAnnualSummaries(0);
        
        opportunity1 = rc.refreshOpportunity(opportunity1);
        opportunity2 = rc.refreshOpportunity(opportunity2);
        
        system.assertEquals(opportunity1.rC_Giving__Summary__c,summaryList[0].Id,'GivingSummary_SetArchiveBatchableTest.test1() : Aggregated Summary is not updated to Opportunities');
        system.assertEquals(opportunity2.rC_Giving__Summary__c,summaryList[0].Id,'GivingSummary_SetArchiveBatchableTest.test1() : Aggregated Summary is not updated to Opportunities');   
        
    }

}