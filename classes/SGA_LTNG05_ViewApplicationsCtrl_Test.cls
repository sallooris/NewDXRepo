/***********************************************************************
Class Name   : SGA_LTNG05_ViewApplicationsCtrl_Test
Date Created :12-May-2017
Created By   : IDC Offshore
Description  : 1. This is a test class for SGA_LTNG05_ViewApplicationsController
**************************************************************************/
@isTest
private class SGA_LTNG05_ViewApplicationsCtrl_Test {
   
    /************************************************************************************
    Method Name : completedApplicationListTest
    Parameters  : None
    Return type : void
    Description : This is the testmethod for completedApplicationList
    *************************************************************************************/
    private testMethod static void completedApplicationListTest() {
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
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.Insert(testAccount);
            Database.insert(testApplication);
             //Create Party for Account
           vlocity_ins__Party__c party=Util02_TestData.createPartyforAccount(testAccount.Id);
           Database.insert(party);
            //update account with vlocity_ins__PartyId__c
           Database.update(Util02_TestData.pepareForUpdate(testAccount,party.Id));
           //insert ApplicationPartyRelationship
           vlocity_ins__ApplicationPartyRelationship__c appRel=Util02_TestData.createApplicationPartyRelationship(testApplication.Id, party.Id);
           Database.insert(appRel);
           Test.startTest();
           List<SGA_LTNG05_ViewApplicationsController.WrpApplication> wrpAppList = SGA_LTNG05_ViewApplicationsController.completedApplicationList(testAccount.Id);
           Test.stopTest();    
           System.assertNotEquals(null, appRel.Id);
        }
    }
    
      /************************************************************************************
    Method Name : completedApplicationListNegTest
    Parameters  : None
    Return type : void
    Description : This is the Negative test for completedApplicationList
    *************************************************************************************/
    private testMethod static void completedApplicationListNegTest() {
         User testUser = Util02_TestData.createUser();
         //Account record creation
        Account testAccount = Util02_TestData.createGroupAccountForRelatedList();
        //Application record creation
        vlocity_ins__Application__c testApplication = Util02_TestData.createApplicationForRelatedList(SG01_Constants.STATUSINPROGRESS, System.today() +5);
        //Business Custom Setting insertion
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        //Record Type Assignment Custom Setting insertion
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        
        System.runAs(testUser){
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.Insert(testAccount);
            Database.insert(testApplication);
            //Create Party for Account
            vlocity_ins__Party__c party=Util02_TestData.createPartyforAccount(testAccount.Id);
            Database.insert(party);
            //update account with vlocity_ins__PartyId__c
            Database.update(Util02_TestData.pepareForUpdate(testAccount,party.Id));
           //insert ApplicationPartyRelationship
           vlocity_ins__ApplicationPartyRelationship__c appRel=Util02_TestData.createApplicationPartyRelationship(testApplication.Id, party.Id);
           Database.insert(appRel);
           //fetch Completed Application List
            List<SGA_LTNG05_ViewApplicationsController.WrpApplication> wrpAppList = new List<SGA_LTNG05_ViewApplicationsController.WrpApplication>();
            Test.startTest();
            wrpAppList=SGA_LTNG05_ViewApplicationsController.completedApplicationList(testAccount.Id);
            Test.stopTest();
           System.assertEquals(0,wrpAppList.size());
           System.assertNotEquals(null, appRel.Id);
        }
    }
    
    /************************************************************************************
    Method Name : completedApplicationListExTest
    Parameters  : None
    Return type : void
    Description : This is the exception scenario generated in Controller
    *************************************************************************************/
    private testMethod static void completedApplicationListExTest() {
         User testUser = Util02_TestData.createUser();
         //Account record creation
        Account testAccount = Util02_TestData.createGroupAccountForRelatedList();
        //Application record creation
        vlocity_ins__Application__c testApplication = Util02_TestData.createApplicationForRelatedList(SG01_Constants.STATUSINENROLLMENTCOMPLETED, NULL);
        //Business Custom Setting insertion
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        //Record Type Assignment Custom Setting insertion
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
       
        System.runAs(testUser){
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.Insert(testAccount);
            Database.insert(testApplication);
             //Create Party for Account
           vlocity_ins__Party__c party=Util02_TestData.createPartyforAccount(testAccount.Id);
           Database.insert(party);
            //update account with vlocity_ins__PartyId__c
           Database.update(Util02_TestData.pepareForUpdate(testAccount,party.Id));
           //insert ApplicationPartyRelationship
           vlocity_ins__ApplicationPartyRelationship__c appRel=Util02_TestData.createApplicationPartyRelationship(testApplication.Id, party.Id);
           Database.insert(appRel);
           Test.startTest();
           List<SGA_LTNG05_ViewApplicationsController.WrpApplication> wrpAppList = SGA_LTNG05_ViewApplicationsController.completedApplicationList(testAccount.Id);
           Test.stopTest();    
           System.assertNotEquals(null, appRel.Id);
        }
    }
}