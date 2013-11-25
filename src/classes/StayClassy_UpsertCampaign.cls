global with sharing class StayClassy_UpsertCampaign implements rC_Messaging.MessageServicer.Servicer {
    global StayClassy_UpsertCampaign() {}
    
    // Should only be called by the StayClassyServicer code.
    global virtual void processMessage(rC_Messaging__Message__c message, Dom.Document payload) {
        // Get the donations 
        StayClassy.CampaignResponseList objectDataList = (StayClassy.CampaignResponseList) Json.createParser(StayClassy.getEndpointResponse('/api1/campaigns', new Map<String, String> {
            'eid' => message.rC_Messaging__Related_Record__c
        })).readValueAs(StayClassy.CampaignResponseList.class);
        
        // Any results?
        if (objectDataList.campaigns == null || objectDataList.campaigns.size() == 0) {
            throw new StayClassy.ServicerException('No results returned from StayClassy for ID: ' + message.rC_Messaging__Related_Record__c);
        }
        
        if (objectDataList.campaigns.size() >= 2) {
            throw new StayClassy.ServicerException('Too many results returned from StayClassy for ID: ' + message.rC_Messaging__Related_Record__c);
        }
        
        // Extract the one record
        StayClassy.Campaign objectData = objectDataList.campaigns[0];
        
        // Try to find the campaign by campaign ID
        Campaign[] campaignList = [
            SELECT Id
              FROM Campaign
             WHERE StayClassy_ID__c = :message.rC_Messaging__Related_Record__c
               AND StayClassy_ID__c != null
             LIMIT 1
               FOR UPDATE
        ];
        
        // If the campaign is missing, create a new one
        if (campaignList.isEmpty()) {
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
            campaign.StartDate = objectData.start_date_time.date();
            campaign.EndDate = objectData.end_date_time.date();
            campaign.ExpectedRevenue = objectData.goal;
            campaign.Subtype__c = objectData.event_type;
            campaign.rC_Giving__Start_Date_Time__c = objectData.start_date_time;
            campaign.rC_Giving__End_Date_Time__c = objectData.end_date_time;
            upsert campaign; 
        } catch (System.Exception pException) {
            Database.rollback(savepoint);
            throw pException;
        }
    }
}