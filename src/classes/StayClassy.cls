global class StayClassy implements rC_Messaging.MessageServicer.Servicer {
    public class ProcessingException extends Exception {}
    
    // Org settings
    public static StayClassy__c SETTINGS {
        get {
            if (SETTINGS == null) { // get user/profile/org values
                SETTINGS = StayClassy__c.getInstance();
            }
            
            if (SETTINGS == null) { // if still null, create a blank object
                SETTINGS = new StayClassy__c();
            }
            
            return SETTINGS;
        }
    }
    
    
    // API objects
    public class CampaignResponseList {
        public String status_code;
        public StayClassy.Campaign[] campaigns;
    }
    
    public class Campaign {
        public String address;
        public String city;
        public Integer charity_id;
        public String charity_name;
        public String designation_name;
        public Integer did;
        public String end_date;
        public String event_image_large;
        public String event_image_medium;
        public String event_image_small;
        public Integer event_type_id;
        public String event_url;
        public Decimal goal;
        public Integer host_id;
        public String host_name;
        public Integer id;
        public String name;
        public Integer num_donations;
        public Integer num_donors;
        public String start_date;
        public String state;
        public Integer tickets_sold;
        public Integer total_attending;
        public Integer total_fund_pages;
        public Integer total_fund_teams;
        public Decimal total_raised;
        public Integer type_id;
        public String venue;
        public String zip;
        
        // Helpers
        public DateTime start_date_time {
            get {
                return StayClassy.getDateTime(start_date);
            }
        }
        
        public DateTime end_date_time {
            get {
                return StayClassy.getDateTime(end_date);
            }
        }
        
        public String event_type {
            get {
                return new Map<Integer, String> {
                    1 => 'Ticketed Event',
                    2 => 'Registration Event',
                    3 => 'Fundraise For Entry Event',
                    4 => 'Fundraising Campaign',
                    5 => 'Donation Page'
                }.get(event_type_id);
            }
        }
    }
    
    public class CampaignTicket {
        public Integer charity_price;
        public String end_date;
        public Integer quantity_available;
        public String start_date;
        public Integer ticket_id;
        public String ticket_name;
        public Decimal ticket_price;
        public Integer total_sold;
    }
    
    public class FundraiserResponseList {
        public String status_code;
        public StayClassy.Fundraiser[] fundraisers;
    }
    
    public class Fundraiser {
        public Integer fundraiser_campaign_id;
        public String fundraiser_url;
        public String campaign_name;
        public Integer charity_id;
        public String charity_name;
        public String designation_name;
        public Integer event_id;
        public String event_name;
        public String first_name;
        public Decimal goal;
        public String last_name;
        public String member_address;
        public String member_city;
        public String member_email;
        public Integer member_id;
        public String member_image_large;
        public String member_image_medium;
        public String member_image_small;
        public String member_name;
        public String member_state;
        public String member_zip;
        public Integer num_donors;
        public String page_title;
        public Integer project_id;
        public String project_name;
        public Integer team_id;
        public String team_name;
        public Decimal total_raised;
    }
    
    public class DonationResponseList {
        public String status_code;
        public StayClassy.Donation[] donations;
    }
    
    public class Donation {
        public String address;
        public String address2;
        public String city;
        public String country;
        public String designation_id;
        public String designation_name;
        public Decimal donate_amount;
        public String donation_date;
        public String email;
        public Integer event_id;
        public String event_name;
        public String first_name;
        public String fundraiser;
        public Integer fundraiser_id;
        public String in_honor_of;
        public String last_name;
        public Integer member_id;
        public String member_image_large;
        public String member_image_medium;
        public String member_image_small;
        public Integer order_id;
        public String payment_type;
        public Integer recurring_id;
        public String state;
        public String status;
        public String team_id;
        public String team_name;
        public String zip;

        // Helpers
        public DateTime donation_date_time {
            get {
                return StayClassy.getDateTime(donation_date);
            }
        }
    }
    
    public class TeamResponseList {
        public String status_code;
        public StayClassy.Team[] teams;
    }
    
    public class Team {
        public Integer category_id;
        public String category_name;
        public Integer charity_id;
        public String charity_name;
        public String donation_url;
        public Integer event_id;
        public String event_name;
        public String fundraising_team_id;
        public Decimal goal;
        public String join_url;
        public Integer num_donors;
        public Integer project_id;
        public String project_name;
        public String team_image_large;
        public String team_image_medium;
        public String team_image_small;
        public String team_lead_email;
        public Integer team_lead_id;
        public String team_lead_name;
        public String team_name;
        public String team_url;
        public Decimal total_raised;
    }
    
    // Helper methods
    public static String getEndpointResponse(String endpoint, Map<String, String> paramMap) {
        PageReference pageReference = new PageReference(SETTINGS.Endpoint_Url__c + endpoint);
        pageReference.getParameters().put('token', SETTINGS.Authorization_Token__c);
        pageReference.getParameters().put('cid', SETTINGS.Organization_ID__c);
        
        for(String param : paramMap.keySet()) {
            pageReference.getParameters().put(param, paramMap.get(param));
        }
        
        // Build request
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setMethod('GET');
        httpRequest.setEndpoint(pageReference.getUrl());
        httpRequest.setTimeout(60000); // 60 seconds for a callout
        
        // Send request
        String responseBody = new Http().send(httpRequest).getBody();
        
        if (responseBody == null) {
            throw new ServicerException('getEndpointResponse(): ' + pageReference.getUrl() + ': Empty response body!');
        }
        
        return responseBody;
    }
    
    // Exceptions
    global class ServicerException extends Exception {}
    
    // Constructor
    global StayClassy() {}
    
    // Main processor
    global static final Map<String, Map<String, String>> ENDPOINT_MATRIX = new Map<String, Map<String, String>> {
        'stayclassy://campaigns' => new Map<String, String> {
            'insert' => 'StayClassy_UpsertCampaign',
            'update' => 'StayClassy_UpsertCampaign',
            'delete' => 'StayClassy_DeleteCampaign'
        },
        
        'stayclassy://fundraisers' => new Map<String, String> {
            'insert' => 'StayClassy_UpsertFundraiser',
            'update' => 'StayClassy_UpsertFundraiser',
            'delete' => 'StayClassy_DeleteFundraiser'
        },
        
        'stayclassy://teams' => new Map<String, String> {
            'insert' => 'StayClassy_UpsertTeam',
            'update' => 'StayClassy_UpsertTeam',
            'delete' => 'StayClassy_DeleteTeam'
        },
        
        'stayclassy://donations' => new Map<String, String> {
            'insert' => 'StayClassy_UpsertDonation',
            'update' => 'StayClassy_UpsertDonation'
        }
    };
    
    // Scheduler
    global static void schedule() {
        rC_Messaging.MessageServicerSchedulable scheduler = new rC_Messaging.MessageServicerSchedulable('stayclassy://servicer');
        scheduler.register(new StayClassy()); 
        
        for(String endpointName : ENDPOINT_MATRIX.keySet()) {
            scheduler.registerEndpoint(endpointName);
        }
        
        scheduler.schedule();
    }
    
    @Future(callout=true)
    public static void processMessageFuture(Id messageId) {
        rC_Messaging__Message__c[] messageList = [
            select rC_Messaging__Endpoint__c
                 , rC_Messaging__Related_Method__c
                 , rC_Messaging__Related_Record__c
                 , rC_Messaging__Effective_Date__c
                 , rC_Messaging__Processed_Date__c
                 , rC_Messaging__Deletable_Date__c
                 , rC_Messaging__Deletable_Cache_Time__c
              from rC_Messaging__Message__c
             where Id = :messageId
             limit 1
        ];
        
        if (messageList.isEmpty()) {
            return;
        }
        
        try {
            new StayClassy().processMessage(messageList[0], null);
            update messageList;
        } catch (System.Exception pException) {
            rC_Messaging__Message_Error__c messageError = new rC_Messaging__Message_Error__c();
            messageError.rC_Messaging__Message__c = messageList[0].Id;
            messageError.rC_Messaging__Description__c = pException.getMessage();
            messageError.rC_Messaging__Type__c = pException.getTypeName();
            insert messageError;
        }
    }
    
    global virtual void processMessage(rC_Messaging__Message__c message, Dom.Document payload) {
        if (message == null) {
            return;
        }
        
        if (message.rC_Messaging__Endpoint__c == null) {
            return;
        }
        
        // Find the endpoint class mapping
        Map<String, String> endpointMap = ENDPOINT_MATRIX.get(message.rC_Messaging__Endpoint__c.toLowerCase().trim());
        
        if (endpointMap == null) {
            return; // no endpoint match
        }
        
        // Check the method and record
        if (message.rC_Messaging__Related_Method__c == null) {
            throw new ServicerException('Missing related method');
        }
        
        if (message.rC_Messaging__Related_Record__c == null) {
            throw new ServicerException('Missing related record');
        }
        
        // Find the endpoint class name
        String endpointTypeName = endpointMap.get(message.rC_Messaging__Related_Method__c.toLowerCase().trim());
        Type endpointType = Type.forName(endpointTypeName);
        
        if (endpointType == null) {
            throw new ServicerException('Unknown endpoint type name: ' + endpointTypeName);
        }
        
        // Process
        ((rC_Messaging.MessageServicer.Servicer) endpointType.newInstance()).processMessage(message, null);
        
        // Cleanup
        message.rC_Messaging__Processed_Date__c = addMinutes(DateTime.now(), 0);
        message.rC_Messaging__Deletable_Date__c = addMinutes(DateTime.now(), message.rC_Messaging__Deletable_Cache_Time__c);
    }
    
    public static DateTime addMinutes(DateTime base, Decimal offset) {
        return base.addMinutes(offset == null ? 0 : offset.intValue());
    }
    
    public static DateTime getDateTime(String dt) {
        if (dt == null || dt.length() == 0) {
            return null;
        }
        
        // Something like this: "2013-05-20 20:00:00"
        return DateTime.newInstance(
            Integer.valueOf(dt.substring(0, 4)),
            Integer.valueOf(dt.substring(5, 7)),
            Integer.valueOf(dt.substring(8, 10)),
            Integer.valueOf(dt.substring(11, 13)),
            Integer.valueOf(dt.substring(14, 16)),
            Integer.valueOf(dt.substring(17, 19))
        );
    }
    
    public static String getTruncated(String value, Integer maxlen) {
        return value == null || value.trim().length() <= maxlen ? value : value.substring(0, maxlen - 3) + '...';
    }
}