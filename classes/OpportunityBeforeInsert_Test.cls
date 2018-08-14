/****************************************************************************
Class Name  :  OpportunityBeforeInsert_Test
Date Created:  30-June-2015
Created By  :  Bhaskar
Description :  1. Test Class for Opportunity Before Insert trigger, used to restrict the user to create multiple open opportunities
with single Open Enrollment
Change History :    
****************************************************************************/
/*    Test Class : - OpportunityBeforeInsert Trigger */
@isTest
private class OpportunityBeforeInsert_Test{ 
    /*
    Method Name : testOpportunityEnrollment1
    Param 1 : 
    Return type : void
    Description : Test Method for OpportunityBeforeInsert trigger it covers AP08_RestructMultpleOpportunities Class 
    */          
private static testMethod void testOpportunityEnrollment1()
{  
    List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
    insert cs001List; 
    List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
    insert cs002List;
    Account testAcc = Util02_TestData.insertAccount();
    List<Opportunity> listopp = new List<Opportunity>();
    Opportunity testOpp=Util02_TestData.insertOpportunity();
    Opportunity testOpp1=Util02_TestData.insertOpportunity();
    List<Account_Stage__c> astage = Util02_TestData.insertAccountStages();
    insert astage;
    ID accRT =[select Id,Name from Recordtype where Name = 'Person Account' and SobjectType = 'Account'].Id;
    testAcc.recordtypeId = accRT ; 
    ID oppRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'Opportunity'].Id;
    test.startTest();
        testAcc.customer_stage__c = 'Opportunity';
        Database.insert(testAcc);
        testOpp.accountid=testAcc.id;
        testOpp.stagename='Application Started';
        testOpp.CloseDate=System.today();
        testOpp.Name='testO';
        testOpp.recordtypeId = oppRT ;      
        testOpp.Open_Enrollment__c = 'OE 2015';
        AP08_RestrictMultipleOpenOpportunities.isFirstRunOPPBeforeInsert = true;
        Database.insert(testOpp);
        testOpp1.accountid=testAcc.id;
        testOpp1.stagename='Application Started';
        testOpp1.CloseDate=System.today();
        testOpp1.Name='testO';
        testOpp1.recordtypeId = oppRT ;
        testOpp1.Open_Enrollment__c = 'OE 2016';
        Database.insert(testOpp1);
    test.stopTest();
}
/*
Method Name : testOpportunityEnrollment2
Param 1 : 
Return type : void
Description : Test Method for OpportunityBeforeInsert trigger it covers AP08_RestructMultpleOpportunities Class 
*/
private static testMethod void testOpportunityEnrollment2()
{  
    List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
    insert cs001List; 
    List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
    insert cs002List;
    List<Account_Stage__c> astage = Util02_TestData.insertAccountStages();
    insert astage;
    Account testAcc = Util02_TestData.insertAccount();
    List<Opportunity> listopp = new List<Opportunity>();
    Opportunity testOpp=Util02_TestData.insertOpportunity();
    Opportunity testOpp1=Util02_TestData.insertOpportunity();
    ID accRT =[select Id,Name from Recordtype where Name = 'Person Account' and SobjectType = 'Account'].Id;
    testAcc.recordtypeId = accRT ; 
    ID oppRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'Opportunity'].Id;
    testOpp.recordtypeId = oppRT ;      
    testOpp1.recordtypeId = oppRT ;
    test.startTest();
        testAcc.customer_stage__c = 'Opportunity';
        Database.insert(testAcc);
        testOpp.accountid=testAcc.id;
        testOpp.stagename='Application Started';
        testOpp.CloseDate=System.today();
        testOpp.Name='testO';
        testOpp.Open_Enrollment__c = 'OE 2015';
        testOpp.tech_businesstrack__c = 'TELESALES';
        Database.insert(testOpp);
        testOpp1.accountid=testAcc.id;
        testOpp1.stagename='Application Started';
        testOpp1.CloseDate=System.today();
        testOpp1.Name='testO';
        testOpp1.Open_Enrollment__c = 'OE 2015';
        AP08_RestrictMultipleOpenOpportunities.isFirstRunOPPBeforeInsert = true;
        try{
        Database.insert(testOpp1);
        }Catch(Exception e){}
    test.stopTest();
}
}