global with sharing class StayClassy_UpsertFundraiser implements rC_Messaging.MessageServicer.Servicer {
    global StayClassy_UpsertFundraiser() {}
    
    // Should only be called by the StayClassyServicer code.
    global virtual void processMessage(rC_Messaging__Message__c message, Dom.Document payload) {
        StayClassy.FundraiserResponseList objectDataList = (StayClassy.FundraiserResponseList) Json.createParser(StayClassy.getEndpointResponse('/api1/fundraisers', new Map<String, String> {
            'fcid' => message.rC_Messaging__Related_Record__c
        })).readValueAs(StayClassy.FundraiserResponseList.class);
        
        // Any results?
        if (objectDataList.fundraisers == null || objectDataList.fundraisers.size() == 0) {
            throw new StayClassy.ServicerException('No results returned from StayClassy for ID: ' + message.rC_Messaging__Related_Record__c);
        }
        
        if (objectDataList.fundraisers.size() >= 2) {
            throw new StayClassy.ServicerException('Too many results returned from StayClassy for ID: ' + message.rC_Messaging__Related_Record__c);
        }
        
        // Extract the one record
        StayClassy.Fundraiser objectData = objectDataList.fundraisers[0];
        
        // Validations
        if (objectData.page_title == null || objectData.page_title == '') {
            message.rC_Messaging__Effective_Date__c = DateTime.now().addMinutes(15);
            throw new StayClassy.ServicerException('StayClassy fundraiser page is missing a page title!');
        }
        
        // Get the fundraiser team
        StayClassy.TeamResponseList objectTeamDataList = (StayClassy.TeamResponseList) Json.createParser(StayClassy.getEndpointResponse('/api1/teams', new Map<String, String> {
            'ftid' => String.valueOf(objectData.team_id)
        })).readValueAs(StayClassy.TeamResponseList.class);
        
        // Extract the one record
        StayClassy.Team objectTeamData = null;
        
        if (objectTeamDataList != null && objectTeamDataList.teams != null && objectTeamDataList.teams.isEmpty() == false) {
            objectTeamData = objectTeamDataList.teams[0];
        }
        
        // Find the 
        Integer parentId = (objectData.team_id == 0 || objectData.team_id == null) ? objectData.event_id : objectData.team_id;
        // Find the parent campaign record 
        Campaign[] campaignParentList = [
            select Id
              from Campaign
             where StayClassy_ID__c = :String.valueOf(parentId)
               and StayClassy_ID__c != null
             limit 1
        ];
        
        // The parent is required
        if (campaignParentList.isEmpty()) {
            throw new StayClassy.ServicerException('Missing parent StayClassy ID: ' + parentId);
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
        
        // Establish a savepoint
        System.Savepoint savepoint = Database.setSavepoint();
        
        try {
            // Upsert a campaign
            Campaign campaign = campaignList[0];
            campaign.Name = StayClassy.getTruncated(objectData.page_title, 80);
            campaign.Type = 'StayClassy Fundraiser';
            campaign.StayClassy_ID__c = message.rC_Messaging__Related_Record__c;
            campaign.ParentId = campaignParentList[0].Id;
            campaign.ExpectedRevenue = objectData.goal;
            campaign.StayClassy_Member_ID__c = String.valueOf(objectData.member_id);
            upsert campaign; // @todo - add other data
            
            // Insert a new batch upload record
            rC_Connect__Batch_Upload__c batchUpload = new rC_Connect__Batch_Upload__c();
            batchUpload.rC_Connect__Batch_Upload_Campaign_Matched__c = campaign.Id;
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
            batchUpload.rC_Connect__Exclude_Giving__c = true;
            
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
            
            // If record has a Team ID, is the fundraiser member ID the same as the team lead member ID or not?
            if (objectData.team_id!=0)  
            { if (objectData.member_id == objectTeamData.team_lead_id) {
                batchUpload.rC_Connect__Preferences_1_Category__c = 'Peer to Peer';
                batchUpload.rC_Connect__Preferences_1_Subcategory__c = 'Team Lead';
            } else { 
                batchUpload.rC_Connect__Preferences_1_Category__c = 'Peer to Peer';
                batchUpload.rC_Connect__Preferences_1_Subcategory__c = 'Team Member';
            } 
            } else { 
                batchUpload.rC_Connect__Preferences_1_Category__c = 'Peer to Peer';
                batchUpload.rC_Connect__Preferences_1_Subcategory__c = 'Fundraiser';
            } 
            
            // Save it
            insert batchUpload;
        } catch (System.Exception pException) {
            Database.rollback(savepoint);
            throw pException;
        }
    }
}