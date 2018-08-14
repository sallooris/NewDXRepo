/**********************************************************************************
Class Name :   SGA_BAP02_CloseOppByEffectiveDate_Test
Date Created : 09/13/2017 (mm/dd/yyyy)
Created By   : IDC Offshore
Description  : 1. This class is the test class for SGA_BAP02_CloseOppByEffectiveDate
*************************************************************************************/
@isTest
private class SGA_BAP02_CloseOppByEffectiveDate_Test {
/************************************************************************************
    Method Name : testExecute
    Parameters  : None
    Return type : void
    Description : This is positive testmethod for execute Method
*************************************************************************************/
    private static testMethod void testExecute(){
        User testUser = Util02_TestData.createUser();
        Date curDate= System.Today();
        Integer dayValue= 1;
        Account testAcc = Util02_TestData.createGroupAccount();
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        vlocity_ins__Application__c testApplication = Util02_TestData.createApplicationForRelatedList(SG01_Constants.STATUSINENROLLMENTCOMPLETED, NULL);
        ID oppRT =[select Id,Name from Recordtype where Name = 'SG Quoting' and SobjectType = 'Opportunity'].Id;
        Opportunity testOpp=Util02_TestData.createGrpAccOpportunity();
        System.runAs(testUser){
        Database.insert(cs001List);
        Database.insert(cs002List);
        Database.insert(testAcc);
        Database.insert(testApplication);
        // attach application to Account 
        testApplication.vlocity_ins__AccountId__c=testAcc.Id;
        Database.update(testApplication);
        testOpp.accountid=testAcc.id;
        testOpp.recordtypeId = oppRT ;  
         if(curDate.day() >= 15 ){dayValue =15;}
        testOpp.Effective_Date__c = Date.newInstance(curDate.year(),curDate.month(),dayValue);
        AP08_RestrictMultipleOpenOpportunities.isFirstRunOPPBeforeInsert = true;
        Database.insert(testOpp);
        SGA_BAP02_CloseOppByEffectiveDate obj = new SGA_BAP02_CloseOppByEffectiveDate(0);    
        Test.startTest();
        DataBase.executeBatch(obj); 
        Test.stopTest();
        Opportunity opp=[Select Id,Stagename from Opportunity Where Id =:testOpp.Id limit 1];
        System.assertEquals('Lost', opp.StageName);
        }
     }
     
/************************************************************************************
    Method Name : testExecuteNeg
    Parameters  : None
    Return type : void
    Description : This is the Negative test for execute Method
*************************************************************************************/
     private static testMethod void testExecuteNeg(){
        User testUser = Util02_TestData.createUser();
        Date curDate= System.Today();
         Integer dayValue= 15;
        Account testAcc = Util02_TestData.createGroupAccount();
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        vlocity_ins__Application__c testApplication = Util02_TestData.createApplicationForRelatedList(SG01_Constants.STATUSINENROLLMENTCOMPLETED, NULL);
        ID oppRT =[select Id,Name from Recordtype where Name = 'SG Quoting' and SobjectType = 'Opportunity'].Id;
        Opportunity testOpp=Util02_TestData.createGrpAccOpportunity();
        
        System.runAs(testUser){
        Database.insert(cs001List);
        Database.insert(cs002List);
        Database.insert(testAcc);
        Database.insert(testApplication);
        // attach application to Account 
        testApplication.vlocity_ins__AccountId__c=testAcc.Id;
        Database.update(testApplication);
        testOpp.accountid=testAcc.id;
        testOpp.recordtypeId = oppRT ;  
        if(curDate.day() >= 15 ){dayValue =1;}
        testOpp.Effective_Date__c = Date.newInstance(curDate.year(),curDate.month(), dayValue);
        System.debug('Effective_Date__c'+ testOpp.Effective_Date__c);
        AP08_RestrictMultipleOpenOpportunities.isFirstRunOPPBeforeInsert = true;
        Database.insert(testOpp);
        SGA_BAP02_CloseOppByEffectiveDate obj = new SGA_BAP02_CloseOppByEffectiveDate(0);
        Test.startTest();
        DataBase.executeBatch(obj); 
        Test.stopTest();
        Opportunity opp=[Select Id,Stagename from Opportunity Where Id =:testOpp.Id limit 1];
            if(dayValue !=1){
                System.assertNotEquals('Lost', opp.StageName);
            }else{System.assertEquals('Lost', opp.StageName);}
            
        }
     }

}