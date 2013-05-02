public class rC_LabsGivingTests {
    // Instance properties
    public static final Decimal GIVING_LEVEL_MAJOR_DONOR_THRESHOLD = 1500;
    public static final Decimal GIVING_LEVEL_MIN = 0;
    public static final Decimal GIVING_LEVEL_INCREMENT = 1000;
    public static final Decimal GIVING_LEVEL_MAX = 3000;
    public static final Decimal OPPORTUNITY_GIVING_AMOUNT = 950;
    public rC_Giving__Giving_Level__c[] givingLevelList ;
    
    public rC_Giving__Giving_Level__c[] initializeGivingLevelList() {
        givingLevelList = new rC_Giving__Giving_Level__c[] {};
        
        for(Decimal i = GIVING_LEVEL_MIN; i < GIVING_LEVEL_MAX; i += GIVING_LEVEL_INCREMENT) {
            rC_Giving__Giving_Level__c givingLevel = new rC_Giving__Giving_Level__c();
            givingLevel.Name = 'RCSBIRD Giving Level ' + i;
            givingLevel.rC_Giving__Activity_Type__c = 'Membership';
            givingLevel.rC_Giving__Affiliation__c = 'RCSBIRD';
            givingLevel.rC_Giving__Min_Amount__c = i;
            givingLevel.rC_Giving__Max_Amount__c = i + GIVING_LEVEL_INCREMENT - 0.01;
            givingLevel.rC_Giving__Major_Donor_Level__c = givingLevel.rC_Giving__Min_Amount__c >= GIVING_LEVEL_MAJOR_DONOR_THRESHOLD;
            givingLevel.rC_Giving__Active_Months__c = '12';
            givingLevel.rC_Giving__Renewal_Months__c = '2';
            givingLevel.rC_Giving__Grace_Months__c = '2';
            givingLevelList.add(givingLevel);
        }
        
        insert givingLevelList;
        return givingLevelList;
    }
}