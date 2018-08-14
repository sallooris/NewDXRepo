/*************************************************************
Class Name   : CaseCommentBeforeInsertAndUpdate_Test 
Date Created : 10-Aug-2015
Created By   : Kishore Jonnadula
Description  : This class is used for testing Case Comments should not be public
*************************************************************/
@isTest
public with sharing class CaseCommentBeforeInsertAndUpdate_Test {

private static testMethod void testCaseCommentsnotPublic()
  {
      User testUser=BR_Util01_TestMethods.CreateTestUser();
      insert(testUser);
      
      Case testCase = BR_Util01_TestMethods.CreateCase();
      //testCase.ownerId = testUser.id;
      //insert(testCase);
      
      System.runAs(testUser){
         Test.startTest();
           try{
               insert(testCase);
                   
               CaseComment cc = new CaseComment(IsPublished = true, CommentBody= 'Test Case Comment');
               cc.ParentId = testCase.Id;
               insert(cc);
           }catch(DmlException ex){
               System.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION, ex.getDmlType(0));
               System.assertEquals('Please uncheck \'Public\' checkbox.', ex.getDmlMessage(0));
           }
         Test.stopTest();
     }
  }
    
    private static testMethod void testCaseCommentsnotEdit()
  {
      User testUser=BR_Util01_TestMethods.CreateTestUser();
      insert(testUser);
      
      Case testCase = Util02_TestData.createSGInstallationCase();
      System.runAs(testUser){
         Test.startTest();
           try{
               insert(testCase);
                   
               CaseComment cc = new CaseComment(IsPublished = true, CommentBody= 'Test Case Comment');
               cc.ParentId = testCase.Id;
               insert(cc);
               
               cc.CommentBody = 'Changing body';
               update cc;
           }catch(DmlException ex){
               
           }
         Test.stopTest();
     }
  }
}