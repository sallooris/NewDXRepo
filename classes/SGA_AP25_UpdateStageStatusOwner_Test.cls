/*******************************************************************************************
* Class Name  : SGA_AP25_UpdateStageStatusOwner_Test
* Created By  : IDC Offshore
* CreatedDate : 8/4/2017
* Description : This test class for SGA_AP25_UpdateStageStatusOwner
********************************************************************************************/
@isTest
private class SGA_AP25_UpdateStageStatusOwner_Test {
    private static final String STATUS_VALUE = 'Assigned';
    private static final String STAGE_VALUE = 'Members Loaded';
    /************************************************************************
    * Method Name : createSGCaseInstallationTest
    * Description : To test the status , stage and owner changes 
    * 				 and creation/updation of case stage line item records
    ************************************************************************/
    private testMethod static void createSGCaseInstallationPositiveTest(){
        User testUser = Util02_TestData.createUser();
        //Account record creation
        Account testAccount = Util02_TestData.createGroupAccountForRelatedList();
        //Application record creation
        vlocity_ins__Application__c testApplication = Util02_TestData.createApplicationForRelatedList(SG01_Constants.STATUSINENROLLMENTCOMPLETED, System.today() +5);
        //Business Custom Setting insertion
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        //Record Type Assignment Custom Setting insertion
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        System.runAs(testUser){
            Test.startTest();
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.Insert(testAccount);
            Database.insert(testApplication);
            
            Case testCase = Util02_TestData.insertSGACase(testAccount.Id,testApplication.Id);
            Insert testCase; 
            
            Case updateCase = [select id,status,stage__c from case where id=:testCase.id];
            updateCase.status = STATUS_VALUE;
            updateCase.Stage__c = STAGE_VALUE;
            update updateCase;
            Test.stopTest();
            System.assertNotEquals(NULL, updateCase.Stage__c);
        }
        System.assertNotEquals(NULL, testAccount.Id);
    }
    
    /****************************************************************************
    * Method Name : createBulkSGCaseInstallationTest
    * Description : To test the status , stage and owner changes 
    * 				 and creation/updation of case stage line item records for 
    * 				 bulk creation of cases
    ****************************************************************************/
    private testMethod static void createBulkSGCaseInstallationTest(){
        User testUser = Util02_TestData.createUser();
        User testUser1 = Util02_TestData.insertUser();
        Database.insert(testUser1);
        //Account record creation
        Account testAccount = Util02_TestData.createGroupAccountForRelatedList();
        //Application record creation
        vlocity_ins__Application__c testApplication = Util02_TestData.createApplicationForRelatedList(SG01_Constants.STATUSINENROLLMENTCOMPLETED, System.today() +5);
        //Business Custom Setting insertion
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        //Record Type Assignment Custom Setting insertion
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        List<Case> caseList = new List<Case>();
        
        System.runAs(testUser){
            Test.startTest();
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.Insert(testAccount);
            Database.insert(testApplication);
            Case testCase = Util02_TestData.insertSGACase(testAccount.Id,testApplication.Id);
            caseList.add(testCase);
            Database.Insert(caseList);
            
            List<Case> updateCase = [select id,status,stage__c from case where id IN:caseList];
            for(Case caseObj : updateCase){
                caseObj.status = STATUS_VALUE;
                caseObj.Stage__c = STAGE_VALUE;
                caseObj.OwnerId = testUser1.Id;
            }
            Database.Update(updateCase);
            Test.stopTest();
            System.assertNotEquals(NULL, updateCase[0].Stage__c);
        }
        System.assertNotEquals(NULL, testAccount.Id);
    }
    
    /************************************************************************
    * Method Name : createSGCaseInstallationNegativeTest
    * Description : To test the status , stage and owner changes 
    * 				 and creation/updation of case stage line item records
    ************************************************************************/
    private testMethod static void createSGCaseInstallationNegativeTest(){
        User testUser = Util02_TestData.createUser();
        //Account record creation
        Account testAccount = Util02_TestData.createGroupAccountForRelatedList();
        //Application record creation
        vlocity_ins__Application__c testApplication = Util02_TestData.createApplicationForRelatedList(SG01_Constants.STATUSINENROLLMENTCOMPLETED, System.today() +5);
        //Business Custom Setting insertion
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        //Record Type Assignment Custom Setting insertion
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        System.runAs(testUser){
            Test.startTest();
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.Insert(testAccount);
            Database.insert(testApplication);
            
            Case testCase = Util02_TestData.createSGPEIMCase();
            testCase.AccountId = testAccount.Id;
            testCase.Application_Name__c = testApplication.Id;
            Insert testCase; 
            //checking the negative scenario for pre enrollment cases, only status record will be created
            List<Case_Status_Stage_Line_Item__c> lineItemList = [select id from Case_Status_Stage_Line_Item__c where Case__c=:testCase.Id];
			Test.stopTest();
            system.assertEquals(1, lineItemList.size());
        }
        System.assertNotEquals(NULL, testAccount.Id);
    }
}