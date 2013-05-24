global class StayClassy_DeleteCampaign implements rC_Messaging.MessageServicer.Servicer {
    global StayClassy_DeleteCampaign() {}
    
    // Should only be called by the StayClassyServicer code.
    global virtual void processMessage(rC_Messaging__Message__c message, Dom.Document payload) {
        // Try to find the campaign by campaign ID
        Campaign[] campaignList = [
            select Id
              from Campaign
             where rC_Giving__External_ID__c = :'stayclassy-' + message.rC_Messaging__Related_Record__c
             limit 1
        ];
        
        if (campaignList.isEmpty() == false) {
            delete campaignList;
        }
    }
}