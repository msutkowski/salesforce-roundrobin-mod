trigger ValidateQueueName on Assignment_Group_Queues__c (before insert, before update) {
    //Determine if the value of the Queue Name has been updated.  If so Break.
    
    if(trigger.isUpdate){
        Assignment_Group_Queues__c oldRecord = Trigger.old[0];
        Assignment_Group_Queues__c newRecord = Trigger.new[0];   

        if(oldRecord.name == newRecord.name)return;
    }
   
    //Setup Queue lookup Xref map
    //NOTE: the number of Queues supported is limited by Map size (ie. 1000)
    Map<String,Group> Queues = new Map<String,Group>();     //Queue name --> Queue
    
    for (Group[] q :  [SELECT Name FROM Group WHERE Type= 'Queue']) {
        for (Integer i = 0; i < q.size() ; i++) {
            Queues.put(q[i].Name, q[i]);
        }
    }

    
    Map<String,String> agNames = new Map<String,String> ();
    for (Assignment_Group_Queues__c agq : [SELECT Name, Assignment_Group_Name__r.Name
                                            FROM Assignment_Group_Queues__c 
                                            WHERE Active__c = 'True']) {
        agNames.put(agq.Name, agq.Assignment_Group_Name__r.Name);
    }
    
    //Find Queues matching on name
    for (Assignment_Group_Queues__c agq : Trigger.new)
    {
        if (Queues.containsKey(agq.Name))
        {
            Id qId = Queues.get(agq.Name).Id;
            System.debug('>>>>>Queue Id for name ' + agq.Name + ': '+qId);
            
            //Check if Queue is already assigned to an Assignment_Group_Queues__c record
            if (agNames.containsKey(agq.Name)) {
                agq.Valid_Queue__c = false;
                agq.addError('Queue "'+agq.Name+'" already assigned to another Assignment Group "'+agNames.get(agq.Name)+'".');
            } else {
                agq.QueueId__c = qId;
                agq.Valid_Queue__c = true;
            }
        } else {
            //Error: queue not found
            agq.Valid_Queue__c = false;
            agq.addError('Invalid Queue name: Queue name ' + agq.Name + ' cannot be found.');
        }   
    }
}
