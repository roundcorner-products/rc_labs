public virtual class SobjectExtension {
    public static final String NAMESPACE_PREFIX = 'rC_Giving__';
    
    public class ExtensionException extends Exception {}
    
    public Id controllerId { get; set; }
    
    public SobjectExtension() {
        this.controllerId = null;
    }
    
    public SobjectExtension(Id sobjectId) {
        system.assert(sobjectId != null, 'controller is null');
        this.controllerId = sobjectId;
    }
    
    public SobjectExtension(ApexPages.StandardController controller) {
        system.assert(controller != null, 'controller is null');
        this.controllerId = controller.getId();
    }
    
    public SobjectExtension(ApexPages.StandardSetController controller) {
        system.assert(controller != null, 'controller is null');
        this.controllerId = getParam('id', null);
    }
    
    public virtual PageReference addMessage(ApexPages.Severity severity, String message) {
        ApexPages.addMessage(new ApexPages.Message(severity, message));
        return null;
    }
    
    public virtual PageReference addInfoMessage(String message) {
        return addMessage(ApexPages.Severity.Info, message);
    }
    
    public virtual PageReference addWarningMessage(String message) {
        return addMessage(ApexPages.Severity.Warning, message);
    }
    
    public virtual PageReference addErrorMessage(String message) {
        return addMessage(ApexPages.Severity.Error, message);
    }
    
    public virtual PageReference addErrorMessage(Exception pException) {
        return addMessage(ApexPages.Severity.Error, pException.getTypeName() + ': ' + pException.getMessage());
    }
    
    public virtual PageReference addInfoMessageAndRollback(Savepoint savepoint, String message) {
        Database.rollback(savepoint);
        return addMessage(ApexPages.Severity.Info, message);
    }
    
    public virtual PageReference addInfoMessageAndRollback(Savepoint savepoint, Exception pException) {
        Database.rollback(savepoint);
        
        if (pException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))
            return null; // already be added to the page messages.
        if (pException.getMessage().contains('FIELD_INTEGRITY_EXCEPTION'))
            return null; // already be added to the page messages.
        if (pException.getMessage().contains('REQUIRED_FIELD_MISSING'))
            return null; // already be added to the page messages.
        
        return addMessage(ApexPages.Severity.Info, pException.getTypeName() + ': ' + pException.getMessage());
    }
    
    public virtual PageReference addWarningMessageAndRollback(Savepoint savepoint, String message) {
        Database.rollback(savepoint);
        return addMessage(ApexPages.Severity.Warning, message);
    }
    
    public virtual PageReference addWarningMessageAndRollback(Savepoint savepoint, Exception pException) {
        Database.rollback(savepoint);
        
        if (pException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))
            return null; // already be added to the page messages.
        if (pException.getMessage().contains('FIELD_INTEGRITY_EXCEPTION'))
            return null; // already be added to the page messages.
        if (pException.getMessage().contains('REQUIRED_FIELD_MISSING'))
            return null; // already be added to the page messages.
        
        return addMessage(ApexPages.Severity.Warning, pException.getTypeName() + ': ' + pException.getMessage());
    }
    
    public virtual PageReference addErrorMessageAndRollback(Savepoint savepoint, String message) {
        Database.rollback(savepoint);
        return addMessage(ApexPages.Severity.Error, message);
    }
    
    //This Method is added for RCSBIRD-1676
    public virtual PageReference addErrorMessageAndRollbackWithValidationErrors(Savepoint savepoint, Exception pException) {
        Database.rollback(savepoint);
        
        if (pException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))
            return addMessage(ApexPages.Severity.Error, pException.getDMLMessage(0));
        return addMessage(ApexPages.Severity.Error, pException.getTypeName() + ': ' + pException.getMessage());
    }
    
    public virtual PageReference addErrorMessageAndRollback(Savepoint savepoint, Exception pException) {
        Database.rollback(savepoint);
        
        if (pException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))
            return null; // already be added to the page messages.
        if (pException.getMessage().contains('FIELD_INTEGRITY_EXCEPTION'))
            return null; // already be added to the page messages.
        if (pException.getMessage().contains('REQUIRED_FIELD_MISSING'))
            return null; // already be added to the page messages.
        
        return addMessage(ApexPages.Severity.Error, pException.getTypeName() + ': ' + pException.getMessage());
    }
    
    public virtual Boolean hasWarningMessages() {
        return ApexPages.hasMessages(ApexPages.Severity.Warning);
    }
    
    public virtual Boolean hasErrorMessages() {
        return ApexPages.hasMessages(ApexPages.Severity.Error);
    }
    public virtual Boolean hasInfoMessages() {
        return ApexPages.hasMessages(ApexPages.Severity.Info);
    }
    
    public virtual Boolean getHasMessages() {
        return ApexPages.hasMessages();
    }
    
    public virtual PageReference redirectTo(PageReference pageReference) {
        return redirectTo(pageReference, true);
    }
    
    public virtual PageReference redirectTo(PageReference pageReference, Boolean includeId) {
        if (includeId == true && getId() != null)
            pageReference.getParameters().put('id', controllerId);
        pageReference.setRedirect(true);
        return pageReference;
    }
    
    public virtual String getParam(String paramName, String defaultValue) {
        system.assert(ApexPages.currentPage() != null, 'ApexPages.currentPage() == null');
        system.assert(ApexPages.currentPage().getParameters() != null, 'ApexPages.currentPage().getParameters() == null');
        String param = ApexPages.currentPage().getParameters().get(paramName);
        return param == null ? defaultValue : param;
    }
    
    public virtual String getParam(String paramName) {
        return getParam(paramName, '');
    }
    
    public virtual void putParam(String paramName, String paramData) {
        system.assert(ApexPages.currentPage() != null, 'ApexPages.currentPage() == null');
        system.assert(ApexPages.currentPage().getParameters() != null, 'ApexPages.currentPage().getParameters() == null');
        ApexPages.currentPage().getParameters().put(paramName, paramData);
    }
    
    public virtual Id getId() {
        return controllerId;
    }
    
    public virtual PageReference initializeSafe() {
        try {
            return initialize();
        } catch (Exception systemException) {
            return addErrorMessage(systemException);
        }
        
        return null;
    }
    
    public virtual PageReference initialize() {
        return null;
    }
    
    public static List<object> getFieldObjectList(Sobject[] sobjectRefList, String sobjectField) {
        if (sobjectRefList == null || sobjectRefList.size() == 0)
            return new List<object> {};
        if (sobjectField == null)
            return new List<object> {};
        
        List<object> fieldList = new List<object> {};
        
        for(Sobject sobjectRef : sobjectRefList)
            fieldList.add((object) sobjectRef.get(sobjectField));
        return fieldList;
    }
    
    public static Map<String,List<sObject>> getFieldObjectMaps(Sobject[] sobjectRefList, Schema.SobjectField sobjectField) {
        if (sobjectRefList == null || sobjectRefList.size() == 0)
            return new Map<String,List<sObject>> {};
        if (sobjectField == null)
            return new Map<String,List<sObject>> {};
        
        Map<String,List<sObject>> fieldMap = new Map<String,List<sObject>>();
        
        for(Sobject sobjectRef : sobjectRefList) {
            String f = String.valueOf(sobjectRef.get(sobjectField));
            if (fieldMap.containsKey(f))
                fieldMap.get(f).add(sobjectRef);
            else
                fieldMap.put(f,new List<Sobject>{sobjectRef});
        }
        return fieldMap;
    }
    
    public static Set<String> getFieldStringSet(Sobject[] sobjectRefList, String sobjectField) {
        if (sobjectRefList == null || sobjectRefList.size() == 0)
            return new Set<String> {};
        if (sobjectField == null)
            return new Set<String> {};
        
        Set<String> fieldSet = new Set<String> {};
        
        for(Sobject sobjectRef : sobjectRefList)
            fieldSet.add((String) sobjectRef.get(sobjectField));
        return fieldSet;
    }
    
    public static Set<String> getFieldStringSet(Sobject[] sobjectRefList, Schema.SobjectField sobjectField) {
        if (sobjectRefList == null || sobjectRefList.size() == 0)
            return new Set<String> {};
        if (sobjectField == null)
            return new Set<String> {};
        
        Set<String> fieldSet = new Set<String> {};
        
        for(Sobject sobjectRef : sobjectRefList)
            fieldSet.add((String) sobjectRef.get(sobjectField));
        return fieldSet;
    }
    
    public static Boolean getIsRenderedPageMessages() {
        return ApexPages.hasMessages();
    }
    
    public static Set<String> addSelectedFields(Set<String> selectedFields, Set<String> fieldPathList) {
        if (selectedFields == null)
            selectedFields = new Set<String> {};
        if (fieldPathList == null || fieldPathList.size() == 0)
            return selectedFields;
        for(String fieldPath : fieldPathList)
            selectedFields.add(fieldPath.toLowerCase());
        return selectedFields;
    }
    
    public static Set<String> addSelectedFields(Set<String> selectedFields, Schema.FieldSetMember[] fieldSetMemberList) {
        if (selectedFields == null)
            selectedFields = new Set<String> {};
        if (fieldSetMemberList == null || fieldSetMemberList.size() == 0)
            return selectedFields;
        for(Schema.FieldSetMember fieldSetMember : fieldSetMemberList)
            selectedFields.add(fieldSetMember.getFieldPath().toLowerCase());
        return selectedFields;
    }
    
    public static Set<String> addSelectedFields(Set<String> selectedFields, Schema.FieldSet fieldSet) {
        return addSelectedFields(selectedFields, fieldSet == null ? null : fieldSet.getFields());
    }
    
    public static String generateFieldSelect(Set<String> fieldSet) {
        String result = '';
        
        for(String field : fieldSet) {
            result += result.length() == 0 ? '' : ', ';
            result += field;
        } 
        
        return result;
    }
    
    public static String join(String chr, Set<String> valueSet){
        List<String> valueList = new List<String>();
        valueList.addAll(valueSet);
        return join(chr,valueList);
    }
    
    public static String join(String chr, List<String> valueList){
        String rs = '';
        for(Integer i = 0; i < valueList.size(); i++){
            if(i == 0){
                rs = valueList[i];
            }
            else{
                rs+=chr+valueList[i];
            }
        }
        return rs;
    }
}