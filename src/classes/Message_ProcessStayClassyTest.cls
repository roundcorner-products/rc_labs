@isTest
public class Message_ProcessStayClassyTest {
    @IsTest
    public static void Message_ProcessStayClassyTest1() {
        rC_Messaging__Message__c message1 = new rC_Messaging__Message__c();
        message1.rC_Messaging__Endpoint__c = 'test message1';
        insert message1;
        
        system.assert(null != message1.Id, 'Message_ProcessStayClassyTest : rC_Messaging__Message__c record insertion is failed'+message1);
        Message_ProcessStayClassy messageProcessStayClassy1 = new Message_ProcessStayClassy(new ApexPages.StandardController(message1));
        messageProcessStayClassy1.initialize();
    }
    
    @IsTest
    public static void Message_ProcessStayClassyTest2() {
        rC_Messaging__Message__c message2 = new rC_Messaging__Message__c();
        message2.rC_Messaging__Endpoint__c = 'stayclassy:// test message2';
        insert message2;
        
        system.assert(null != message2.Id, 'Message_ProcessStayClassyTest : rC_Messaging__Message__c record insertion is failed'+message2);
        Message_ProcessStayClassy messageProcessStayClassy2 = new Message_ProcessStayClassy(new ApexPages.StandardController(message2));
        messageProcessStayClassy2.initialize();
    }
}