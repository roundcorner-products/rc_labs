public class Message_ProcessStayClassy {
	public ApexPages.StandardController controller;
    
    public Message_ProcessStayClassy(ApexPages.StandardController controller) {
        this.controller = controller;
    }
    
    public PageReference initialize() {
        rC_Messaging__Message__c[] messageList = [
            SELECT rC_Messaging__Endpoint__c
                 , rC_Messaging__Related_Method__c
                 , rC_Messaging__Related_Record__c
                 , rC_Messaging__Effective_Date__c
                 , rC_Messaging__Processed_Date__c
                 , rC_Messaging__Deletable_Date__c
                 , rC_Messaging__Deletable_Cache_Time__c
              FROM rC_Messaging__Message__c
             WHERE Id = :controller.getId()
               AND rC_Messaging__Endpoint__c LIKE 'stayclassy://%'
             LIMIT 1
        ];
        
        PageReference pageReference = new PageReference('/' + controller.getId());
        pageReference.setRedirect(true);
        
        // Any message results?
        if (messageList.isEmpty()) {
            return pageReference;
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
        
        // Return to message
        return pageReference;
    }
}