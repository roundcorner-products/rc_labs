global class StayClassy_UpdateCampaign implements rC_Messaging.MessageServicer.Servicer {
    global StayClassy_UpdateCampaign() {}
    
    // Should only be called by the StayClassyServicer code.
    global virtual void processMessage(rC_Messaging__Message__c message, Dom.Document payload) {
        String externalId = message.rC_Messaging__Related_Record__c;
        
        // Send/Get the data
        String jsonData = StayClassy.getEndpointResponse('/api1/campaign-info', new Map<String, String> {
            'eid' => externalId
        });
        
        // Parse the data
        StayClassy.Campaign objectData = (StayClassy.Campaign) Json.createParser(jsonData).readValueAs(StayClassy.Campaign.class);
        
        // Try to find the campaign by campaign ID
        Campaign[] campaignList = [
            select Id
              from Campaign
             where rC_Giving__External_ID__c = :'stayclassy-' + externalId
             limit 1
        ];
        
        if (campaignList.isEmpty()) {
            throw new StayClassy.ServicerException('Unknown campaign external ID: stayclassy-' + externalId);
        }
        
        // Update the campaign
        Campaign campaign = campaignList[0];
        campaign.Name = StayClassy.getTruncated(objectData.name, 80);
        campaign.rC_Giving__Start_Date_Time__c = objectData.start_date_time;
        campaign.rC_Giving__End_Date_Time__c = objectData.end_date_time;
        update campaign;
        
        // Save the json data as an attachment for review
        Attachment attachment = new Attachment();
        attachment.ParentId = campaign.Id;
        attachment.Name = 'StayClassy_UpdateCampaign: Message.Id#' + message.Id;
        attachment.ContentType = 'application/json';
        attachment.Body = Blob.valueOf(jsonData);
        insert attachment;
    }
}