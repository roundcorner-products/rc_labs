@isTest
public class Task_DeleteArchivedBatchableTest {
    @isTest
    public static void test() {
        Account account = new Account();
        account.name = 'Account Name';
        account.rC_Giving__Lifetime_Is_Major_Giver__c = false;
        insert account;
        
        System.assert(null != account.Id, 'Task_DeleteArchivedBatchableTest.test() : Account record insertion is failed'+account);
        
        Task task = new Task();
        task.OwnerId = system.Userinfo.getUserId();
        task.WhatId = account.Id;
        task.Subject = 'Email';
        task.Status = 'Completed';
        task.ActivityDate =  Date.today().addYears(-3);
        task.Priority = 'Normal';
        task.rC_Bios__Archive_Flag__c = true;
        insert task;
        
        System.assert(null != task.Id, 'Task_DeleteArchivedBatchableTest.test() : Task record insertion is failed'+task);
        
        Test.startTest();
        System.assert(true, Database.executeBatch(new Task_DeleteArchivedBatchable(), 1) != null);
        Test.stopTest();
        System.assertEquals(0, [select Id from Task where Id =: task.Id].size(), 'Task_DeleteArchivedBatchableTest.test() : Task record deletion failed');
    }
}