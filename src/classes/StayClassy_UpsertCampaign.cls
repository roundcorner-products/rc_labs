global class StayClassy_UpsertCampaign implements rC_Messaging.MessageServicer.Servicer {
    global StayClassy_UpsertCampaign() {}
    
    // Should only be called by the StayClassyServicer code.
    global virtual void processMessage(rC_Messaging__Message__c message, Dom.Document payload) {
        String jsonData = StayClassy.getEndpointResponse('/api1/campaign-info', new Map<String, String> {
            'eid' => message.rC_Messaging__Related_Record__c
        });
        
        StayClassy.Campaign objectData;
        
        try {
            objectData = (StayClassy.Campaign) Json.createParser(StayClassy.getEndpointResponse('/api1/campaign-info', new Map<String, String> {
                'eid' => message.rC_Messaging__Related_Record__c
            })).readValueAs(StayClassy.Campaign.class);
        } catch (System.Exception pException) {
            throw new StayClassy.ProcessingException(''
                + pException.getTypeName()
                + ': '
                + pException.getMessage() 
                + ': '
                + jsonData
            );
        }
        // Try to find the campaign by campaign ID
        Campaign[] campaignList = [
            select Id
              from Campaign
             where StayClassy_ID__c = :message.rC_Messaging__Related_Record__c
               and StayClassy_ID__c != null
             limit 1
        ];
        
        // For the update case, if the campaign is missing, block execution
        if (campaignList.isEmpty() && 'update'.equalsIgnoreCase(message.rC_Messaging__Related_Method__c)) {
            throw new StayClassy.ServicerException('Unknown StayClassy ID: ' + message.rC_Messaging__Related_Record__c);
        }
        
        // For the insert case, if the campaign is missing, create a new one
        if (campaignList.isEmpty() && 'insert'.equalsIgnoreCase(message.rC_Messaging__Related_Method__c)) {
            campaignList = new Campaign[] { 
                new Campaign(StayClassy_ID__c = message.rC_Messaging__Related_Record__c)
            };
        }
        // Establish a savepoint
        System.Savepoint savepoint = Database.setSavepoint();
        
        try {
            // Update the campaign
            Campaign campaign = campaignList[0];
            campaign.Name = StayClassy.getTruncated(objectData.name, 80);
            campaign.Type = 'StayClassy Campaign';
            campaign.StayClassy_ID__c = message.rC_Messaging__Related_Record__c;
            campaign.rC_Giving__Start_Date_Time__c = objectData.start_date_time;
            campaign.rC_Giving__End_Date_Time__c = objectData.end_date_time;
            update campaign;
        } catch (System.Exception pException) {
            Database.rollback(savepoint);
            throw pException;
        }
    }
}