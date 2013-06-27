global virtual class SageServicerSchedulable implements Schedulable {
    global SageServicerSchedulable() {
        // noop
    }
    
    global void execute(SchedulableContext schedulableContext) {
        rC_Messaging.MessageServicerBatchable servicerBatchable = new rC_Messaging.MessageServicerBatchable();
        servicerBatchable.schedulerName = 'SageServicerSchedulable'; 
        
        servicerBatchable.servicerList = new rC_Messaging.MessageServicer.Servicer[] {
            new rC_Payments.SageVault_Send(),
            new rC_Payments.SageVault_Save(),
            new rC_Payments.SageVaultBankcard_Send(),
            new rC_Payments.SageVaultBankcard_Save(),
            new rC_Payments.SageVaultVirtualCheck_Send(),
            new rC_Payments.SageVaultVirtualCheck_Save()
        };
        
        servicerBatchable.endpointSet = new Set<String> {
            'rC_Payments://SageVault_Send',
            'rC_Payments://SageVault_Save',
            'rC_Payments://SageVaultBankcard_Send',
            'rC_Payments://SageVaultBankcard_Save',
            'rC_Payments://SageVaultVirtualCheck_Send',
            'rC_Payments://SageVaultVirtualCheck_Save'
        };
        
        Database.executeBatch(servicerBatchable, 1);
    }
}