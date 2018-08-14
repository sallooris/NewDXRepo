/****************************************************************************
Class Name  :  AccountAfterUpdate_Test
Date Created:  29-June-2015
Created By  :  Bhaskar
Description :  1. Test Class for Account after update trigger. Account after update trigger updates the customer stage 
in Opportunity based on account stage updates.
2. Used to check the task owner is chaning based on account owner change
Change History :  
****************************************************************************
****************************************************************************/
/*    Test Class : - AccountOppStageUpdate Trigger */
@isTest
Private class AccountAfterUpdate_Test{ 
    /*
    Method Name : testOpportunityStageUpdate1
    Param 1 : 
    Return type : void

    Description : Test Method for AP01_AccountOppStageUpdate Class 
    */        
    private static testMethod void testOpportunityStageUpdate1()
    {  
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        List<Account_Stage__c> astage = Util02_TestData.insertAccountStages();
        insert astage;
        User tstUser = Util02_TestData.insertUser();       
        Account testAcc = Util02_TestData.insertAccount();
        Opportunity testOpp=Util02_TestData.insertOpportunity();
        ID accRT =[select Id,Name from Recordtype where Name = 'Person Account' and SobjectType = 'Account'].Id;
        ID oppRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'Opportunity'].Id;
        testAcc.recordtypeId = accRT ;          
        System.runAs(tstUser)
        {
            test.startTest();
            testAcc.customer_stage__c = 'Opportunity';
            Database.insert(testAcc);
            testOpp.accountid=testAcc.id;
            testOpp.recordTypeId = oppRT;
            Database.insert(testOpp);
            testAcc.customer_stage__c='Application Started';
            AP01_AccountOppStageUpdate.isFirstRun = true;
            Database.update(testAcc);
            test.stopTest();         
            testOpp=[select id,StageName from Opportunity where accountid=:testAcc.id AND Tech_Businesstrack__c='TELESALES' Limit 1];                           
        }
    }
    /*
    Method Name : testOpportunityStageUpdate2
    Param 1 : 
    Return type : void

    Description : Test Method for AP01_AccountOppStageUpdate Class 
    */
    private static testMethod void testOpportunityStageUpdate2()
    {  
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        List<Account_Stage__c> astage = Util02_TestData.insertAccountStages();
        insert astage;
        User tstUser = Util02_TestData.insertUser();       
        Account testAcc = Util02_TestData.insertAccount();
        Opportunity testOpp=Util02_TestData.insertOpportunity();
        ID accRT =[select Id,Name from Recordtype where Name = 'Person Account' and SobjectType = 'Account'].Id;
        ID oppRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'Opportunity'].Id;
        testAcc.recordtypeId = accRT ;       
        System.runAs(tstUser)
        {
            test.startTest();
            Database.insert(testAcc);
            testOpp.accountid=testAcc.id;
            testOpp.recordTypeId = oppRT;
            Database.insert(testOpp);
            testAcc.customer_stage__c='Customer Enrolled';
            AP01_AccountOppStageUpdate.isFirstRun = true;
            Database.update(testAcc);  
            test.stopTest();    
            System.assertNotEquals(testOpp.StageName, 'Closed Won');  
        }
    }
    /*
    Method Name : testOpportunityStageUpdate3
    Param 1 : 
    Return type : void
    Description : Test Method for AP01_AccountOppStageUpdate Class 
    */
    private static testMethod void testOpportunityStageUpdate3()
    {  
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        List<Account_Stage__c> astage = Util02_TestData.insertAccountStages();
        insert astage;
        User tstUser = Util02_TestData.insertUser();       
        Account testAcc = Util02_TestData.insertAccount();
        Opportunity testOpp=Util02_TestData.insertOpportunity();
        ID accRT =[select Id,Name from Recordtype where Name = 'Person Account' and SobjectType = 'Account'].Id;
        ID oppRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'Opportunity'].Id;
        testAcc.recordtypeId = accRT ;       
        System.runAs(tstUser)
        {
            test.startTest();
            testAcc.customer_stage__c='Opportunity';
            Database.insert(testAcc);
            testOpp.accountid=testAcc.id;
            testOpp.recordTypeId = oppRT;
            Database.insert(testOpp);
            testAcc.customer_stage__c=NULL;
            AP01_AccountOppStageUpdate.isFirstRun = true;
            try{
            Database.update(testAcc);  
            }Catch(Exception e){}
            test.stopTest();    
        }
    }
    /*
    Method Name : testLeadActivityOwnerChange
    Return type : void
    Description : This method is used to check the activity owner is getting changed or not after lead owner change
    */
    private static testMethod void testLeadActivityOwnerChange()
    { 
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        User testUser01=Util02_TestData.insertUser();
        User testUser02=Util02_TestData.insertUser();
        Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
        Lead ldObj=Util02_TestData.insertLead();
        List<Task> testLeadTasks=new List<Task>(); 
        id taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Send Fulfillment' AND SobjectType ='Task' LIMIT 1].Id;
        Test.startTest();
        Database.insert(testUser01);
        Database.insert(pCode);
        pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];      
        ldObj.zip_code__c = pCode.Id;
        ID accRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'Lead'].Id;
        ldObj.recordtypeId = accRT ;
        Database.insert(ldObj);
        for(Integer i=0;i< 5;i++){
            Task t = new Task();
            t.ActivityDate = System.Today()+i;
            t.Subject = 'Subject'+i;
            t.RecordTypeId = taskRecordTypeId;
            t.language__c='SP';
            t.communication_type__c ='Deadline Passed';
            t.email_address__c = 'Primary Email';
            t.whoId = ldObj.id;
            testLeadTasks.add(t);
        }
        Database.insert(testLeadTasks);
        testUser02.username = 'bhasakrb123@ggggg.com';
        Database.insert(testUser02);
        ldObj.ownerId = testUser02.id;
        Database.Update(ldObj);
        List<Lead> lsslist=new List<Lead>();
        AP13_UpdateAcitivityOwner obj=new AP13_UpdateAcitivityOwner();
        lsslist.add(ldObj);
        obj.changeLeadAcitivityOwner(lsslist);
        Test.stopTest();
    }
    /*
    Method Name : testAccountActivityOwnerChange
    Return type : void
    Description : This method is used to check the activity owner is getting changed or not after account owner change
    */
    private static testMethod void testAccountActivityOwnerChange()
    { 
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        User testUser01=Util02_TestData.insertUser();
        User testUser02=Util02_TestData.insertUser();
        
        Account testAcc = Util02_TestData.insertAccount();
        ID accRT =[select Id,Name from Recordtype where Name = 'Person Account' and SobjectType = 'Account'].Id;
        testAcc.recordtypeId = accRT ;  
        List<Task> testAccountTasks=new List<Task>(); 
        id taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Send Fulfillment' AND SobjectType ='Task' LIMIT 1].Id;
        Database.insert(testUser01);
        testAcc.ownerId = testUser01.id;
        Database.insert(testAcc);
        testUser02.username = 'bhasakrb123@ggggg.com';
        Database.insert(testUser02);
        for(Integer i=0;i< 5;i++){
            Task t = new Task();
            t.ActivityDate = System.Today()+i;
            t.Subject = 'Subject'+i;
            t.RecordTypeId = taskRecordTypeId;
            t.language__c='EN';
            t.communication_type__c ='Deadline Passed';
            t.email_address__c = 'Primary Email';
            t.whatId = testAcc.id;
            testAccountTasks.add(t);
        }
        Database.insert(testAccountTasks);
        Test.startTest();
        Update testAcc;
        testAcc.ownerId = testUser02.id;
        
        //Lines 205 & 207 added to enable updateContacts in AfterUpdateAccount Trigger
        Util02_TestData.runContactsUpdate = true;
        Update testAcc;
        Util02_TestData.runContactsUpdate = false;
        List<Account> lsslist=new List<Account>();
        AP13_UpdateAcitivityOwner obj=new AP13_UpdateAcitivityOwner();
        lsslist.add(testAcc);
        obj.changeAccountAcitivityOwner(lsslist);
        Test.stopTest();
    }
    
    private static testMethod void testOpportunityStageUpdate111()
    {  
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        CS001_RecordTypeBusinessTrack__c cs001 = new CS001_RecordTypeBusinessTrack__c ();
        cs001.name = 'Account_Anthem Opps';
        cs001.BusinessTrackName__c = 'ANTHEMOPPS';
        insert cs001;
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        ID accOppsRT =[select Id,Name from Recordtype where Name = 'Anthem Opps' and SobjectType = 'Account'].Id; 
        Account testAcc = new Account(name='Opps Acc',recordtypeid=accOppsRT);
        insert testAcc;
        testAcc.Name = 'Opps Acc1';
        update testAcc;
    }
}