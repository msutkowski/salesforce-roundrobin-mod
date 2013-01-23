@isTest
private class TestMethodClsLeads1 {

    static testMethod void myTest1() {

        // This code runs as the system user

        User u1;

        try{
          u1 = [select Id from User WHERE IsActive=True AND Profile.Name = 'System Administrator'  LIMIT 1];
        } catch (QueryException qe){

        List<User> users = [SELECT Id, Profile.PermissionsModifyAllData FROM User WHERE IsActive = true LIMIT 1000];

        for(User u : users){
            if(u.Profile.PermissionsModifyAllData = true){
              u1 = u;
              break;
        }
        }

        }

        System.debug(u1);

       //*****Create Queue 
       
       Group testGroup = new Group ();
       testGroup.Name = 'TestQueue';
       testGroup.Type = 'Queue';
       insert testGroup;
       
       QueueSObject testQueue = new QueueSObject();
       testQueue.QueueId = testGroup.id;
       testQueue.SObjectType = 'Lead';
       insert testQueue;

       // Second Queue       
       Group testGroup2 = new Group ();
       testGroup2.Name = 'TestQueue2';
       testGroup2.Type = 'Queue';
       insert testGroup2;
       
       QueueSObject testQueue2 = new QueueSObject();
       testQueue2.QueueId = testGroup2.id;
       testQueue2.SObjectType = 'Lead';
       insert testQueue2;


       test.starttest();
        
        //Run test

        //Assign Lead with out any Assignment Groups
        Lead c1 = new Lead (Lastname='testLead',TempOwnerID__c=testGroup2.id, OwnerID=u1.id); //TempOwnerID__c=testGroup2.id,  
        insert c1;
        update c1;
        
        
        //Create Assignment Group
        Assignment_Group_Name__c ag1 = new Assignment_Group_Name__c (Name='TestAG', Type__c = 'Lead');
        insert ag1;

         
        //Add bad queue name
        Assignment_Group_Queues__c agqBad = new Assignment_Group_Queues__c(name='Bad Queue',Assignment_Group_Name__c = ag1.id );

        try {
            insert agqBad; 
        } catch (DmlException e){
             System.assert(e.getMessage().contains('CUSTOM_VALIDATION_EXCEPTION'), e.getMessage()); 
        
        } //catch

        test.stoptest();
        
    }
    
    static testMethod void myTest2() {

        // This code runs as the system user

        User u1;

        try{
          u1 = [select Id from User WHERE IsActive=True AND Profile.Name = 'System Administrator'  LIMIT 1];
        } catch (QueryException qe){

        List<User> users = [SELECT Id, Profile.PermissionsModifyAllData FROM User WHERE IsActive = true LIMIT 1000];

        for(User u : users){
            if(u.Profile.PermissionsModifyAllData = true){
              u1 = u;
              break;
        }
        }

        }

        System.debug(u1);

       //*****Create Queue 
       
       Group testGroup = new Group ();
       testGroup.Name = 'TestQueue';
       testGroup.Type = 'Queue';
       insert testGroup;
       
       QueueSObject testQueue = new QueueSObject();
       testQueue.QueueId = testGroup.id;
       testQueue.SObjectType = 'Lead';
       insert testQueue;

       // Second Queue       
       Group testGroup2 = new Group ();
       testGroup2.Name = 'TestQueue2';
       testGroup2.Type = 'Queue';
       insert testGroup2;
       
       QueueSObject testQueue2 = new QueueSObject();
       testQueue2.QueueId = testGroup2.id;
       testQueue2.SObjectType = 'Lead';
       insert testQueue2;


       test.starttest();
        
        //Run test
        
        //Create Assignment Group
        Assignment_Group_Name__c ag1 = new Assignment_Group_Name__c (Name='TestAG', Type__c = 'Lead');
        insert ag1;        

        //Add Good Queue to Assignment Group
        Assignment_Group_Queues__c agq1 = new Assignment_Group_Queues__c(name=testGroup.Name ,Assignment_Group_Name__c = ag1.id );
        insert agq1;
        
        
        //Add User to Assignment Groups Users
        Assignment_Groups__c agu1 = new Assignment_Groups__c (User__c = u1.id, Active__c='True', Group_Name__c = ag1.id, Last_Assignment__c = datetime.valueOf('2009-01-01 21:13:24') );
        insert agu1;

        Lead c2 = new Lead (Lastname='testLead', Status='New', TempOwnerID__c=testGroup2.id , OwnerID=testGroup.id); //Set owner ID to Queue
        insert c2;
        update c2;        

        test.stoptest();
        
    }

    static testMethod void myTest3() {

        // This code runs as the system user

        User u1;

        try{
          u1 = [select Id from User WHERE IsActive=True AND Profile.Name = 'System Administrator'  LIMIT 1];
        } catch (QueryException qe){

        List<User> users = [SELECT Id, Profile.PermissionsModifyAllData FROM User WHERE IsActive = true LIMIT 1000];

        for(User u : users){
            if(u.Profile.PermissionsModifyAllData = true){
              u1 = u;
              break;
        }
        }

        }

        System.debug(u1);
        
        User u2;

        try{
          u2 = [select Id from User WHERE IsActive=True AND Profile.Name = 'AMAG Standard User'  LIMIT 1];
        } catch (QueryException qe){
//should run an error test here like above.              
        }


        System.debug(u2);
        


       //*****Create Queue 
       
       Group testGroup = new Group ();
       testGroup.Name = 'TestQueue';
       testGroup.Type = 'Queue';
       insert testGroup;
       
       QueueSObject testQueue = new QueueSObject();
       testQueue.QueueId = testGroup.id;
       testQueue.SObjectType = 'Lead';
       insert testQueue;

       test.starttest();
        
        //Run test        
        
        //Create Assignment Group
        Assignment_Group_Name__c ag1 = new Assignment_Group_Name__c (Name='TestAG', Type__c = 'Lead');
        insert ag1;        

        //Add Good Queue to Assignment Group
        Assignment_Group_Queues__c agq1 = new Assignment_Group_Queues__c(name=testGroup.Name ,Assignment_Group_Name__c = ag1.id );
        insert agq1;
        
         //Add User to Assignment Groups Users
        Assignment_Groups__c agu1 = new Assignment_Groups__c (User__c = u1.id, Active__c='True', Group_Name__c = ag1.id, Last_Assignment__c = datetime.valueOf('2009-01-01 21:13:24') );
        insert agu1;   

        //Add User to Assignment Groups Users
        Assignment_Groups__c agu2 = new Assignment_Groups__c (User__c = u2.id, Active__c='True', Group_Name__c = ag1.id, Last_Assignment__c = datetime.valueOf('2010-01-01 21:13:24') );
        insert agu2;   
        
        Lead c2 = new Lead (Lastname='testLead', Status='New', OwnerID=testGroup.id); //Set owner ID to Queue
        insert c2;
        update c2;
                
        Lead c3 = new Lead (Lastname='testLead2', Status='New', TempOwnerID__c=testGroup.id , OwnerID=testGroup.id); //Set owner ID to Queue
        insert c3;
    	update c3; 
  		
        Lead c4 = new Lead (Lastname='testLead3', Status='New', TempOwnerID__c=testGroup.id , OwnerID=testGroup.id); //Set owner ID to Queue
        insert c4;
        update c4;       
        
        test.stoptest();
        
    }

    static testMethod void myTest4() {

        // This code runs as the system user

        User u1;

        try{
          u1 = [select Id from User WHERE IsActive=True AND Profile.Name = 'System Administrator'  LIMIT 1];
        } catch (QueryException qe){

        List<User> users = [SELECT Id, Profile.PermissionsModifyAllData FROM User WHERE IsActive = true LIMIT 1000];

        for(User u : users){
            if(u.Profile.PermissionsModifyAllData = true){
              u1 = u;
              break;
        }
        }

        }

        System.debug(u1);

       //*****Create Queue 
       
       Group testGroup = new Group ();
       testGroup.Name = 'TestQueue';
       testGroup.Type = 'Queue';
       insert testGroup;
       
       QueueSObject testQueue = new QueueSObject();
       testQueue.QueueId = testGroup.id;
       testQueue.SObjectType = 'Lead';
       insert testQueue;
      

       test.starttest();
        
        //Run test

        //Create Assignment Group
        Assignment_Group_Name__c ag1 = new Assignment_Group_Name__c (Name='TestAG', Type__c = 'Lead');
        insert ag1;        

        //Add Good Queue to Assignment Group
        Assignment_Group_Queues__c agq1 = new Assignment_Group_Queues__c(name=testGroup.Name ,Assignment_Group_Name__c = ag1.id );
        insert agq1;
        
          //Test for AG-Queues already assigned to another Assignment Group -- trying to assign a group with a name that already exists.. repeats code above.
        Assignment_Group_Queues__c agq2 = new Assignment_Group_Queues__c(name=testGroup.Name,Assignment_Group_Name__c = ag1.id );
        try {
            insert agq2;
        } catch (DmlException e){
             System.assert(e.getMessage().contains('CUSTOM_VALIDATION_EXCEPTION'), e.getMessage()); 
        } //catch

        test.stoptest();
        
    }
}
