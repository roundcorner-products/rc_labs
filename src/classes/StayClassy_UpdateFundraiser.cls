global class StayClassy_UpdateFundraiser implements rC_Messaging.MessageServicer.Servicer {
    global StayClassy_UpdateFundraiser() {}
    
    // Should only be called by the StayClassyServicer code.
    global virtual void processMessage(rC_Messaging__Message__c message, Dom.Document payload) {
        // Send/Get the data
        String jsonData = StayClassy.getEndpointResponse('/api1/campaign-info', new Map<String, String> {
            'fcid' => message.rC_Messaging__Related_Record__c
        });
        
        // Parse the data
        StayClassy.Fundraiser objectData = (StayClassy.Fundraiser) Json.createParser(jsonData).readValueAs(StayClassy.Fundraiser.class);
        
        // Try to find the campaign by campaign ID
        Campaign[] campaignList = [
            select Id
              from Campaign
             where rC_Giving__External_ID__c = :'stayclassy-' + objectData.fcid
             limit 1
        ];
        
        if (campaignList.isEmpty()) {
            throw new StayClassy.ServicerException('Unknown campaign external ID: stayclassy-' + objectData.fcid);
        }
        
        // Update the campaign
        Campaign campaign = campaignList[0];
        campaign.Name = StayClassy.getTruncated(objectData.page_title, 80);
        update campaign;
    }
}