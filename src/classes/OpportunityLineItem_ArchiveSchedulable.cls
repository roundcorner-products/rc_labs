global class OpportunityLineItem_ArchiveSchedulable implements Schedulable {
    global void execute(SchedulableContext schedulableContext) {
        //OpportunityLineItem
        Database.executeBatch(new OpportunityLineItem_SetArchiveBatchable());
    }
    
    @IsTest
    public static void test() {
        Test.startTest();
        OpportunityLineItem_ArchiveSchedulable opportunityLineItemSchedulable = new OpportunityLineItem_ArchiveSchedulable();
        SchedulableContext SC;
        opportunityLineItemSchedulable.execute(SC);
        Test.stopTest();
    }
}