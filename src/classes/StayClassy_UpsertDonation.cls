global class StayClassy_UpsertDonation implements rC_Messaging.MessageServicer.Servicer {
    global StayClassy_UpsertDonation() {}
    
    // Should only be called by the StayClassyServicer code.
    global virtual void processMessage(rC_Messaging__Message__c message, Dom.Document payload) {
        // Get the donations 
        StayClassy.DonationResponseList objectDataList = (StayClassy.DonationResponseList) Json.createParser(StayClassy.getEndpointResponse('/api1/donations', new Map<String, String> {
            'oid' => message.rC_Messaging__Related_Record__c
        })).readValueAs(StayClassy.DonationResponseList.class);
        
        // Any results?
        if (objectDataList.donations == null || objectDataList.donations.size() == 0) {
            throw new StayClassy.ServicerException('No results returned from StayClassy for ID: ' + message.rC_Messaging__Related_Record__c);
        }
        
        if (objectDataList.donations.size() >= 2) {
            throw new StayClassy.ServicerException('Too many results returned from StayClassy for ID: ' + message.rC_Messaging__Related_Record__c);
        }
        
        // Extract the one record
        StayClassy.Donation objectData = objectDataList.donations[0];
        
        // Try to find the opportunity by opportunity external ID
        Opportunity[] opportunityList = [
            select Id
              from Opportunity
             where StayClassy_ID__c = :message.rC_Messaging__Related_Record__c
               and StayClassy_ID__c != null
             limit 1
        ];
        
        // If the campaign is missing, create a new one
        if (opportunityList.isEmpty()) {
            opportunityList = new Opportunity[] { 
                new Opportunity(StayClassy_ID__c = message.rC_Messaging__Related_Record__c)
            };
        }
        
        // Find the parent campaign record 
        Campaign[] campaignParentList = [
            SELECT Id
              FROM Campaign
             WHERE StayClassy_ID__c = :String.valueOf(objectData.event_id)
               AND StayClassy_ID__c != null
             LIMIT 1
        ];
        
        if (campaignParentList.isEmpty()) {
            throw new StayClassy.ServicerException('Missing parent StayClassy ID: ' + objectData.event_id);
        }
        
        // Establish a savepoint
        System.Savepoint savepoint = Database.setSavepoint();
        
        try {
            // Insert a new batch upload record
            rC_Connect__Batch_Upload__c batchUpload = new rC_Connect__Batch_Upload__c();
            
            // Batch Info
            batchUpload.rC_Connect__Batch_Upload_Campaign_Matched__c = campaignParentList[0].Id;
            batchUpload.rC_Connect__Batch_Upload_Batch_Number__c = '' + objectData.order_id;
            
            // Contact / Member Info
            batchUpload.rC_Connect__Contact_1_First_Name__c  = objectData.first_name;
            batchUpload.rC_Connect__Contact_1_Last_Name__c  = objectData.last_name;
            batchUpload.rC_Connect__Contact_1_Email__c = objectData.email;
            batchUpload.rC_Connect__Contact_1_Email_Type__c = 'Home';
            batchUpload.rC_Connect__Address_Street_Line_1__c = objectData.address;
            batchUpload.rC_Connect__Address_Street_Line_2__c = objectData.address2;
            batchUpload.rC_Connect__Address_City__c = objectData.city;
            batchUpload.rC_Connect__Address_State__c = objectData.state;
            batchUpload.rC_Connect__Address_Zip__c = objectData.zip;
            batchUpload.rC_Connect__Address_Country__c = objectData.country;
            batchUpload.rC_Connect__Address_Type__c  = 'Home';
            batchUpload.rC_Connect__Preferences_1_Category__c = 'Peer to Peer';
            batchUpload.rC_Connect__Preferences_1_Subcategory__c = 'Donation';
            
            // Giving Info
            batchUpload.rC_Connect__Giving_Giving_Number__c = message.rC_Messaging__Related_Record__c;
            batchUpload.rC_Connect__Giving_Giving_Amount__c = objectData.donate_amount;
            batchUpload.rC_Connect__Giving_Close_Date__c = objectData.donation_date_time.date();
            batchUpload.rC_Connect__Giving_Close_Date_Time__c = objectData.donation_date_time;
            batchUpload.rC_Connect__Giving_Paid__c = true;
            batchUpload.rC_Connect__Giving_Transaction_Type__c = 'Payment';
            batchUpload.rC_Connect__Payment_Method_Payment_Type__c = 'Charge Card';
            
            // Giving frequency
            if (objectData.recurring_id == 0) {
                batchUpload.rC_Connect__Giving_Giving_Frequency__c = 'One Payment';
            } else {
                batchUpload.rC_Connect__Giving_Giving_Frequency__c = 'Monthly';
            }
            
            // Try to find a matching contact via the member_id field.
            Contact[] contactMemberList = [
                SELECT StayClassy_ID__c
                  FROM Contact
                 WHERE StayClassy_ID__c = :String.valueOf(objectData.member_id)
                   AND StayClassy_ID__c != null
                 LIMIT 1
            ];
            
            if (contactMemberList.isEmpty() == false) {
                batchUpload.rC_Connect__Batch_Upload_Contact_1_Matched__c = contactMemberList[0].Id;
            }
            
            // Save it
            insert batchUpload;
        } catch (System.Exception pException) {
            Database.rollback(savepoint);
            throw pException;
        }
    }
}