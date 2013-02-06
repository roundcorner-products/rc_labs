@isTest
public class Preference_DeleteArchivedSchedulableTest {
    @isTest
    public static void test() {
        Test.startTest();
        Preference_DeleteArchivedSchedulable preferenceSchedulable = new Preference_DeleteArchivedSchedulable();
        SchedulableContext SC;
        preferenceSchedulable.execute(SC);
        Test.stopTest();
    }
}