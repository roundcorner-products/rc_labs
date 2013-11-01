global class StayClassy_UpsertCampaign implements rC_Messaging.MessageServicer.Servicer {
    global StayClassy_UpsertCampaign() {}
    
    // Should only be called by the StayClassyServicer code.
    global virtual void processMessage(rC_Messaging__Message__c message, Dom.Document payload) {
        // Get the donations 
        StayClassy.CampaignResponseList objectDataList = (StayClassy.CampaignResponseList) Json.createParser(getEndpointResponse('/api1/campaigns', new Map<String, String> {
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
    
    public String getEndpointResponse(String endpoint, Map<String, String> endpointParams) {
        if (Test.isRunningTest() == false) {
            return StayClassy.getEndpointResponse(endpoint, endpointParams);
        }
        
        StayClassy.CampaignResponseList recordList = new StayClassy.CampaignResponseList();
        recordList.status_code = 'SUCCESS';
        recordList.campaigns = new StayClassy.Campaign[] {};
        
        StayClassy.Campaign record = new StayClassy.Campaign();
        record.id = 22000;
        record.name = 'TEST Campaign';
        record.start_date = '2013-05-07 00:00:00';
        record.start_date = '2013-12-01 00:00:00';
        recordList.campaigns.add(record);
        
        return Json.serialize(recordList);
        
        /*
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
         */
    }
}