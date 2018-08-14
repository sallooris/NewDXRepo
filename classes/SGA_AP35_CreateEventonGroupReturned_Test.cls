/************************************************************************
Class Name   : SGA_AP35_CreateEventonGroupReturned_Test
Date Created : 22-August-2017
Created By   : IDC Offshore
Description  : 1. This is a test class for SGA_AP35_CreateEventonGroupReturned
**************************************************************************/
@isTest
private class SGA_AP35_CreateEventonGroupReturned_Test{
/************************************************************************************
Method Name : searchPositiveTest
Parameters  : None
Return type : void
Description : This is the testmethod for Broker Search criteria with positive values
*************************************************************************************/
    private static testMethod void  searchPositiveTest()
    {    
        final string docName = 'Test123.txt';
        final string revNotes = 'Test Notes';
        final string docStatus = 'Missing Information';
        
        User testUser = Util02_TestData.createUser();
         
        Account testAccount = Util02_TestData.createGroupAccount();
        vlocity_ins__Application__c testApplication = Util02_TestData.createApplication();
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
                
        System.runAs(testUser)
        {        
            Test.StartTest();
                Database.insert(cs001List);
                Database.insert(cs002List);
                database.insert(testAccount);
                database.insert(testApplication);
                
                Case testCaseIns = Util02_TestData.insertSGACase(testAccount.id, testApplication.id);
                database.insert(testCaseIns);
                
                //Application_Document_Config__c record creation
                Application_Document_Config__c appConfig=Util02_TestData.createApplicationDocumentConfig();
                Database.insert(appConfig);
                
                //Application_Document_Checklist__c record creation
                Application_Document_Checklist__c docCheckList=Util02_TestData.createApplicationDocumentCheckList(appConfig.Id,testApplication.Id);
                docCheckList.Application_Document_Config__c=appConfig.Id;
                docCheckList.Application__c=testApplication.Id;
                docCheckList.Document_Name__c= docName;   
                docCheckList.Reviewer_Notes__c = revNotes;
                docCheckList.Status__c = docStatus;
                docCheckList.Case__c = testCaseIns.id;
                Database.insert(docCheckList);
                     
                testCaseIns.Stage__c = System.Label.SG56_GroupReturned;
                database.update(testCaseIns);            
            Test.StopTest();
        }
        
    }
}