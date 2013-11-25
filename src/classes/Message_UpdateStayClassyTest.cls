@isTest
public class Message_UpdateStayClassyTest {
    @isTest
    public static void Message_UpdateStayClassyTest_1() {
        Test.startTest();
        rC_Messaging__Message__c message = new rC_Messaging__Message__c();
        message.rC_Messaging__Endpoint__c = 'stayclassy://fundraisers';
        message.rC_Messaging__Related_Method__c = 'insert';
        message.rC_Messaging__Related_Record__c = '000002';
        message.rC_Messaging__Effective_Date__c = DateTime.now();
        insert message;
        Test.stopTest();
    }
}