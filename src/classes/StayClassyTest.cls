@IsTest
public class StayClassyTest {
    @IsTest
    public static void testCampaign_Insert() {
        rC_Messaging__Message__c message = new rC_Messaging__Message__c();
        message.rC_Messaging__Endpoint__c = 'stayclassy://campaigns';
        message.rC_Messaging__Related_Method__c = 'insert';
        message.rC_Messaging__Related_Record__c = '000000';
        message.rC_Messaging__Effective_Date__c = DateTime.now();
        insert message;
        
        // @todo
    }
}