/*******************************************************************************
Class Name   : SGA_AP41_UpdatePartyIdOnApplication_Test
Date Created : 25-August-2017
Created By   : IDC Offshore
Description  : 1. This is a test class for SGA_AP41_UpdatePartyIdOnApplication
*********************************************************************************/
@isTest
private class SGA_AP41_UpdatePartyIdOnApplication_Test {
    /************************************************************************************
    Method Name : updatePartyIdOnApplicationTest
    Parameters  : None
    Return type : void
    Description : This is the testmethod for paper application creation without party id
    *************************************************************************************/
    private testMethod static void updatePartyIdOnApplicationTest(){
        User testUser = Util02_TestData.createUser();

        //Business Custom Setting insertion
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        //Account record creation 
        Account testAccount = Util02_TestData.createGroupAccount();
        
        System.runAs(testUser){
            Test.startTest();
            	Database.insert(cs001List);
                Database.insert(testAccount);
                vlocity_ins__Party__c partyObj = Util02_TestData.createPartyforAccount(testAccount.Id);
                Database.insert(partyObj);
                vlocity_ins__Application__c applicationObj = Util02_TestData.createApplicationRec(testAccount.Id, null);
                applicationObj.vlocity_ins__Type__c = System.Label.SG42_PaperApplication;
                Database.insert(applicationObj);
            Test.stopTest();
        }
    }
    /**************************************************************************************
    Method Name : updateAccountIdOnApplicationTest
    Parameters  : None
    Return type : void
    Description : This is the testmethod for paper application creation without account id
    ***************************************************************************************/
    private testMethod static void updateAccountIdOnApplicationTest(){
        User testUser = Util02_TestData.createUser();
   
        //Business Custom Setting insertion
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        //Account record creation
        Account testAccount = Util02_TestData.createGroupAccount();
        System.runAs(testUser){
            Test.startTest();
            Database.insert(cs001List);
                Database.insert(testAccount);
                vlocity_ins__Party__c partyObj = Util02_TestData.createPartyforAccount(testAccount.Id);
                Database.insert(partyObj);
                vlocity_ins__Application__c applicationObj = Util02_TestData.createApplicationRec(NULL, partyObj.Id);
                applicationObj.vlocity_ins__Type__c = System.Label.SG42_PaperApplication;
                Database.insert(applicationObj);
            Test.stopTest();
        }
    }
}