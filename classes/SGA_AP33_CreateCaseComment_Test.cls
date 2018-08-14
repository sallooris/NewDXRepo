/************************************************************************
Class Name   : SGA_AP33_CreateCaseComment_Test
Date Created : 17-August-2017
Created By   : IDC Offshore
Description  : 1. This is a test class for SGA_AP33_CreateCaseComment
**************************************************************************/
@isTest
private class SGA_AP33_CreateCaseComment_Test{

/************************************************************************************
Method Name : searchPositiveTest
Parameters  : None
Return type : void
Description : This is the testmethod for Broker Search criteria with positive values
*************************************************************************************/
    private static testMethod void  searchPositiveTest()
    {   
         User testUser = Util02_TestData.createUser();
         
         //Account data creation
         Account testAccount = Util02_TestData.createGroupAccount();
        //Application record creation
        vlocity_ins__Application__c testApplication = Util02_TestData.createApplication();
        //Business Custom Setting insertion
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        //Record Type Assignment Custom Setting insertion
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        
        System.runAs(testUser)
        {
             Database.insert(cs001List);
             Database.insert(cs002List);
             database.insert(testAccount);
             database.insert(testApplication);
             
             Case testCaseIns = Util02_TestData.insertSGACase(testAccount.id, testApplication.id);
             database.insert(testCaseIns);
             
             CaseComment testCaseComment = Util02_TestData.createCaseComment();
             testCaseComment.IsPublished = True;
                 
             Test.StartTest();
                 ApexPages.StandardController sc = new ApexPages.standardController(testCaseIns);
                 
                 SGA_AP33_CreateCaseComment ccm = new SGA_AP33_CreateCaseComment(sc);
                 
                 SGA_AP33_CreateCaseComment.createCaseComment(testCaseComment, testCaseIns.Id);                 
                 
            Test.StopTest();
            
            System.AssertEquals(testCaseComment.IsPublished , True);
        }
    
    }
}