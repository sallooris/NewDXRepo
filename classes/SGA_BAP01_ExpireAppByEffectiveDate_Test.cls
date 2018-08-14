/***********************************************************************
Class Name   : SGA_BAP01_ExpireAppByEffectiveDate_Test
Date Created :12-May-2017
Created By   : IDC Offshore
Description  : 1. This is a test class for SGA_BAP01_ExpireAppByEffectiveDate
**************************************************************************/
@isTest 
private class SGA_BAP01_ExpireAppByEffectiveDate_Test
{
    
    /************************************************************************************
    Method Name : testMethod1
    Parameters  : None
    Return type : void
    Description : This is the positive test for batch class execute method
    *************************************************************************************/
    private testMethod static void testMethod1() {
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
           testApplication.vlocity_ins__Status__c=SG01_Constants.STATUSINPROGRESS;
           Database.update(testApplication);
           vlocity_ins__Party__c party=Util02_TestData.createPartyforAccount(testAccount.Id);
           Database.insert(party);
            //update account with vlocity_ins__PartyId__c
           Database.update(Util02_TestData.pepareForUpdate(testAccount,party.Id));
           //insert ApplicationPartyRelationship
           vlocity_ins__ApplicationPartyRelationship__c appRel=Util02_TestData.createApplicationPartyRelationship(testApplication.Id, party.Id);
           Database.insert(appRel);
           
            Test.startTest();

            SGA_BAP01_ExpireAppByEffectiveDate obj = new SGA_BAP01_ExpireAppByEffectiveDate();
            DataBase.executeBatch(obj); 
            
            Test.stopTest();    
            System.assertEquals(SG01_Constants.STATUSINPROGRESS, testApplication.vlocity_ins__Status__c);
        }
    }
    
/************************************************************************************
    Method Name : NegTestMethod2
    Parameters  : None
    Return type : void
    Description : This is the negative test for batch class execute method
*************************************************************************************/
    private testMethod static void NegTestMethod2() {
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
            
            Test.startTest();
            SGA_BAP01_ExpireAppByEffectiveDate obj = new SGA_BAP01_ExpireAppByEffectiveDate();
            DataBase.executeBatch(obj); 
            Test.stopTest();
           System.assertNotEquals(SG01_Constants.ENROLLMENT_EXPIRED_STATUS, testApplication.vlocity_ins__Status__c);
        }
    }
}