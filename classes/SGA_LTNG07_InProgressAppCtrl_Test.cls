/***********************************************************************
Class Name   : SGA_LTNG07_InProgressAppCtrl_Test
Date Created :12-May-2017
Created By   : IDC Offshore
Description  : 1. This is a test class for SGA_LTNG07_InProgressApplicationsCtrl
**************************************************************************/
@isTest
private class SGA_LTNG07_InProgressAppCtrl_Test{
	
/************************************************************************************
Method Name : inProgressAppStdTest
Parameters  : None
Return type : void
Description : This is the testmethod to Test SGA_LTNG07_InProgressApplicationsCtrl constructor 
*************************************************************************************/
    private testMethod static void inProgressAppStdTest() {
        User testUser = Util02_TestData.createUser();
        //Account record creation
        Account testAccount = Util02_TestData.createGroupAccountForRelatedList();
       //vlocity_ins__OmniScript__c record creation
        vlocity_ins__OmniScript__c omniSript=Util02_TestData.createOmniScript(SG01_Constants.SG_QUOTING ,SG01_Constants.SUBTYPE_NEWYORK1 );
        //Business Custom Setting insertion
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        //Record Type Assignment Custom Setting insertion
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        System.runAs(testUser){
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.insert(testAccount);
            Database.insert(omniSript);
            //vlocity_ins__OmniScriptInstance__c record insert for Account and OmniScript
            vlocity_ins__OmniScriptInstance__c omniSriptIntance=Util02_TestData.createOmniScriptInstance(testAccount,SG01_Constants.ACCOUNT ,omniSript.Id,SG01_Constants.STATUSINPROGRESS);
      
            Database.insert(omniSriptIntance);
            
           ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
            Test.startTest();
            
           SGA_LTNG07_InProgressApplicationsCtrl sgInProgress = new SGA_LTNG07_InProgressApplicationsCtrl(sc);

            Test.stopTest();
            System.assertNotEquals(null, omniSript.Id);
            System.assertEquals(testAccount.Id, sgInProgress.acct.Id);
        }
        
    } 
   
    /************************************************************************************
    Method Name : inProgressApplicationsTest
    Parameters  : None
    Return type : void
    Description : This is the testmethod to fetch InProgress Applications Test
    *************************************************************************************/
    private testMethod static void inProgressApplicationsTest() { 
        User testUser = Util02_TestData.createUser();
        //Account record creation
        Account testAccount = Util02_TestData.createGroupAccountForRelatedList();
       //vlocity_ins__OmniScript__c record creation
        vlocity_ins__OmniScript__c omniSript=Util02_TestData.createOmniScript('SG Quoting','Enrollment');
       //Business Custom Setting insertion
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        //Record Type Assignment Custom Setting insertion
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        System.runAs(testUser) {
          
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.insert(testAccount);
            Database.insert(omniSript);
           
            //vlocity_ins__OmniScriptInstance__c record insert for Account and OmniScript
      
            vlocity_ins__OmniScriptInstance__c omniSriptIntance=Util02_TestData.createOmniScriptInstance(testAccount,'Account',omniSript.Id,'In Progress');
            
            Database.insert(omniSriptIntance);
          
           List<vlocity_ins__OmniScriptInstance__c> inProgressApplicationsList = new List<vlocity_ins__OmniScriptInstance__c>();
           Test.startTest();
            SGA_LTNG07_InProgressApplicationsCtrl.getCurrentUserProfile();
            //inProgressApplicationsList=SGA_LTNG07_InProgressApplicationsCtrl.inProgressApplications(testAccount.Id);
            inProgressApplicationsList=SGA_LTNG07_InProgressApplicationsCtrl.CancelInProgressApplications(omniSriptIntance,testAccount.Id);
           Test.stopTest();
           System.assertNotEquals(null, omniSript.Id);
           System.assertEquals(1, inProgressApplicationsList.size());
           
        }
    }
    
    /************************************************************************************
    Method Name : inProgressApplicationsExTest
    Parameters  : None
    Return type : void
    Description : This is the testmethod check exception in inProgressApplications
    *************************************************************************************/
    private testMethod static void inProgressApplicationsExTest() { 
        User testUser = Util02_TestData.createUser();
        //Account record creation
        Account testAccount = Util02_TestData.createGroupAccountForRelatedList();
       //vlocity_ins__OmniScript__c record creation
        vlocity_ins__OmniScript__c omniSript=Util02_TestData.createOmniScript('SG Quoting','Enrollment');
       //Business Custom Setting insertion
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        //Record Type Assignment Custom Setting insertion
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        System.runAs(testUser) {
          
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.insert(testAccount);
            Database.insert(omniSript);
           
            //vlocity_ins__OmniScriptInstance__c record insert for Account and OmniScript
      
            vlocity_ins__OmniScriptInstance__c omniSriptIntance=Util02_TestData.createOmniScriptInstance(testAccount,'Account',omniSript.Id,'In Progress');
            
            Database.insert(omniSriptIntance);
           List<vlocity_ins__OmniScriptInstance__c> inProgressApplicationsList = new List<vlocity_ins__OmniScriptInstance__c>();
           Test.startTest();
            inProgressApplicationsList=SGA_LTNG07_InProgressApplicationsCtrl.inProgressApplications('');
           Test.stopTest();
           System.assertNotEquals(null, omniSript.Id);
           System.assertEquals(0, inProgressApplicationsList.size());
           
        }
    }   
}