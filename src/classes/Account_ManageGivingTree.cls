public with sharing class Account_ManageGivingTree extends SobjectExtension {
    public class OpportunityData {
        public Decimal indentation { set; get; }
        public Opportunity opportunity { set; get; }
    }
    
    public class TimelineData {
        public String name { set; get; }
        public Decimal open { set; get; }
        public Decimal closed { set; get; }
        public Decimal lost { set; get; }
        public Decimal refund { set; get; }
    }
     
    public Account account { set; get; }
    public Opportunity opportunityForSelectingDate { set; get; }
    
    public String period { set; get; }
    public String stage { set; get; }
    public String minAmount { set; get; }
    public String maxAmount { set; get; }
    public SelectOption[] stageList{ set; get; }
    
    public transient Opportunity[] opportunityList { set; get; }
    
    public OpportunityData[] opportunityDataList { set; get; } 
    public TimelineData[] timelineDataList { set; get; }
    public Boolean isRenderedTransactions { set; get; }
    public Archival__c archivalSetting { set; get; }
    public Boolean showOpportunityArchival { set; get; } 
    
    public Account_ManageGivingTree(ApexPages.StandardController controller) {
        super(controller);
    }
    
    public override PageReference initialize() {
        isRenderedTransactions = getParam('isRenderedTransactions', 'true') == 'true';
        
        initializeAccount();
        initializeOpportunityList();
        initializeOpportunityDataList();
        initializeTimelineDataList();
        
        archivalSetting = Archival__c.getInstance();
        if (archivalSetting != null)
            showOpportunityArchival = archivalSetting.RESTapi_Opportunity__c != null;
        
        return null;
    }
    
    public PageReference initializeAccount() {
        if (null == controllerId) {
            return addErrorMessage('Internal error: missing value for "controllerId"');
        } else try {
            account = [
                select Name
                  from Account
                 where Id = :controllerId
                 limit 1
            ];
        } catch (System.Exception pException) {
            return addErrorMessage(pException);
        }
        
        return null;
    } 
    
    public PageReference initializeOpportunityList() {
        opportunityList = new Opportunity[] {};
        Opportunity[] filteredOpportunityList = new Opportunity[] {};
        
        if (null == controllerId)
            return null;
        
        Set<String> selectedFields = new Set<String> {};
        String parentField = ('' + Opportunity.rC_Giving__Parent__c).replaceAll('__c', '__r');
        
        // Add field set fields
        selectedFields = addSelectedFields(selectedFields, SObjectType.Opportunity.FieldSets.getMap().get('rc_giving__account_managegivingtree'));
        
        // Add required fields
        selectedFields = addSelectedFields(selectedFields, new Set<String> {
            'RecordType.Name',
            '' + parentField + '.Id',
            '' + parentField + + '.' + parentField + '.Id',
            '' + parentField + + '.' + parentField + '.' + parentField + '.Id',
            '' + parentField + '.CloseDate',
            '' + Opportunity.Name,
            '' + Opportunity.Amount,
            '' + Opportunity.CloseDate,
            '' + Opportunity.ForecastCategoryName,
            '' + Opportunity.ForecastCategoryName,
            '' + Opportunity.rC_Giving__Is_Giving__c,
            '' + Opportunity.rC_Giving__Is_Giving_Transaction__c,
            '' + Opportunity.rC_Giving__Transaction_Type__c
        });
        
        // Get the opportunity data
        String querySOQL = ''
            + 'select ' + generateFieldSelect(selectedFields)
            + '  from Opportunity'
            + ' where (AccountId = :controllerId'
            + '    or  ' + parentField + '.AccountId = :controllerId'
            + '    or  ' + parentField + '.' + parentField + '.AccountId = :controllerId'
            + '    or  ' + parentField + '.' + parentField + '.' + parentField + '.AccountId = :controllerId)';
            
        // Restricted to non-transactions?
        if (isRenderedTransactions != true)
            querySOQL += ' and ' + Opportunity.rC_Giving__Is_Giving_Transaction__c + ' != true';
        
        opportunityList = (Opportunity[]) Database.query(querySOQL
            + ' order by CloseDate desc'
            + ' limit 1000'
        );
        
        // Warning messages?
        if (opportunityList.size() >= 1000)
            addWarningMessage('Restricting the display to the first 1,000 related records, sorted from oldest to newest. You can also try hiding transactions records to see additional pledges.');
        if (opportunityList.size() == 0)
            addInfoMessage('No results available.');
        return null;
    }
    
    public PageReference initializeOpportunityDataList() {
        // Initialize the data list
        opportunityDataList = new OpportunityData[] {};
        
        if (null == controllerId)
            return null;
        if (opportunityList.isEmpty())
            return null;
        
        // Build a breadcrumb map for sorting
        Map<String, Opportunity> opportunityBreadcrumbMap = new Map<String, Opportunity> {};
        
        for(Opportunity opportunity : opportunityList) {
            String breadcrumb = getBlankValue(opportunity.Id);
            breadcrumb = getBlankValue(opportunity.rC_Giving__Parent__r.Id) + breadcrumb;
            breadcrumb = getBlankValue(opportunity.rC_Giving__Parent__r.rC_Giving__Parent__r.Id) + breadcrumb;
            breadcrumb = getBlankValue(opportunity.rC_Giving__Parent__r.rC_Giving__Parent__r.rC_Giving__Parent__r.Id) + breadcrumb;
            opportunityBreadcrumbMap.put(breadcrumb, opportunity);
        }
        
        // Sort the keys
        String[] breadcrumbNameList = new List<String>(opportunityBreadcrumbMap.keySet());
        breadcrumbNameList.sort();
        
        // Turn into indented data
        for(String breadcrumbName : breadcrumbNameList) {
            OpportunityData opportunityData = new OpportunityData();
            opportunityData.opportunity = opportunityBreadcrumbMap.get(breadcrumbName);
            opportunityData.indentation = (breadcrumbName.length() / 18) - 1;
            opportunityDataList.add(opportunityData);
        }
         
        return null;
    }
    
    public PageReference initializeTimelineDataList() {
        timelineDataList = new TimelineData[] {};
        
        if (null == controllerId)
            return null;
        
        // Find the oldest and latest dates. 6 months minimum spread each way.
        Date date1 = Date.today().addMonths(-6);
        Date date2 = Date.today().addMonths(6);
        
        for(Opportunity opportunity : opportunityList) {
            if (opportunity == null || opportunity.CloseDate == null)
                continue;
            if (date1 > opportunity.CloseDate)
                date1 = opportunity.CloseDate;
            if (date2 < opportunity.CloseDate)
                date2 = opportunity.CloseDate;
        }
        
        // Start processing the opps
        Integer workingYear = null;
        String workingFormatFull = 'yyyy';
        String workingFormatSlim = 'MMM';
        
        for(Date workingDate = date1; workingDate < date2; workingDate = workingDate.addMonths(1)) {
            TimelineData timelineData = new TimelineData();
            timelineData.open = 0;
            timelineData.closed = 0;
            timelineData.lost = 0;
            timelineData.refund = 0;
            
            // Add the timeline object
            if (workingYear == null || workingYear != workingDate.year())
                timelineData.name = DateTime.newInstance(workingDate, Time.newInstance(0, 0, 0, 0)).format('MMM/yy');
            else
                timelineData.name = DateTime.newInstance(workingDate, Time.newInstance(0, 0, 0, 0)).format('MMM');
            
            // Start totaling opps and break when the year+month are in the past
            for(Opportunity opportunity : opportunityList) {
                if (opportunity == null || opportunity.CloseDate == null)
                    continue;
                if (opportunity.RecordType.Id != rC_Giving.OpportunityRecordTypes.RT_TRANSACTION_ID)
                    continue;
                if (opportunity.CloseDate < workingDate)
                    continue;
                if (opportunity.CloseDate >= workingDate.addMonths(1))
                    break;
                
                // Categorize
                Boolean isTransactionPayment = 'Payment'.equalsIgnoreCase(opportunity.rC_Giving__Transaction_Type__c);
                Boolean isTransactionRefund = 'Refund'.equalsIgnoreCase(opportunity.rC_Giving__Transaction_Type__c);
                Boolean isForecastClosed = 'Closed'.equalsIgnoreCase(opportunity.ForecastCategoryName);
                Boolean isForecastOmitted = 'Omitted'.equalsIgnoreCase(opportunity.ForecastCategoryName);
                 
                if (isTransactionPayment && isForecastClosed == true)
                    timelineData.closed += opportunity.Amount;
                if (isTransactionPayment && isForecastClosed != true && isForecastOmitted == true)
                    timelineData.lost += opportunity.Amount;
                if (isTransactionPayment && isForecastClosed != true && isForecastOmitted != true)
                    timelineData.open += opportunity.Amount;
                if (isTransactionRefund)
                    timelineData.refund += opportunity.Amount;
            }
            
            // Add to the list
            timelineDataList.add(timelineData);
            workingYear = workingDate.year();
        }
        
        return null;
    }
        
    public PageReference redirectToHideTransactions() {
        PageReference pageReference = System.Page.Account_ManageGivingTree;
        pageReference.setRedirect(true);
        pageReference.getParameters().put('id', controllerId);
        pageReference.getParameters().put('isRenderedTransactions', 'false');
        return pageReference;
    }
    
    public PageReference redirectToShowTransactions() {
        PageReference pageReference = System.Page.Account_ManageGivingTree;
        pageReference.setRedirect(true);
        pageReference.getParameters().put('id', controllerId);
        pageReference.getParameters().put('isRenderedTransactions', 'true');
        return pageReference;
    }
    
    public PageReference redirectToShowArchivedGiving() {
        PageReference pageReference = System.Page.Account_ManageGivingArchival;
        pageReference.setRedirect(true);
        pageReference.getParameters().put('id', controllerId);
        return pageReference;
    }
    
    String getBlankValue(String value) {
        return value == null ? '' : value;
    }
}