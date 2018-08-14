/****************************************************************************
Class Name  :  AP01_AccountOppStageUpdate_Test
Date Created:  20-April-2015
Created By  :  Bhaskar/Santosh
Description :  Test Class for Account after update trigger. Account after update trigger updates the customer stage 
in Opportunity based on account stage updates.
Change History :    
****************************************************************************/
/*    Test Class : - AccountOppStageUpdate Trigger */
@isTest
Private class AP01_AccountOppStageUpdate_Test
{ 
/*
Method Name : testOpportunityStageUpdate1
Param 1 : 
Return type : void
Description : Test Method for AP01_AccountOppStageUpdate Class 
*/         
private static testMethod void testOpportunityStageUpdate1()
{  
    User tstUser = Util02_TestData.insertUser();       
    Account testAcc = Util02_TestData.insertAccount();
    Opportunity testOpp=Util02_TestData.insertOpportunity();
    List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
    insert cs001List; 
    List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
    insert cs002List;
    Account_Stage__c ast = new Account_Stage__c();
    ast.name = 'Application Started';
    ast.Oppty_Stage__c = 'Application Started';
    insert ast;
    Account_Stage__c as1 = new Account_Stage__c();
    as1.name = 'Customer Enrolled';
    as1.Oppty_Stage__c = 'Sold';
    insert as1;
    Account_Stage__c as2 = new Account_Stage__c();
    as2.name = 'Exhausted';
    as2.Oppty_Stage__c = 'Lost';
    insert as2;
    Account_Stage__c as3 = new Account_Stage__c();
    as3.name = 'Opportunity';
    as3.Oppty_Stage__c = 'Opportunity';
    insert as3;
    Account_Stage__c as4 = new Account_Stage__c();
    as4.name = 'Quote Provided';
    as4.Oppty_Stage__c = 'Quote Provided';
    insert as4;
    ID accRT =[select Id,Name from Recordtype where Name = 'Person Account' and SobjectType = 'Account'].Id;
    testAcc.recordtypeId = accRT ;   
    ID oppRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'Opportunity'].Id;
    testOpp.recordtypeId = oppRT;         
    System.runAs(tstUser)
    {
        test.startTest();
        testAcc.customer_stage__c ='New Lead';
        Database.insert(testAcc);
        testOpp.accountid=testAcc.id;
        Database.insert(testOpp);
        testAcc.customer_stage__c='Opportunity';
        Database.update(testAcc);  
        test.stopTest();               
        testOpp=[select id,StageName from Opportunity where accountid=:testAcc.id  AND Tech_Businesstrack__c='TELESALES' Limit 1];                           
        System.assertEquals(testAcc.customer_stage__c, 'Opportunity');            
        System.assertNotEquals(testOpp.StageName, 'Sold');                       
        System.assertEquals(testOpp.StageName, 'Opportunity');
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
    User tstUser = Util02_TestData.insertUser();       
    Account testAcc = Util02_TestData.insertAccount();
    Opportunity testOpp=Util02_TestData.insertOpportunity();
    List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
    insert cs001List; 
    List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
    insert cs002List;
    Account_Stage__c ast = new Account_Stage__c();
    ast.name = 'Application Started';
    ast.Oppty_Stage__c = 'Application Started';
    insert ast;
    Account_Stage__c as1 = new Account_Stage__c();
    as1.name = 'Customer Enrolled';
    as1.Oppty_Stage__c = 'Sold';
    insert as1;
    Account_Stage__c as2 = new Account_Stage__c();
    as2.name = 'Exhausted';
    as2.Oppty_Stage__c = 'Lost';
    insert as2;
    Account_Stage__c as3 = new Account_Stage__c();
    as3.name = 'Opportunity';
    as3.Oppty_Stage__c = 'Opportunity';
    insert as3;
    Account_Stage__c as4 = new Account_Stage__c();
    as4.name = 'Quote Provided';
    as4.Oppty_Stage__c = 'Quote Provided';
    insert as4;
    ID accRT =[select Id,Name from Recordtype where Name = 'Person Account' and SobjectType = 'Account'].Id;
    testAcc.recordtypeId = accRT ;    
    ID oppRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'Opportunity'].Id;
    testOpp.recordtypeId = oppRT;    
    System.runAs(tstUser)
    {
        test.startTest();
        Database.insert(testAcc);
        testOpp.accountid=testAcc.id;
        Database.insert(testOpp);
        testAcc.customer_stage__c='Opportunity';
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
    User tstUser = Util02_TestData.insertUser();       
    Account testAcc = Util02_TestData.insertAccount();
    Opportunity testOpp=Util02_TestData.insertOpportunity();
    List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
    insert cs001List; 
    List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
    insert cs002List;
    Account_Stage__c ast = new Account_Stage__c();
    ast.name = 'Application Started';
    ast.Oppty_Stage__c = 'Application Started';
    insert ast;
    Account_Stage__c as1 = new Account_Stage__c();
    as1.name = 'Customer Enrolled';
    as1.Oppty_Stage__c = 'Sold';
    insert as1;
    Account_Stage__c as2 = new Account_Stage__c();
    as2.name = 'Exhausted';
    as2.Oppty_Stage__c = 'Lost';
    insert as2;
    Account_Stage__c as3 = new Account_Stage__c();
    as3.name = 'Opportunity';
    as3.Oppty_Stage__c = 'Opportunity';
    insert as3;
    Account_Stage__c as4 = new Account_Stage__c();
    as4.name = 'Quote Provided';
    as4.Oppty_Stage__c = 'Quote Provided';
    insert as4;
    ID accRT =[select Id,Name from Recordtype where Name = 'Person Account' and SobjectType = 'Account'].Id;
    testAcc.recordtypeId = accRT ;  
    ID oppRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'Opportunity'].Id;
    testOpp.recordtypeId = oppRT;          
    System.runAs(tstUser)
    {
        test.startTest();
        testAcc.customer_stage__c ='New Lead';
        Database.insert(testAcc);
        testOpp.accountid=testAcc.id;
        testOpp.StageName ='Sold';
        Database.insert(testOpp);
        testAcc.customer_stage__c='Opportunity';
        try{
            Database.update(testAcc);  
        }catch(Exception e){}
        test.stopTest();               
        testOpp=[select id,StageName from Opportunity where accountid=:testAcc.id  AND Tech_Businesstrack__c='TELESALES' Limit 1];                           
        System.assertEquals(testAcc.customer_stage__c, 'Opportunity');            
        System.assertNotEquals(testOpp.StageName, 'Opportunity');                       
        System.assertEquals(testOpp.StageName, 'Sold');
    }
}
}