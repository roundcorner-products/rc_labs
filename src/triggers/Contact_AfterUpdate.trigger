trigger Contact_AfterUpdate on Contact (after update) {
    new Contact_UpdateContactAddressFromAPI(trigger.old, trigger.new).execute();
}