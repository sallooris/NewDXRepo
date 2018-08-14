/***********************************************************************
Class Name   : SGA_LTNG04_InProgressQuotesCtrl_Test
Date Created : 15-May-2017
Created By   : IDC Offshore
Description  : 1. This is a test class for SGA_LTNG04_InProgressController
**************************************************************************/
@isTest
private class SGA_LTNG04_InProgressQuotesCtrl_Test {
 
/************************************************************************************
Method Name : inProgressQuotesStdTest
Parameters  : None
Return type : void
Description : This is the testmethod to Test sga_LTNG04_InProgressController constructor
*************************************************************************************/
    private testMethod static void inProgressQuotesStdTest() {
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
            
           sga_LTNG04_InProgressController sgInProgress = new sga_LTNG04_InProgressController(sc);

            Test.stopTest();
            System.assertNotEquals(null, omniSript.Id);
            System.assertEquals(testAccount.Id, sgInProgress.acct.Id);
        }
        
    } 
/************************************************************************************
Method Name : inProcessQuotesListTest
Parameters  : None
Return type : void
Description : This is the testmethod to fetch InProgress Applications Test
*************************************************************************************/
    private testMethod static void inProcessQuotesListTest() {
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
            
            List<vlocity_ins__OmniScriptInstance__c> inProgressQuotesList = new List<vlocity_ins__OmniScriptInstance__c>();
            Test.startTest();
            SGA_LTNG04_InProgressController.getCurrentUserProfile();
			
            inProgressQuotesList=SGA_LTNG04_InProgressController.getInProcessQuotesList(testAccount.Id);
			
            Test.stopTest();
            System.assertNotEquals(null, omniSript.Id);
            System.assertEquals(1, inProgressQuotesList.size());
        }
        
    }
	
	/************************************************************************************
Method Name : cancelInProgressQuotesTest
Parameters  : None
Return type : void
Description : This is the testmethod to test CancelInProgressQuotes Method
*************************************************************************************/
    private testMethod static void cancelInProgressQuotesTest() {
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
            
            List<vlocity_ins__OmniScriptInstance__c> inProgressQuotesList = new List<vlocity_ins__OmniScriptInstance__c>();
            Test.startTest();
            SGA_LTNG04_InProgressController.getCurrentUserProfile();
            inProgressQuotesList=SGA_LTNG04_InProgressController.cancelInProgressQuotes(omniSriptIntance,testAccount.Id);
            Test.stopTest();
            System.assertNotEquals(null, omniSript.Id);
            System.assertEquals(1, inProgressQuotesList.size());
        }
  }
        
}