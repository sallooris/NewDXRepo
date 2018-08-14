/***********************************************************************
Class Name   : SGA_Util12_CaseDataAccessHelper_Test
Date Created : 10/10/2017 (MM/DD/YYYY)
Created By   : IDC Offshore
Description  : 1. This is a test class for SGA_Util12_CaseDataAccessHelper
**************************************************************************/
@isTest
private class SGA_Util12_CaseDataAccessHelper_Test {
    
/************************************************************************************
Method Name : createCaseTest
Parameters  : None
Return type : void
Description : This is the testmethod for createCase
*************************************************************************************/
    private testMethod static void createCaseTest() {
        User testUser = Util02_TestData.createUser();
        Account testAcc = Util02_TestData.createGroupAccount();
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        vlocity_ins__Application__c testApplication = Util02_TestData.createApplicationForRelatedList('Group Created', NULL);
        
        System.runAs(testUser){
            Database.insert(cs001List);
            Database.insert(cs002List);
            
            Database.insert(testAcc);
            testApplication.vlocity_ins__AccountId__c=testAcc.Id;
            Database.insert(testApplication);
            try{
                // Set app to Status =APP_STATUS_GROUP_SUBMITED to create Case record;
                testApplication.vlocity_ins__Status__c = SG01_Constants.APP_STATUS_GROUP_SUBMITED;
                Database.Update(testApplication);
                
                Test.startTest();
                List<Case> csListToInsert = new List<Case>();
                Case testCase = Util02_TestData.insertSGACase(testAcc.Id,testApplication.Id);
                csListToInsert.add(testCase);
                SGA_Util12_CaseDataAccessHelper.dmlOnCase(csListToInsert,SGA_Util12_CaseDataAccessHelper.INSERT_OPERATION);
                SGA_Util12_CaseDataAccessHelper.dmlOnCase(csListToInsert,SGA_Util12_CaseDataAccessHelper.UPSERT_OPERATION);
                SGA_Util12_CaseDataAccessHelper.dmlOnCase(csListToInsert,SGA_Util12_CaseDataAccessHelper.DELETE_OPERATION);
                
                Test.stopTest();   
                //System.assertEquals(FALSE,sobjList.isEmpty());
            }catch(Exception e){}
         
        }
    }
       
}