global class StayClassy_DeleteCampaign implements rC_Messaging.MessageServicer.Servicer {
    global StayClassy_DeleteCampaign() {}
    
    // Should only be called by the StayClassyServicer code.
    global virtual void processMessage(rC_Messaging__Message__c message, Dom.Document payload) {
        // Try to find the campaign by campaign ID
        Campaign[] campaignList = [
            select Id
              from Campaign
             where StayClassy_ID__c = :message.rC_Messaging__Related_Record__c
               and StayClassy_ID__c != null
             limit 1
        ];
        
        // Establish a savepoint
        System.Savepoint savepoint = Database.setSavepoint();
        
        try {
            if (campaignList.isEmpty() == false) {
                delete campaignList;
            }
        } catch (System.Exception pException) {
            Database.rollback(savepoint);
            throw pException;
        }
    }
}