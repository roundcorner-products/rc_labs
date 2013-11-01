trigger Message_UpdateStayClassy on rC_Messaging__Message__c (after insert) {
    Boolean hasLimitFutureCalls = Limits.getLimitFutureCalls() >= 3; // for safety, at least 3 limit calls left
    Boolean hasRecord = trigger.new.size() == 1;
    Boolean hasRecordEndpoint = hasRecord && trigger.new[0].rC_Messaging__Endpoint__c != null;
    Boolean hasRecordMatching = hasRecordEndpoint && trigger.new[0].rC_Messaging__Endpoint__c.startsWith('stayclassy://');
    
    if (hasLimitFutureCalls && hasRecordMatching) {
        StayClassy.processMessageFuture(trigger.new[0].Id);
    }
}