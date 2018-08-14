/***********************************************************************
Class Name   : SGA_SCAP02_CloseOppByEffectiveDate_Test
Date Created : 09/13/2017 (mm/dd/yyyy)
Created By   : IDC Offshore
Description  : 1. This is a test class for SGA_SCAP02_CloseOppByEffectiveDate
**************************************************************************/
@isTest
private class SGA_SCAP02_CloseOppByEffectiveDate_Test
{
    /************************************************************************************
    Method Name : testMethod1
    Parameters  : None
    Return type : void
    Description : This is the positive test for batch class execute method
    *************************************************************************************/
    private testMethod static void testMethod1() {
        User testUser = Util02_TestData.createUser();
        Date curDate= System.Today();
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
        testOpp.Effective_Date__c = Date.newInstance(curDate.year(),curDate.month(), 1);
            
        AP08_RestrictMultipleOpenOpportunities.isFirstRunOPPBeforeInsert = true;
        Database.insert(testOpp);
           SGA_SCAP02_CloseOppByEffectiveDate sh1 = new SGA_SCAP02_CloseOppByEffectiveDate();
           String sch = '0 0 23 * * ?';
           Test.startTest(); 
           system.schedule('Test ExpireAppByEffectiveDate', sch, sh1);
           Test.stopTest();  
           Opportunity opp=[Select Id,StageName from Opportunity Where Id =:testOpp.Id limit 1];
           System.assertEquals('Opportunity', opp.StageName);
        }
    }
    
}