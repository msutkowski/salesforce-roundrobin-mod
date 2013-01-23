trigger leadOwnerUpdate on Lead (after update) {
    List<Lead> updateLeads = new List<Lead>();
    Map<Id,Lead> leads = new Map<Id,Lead>();
    
    for (Lead l : Trigger.new)
    {
        if(Trigger.isUpdate) {  
            System.debug('>>>>> Owner ID: '+l.ownerId+' Temp Owner ID: '+ l.TempOwnerId__c);
            if(l.TempOwnerId__c <> null && l.TempOwnerId__c <> '') {
                if(l.OwnerId <> l.TempOwnerId__c) {
                    leads.put(l.id,l);
                }
            }           
        }   
    }
    if (leads.isEmpty()) return;
    
    for (Lead l : [SELECT OwnerId,TempOwnerId__c FROM Lead WHERE id in :leads.keySet()]) {
        l.OwnerId = leads.get(l.Id).TempOwnerId__c;
        l.TempOwnerId__c = 'SKIP'; //flag to stop infinite loop upon update
        updateLeads.add(l);
    }
    System.debug('>>>>>Update Leads: '+updateLeads);
    
    //
    //Update last assignment for Assignment Group in batch
    //
    if (updateLeads.size() > 0) {
        try {
            update updateLeads;
        } catch (Exception e){

        }
    }
}
