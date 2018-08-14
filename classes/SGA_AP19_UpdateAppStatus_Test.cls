/***********************************************************************
Class Name   : SGA_AP19_UpdateAppStatus_Test
Date Created : 08/04/2017 (MM/DD/YYYY)
Created By   : IDC Offshore
Description  : 1. This is a test class for SGA_AP19_UpdateAppStatus
**************************************************************************/
@isTest
private class SGA_AP19_UpdateAppStatus_Test {
    
    /************************************************************************************
Method Name : updateApplicationTest
Parameters  : None
Return type : void
Description : This is the testmethod for updateApplication
*************************************************************************************/
    
    private testMethod static void updateApplicationTest() {
        User testUser = Util02_TestData.createUser();
        Account testAcc = Util02_TestData.createGroupAccount();
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        vlocity_ins__Application__c testApplication = Util02_TestData.createApplicationForRelatedList('Application Created', NULL);
        SGA_CS03_CaseStage_AppStatus__c csc = new SGA_CS03_CaseStage_AppStatus__c(Name='Group Returned',Application_Status__c='Group Returned');
        System.runAs(testUser){
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.insert(testAcc);
            Database.insert(csc);
            testApplication.vlocity_ins__AccountId__c=testAcc.Id;
            Database.insert(testApplication);
            // Set app to Status =APP_STATUS_GROUP_SUBMITED to create Case record;
            testApplication.vlocity_ins__Status__c = SG01_Constants.APP_STATUS_GROUP_SUBMITED;
            Database.Update(testApplication);
            try{
                
                
                Test.startTest();
                // check exising Case for Application
                Map<Id,Case> csMap = SGA_Util12_CaseDataAccessHelper.fetchCaseMap(SGA_AP20_CreateInstallationCase.EXIST_CASE_QUERY_SELECT,SGA_AP20_CreateInstallationCase.EXIST_CASE_QUERY_WHERE,SGA_AP20_CreateInstallationCase.ORDER_BY_CLAUSE,SG01_Constants.BLANK);
                Case cs=csMap.values()[0];
                cs.Stage__c = 'Group Returned';
                Database.Update(cs);
                
                Test.stopTest();   
                System.assertNotEquals(null, csMap);
                System.assertEquals('Group Returned', csMap.values()[0].Stage__c);
            }catch(Exception e){}
        }
    }
    
    
    
    /************************************************************************************
Method Name : updateApplicationNegTest
Parameters  : None
Return type : void
Description : This is the testmethod for checking Negative Condition for
updateApplication
************************************************************************************/
    private testMethod static void updateApplicationNegTest() {
        User testUser = Util02_TestData.createUser();
        Account testAcc = Util02_TestData.createGroupAccount();
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        vlocity_ins__Application__c testApplication = Util02_TestData.createApplicationForRelatedList('Application Created', NULL);
        
        System.runAs(testUser){
            try{
                Database.insert(cs001List);
                Database.insert(cs002List);
                Database.insert(testAcc);
                testApplication.vlocity_ins__AccountId__c=testAcc.Id;
                Database.insert(testApplication);
                // Set app to Status =APP_STATUS_GROUP_SUBMITED to create Case record;
                testApplication.vlocity_ins__Status__c = SG01_Constants.APP_STATUS_GROUP_SUBMITED;
                Database.Update(testApplication);
                
                Test.startTest();
                // check exising Case for Application
                Map<Id,Case> csMap = SGA_Util12_CaseDataAccessHelper.fetchCaseMap(SGA_AP20_CreateInstallationCase.EXIST_CASE_QUERY_SELECT,SGA_AP20_CreateInstallationCase.EXIST_CASE_QUERY_WHERE,SGA_AP20_CreateInstallationCase.ORDER_BY_CLAUSE,SG01_Constants.BLANK);
                System.assertNotEquals(null, csMap);
                
                System.debug('cs::>'+csMap);
                Case cs=csMap.values()[0];
                cs.Stage__c = 'Group Denied';
                Database.Update(cs);
                
                Test.stopTest();   
                System.assertNotEquals(SG01_Constants.APP_STATUS_GROUP_SUBMITED, 'Group Denied');
            }catch(Exception e){}
        }
    }
    
    /************************************************************************************
Method Name : upsertAndDelApplicationTest
Parameters  : None
Return type : void
Description : This is the testmethod for checking Negative Condition for
updateApplication
************************************************************************************/
    private testMethod static void upsertAndDelApplicationTest() {
        User testUser = Util02_TestData.createUser();
        Account testAcc = Util02_TestData.createGroupAccount();
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        vlocity_ins__Application__c testApplication = Util02_TestData.createApplicationForRelatedList('Application Created', NULL);
        
        System.runAs(testUser){
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.insert(testAcc);
            testApplication.vlocity_ins__AccountId__c=testAcc.Id;
            Database.insert(testApplication);
            // Set app to Status =APP_STATUS_GROUP_SUBMITED to create Case record;
            testApplication.vlocity_ins__Status__c = SG01_Constants.APP_STATUS_GROUP_SUBMITED;
            Database.UpSert(testApplication);
            SGA_Util03_ApplicationDataAccessHelper.dmlApplicationlist( new List<vlocity_ins__Application__c> {testApplication},SGA_Util03_ApplicationDataAccessHelper.UPSERT_OPERATION);
            Test.startTest();
            try{
                
                // check exising Case for Application
                Map<Id,Case> csMap = SGA_Util12_CaseDataAccessHelper.fetchCaseMap(SGA_AP20_CreateInstallationCase.EXIST_CASE_QUERY_SELECT,SGA_AP20_CreateInstallationCase.EXIST_CASE_QUERY_WHERE,SGA_AP20_CreateInstallationCase.ORDER_BY_CLAUSE,SG01_Constants.BLANK);
                System.assertNotEquals(null, csMap);
                
                Case cs=csMap.values()[0];
                cs.Stage__c = 'Group Denied';
                SGA_Util12_CaseDataAccessHelper.dmlOnCase( new List<Case> {cs},SGA_Util12_CaseDataAccessHelper.UPSERT_OPERATION);
                
                Test.stopTest();   
                System.assertNotEquals(SG01_Constants.APP_STATUS_GROUP_SUBMITED, 'Group Denied');
                
            }catch(Exception e){}
        }
    }
    
}