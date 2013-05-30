global class StayClassy_UpsertFundraiser implements rC_Messaging.MessageServicer.Servicer {
    global StayClassy_UpsertFundraiser() {}
    
    // Should only be called by the StayClassyServicer code.
    global virtual void processMessage(rC_Messaging__Message__c message, Dom.Document payload) {
        // Get the fundraiser 
        StayClassy.Fundraiser objectData = (StayClassy.Fundraiser) Json.createParser(StayClassy.getEndpointResponse('/api1/fundraiser-info', new Map<String, String> {
            'fcid' => message.rC_Messaging__Related_Record__c
        })).readValueAs(StayClassy.Fundraiser.class);
        
        // Validations
        if (objectData.page_title == null || objectData.page_title == '') {
            message.rC_Messaging__Effective_Date__c = DateTime.now().addMinutes(15);
            throw new StayClassy.ServicerException('StayClassy fundraiser page is missing a page title!');
        }
        
        // Get the fundraiser team
        StayClassy.Team objectTeamData = (StayClassy.Team) Json.createParser(StayClassy.getEndpointResponse('/api1/team-info', new Map<String, String> {
            'ftid' => String.valueOf(objectData.team_id)
        })).readValueAs(StayClassy.Team.class);
        
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
            campaign.Name = StayClassy.getTruncated(objectData.page_title, 80);
            campaign.Type = 'StayClassy Fundraiser';
            campaign.StayClassy_ID__c = message.rC_Messaging__Related_Record__c;
            upsert campaign; // @todo - add other data
            
            // Insert a new batch upload record
            rC_Connect__Batch_Upload__c batchUpload = new rC_Connect__Batch_Upload__c();
            batchUpload.rC_Connect__Batch_Upload_Campaign_Matched__c = campaign.Id;
            // ?? batchUpload.rC_Connect__Exclude_Giving__c = true;
            batchUpload.rC_Connect__Contact_1_First_Name__c  = objectData.first_name;
            batchUpload.rC_Connect__Contact_1_Last_Name__c  = objectData.last_name;
            batchUpload.rC_Connect__Contact_1_Email__c = objectData.member_email;
            batchUpload.rC_Connect__Contact_1_Email_Type__c = 'Home';
            batchUpload.rC_Connect__Address_Street_Line_1__c = objectData.member_address;
            batchUpload.rC_Connect__Address_Street_Line_2__c = null;
            batchUpload.rC_Connect__Address_City__c = objectData.member_city;
            batchUpload.rC_Connect__Address_State__c = objectData.member_state;
            batchUpload.rC_Connect__Address_Zip__c = objectData.member_zip;
            batchUpload.rC_Connect__Address_Country__c = null;
            batchUpload.rC_Connect__Address_Type__c  = 'Home';
            batchUpload.rC_Connect__Preferences_1_Category__c = 'Peer to Peer';
            batchUpload.rC_Connect__Preferences_1_Subcategory__c = 'Fundraiser';
            
            // Try to find a matching contact via the member_id field.
            Contact[] contactMemberList = [
                select StayClassy_ID__c
                  from Contact
                 where StayClassy_ID__c = :String.valueOf(objectData.member_id)
                   and StayClassy_ID__c != null
                 limit 1
            ];
            
            if (contactMemberList.isEmpty() == false) {
                batchUpload.rC_Connect__Batch_Upload_Contact_1_Matched__c = contactMemberList[0].Id;
            }
            
            // Is the fundraiser member ID the same as the team lead member ID or not?
            if (objectData.member_id == objectTeamData.team_lead_id) {
                batchUpload.rC_Connect__Preferences_1_Category__c = 'Peer to Peer';
                batchUpload.rC_Connect__Preferences_1_Subcategory__c = 'Team Lead';
            } else { 
                batchUpload.rC_Connect__Preferences_1_Category__c = 'Peer to Peer';
                batchUpload.rC_Connect__Preferences_1_Subcategory__c = 'Team Member';
            }
            
            // Save it
            insert batchUpload;
        } catch (System.Exception pException) {
            Database.rollback(savepoint);
            throw pException;
        }
    }
}