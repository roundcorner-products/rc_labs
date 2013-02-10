@IsTest
public class OpportunityLineItem_DelArchivedBatchTest {
    @IsTest(SeeAllData = true)
    public static void OpportunityLineItem_DelArchivedBatchable_test() {
        Account account = new Account();
        account.name = 'Account Name';
        account.rC_Giving__Lifetime_Is_Major_Giver__c = false;
        insert account;
        
        System.assert(null != account.Id, 'OpportunityLineItem_DelArchivedBatchTest.OpportunityLineItem_DelArchivedBatchable_test() : Account record insertion is failed'+account);
        
        Campaign campaign = new Campaign(Name = 'Campaign Name');
        insert campaign;
        
        System.assert(null != campaign.Id, 'OpportunityLineItem_DelArchivedBatchTest.OpportunityLineItem_DelArchivedBatchable_test() : Campaign record insertion is failed'+campaign);
        
        Opportunity opportunity = new Opportunity();
        opportunity.AccountId = account.Id;
        opportunity.CampaignId = campaign.Id;
        opportunity.Name = 'Opportunity Name';
        opportunity.StageName = 'Closed';
        opportunity.CloseDate = Date.today();
        opportunity.rC_Giving__Archive_Flag__c = true;
        opportunity.rC_Giving__Giving_Amount__c = 10;
        opportunity.rC_Giving__Giving_Frequency__c = 'One Payment';
        opportunity.rC_Giving__Payment_Frequency__c = 'One Payment';
        insert opportunity;
        
        System.assert(null != opportunity.Id, 'OpportunityLineItem_DelArchivedBatchTest.OpportunityLineItem_DelArchivedBatchable_test() : Opportunity record insertion is failed'+opportunity);
        
        Pricebook2 pricebookStandard = [
            select Id
              from Pricebook2
             where IsStandard = true
             limit 1
        ];
         
        Product2 product1 = new Product2();
        product1.Name = 'RCSBIRD Product1';
        product1.ProductCode = 'TEST1';
        product1.Family = null;
        product1.rC_Inventory__Check_Inventory_Levels__c = false;
        insert product1;
        
        System.assert(null != product1.Id, 'OpportunityLineItem_DelArchivedBatchTest.OpportunityLineItem_DelArchivedBatchable_test() : Product record insertion is failed'+product1);
        
        // Add to the standard pricebook
        PricebookEntry stdPricebookEntry1 = new PricebookEntry();
        stdPricebookEntry1.Pricebook2Id = pricebookStandard.Id;
        stdPricebookEntry1.Product2Id = product1.Id;
        stdPricebookEntry1.UnitPrice = 10;
        stdPricebookEntry1.UseStandardPrice = false;
        stdPricebookEntry1.IsActive = true;
        insert stdPricebookEntry1;
        
        System.assert(null != stdPricebookEntry1.Id, 'OpportunityLineItem_DelArchivedBatchTest.OpportunityLineItem_DelArchivedBatchable_test() : PriceBookEntry record insertion is failed'+stdPricebookEntry1);
        
        OpportunityLineItem opportunityLineItem = new OpportunityLineItem();
        opportunityLineItem.OpportunityId = opportunity.Id;
        opportunityLineItem.PricebookEntryId = stdPricebookEntry1.Id;
        opportunityLineItem.Quantity = 1;
        opportunityLineItem.UnitPrice = 10;
        opportunityLineItem.rC_Giving__Archive_Flag__c = true;
        insert opportunityLineItem;
        
        System.assert(null != opportunityLineItem.Id, 'OpportunityLineItem_DelArchivedBatchTest.OpportunityLineItem_DelArchivedBatchable_test() : OpportunityLineItem record insertion is failed'+opportunityLineItem);
        
        Test.startTest();
        System.assert(true, Database.executeBatch(new OpportunityLineItem_DelArchivedBatchable(), 1) != null);
        Test.stopTest();
        System.assertEquals(0, [select Id from OpportunityLineItem where Id =: opportunityLineItem.Id].size(), 'OpportunityLineItem_DelArchivedBatchTest.OpportunityLineItem_DelArchivedBatchable_test() : OpportunityLineItem record deletion failed');
    }
}