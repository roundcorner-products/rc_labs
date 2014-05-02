public class Contact_UpdateContactAddressFromAPI extends ContactTrigger {
    public Contact_UpdateContactAddressFromAPI(Contact[] contactOldList, Contact[] contactNewList) {
        super(contactOldList, contactNewList);
    }
    
    public override Boolean getIsUpdateable(Contact contactOld, Contact contactNew) {
        if (setting.Disable_UpdateContactAddressFromAPI__c == true) {
            return false;
        }
        
        if(trigger.isInsert) {
            return (contactNew.API_Address_Street_Line_1__c != null 
                 || contactNew.API_Address_Street_Line_2__c != null 
                 || contactNew.API_Address_City__c != null 
                 || contactNew.API_Address_Country__c != null 
                 || contactNew.API_Address_PostalCode__c != null 
                 || contactNew.API_Address_State__c != null);
        }
        
        if(trigger.isUpdate) {
            return (contactOld.API_Address_Street_Line_1__c != contactNew.API_Address_Street_Line_1__c 
                 || contactOld.API_Address_Street_Line_2__c != contactNew.API_Address_Street_Line_2__c 
                 || contactOld.API_Address_City__c != contactNew.API_Address_City__c 
                 || contactOld.API_Address_Country__c != contactNew.API_Address_Country__c 
                 || contactOld.API_Address_PostalCode__c != contactNew.API_Address_PostalCode__c
                 || contactOld.API_Address_State__c != contactNew.API_Address_State__c );
        }
        
        return false;
    }
    
    public override void execute(Contact[] contactList, Boolean doUpdate) {
        if (contactList == null || contactList.size() == 0) {
            return;
        }
        
        rC_Bios__Contact_Address__c[] contactAddressInsertList = new rC_Bios__Contact_Address__c[] {};
        rC_Bios__Contact_Address__c[] contactAddressUpdateList = new rC_Bios__Contact_Address__c[] {};
        system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>  contactList '+contactList);
        
        If(doUpdate == false) {
            for(Contact contactNew : contactList) {
                rC_Bios__Contact_Address__c contactAddress = new rC_Bios__Contact_Address__c();
                contactAddress.rC_Bios__Contact__c = contactNew.Id;
                contactAddress.rC_Bios__Original_Street_Line_1__c = contactNew.API_Address_Street_Line_1__c;
                contactAddress.rC_Bios__Original_Street_Line_2__c = contactNew.API_Address_Street_Line_2__c;
                contactAddress.rC_Bios__Original_City__c = contactNew.API_Address_City__c;
                contactAddress.rC_Bios__Original_State__c = contactNew.API_Address_State__c;
                contactAddress.rC_Bios__Original_Country__c = contactNew.API_Address_Country__c;
                contactAddress.rC_Bios__Original_Postal_Code__c = contactNew.API_Address_PostalCode__c;
                if(contactNew.API_Address_Type__c == null || contactNew.API_Address_Type__c == '') {
                    contactAddress.rC_Bios__Type__c = 'Home';
                } else {
                    contactAddress.rC_Bios__Type__c = contactNew.API_Address_Type__c;
                }
                contactAddress.rC_Bios__Preferred_Other__c = true;
                contactAddress.rC_Bios__Preferred_Mailing__c = true;
                contactAddressInsertList.add(contactAddress);
            }
        }
        
        If(doUpdate == true) {
            Set <Id> contactIdSet = contactOldListMap.keyset();
            Contact[] contactWithAddressList =  [ SELECT c.Id, 
                                                    (SELECT rC_Bios__Contact__c
                                                          , rC_Bios__Original_City__c
                                                          , rC_Bios__Original_Country__c
                                                          , rC_Bios__Original_Postal_Code__c
                                                          , rC_Bios__Original_State__c
                                                          , rC_Bios__Original_Street_Line_1__c
                                                          , rC_Bios__Original_Street_Line_2__c
                                                          , rC_Bios__Preferred_Mailing__c
                                                          , rC_Bios__Preferred_Other__c
                                                          , rC_Bios__Seasonal_End_Date__c
                                                          , rC_Bios__Seasonal_Start_Date__c
                                                          , rC_Bios__Type__c 
                                                       FROM rC_Bios__Contact_Addresses__r
                                                      WHERE rC_Bios__Type__c = 'Home') 
                                                       FROM Contact c
                                                      WHERE c.Id in :contactIdSet
                                                   ORDER BY c.LastModifiedDate 
                                                ];
                                                
            system.debug('>>>>>>>>>>>>>>>>>>>>  contactWithAddressList  ' +contactWithAddressList);
            
            for(Contact contactNew : contactWithAddressList) {
                rC_Bios__Contact_Address__c[] contactAddressList = contactNew.rC_Bios__Contact_Addresses__r;
                system.debug('>>>>>>>>>>>>>>>>>>>>  contactAddressList  ' +contactWithAddressList);
                system.debug('>>>>>>>>>>>>>>>>>>>>  contactNew while update ' +contactNew);
                rC_Bios__Contact_Address__c[] contactAddressPreferredList = new rC_Bios__Contact_Address__c[] {};
                rC_Bios__Contact_Address__c[] contactAddressSeasonalFieldsBlankList = new rC_Bios__Contact_Address__c[] {};
                rC_Bios__Contact_Address__c[] allContactAddressList = new rC_Bios__Contact_Address__c[] {};
                
                if(contactAddressList.size() != 0 ) {
                    for(rC_Bios__Contact_Address__c contactAddress : contactAddressList) {
                        if(contactAddress.rC_Bios__Preferred_Mailing__c == true  ) {
                            contactAddressPreferredList.add(contactAddress);
                        }
                        if(contactAddress.rC_Bios__Seasonal_Start_Date__c == null && contactAddress.rC_Bios__Seasonal_End_Date__c == null) {
                            contactAddressSeasonalFieldsBlankList.add(contactAddress);
                        }
                        allContactAddressList.add(contactAddress);
                    }
                    
                    if(contactAddressPreferredList != null && contactAddressPreferredList.size() != 0 && contactAddressPreferredList.size() == 1) {
                        contactAddressUpdateList.add(contactAddressPreferredList[0]);
                    } else if (contactAddressSeasonalFieldsBlankList != null && contactAddressSeasonalFieldsBlankList.size() != 0 && contactAddressSeasonalFieldsBlankList.size() == 1) {
                        contactAddressUpdateList.add(contactAddressSeasonalFieldsBlankList[0]);
                    } else if(allContactAddressList != null && allContactAddressList.size() != 0) {
                        contactAddressUpdateList.add(allContactAddressList[0]);
                    }
                } else {
                    execute(contactList, false);
                }
            }
        }
        
        
        If(contactAddressInsertList != null && contactAddressInsertList.size() != 0 ) {
            system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>  contactAddressInsertList '+contactAddressInsertList);
            insert(contactAddressInsertList);
        }
        
        If(contactAddressUpdateList != null && contactAddressUpdateList.size() != 0 ) {
            system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>  contactAddressUpdateList '+contactAddressUpdateList);
            Contact newContact;
            for(rC_Bios__Contact_Address__c contactAddress : contactAddressUpdateList) {
                newContact = ContactNewListMap.get(contactAddress.rC_Bios__Contact__c);
                system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>  newContact '+newContact);
                
                contactAddress.rC_Bios__Original_Street_Line_1__c = newContact.API_Address_Street_Line_1__c;
                contactAddress.rC_Bios__Original_Street_Line_2__c = newContact.API_Address_Street_Line_2__c;
                contactAddress.rC_Bios__Original_State__c = newContact.API_Address_State__c;
                contactAddress.rC_Bios__Original_City__c = newContact.API_Address_City__c;
                contactAddress.rC_Bios__Original_Country__c = newContact.API_Address_Country__c;
                contactAddress.rC_Bios__Original_Postal_Code__c = newContact.API_Address_PostalCode__c;
                if(newContact.API_Address_Type__c == null || newContact.API_Address_Type__c == '') {
                    contactAddress.rC_Bios__Type__c = 'Home';
                } else {
                    contactAddress.rC_Bios__Type__c = newContact.API_Address_Type__c;
                }
                contactAddress.rC_Bios__Preferred_Other__c = true;
                contactAddress.rC_Bios__Preferred_Mailing__c = true;
            }
            
            update(contactAddressUpdateList);
        }
        
    }
}