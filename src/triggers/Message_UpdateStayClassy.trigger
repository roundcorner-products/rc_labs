trigger Message_UpdateStayClassy on rC_Messaging__Message__c (after insert) {
    // Do we have enough limits
    if (Limits.getLimitFutureCalls() < 2) {
        return;
    }
    
    // Is this trigger inserting more than one record? 
    if (trigger.new.size() != 1) {
        return;
    }
    
    StayClassy.processMessageFuture(trigger.new[0].Id);
}