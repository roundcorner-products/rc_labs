@isTest
public class Contact_UpdateContactAddressFromAPITest {
    @isTest
    public static void test_ContactInsertCreateContactAddress()  {
        Contact contact = new Contact();
        contact.LastName = 'Ceciley sheron';
        contact.API_Address_Street_Line_1__c = '29 b, Croford Market';
        contact.API_Address_Street_Line_2__c = 'Park street';
        contact.API_Address_Country__c = 'USA';
        contact.API_Address_PostalCode__c = '2365';
        contact.API_Address_State__c = 'SA';
        contact.API_Address_City__c = 'Idaho';
        contact.API_Address_Type__c = 'Work';
        
        Test.startTest(); 
               
        insert(contact);
        
        rC_Bios__Contact_Address__c[] contactAddressList = [ 
            SELECT rC_Bios__Postal_Code__c
                 , rC_Bios__Original_Street_Line_2__c
                 , rC_Bios__Original_Street_Line_1__c
                 , rC_Bios__Original_State__c
                 , rC_Bios__Original_Postal_Code__c
                 , rC_Bios__Original_Country__c
                 , rC_Bios__Original_City__c
                 , rC_Bios__Contact__c 
                 , rC_Bios__Preferred_Mailing__c
                 , rC_Bios__Preferred_Other__c
                 , rC_Bios__Type__c
              FROM rC_Bios__Contact_Address__c
             WHERE rC_Bios__Contact__c = : contact.Id
        ];
        
        System.assertEquals(1, contactAddressList.size(), 'test_ContactInsertCreateContactAddress : Failed to create Contact_Address record ');
        System.assertEquals(true, contactAddressList[0].rC_Bios__Preferred_Mailing__c, 'test_ContactInsertCreateContactAddress : Failed to set Preferred Mailing true ');
        System.assertEquals(true, contactAddressList[0].rC_Bios__Preferred_Other__c, 'test_ContactInsertCreateContactAddress : Failed to set Preferred Other true ');
        System.assertEquals(contact.API_Address_Street_Line_1__c , contactAddressList[0].rC_Bios__Original_Street_Line_1__c, 'test_ContactInsertCreateContactAddress : Failed to set rC_Bios__Original_Street_Line_1__c ');
        System.assertEquals(contact.API_Address_Street_Line_2__c , contactAddressList[0].rC_Bios__Original_Street_Line_2__c, 'test_ContactInsertCreateContactAddress : Failed to set rC_Bios__Original_Street_Line_2__c ');
        System.assertEquals(contact.API_Address_City__c , contactAddressList[0].rC_Bios__Original_City__c, 'test_ContactInsertCreateContactAddress : Failed to set rC_Bios__Original_City__c ');
        System.assertEquals(contact.API_Address_Country__c, contactAddressList[0].rC_Bios__Original_Country__c, 'test_ContactInsertCreateContactAddress : Failed to set rC_Bios__Original_Country__c ');
        System.assertEquals(contact.API_Address_State__c , contactAddressList[0].rC_Bios__Original_State__c, 'test_ContactInsertCreateContactAddress : Failed to set rC_Bios__Original_State__c ');
        System.assertEquals(contact.API_Address_PostalCode__c , contactAddressList[0].rC_Bios__Original_Postal_Code__c, 'test_ContactInsertCreateContactAddress : Failed to set rC_Bios__Original_Postal_Code__c ');
        System.assertEquals(contact.API_Address_Type__c, contactAddressList[0].rC_Bios__Type__c   , 'test_ContactInsertCreateContactAddress : Failed to set rC_Bios__Type ');
        
        Test.stopTest();
    }
    
    @isTest
    public static void test_ContactUpdateHomePreferredMailingContactAddress()  {
        Contact contact = new Contact();
        contact.LastName = 'Ceciley sheron';
        insert(contact);
        
        rC_Bios__Contact_Address__c contactAddress1 = new rC_Bios__Contact_Address__c();
        contactAddress1.rC_Bios__Contact__c = contact.id;
        contactAddress1.rC_Bios__Original_Street_Line_1__c = 'Lane 3, Walker\'s street ';
        contactAddress1.rC_Bios__Original_State__c = 'PA';
        contactAddress1.rC_Bios__Original_Country__c = 'UK';
        contactAddress1.rC_Bios__Original_City__c = 'Albama';
        contactAddress1.rC_Bios__Type__c = 'Home';
        contactAddress1.rC_Bios__Preferred_Mailing__c = true;
        insert contactAddress1;
        
        rC_Bios__Contact_Address__c contactAddress2 = new rC_Bios__Contact_Address__c();
        contactAddress2.rC_Bios__Contact__c = contact.id;
        contactAddress2.rC_Bios__Original_Street_Line_1__c = 'Lane 5, Wallstreet park ';
        contactAddress2.rC_Bios__Original_State__c = 'SA';
        contactAddress2.rC_Bios__Original_Country__c = 'US';
        contactAddress2.rC_Bios__Original_City__c = 'Ohayo';
        contactAddress2.rC_Bios__Type__c = 'Home';
        contactAddress2.rC_Bios__Preferred_Mailing__c = false;
        insert contactAddress2;
        
        contact.API_Address_Street_Line_1__c = '29 b, Croford Market';
        contact.API_Address_Street_Line_2__c = 'Park street';
        contact.API_Address_Country__c = 'USA';
        contact.API_Address_PostalCode__c = '2365';
        contact.API_Address_State__c = 'SA';
        contact.API_Address_City__c = 'Idaho';
        contact.API_Address_Type__c = '';
        
        Test.startTest(); 
               
        update(contact);
        
        rC_Bios__Contact_Address__c[] contactAddressList = [ 
            SELECT rC_Bios__Postal_Code__c
                 , rC_Bios__Original_Street_Line_2__c
                 , rC_Bios__Original_Street_Line_1__c
                 , rC_Bios__Original_State__c
                 , rC_Bios__Original_Postal_Code__c
                 , rC_Bios__Original_Country__c
                 , rC_Bios__Original_City__c
                 , rC_Bios__Contact__c 
                 , rC_Bios__Preferred_Mailing__c
                 , rC_Bios__Preferred_Other__c
                 , rC_Bios__Type__c
              FROM rC_Bios__Contact_Address__c
             WHERE rC_Bios__Contact__c = : contact.Id
               AND Id = :contactAddress1.Id
        ];
        
        System.assertEquals(1, contactAddressList.size(), 'test_ContactUpdateHomePreferredMailingContactAddress : Failed to get updated Contact_Address record ');
        System.assertEquals(true, contactAddressList[0].rC_Bios__Preferred_Mailing__c, 'test_ContactUpdateHomePreferredMailingContactAddress : Failed to set Preferred Mailing true ');
        System.assertEquals(true, contactAddressList[0].rC_Bios__Preferred_Other__c, 'test_ContactUpdateHomePreferredMailingContactAddress : Failed to set Preferred Other true ');
        System.assertEquals(contact.API_Address_Street_Line_1__c , contactAddressList[0].rC_Bios__Original_Street_Line_1__c, 'test_ContactUpdateHomePreferredMailingContactAddress : Failed to set rC_Bios__Original_Street_Line_1__c ');
        System.assertEquals(contact.API_Address_Street_Line_2__c , contactAddressList[0].rC_Bios__Original_Street_Line_2__c, 'test_ContactUpdateHomePreferredMailingContactAddress : Failed to set rC_Bios__Original_Street_Line_2__c ');
        System.assertEquals(contact.API_Address_City__c , contactAddressList[0].rC_Bios__Original_City__c, 'test_ContactUpdateHomePreferredMailingContactAddress : Failed to set rC_Bios__Original_City__c ');
        System.assertEquals(contact.API_Address_Country__c, contactAddressList[0].rC_Bios__Original_Country__c, 'test_ContactUpdateHomePreferredMailingContactAddress : Failed to set rC_Bios__Original_Country__c ');
        System.assertEquals(contact.API_Address_State__c , contactAddressList[0].rC_Bios__Original_State__c, 'test_ContactUpdateHomePreferredMailingContactAddress : Failed to set rC_Bios__Original_State__c ');
        System.assertEquals(contact.API_Address_PostalCode__c , contactAddressList[0].rC_Bios__Original_Postal_Code__c, 'test_ContactUpdateHomePreferredMailingContactAddress : Failed to set rC_Bios__Original_Postal_Code__c ');
        System.assertEquals('Home', contactAddressList[0].rC_Bios__Type__c   , 'test_ContactUpdateHomePreferredMailingContactAddress : Failed to set rC_Bios__Type ');
        
        Test.stopTest();
    }
    
    @isTest
    public static void test_ContactUpdateNonePreferredMailingContactAddress()  {
        Contact contact = new Contact();
        contact.LastName = 'Ceciley sheron';
        insert(contact);
        
        rC_Bios__Contact_Address__c contactAddress1 = new rC_Bios__Contact_Address__c();
        contactAddress1.rC_Bios__Contact__c = contact.id;
        contactAddress1.rC_Bios__Original_Street_Line_1__c = 'Lane 3, Walker\'s street ';
        contactAddress1.rC_Bios__Original_State__c = 'PA';
        contactAddress1.rC_Bios__Original_Country__c = 'UK';
        contactAddress1.rC_Bios__Original_City__c = 'Albama';
        contactAddress1.rC_Bios__Type__c = 'Home';
        contactAddress1.rC_Bios__Preferred_Mailing__c = false;
        insert contactAddress1;
        
        rC_Bios__Contact_Address__c contactAddress2 = new rC_Bios__Contact_Address__c();
        contactAddress2.rC_Bios__Contact__c = contact.id;
        contactAddress2.rC_Bios__Original_Street_Line_1__c = 'Lane 5, Wallstreet park ';
        contactAddress2.rC_Bios__Original_State__c = 'SA';
        contactAddress2.rC_Bios__Original_Country__c = 'US';
        contactAddress2.rC_Bios__Original_City__c = 'Ohayo';
        contactAddress2.rC_Bios__Type__c = 'Home';
        contactAddress2.rC_Bios__Preferred_Mailing__c = false;
        contactAddress1.rC_Bios__Seasonal_End_Month__c = '05' ;
        contactAddress1.rC_Bios__Seasonal_End_Day__c = '14';
        contactAddress1.rC_Bios__Seasonal_Start_Month__c = '03';
        contactAddress1.rC_Bios__Seasonal_Start_Day__c = '08';
        insert contactAddress2;
        
        contact.API_Address_Street_Line_1__c = '29 b, Croford Market';
        contact.API_Address_Street_Line_2__c = 'Park street';
        contact.API_Address_Country__c = 'USA';
        contact.API_Address_PostalCode__c = '2365';
        contact.API_Address_State__c = 'SA';
        contact.API_Address_City__c = 'Idaho';
        contact.API_Address_Type__c = '';
        
        Test.startTest(); 
               
        update(contact);
        
        rC_Bios__Contact_Address__c[] contactAddressList = [ 
            SELECT rC_Bios__Postal_Code__c
                 , rC_Bios__Original_Street_Line_2__c
                 , rC_Bios__Original_Street_Line_1__c
                 , rC_Bios__Original_State__c
                 , rC_Bios__Original_Postal_Code__c
                 , rC_Bios__Original_Country__c
                 , rC_Bios__Original_City__c
                 , rC_Bios__Contact__c 
                 , rC_Bios__Preferred_Mailing__c
                 , rC_Bios__Preferred_Other__c
                 , rC_Bios__Type__c
              FROM rC_Bios__Contact_Address__c
             WHERE rC_Bios__Contact__c = : contact.Id
               AND Id = :contactAddress1.Id
        ];
        
        System.assertEquals(1, contactAddressList.size(), 'test_ContactUpdateNonePreferredMailingContactAddress : Failed to get updated Contact_Address record ');
        System.assertEquals(true, contactAddressList[0].rC_Bios__Preferred_Mailing__c, 'test_ContactUpdateNonePreferredMailingContactAddress : Failed to set Preferred Mailing true ');
        System.assertEquals(true, contactAddressList[0].rC_Bios__Preferred_Other__c, 'test_ContactUpdateNonePreferredMailingContactAddress : Failed to set Preferred Other true ');
        System.assertEquals(contact.API_Address_Street_Line_1__c , contactAddressList[0].rC_Bios__Original_Street_Line_1__c, 'test_ContactUpdateNonePreferredMailingContactAddress : Failed to set rC_Bios__Original_Street_Line_1__c ');
        System.assertEquals(contact.API_Address_Street_Line_2__c , contactAddressList[0].rC_Bios__Original_Street_Line_2__c, 'test_ContactUpdateNonePreferredMailingContactAddress : Failed to set rC_Bios__Original_Street_Line_2__c ');
        System.assertEquals(contact.API_Address_City__c , contactAddressList[0].rC_Bios__Original_City__c, 'test_ContactUpdateNonePreferredMailingContactAddress : Failed to set rC_Bios__Original_City__c ');
        System.assertEquals(contact.API_Address_Country__c, contactAddressList[0].rC_Bios__Original_Country__c, 'test_ContactUpdateNonePreferredMailingContactAddress : Failed to set rC_Bios__Original_Country__c ');
        System.assertEquals(contact.API_Address_State__c , contactAddressList[0].rC_Bios__Original_State__c, 'test_ContactUpdateNonePreferredMailingContactAddress : Failed to set rC_Bios__Original_State__c ');
        System.assertEquals(contact.API_Address_PostalCode__c , contactAddressList[0].rC_Bios__Original_Postal_Code__c, 'test_ContactUpdateNonePreferredMailingContactAddress : Failed to set rC_Bios__Original_Postal_Code__c ');
        System.assertEquals('Home', contactAddressList[0].rC_Bios__Type__c   , 'test_ContactUpdateNonePreferredMailingContactAddress : Failed to set rC_Bios__Type ');
        
        Test.stopTest();
    }
    
}