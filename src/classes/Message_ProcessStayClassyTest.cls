@isTest
public class Message_ProcessStayClassyTest {
    @IsTest
    public static void Message_ProcessStayClassyTest1() {
        Test.startTest();
        rC_Messaging__Message__c message1 = new rC_Messaging__Message__c();
        message1.rC_Messaging__Endpoint__c = 'test message1';
        insert message1;
        
        system.assert(null != message1.Id, 'Message_ProcessStayClassyTest : rC_Messaging__Message__c record insertion is failed'+message1);
        Message_ProcessStayClassy messageProcessStayClassy1 = new Message_ProcessStayClassy(new ApexPages.StandardController(message1));
        messageProcessStayClassy1.initialize();
        Test.stopTest();
    }
    
    @IsTest
    public static void Message_ProcessStayClassyTest2() {
        Test.startTest();
        rC_Messaging__Message__c message2 = new rC_Messaging__Message__c();
        message2.rC_Messaging__Endpoint__c = 'stayclassy:// test message2';
        insert message2;
        
        system.assert(null != message2.Id, 'Message_ProcessStayClassyTest : rC_Messaging__Message__c record insertion is failed'+message2);
        Message_ProcessStayClassy messageProcessStayClassy2 = new Message_ProcessStayClassy(new ApexPages.StandardController(message2));
        messageProcessStayClassy2.initialize();
        Test.stopTest();
    }
    
    @IsTest
    public static void Message_ProcessStayClassyTest3() {
        Test.startTest();
        rC_Messaging__Message__c message = new rC_Messaging__Message__c();
        message.rC_Messaging__Endpoint__c = 'stayclassy://fundraisers';
        insert message;
        
        system.assert(null != message.Id, 'Message_ProcessStayClassyTest : rC_Messaging__Message__c record insertion is failed'+message);
        Message_ProcessStayClassy messageProcessStayClassy = new Message_ProcessStayClassy(new ApexPages.StandardController(message));
        messageProcessStayClassy.initialize();
        Test.stopTest();
    }
    
}