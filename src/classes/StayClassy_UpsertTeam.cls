global class StayClassy_UpsertTeam implements rC_Messaging.MessageServicer.Servicer {
    global StayClassy_UpsertTeam() {}
    
    // Should only be called by the StayClassyServicer code.
    global virtual void processMessage(rC_Messaging__Message__c message, Dom.Document payload) {
        StayClassy.TeamResponseList objectDataList = (StayClassy.TeamResponseList) Json.createParser(StayClassy.getEndpointResponse('/api1/teams', new Map<String, String> {
            'ftid' => message.rC_Messaging__Related_Record__c
        })).readValueAs(StayClassy.TeamResponseList.class);
        
        // Any results?
        if (objectDataList.teams == null || objectDataList.teams.size() == 0) {
            throw new StayClassy.ServicerException('No results returned from StayClassy for ID: ' + message.rC_Messaging__Related_Record__c);
        }
        
        if (objectDataList.teams.size() >= 2) {
            throw new StayClassy.ServicerException('Too many results returned from StayClassy for ID: ' + message.rC_Messaging__Related_Record__c);
        }
        
        // Extract the one record
        StayClassy.Team objectData = objectDataList.teams[0];
        
        // Validations
        if (objectData.team_name == null || objectData.team_name == '') {
            message.rC_Messaging__Effective_Date__c = DateTime.now().addMinutes(15);
            throw new StayClassy.ServicerException('StayClassy fundraiser page is missing a page title!');
        }
        
        // Try to find the campaign by campaign ID
        Campaign[] campaignList = [
            select Id
              from Campaign
             where StayClassy_ID__c = :message.rC_Messaging__Related_Record__c
               and StayClassy_ID__c != null
             limit 1
        ];
        
        // If the campaign is missing, create a new one
        if (campaignList.isEmpty()) {
            campaignList = new Campaign[] { 
                new Campaign(StayClassy_ID__c = message.rC_Messaging__Related_Record__c)
            };
        }
        // Find the parent campaign record 
        Campaign[] campaignParentList = [
            select Id
              from Campaign
             where StayClassy_ID__c = :String.valueOf(objectData.event_id)
               and StayClassy_ID__c != null
             limit 1
        ];
        
        if (campaignParentList.isEmpty()) {
            throw new StayClassy.ServicerException('Missing parent StayClassy ID: ' + objectData.event_id);
        }
        
        // Establish a savepoint
        System.Savepoint savepoint = Database.setSavepoint();
        
        try {
            // Upsert a campaign
            Campaign campaign = campaignList[0];
            campaign.ParentId = campaignParentList[0].Id;
            campaign.Name = StayClassy.getTruncated(objectData.team_name, 80);
            campaign.Type = 'StayClassy Team';
            campaign.StayClassy_ID__c = message.rC_Messaging__Related_Record__c;
            upsert campaign; // @todo - add other data
        } catch (System.Exception pException) {
            Database.rollback(savepoint);
            throw pException;
        }
    }
}