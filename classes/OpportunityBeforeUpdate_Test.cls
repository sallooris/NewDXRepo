/****************************************************************************
Class Name  :  OpportunityBeforeUpdate_Test
Date Created:  30-June-2015
Created By  :  Bhaskar
Description :  1. Test Class for Opportunity Before Insert trigger, used to restrict the user to create multiple open opportunities
with single Open Enrollment
Change History :    
****************************************************************************/
/*    Test Class : - OpportunityBeforeUpdate Trigger */
@isTest
private  class OpportunityBeforeUpdate_Test{ 
/*
Method Name : testOpportunityEnrollment1
Param 1 : 
Return type : void
Description : Test Method for OpportunityBeforeUpdate trigger it covers AP08_RestructMultpleOpportunities Class 
*/          
private static testMethod void testOpportunityEnrollment1()
{  
    List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
    insert cs001List; 
    List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
    insert cs002List;
    User tstUser = Util02_TestData.insertUser();       
    Account testAcc = Util02_TestData.insertAccount();
    List<Opportunity> listopp = new List<Opportunity>();
    Opportunity testOpp1=Util02_TestData.insertOpportunity();
    ID accRT =[select Id,Name from Recordtype where Name = 'Person Account' and SobjectType = 'Account'].Id;
    testAcc.recordtypeId = accRT ; 
    ID oppRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'Opportunity'].Id; 
    testOpp1.recordtypeId = oppRT ;
    test.startTest();
        testAcc.customer_stage__c = 'Opportunity';
        Database.insert(testAcc);
        testOpp1.accountid=testAcc.id;
        testOpp1.stagename='Opportunity';
        testOpp1.CloseDate=System.today();
        testOpp1.Name='testO';
        testOpp1.Open_Enrollment__c = 'OE 2015';
        Database.insert(testOpp1);
        testOpp1.Open_Enrollment__c = 'OE 2016';
        listopp.add(testOpp1);
        AP08_RestrictMultipleOpenOpportunities.isFirstRunOPPBeforeUpdate = true;
        Database.update(testOpp1);
    test.stopTest();         
    Opportunity  testOpp=[select id,StageName from Opportunity where accountid=:testAcc.id AND Tech_Businesstrack__c='TELESALES' Limit 1];                                      
    System.assertNotEquals(testOpp.StageName, 'Sold');                       
    System.assertEquals(testOpp.StageName, 'Opportunity');   
}
/*
Method Name : testOpportunityEnrollment2
Param 1 : 
Return type : void
Description : Test Method for OpportunityBeforeUpdate trigger it covers AP08_RestructMultpleOpportunities Class 
*/ 
private static testMethod void testOpportunityEnrollment2()
{  
    List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
    insert cs001List; 
    List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
    insert cs002List;
    User tstUser = Util02_TestData.insertUser();       
    Account testAcc = Util02_TestData.insertAccount();
    List<Opportunity> listopp = new List<Opportunity>();
    Opportunity testOpp1=Util02_TestData.insertOpportunity();
    List<Account_Stage__c> astage = Util02_TestData.insertAccountStages();
    insert astage;
    ID accRT =[select Id,Name from Recordtype where Name = 'Person Account' and SobjectType = 'Account'].Id;
    testAcc.recordtypeId = accRT ; 
    ID oppRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'Opportunity'].Id; 
    testOpp1.recordtypeId = oppRT ;
    test.startTest();
        testAcc.customer_stage__c = 'Opportunity';
        Database.insert(testAcc);
        testOpp1.accountid=testAcc.id;
        testOpp1.stagename='Opportunity';
        testOpp1.CloseDate=System.today();
        testOpp1.Name='testO';
        testOpp1.Open_Enrollment__c = 'OE 2016';
        Database.insert(testOpp1);
        testOpp1.Open_Enrollment__c = 'OE 2016';
        listopp.add(testOpp1);
        AP08_RestrictMultipleOpenOpportunities.isFirstRunOPPBeforeUpdate = true;
        try{
        Database.update(testOpp1);
        }Catch(Exception e){}
    test.stopTest();         
    Opportunity  testOpp=[select id,StageName from Opportunity where accountid=:testAcc.id AND Tech_Businesstrack__c='TELESALES' Limit 1];                                      
    System.assertNotEquals(testOpp.StageName, 'Sold');                       
    System.assertEquals(testOpp.StageName, 'Opportunity');   
}
}