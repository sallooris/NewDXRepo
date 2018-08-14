@isTest
/***********************************************************************
Class Name   : SGA_AP09_AppActionBtnRenderer_Test 
Date Created :12-May-2017
Created By   : IDC Offshore
Description  : 1. This is a test class for SGA_AP09_ApplicationActionBtnRenderer
**************************************************************************/
private class SGA_AP09_AppActionBtnRenderer_Test {
    
    /************************************************************************************
Method Name : ApplicationActionBtnRendererTest1
Parameters  : None
Return type : void
Description : This is the testmethod for SGA_AP09_ApplicationActionBtnRenderer constructor
*************************************************************************************/
    private testMethod static void applicationActionBtnRendererTest1() {
        User testUser = Util02_TestData.createUser();
        //Account record creation
        Account testAccount = Util02_TestData.createGroupAccountForRelatedList();
        //Application record creation
        vlocity_ins__Application__c testApplication = Util02_TestData.createApplicationForRelatedList
            (SG01_Constants.STATUSINENROLLMENTCOMPLETED, System.today() +5);
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
            
            ApexPages.StandardController controller = new ApexPages.StandardController(testApplication);
            SGA_AP09_ApplicationActionBtnRenderer ext= new SGA_AP09_ApplicationActionBtnRenderer(controller);
            
            Test.stopTest();    
            System.assertNotEquals(null, appRel.Id);
        }
    }
    /************************************************************************************
Method Name : ApplicationActionBtnRendererTest2
Parameters  : None
Return type : void
Description : This is the testmethod for SGA_AP09_ApplicationActionBtnRenderer constructor
*************************************************************************************/
    private testMethod static void applicationActionBtnRendererTest2() {
        User testUser = Util02_TestData.createUser();
        //Account record creation
        Account testAccount = Util02_TestData.createGroupAccountForRelatedList();
        //Application record creation
        vlocity_ins__Application__c testApplication = Util02_TestData.createApplicationForRelatedList(SG01_Constants.DOCUMENT_SUBMITTED_STATUS, System.today() +15);
        //Business Custom Setting insertion
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        //Record Type Assignment Custom Setting insertion
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        
        System.runAs(testUser){
            try{
                Database.insert(cs001List);
                Database.insert(cs002List);
                Database.Insert(testAccount);
                Database.insert(testApplication);
                testApplication.vlocity_ins__Status__c = SG01_Constants.ENROLLMENT_EXPIRED_STATUS;
                Database.update(testApplication);
                //Create Party for Account
                vlocity_ins__Party__c party=Util02_TestData.createPartyforAccount(testAccount.Id);
                Database.insert(party);
                //update account with vlocity_ins__PartyId__c
                Database.update(Util02_TestData.pepareForUpdate(testAccount,party.Id));
                //insert ApplicationPartyRelationship
                vlocity_ins__ApplicationPartyRelationship__c appRel=Util02_TestData.createApplicationPartyRelationship(testApplication.Id, party.Id);
                Database.insert(appRel);
                
                Test.startTest();
                
                ApexPages.StandardController controller = new ApexPages.StandardController(testApplication);
                SGA_AP09_ApplicationActionBtnRenderer ext= new SGA_AP09_ApplicationActionBtnRenderer(controller);
                
                Test.stopTest();    
                System.assertNotEquals(null, appRel.Id);
            }Catch(Exception e){}
        }
    }
    /************************************************************************************
Method Name : ApplicationActionBtnRendererTest3
Parameters  : None
Return type : void
Description : This is the testmethod for SGA_AP09_ApplicationActionBtnRenderer constructor
*************************************************************************************/
    private testMethod static void applicationActionBtnRendererTest3() {
        User testUser = Util02_TestData.createUser();
        //Account record creation
        Account testAccount = Util02_TestData.createGroupAccountForRelatedList();
        //Application record creation
        vlocity_ins__Application__c testApplication = Util02_TestData.createApplicationForRelatedList(SG01_Constants.STATUSINPROGRESS, System.today() +10);
        //Business Custom Setting insertion
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        //Record Type Assignment Custom Setting insertion
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        
        System.runAs(testUser){
            try{
                Database.insert(cs001List);
                Database.insert(cs002List);
                Database.Insert(testAccount);
                Database.insert(testApplication);
                testApplication.vlocity_ins__Status__c = SG01_Constants.ENROLLMENT_EXPIRED_STATUS;
                Database.update(testApplication);
                //Create Party for Account
                vlocity_ins__Party__c party=Util02_TestData.createPartyforAccount(testAccount.Id);
                Database.insert(party);
                //update account with vlocity_ins__PartyId__c
                Database.update(Util02_TestData.pepareForUpdate(testAccount,party.Id));
                //insert ApplicationPartyRelationship
                vlocity_ins__ApplicationPartyRelationship__c appRel=Util02_TestData.createApplicationPartyRelationship(testApplication.Id, party.Id);
                Database.insert(appRel);
                
                Test.startTest();
                
                ApexPages.StandardController controller = new ApexPages.StandardController(testApplication);
                SGA_AP09_ApplicationActionBtnRenderer ext= new SGA_AP09_ApplicationActionBtnRenderer(controller);
                
                Test.stopTest();    
                System.assertNotEquals(null, appRel.Id);
            }catch(Exception e){}
        }
    }
}