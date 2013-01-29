@isTest
public class Task_SetArchiveBatchableTest {
    @isTest
    public static void test() {
        Account account = new Account();
        account.name = 'Account Name';
        account.rC_Giving__Lifetime_Is_Major_Giver__c = false;
        insert account;
        
        System.assert(null != account.Id, 'Task_SetArchiveBatchableTest.test() : Account record insertion is failed'+account);
        
        Task task = new Task();
        task.OwnerId = system.Userinfo.getUserId();
        task.WhatId = account.Id;
        task.Subject = 'Email';
        task.Status = 'Completed';
        task.ActivityDate = Date.today();
        task.Priority = 'Normal';
        insert task;
        
        System.assert(null != task.Id, 'Task_SetArchiveBatchableTest.test() : Task record insertion is failed'+task);
        
        Test.startTest();
        System.assert(true, Database.executeBatch(new Task_SetArchiveBatchable(), 1) != null);
        Test.stopTest();
    }
}