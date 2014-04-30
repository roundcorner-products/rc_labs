public with sharing abstract class ContactTrigger {
    public Contact_Setting__c setting;
    public Contact[] contactOldList;
    public Contact[] contactNewList;
    public Map<Id, Contact> contactOldListMap = new Map<Id, Contact>();
    public Map<Id, Contact> ContactNewListMap  = new Map<Id,Contact>();
    
    public ContactTrigger(Contact[] contactOldList, Contact[] contactNewList) {
        this.contactOldList = contactOldList == null ? new Contact[] {} : contactOldList;
        this.contactNewList = contactNewList == null ? new Contact[] {} : contactNewList;
        
        if(contactOldList != null && !contactOldList.isEmpty())
            this.contactOldListMap.putAll(contactOldList);
        if(contactNewList != null && !contactNewList.isEmpty())
            this.ContactNewListMap.putAll(contactNewList);
        
        this.setting = Contact_Setting__c.getInstance();
        this.setting = this.setting == null ? new Contact_Setting__c() : this.setting;
    }
    
    public abstract Boolean getIsUpdateable(Contact contactOld, Contact contactNew);
    
    public virtual void execute() {
        Contact[] contactUpdateableList = new Contact[] {};
        
        for(Contact contactNew : contactNewList) {
            Contact contactOld = contactOldListMap.get(contactNew.Id);
            contactOld = contactOld == null ? new Contact() : contactOld;
            
            if (getIsUpdateable(contactOld, contactNew)) {
                contactUpdateableList.add(contactNew);
            }
        }
        
        if (contactUpdateableList.size() != 0) {
            execute(contactUpdateableList, trigger.IsUpdate);
        }
    }
    
    public virtual void execute(Contact[] contactList, Boolean forceUpdate) {}
}