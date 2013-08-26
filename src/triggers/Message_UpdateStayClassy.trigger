trigger Message_UpdateStayClassy on rC_Messaging__Message__c (after insert) {
    Boolean hasLimitFutureCalls = Limits.getLimitFutureCalls() >= 1;
    Boolean hasRecord = trigger.new.size() == 1;
    Boolean hasRecordEndpoint = hasRecord && trigger.new[0].rC_Messaging__Endpoint__c != null;
    Boolean hasRecordMatching = hasRecordEndpoint && trigger.new[0].rC_Messaging__Endpoint__c.startsWith('stayclassy://');
    
    if (hasLimitFutureCalls && hasRecordMatching) {
        StayClassy.processMessageFuture(trigger.new[0].Id);
    }
}