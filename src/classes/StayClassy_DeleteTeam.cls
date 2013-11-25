global with sharing class StayClassy_DeleteTeam implements rC_Messaging.MessageServicer.Servicer {
    global StayClassy_DeleteTeam() {}
    
    // Should only be called by the StayClassyServicer code.
    global virtual void processMessage(rC_Messaging__Message__c message, Dom.Document payload) {
        // Establish a savepoint
        System.Savepoint savepoint = Database.setSavepoint();
        
        // Try to find the campaign by campaign ID
        try {
            Campaign[] campaignList = [
                select Id
                  from Campaign
                 where StayClassy_ID__c = :message.rC_Messaging__Related_Record__c
                   and StayClassy_ID__c != null
                 limit 1
            ];
            
            if (campaignList.isEmpty() == false) {
                delete campaignList;
            }
            if (Test.isRunningTest() && StayClassy_DeleteTeamTest.throwException)
                throw new StayClassy.ServicerException('');
        } catch (System.Exception pException) {
            Database.rollback(savepoint);
            throw pException;
        }
    }
}