/************************************************************************
Class Name   : SGA_AP26_CaseCommentHandler_Test
Date Created : 04-August-2017
Created By   : IDC Offshore
Description  : 1. This is a test class for SGA_AP26_CaseCommentHandler
**************************************************************************/
@isTest
private class SGA_AP26_CaseCommentHandler_Test{
    
    /************************************************************************************
    Method Name : caseCommentEditTest
    Parameters  : None
    Return type : void
    Broker Search criteria with positive values case comment edit 
    *************************************************************************************/
    private static testMethod void  caseCommentEditTest()
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
        
        //List<SGA_InternalUser_Email__c> createInternalUserEmailData = Util02_TestData.createInternalUserEmailData();
        System.runAs(testUser)
        {
            Test.StartTest();
            Database.insert(cs001List);
            Database.insert(cs002List);
            //database.insert(createInternalUserEmailData);
            database.insert(testAccount);
            database.insert(testApplication);
            
            
            Case testCaseIns = Util02_TestData.insertSGACase(testAccount.id, testApplication.id);
            database.insert(testCaseIns);
            
            
            //CaseComment record Creation.
            CaseComment testCaseComment = Util02_TestData.createCaseComment();
            testCaseComment.ParentId = testCaseIns.id;
            database.insert(testCaseComment);
            
            Database.SaveResult srList;
            try
            {
                srList = database.update(testCaseComment, false);
            }           
            catch(exception ex)
            {
                UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_AP26_CASECOMMENTHANDLER, SG01_Constants.AP26_DONOTEDITCASECOMMENT, SG01_Constants.BLANK, Logginglevel.ERROR);
            }
            for(Database.Error err : srList.getErrors())
            {
                System.AssertEquals(err.getMessage(), SG01_Constants.CASE_COMMENT_EDIT_ERROR);
            }
            
            Test.StopTest();
        }
    }
    
    /************************************************************************************
    Method Name : casecommentdeletionTest
    Parameters  : None
    Return type : void
    Description : This is the testmethod for Broker Search criteria with positive values
    *************************************************************************************/
    private static testMethod void  casecommentdeletionTest()
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
        //List<SGA_InternalUser_Email__c> createInternalUserEmailData = Util02_TestData.createInternalUserEmailData();
        
        System.runAs(testUser)
        {
            Test.StartTest();
            Database.insert(cs001List);
            Database.insert(cs002List);
            //database.insert(createInternalUserEmailData);
            database.insert(testAccount);
            database.insert(testApplication);
            
            Case testCaseIns = Util02_TestData.insertSGACase(testAccount.id, testApplication.id);
            database.insert(testCaseIns);
            
            
            //CaseComment record Creation.
            CaseComment testCaseComment = Util02_TestData.createCaseComment();
            testCaseComment.ParentId = testCaseIns.id;
            database.insert(testCaseComment);
            
            try{
                delete testCaseComment;
            }catch(Exception ex){}
            
            Test.StopTest();
        }
    }
}