@IsTest
public with sharing class OpportunityLineItem_DelArchivedSchedTest {
    @IsTest
    public static void OpportunityLineItem_DelArchivSchedulable_test() {
        Test.startTest();
        OpportunityLineItem_DelArchivSchedulable opportunityLineItemSchedulable = new OpportunityLineItem_DelArchivSchedulable();
        SchedulableContext SC;
        opportunityLineItemSchedulable.execute(SC);
        Test.stopTest();
    }
}