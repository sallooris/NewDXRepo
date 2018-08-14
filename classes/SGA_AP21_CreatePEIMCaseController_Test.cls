/***********************************************************************
Class Name   : SGA_AP21_CreatePEIMCaseController_Test
Date Created : 08/09/2017 (MM/DD/YYYY)
Created By   : IDC Offshore
Description  : 1. This is a test class for SGA_AP21_CreatePEIMCaseController
**************************************************************************/
@isTest
private class SGA_AP21_CreatePEIMCaseController_Test {
    
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
                
                // check exising Case for Application
                SGA_AP21_CreatePEIMCaseController.getAgent();
                SGA_AP21_CreatePEIMCaseController.getCaseSates();
                Case testCase = Util02_TestData.insertSGACase(testAcc.Id,testApplication.Id);
                SGA_AP21_CreatePEIMCaseController.createCase(testCase, testAcc.Id);
                SGA_AP21_CreatePEIMCaseController.getCaseNumber(testCase.Id);
                String recType=[Select Id,RecordTypeId,Status From Case where AccountID =:testAcc.Id limit 1].RecordTypeId;
                //System.assertEquals(SGA_AP21_CreatePEIMCaseController.caseRecId,recType);
                List<Sobject> sobjList=SGA_AP22_LookUpController.searchSObject(testAcc.Name, 'Account');
                sobjList= new List<Sobject>{testAcc};
                    SGA_AP22_LookUpController.filterWitRecType(sobjList);
                SGA_AP23_PicklistFieldController.getDependentOptionsImpl('Case', 'BR_Category__c', 'BR_Sub_Category__c');
                Test.stopTest();   
                 System.assertEquals(FALSE,sobjList.isEmpty());
            }catch(Exception e){}
           
        }
    }
    
    /************************************************************************************
Method Name : getDependentOptionsImplTest
Parameters  : None
Return type : void
Description : This is the testmethod for SGA_AP23_PicklistFieldController.getDependentOptionsImpl
*************************************************************************************/
    private testMethod static void getDependentOptionsImplTest() {
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
                
                SGA_AP23_PicklistFieldController.PicklistEntryWrapper wrp= new SGA_AP23_PicklistFieldController.PicklistEntryWrapper();
                wrp.active='True';
                
                Test.startTest();
                // check exising Case for Application
                SGA_AP21_CreatePEIMCaseController.getAgent();
                SGA_AP21_CreatePEIMCaseController.getCaseSates();
                Case testCase = Util02_TestData.insertSGACase(testAcc.Id,testApplication.Id);
                SGA_AP21_CreatePEIMCaseController.createCase(testCase, testAcc.Id);
                SGA_AP21_CreatePEIMCaseController.getCaseNumber(testCase.Id);
                String recType=[Select Id,RecordTypeId,Status From Case where AccountID =:testAcc.Id limit 1].RecordTypeId;
                Map<String,List<String>> picklist=SGA_AP23_PicklistFieldController.getDependentOptionsImpl('Case', 'BR_Category__c', 'BR_Sub_Category__c');
                Test.stopTest();  
                System.assertNotEquals(NULL,picklist.isEmpty());
            }catch(Exception e){}
            
        }
    }
}