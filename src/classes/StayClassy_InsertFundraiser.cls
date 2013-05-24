global class StayClassy_InsertFundraiser implements rC_Messaging.MessageServicer.Servicer {
    global StayClassy_InsertFundraiser() {}
    
    // Should only be called by the StayClassyServicer code.
    global virtual void processMessage(rC_Messaging__Message__c message, Dom.Document payload) {
        // Send/Get the data
        String jsonData = StayClassy.getEndpointResponse('/api1/fundraiser-info', new Map<String, String> {
            'fcid' => message.rC_Messaging__Related_Record__c
        });
        
        // Parse the data
        StayClassy.Fundraiser objectData = (StayClassy.Fundraiser) Json.createParser(jsonData).readValueAs(StayClassy.Fundraiser.class);
        
        // Find the parent campaign record 
        Campaign[] campaignParentList = [
            select Id
              from Campaign
             where rC_Giving__External_ID__c = :'stayclassy-' + objectData.eid
             limit 1
        ];
        
        if (campaignParentList.isEmpty()) {
            throw new StayClassy.ServicerException('Missing parent campaign ID: stayclassy-' + objectData.eid);
        }
        
        // Insert a new campaign
        Campaign campaign = new Campaign();
        campaign.ParentId = campaignParentList[0].Id;
        campaign.Name = StayClassy.getTruncated(objectData.page_title, 80);
        campaign.rC_Giving__External_ID__c = 'stayclassy-' + objectData.eid;
        insert campaign; // @todo - add other data
    }
}