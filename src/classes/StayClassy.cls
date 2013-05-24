global class StayClassy implements rC_Messaging.MessageServicer.Servicer {
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
    public class Campaign {
        public String campaign_image_large;
        public String campaign_image_medium;
        public String campaign_image_small;
        public String campaign_url;
        public String city;
        public Integer charity_id;
        public String charity_name;
        public String designation_name;
        public Integer did;
        public String end_date;
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
    
    public class Fundraiser {
        public String fundraiser_url;
        public String campaign_name;
        public Integer charity_id;
        public String charity_name;
        public String designation_name;
        public Integer did;
        public Integer eid;
        public Integer fcid;
        public Decimal goal;
        public String member_email;
        public String member_image_large;
        public String member_image_medium;
        public String member_image_small;
        public String member_name;
        public Integer num_donors;
        public String page_title;
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
            'insert' => 'StayClassy_InsertCampaign',
            'update' => 'StayClassy_UpdateCampaign',
            'delete' => 'StayClassy_DeleteCampaign'
        },
        
        'stayclassy://fundraisers' => new Map<String, String> {
            'insert' => 'StayClassy_InsertFundraiser',
            'update' => 'StayClassy_UpdateFundraiser',
            'delete' => 'StayClassy_DeleteFundraiser'
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