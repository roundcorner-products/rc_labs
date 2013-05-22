global class StayClassy_InsertCampaign implements rC_Messaging.MessageServicer.Servicer {
    global StayClassy_InsertCampaign() {}
    
    // Should only be called by the StayClassyServicer code.
    global virtual void processMessage(rC_Messaging__Message__c message, Dom.Document payload) {
        // Send/Get the data
        String jsonData = StayClassy.getEndpointResponse('/api1/campaign-info', new Map<String, String> {
            'eid' => message.rC_Messaging__Related_Record__c
        });
        
        // Parse the data
        StayClassy.Campaign campaignData = getAsCampaign(jsonData);
        
        // Insert a new campaign
        Campaign campaign = new Campaign();
        campaign.Name = campaignData.name;
        insert campaign; // @todo - add other data
    }
    
    public StayClassy.Campaign getAsCampaign(String jsonData) {
        try {
            return (StayClassy.Campaign) Json.createParser(jsonData).readValueAs(StayClassy.Campaign.class);
        } catch (System.Exception pException) {
            throw new StayClassy.ServicerException(''
                + pException.getTypeName()
                + ': '
                + pException.getMessage()
                + ': jsonData = '
                + jsonData
            );
        }
        
        return null;
    }
}