global class StayClassy_UpsertCampaign implements rC_Messaging.MessageServicer.Servicer {
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
            upsert campaign;
        } catch (System.Exception pException) {
            Database.rollback(savepoint);
            throw pException;
        }
    }
    
    public String getEndpointResponse(String endpoint, Map<String, String> endpointParams) {
        if (Test.isRunningTest() == false) {
            return StayClassy.getEndpointResponse(endpoint, endpointParams);
        }
        
        // Return test json
        return '{'
             + '    "status_code": "SUCCESS",'
             + '    "campaigns": ['
             + '        {'
             + '            "id": 22789,'
             + '            "name": "P2P Campaign",'
             + '            "start_date": "2013-05-07 20:00:00",'
             + '            "end_date": "2013-08-31 23:00:00",'
             + '            "event_url": "http://staging.stayclassy.org/events/p2p-campaign/e22789",'
             + '            "charity_id": 10811,'
             + '            "charity_name": "roundCause Testing",'
             + '            "goal": 10000,'
             + '            "host_id": 28,'
             + '            "host_name": "Todd Crutchfield",'
             + '            "venue": "",'
             + '            "address": "",'
             + '            "city": "",'
             + '            "state": "",'
             + '            "zip": "",'
             + '            "event_image_small": "",'
             + '            "event_image_medium": "",'
             + '            "event_image_large": "",'
             + '            "event_type_id": 4,'
             + '            "total_raised": 0,'
             + '            "total_attending": null,'
             + '            "total_fund_pages": 0,'
             + '            "total_fund_teams": "1",'
             + '            "num_donations": "2",'
             + '            "num_donors": "1",'
             + '            "projects": ['
             + '                {'
             + '                    "designation_id": 11800,'
             + '                    "designation_name": "General Funds Project"'
             + '                }'
             + '            ]'
             + '        }'
             + '    ]'
             + '}';
    }
}