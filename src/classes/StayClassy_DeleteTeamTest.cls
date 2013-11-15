@isTest
public class StayClassy_DeleteTeamTest {
    @IsTest
    public static void StayClassy_DeleteTeamTest1() {
        Campaign campaign = new Campaign();
        campaign.Name = 'test campaign';
        insert campaign;
        
        campaign.StayClassy_ID__c = campaign.Id;
        update campaign;
        
        rC_Messaging__Message__c message1 = new rC_Messaging__Message__c();
        message1.rC_Messaging__Endpoint__c = 'test message1';
        message1.rC_Messaging__Related_Record__c = campaign.Id;
        insert message1;
        
        system.assert(null != message1.Id, 'StayClassy_DeleteTeamTest : rC_Messaging__Message__c record insertion is failed'+message1);
        StayClassy_DeleteTeam stayClassyDeleteTeam = new StayClassy_DeleteTeam();
        stayClassyDeleteTeam.processMessage(message1, null);
    }
}