trigger Contact_AfterInsert on Contact (after insert) {
    new Contact_UpdateContactAddressFromAPI(trigger.old, trigger.new).execute();
}