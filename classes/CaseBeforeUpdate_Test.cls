/*************************************************************
Class Name   : CaseBeforeUpdate_Test 
Date Created : 10-Aug-2015
Created By   : Kishore Jonnadula
Description  : This class is used for testing Case Status is closed, if there is any open tasks on that case.
Change History:
1. Modified by Rayson Landeta. Added test methods for checking record type change when Case is reopened
2. Modified by Wendy Kelley. Added test methods for testing validation for case ownership when updating a case
*************************************************************/
@isTest
public with sharing class CaseBeforeUpdate_Test {

private static testMethod void testCaseStatusChangetoClosed()
  {
      List<CS001_RecordTypeBusinessTrack__c> cs001List = BR_Util01_TestMethods.createBusinessTrack();
      insert cs001List; 
      User testUser=BR_Util01_TestMethods.CreateTestUser();
      insert testUser;
      System.runAs(testUser){
        Account b = BR_Util01_TestMethods.CreateBrokerAccount();
        insert b;

        List<AssignmentRule> ar = [SELECT Id FROM AssignmentRule WHERE SObjectType = 'Case' AND Active = true];

        Case testCase = BR_Util01_TestMethods.CreateCase();
        insert testCase;

        Task testTask = BR_Util01_TestMethods.CreateTask();
          testTask.WhatId = testCase.Id;
          //testTask.Tech_Businesstrack__c='BROKER';
        insert(testTask);
        
        Test.startTest();
          try{
              testCase.Status = 'Closed';
              Update testCase;
          }catch(DmlException ex){
              //System.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION, ex.getDmlType(0));
              //System.assertEquals('Please Check, Cannot close the case until the open activities are closed.', ex.getDmlMessage(0));
          }
        Test.stopTest();
      }
  }
  
  // Test reopen case with no previous record type and no Department specified
   static testMethod void reopenCaseTest() {
        
        User testUser=BR_Util01_TestMethods.CreateTestUser();
        insert(testUser);
        system.runAs(testUser){
            Case c = new Case(Origin = 'Email', Subject = 'Test Email To Case', Status = 'New', OwnerId = testUser.Id);
            
            //create case 
            insert c;

            //update case status
            c.Status = 'Closed';
            c.Case_Record_Type_before_Closing__c = '';
            Update c;

            Test.startTest();  
            try
            {
                c.Status = 'Closed - Reopen';
                Update c;
            }
            catch(Exception ex){
                  System.debug('Exception in Test Class'+ex.getMessage());
            }
            Test.stopTest(); 
            Id bCaseId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Broker Case').getRecordTypeId();    
            Case emailCase =  [SELECT Id, BR_Tech_Case_RoutingAddress__c,RecordtypeId FROM CASE WHERE ID =: c.Id];
            
            //record type should be 'Broker Case'
            //System.AssertEquals(bCaseId, emailCase.RecordtypeId);
        }
    }
    
    // Test reopen case with no previous record type and Department is 'BTS'
    static testMethod void reopenCaseTest2() {
        
        User testUser=BR_Util01_TestMethods.CreateTestUser();
        insert(testUser);
        system.runAs(testUser){
            Case c = new Case(Origin = 'Email', Subject = 'Test Email To Case', Status = 'New', OwnerId = testUser.Id);
            //create case 
            insert c;

            //update case status
            c.Status = 'Closed';
            c.Case_Record_Type_before_Closing__c = '';
            c.BR_Department__c = 'BTS';
            Update c;
            
            Test.startTest();  
            try
            {
                c.Status = 'Closed - Reopen';
                Update c;
            }
            catch(Exception ex){
                  System.debug('Exception in Test Class'+ex.getMessage());
            }
            Test.stopTest(); 
            Id bCaseId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('BTS Case').getRecordTypeId();    
            Case emailCase =  [SELECT Id, BR_Tech_Case_RoutingAddress__c,RecordtypeId FROM CASE WHERE ID =: c.Id];

            //record type should be 'BTS Case'
            //System.AssertEquals(bCaseId, emailCase.RecordtypeId);
        }
    }
    
    // Test reopen case with previous record type
    static testMethod void reopenCaseTest3() {
        
        User testUser=BR_Util01_TestMethods.CreateTestUser();
        insert(testUser);
        system.runAs(testUser){
        Id btsCaseId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('BTS Case').getRecordTypeId();
            Case c = new Case(Origin = 'Email', Subject = 'Test Email To Case', Status = 'New', OwnerId = testUser.Id,  RecordTypeId = btsCaseId);
            // create case 
            insert c;

            // update case status
            c.Status = 'Closed';
            c.BR_Department__c = 'BTS';
            Update c;
            Test.startTest();  
            try
            {
                c.Status = 'Closed - Reopen';
                Update c;
            }
            catch(Exception ex){
                  System.debug('Exception in Test Class'+ex.getMessage());
            }
            Test.stopTest(); 
            Case emailCase =  [SELECT Id, BR_Tech_Case_RoutingAddress__c,RecordtypeId,Case_Record_Type_before_Closing__c  FROM CASE WHERE ID =: c.Id];

            // new record type should be equal to Case Record Type Before Closing
            //System.AssertEquals(emailCase.Case_Record_Type_before_Closing__c, emailCase.RecordTypeId);
        }
    }

    // Test validation rule when updating Case record owned by another user
    static testMethod void testValidationRule1() {
        
        //create users
        List<User> usrList = E2C_Util_TestDataFactory.createUserList(2, null, true);
        Case testCase = BR_Util01_TestMethods.CreateCase();
        
        Test.startTest();  
            try
            {
              // Create case as 1st user 
              System.runAs(usrList[0]) {
                // create case
                insert testCase;
              }

              // Update case as 2nd user
              System.runAs(usrList[1]) {
                // update case status
                testCase.Status = 'Closed';
                update testCase;
              }
            }
            catch(DmlException ex){
              //validation error
              //System.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION, ex.getDmlType(0));
              //System.assertEquals('Please take ownership and save.', ex.getDmlMessage(0));
            }
        Test.stopTest();         
    }

    // Test validation rule when Default Broker Case Owner User updates Case record created by another user
    static testMethod void testValidationRule2() {
        
        //create users
        List<User> usrList = E2C_Util_TestDataFactory.createUserList(2, null, true);
        Case testCase = BR_Util01_TestMethods.CreateCase();
        
        CS003_BrokerEmail2CaseDefaultOwner__c cs = new CS003_BrokerEmail2CaseDefaultOwner__c (BR_CaseDefaultOwnerId__c = usrList[1].Id);
        insert cs;

        boolean isValidationError = false;
        Test.startTest();  
            try
            {
              // Create case as 1st user 
              System.runAs(usrList[0]) {
                // create case
                insert testCase;
              }

              // Update case as Default Broker Case Owner User
              System.runAs(usrList[1]) {
                // update case status
                testCase.Status = 'Closed';
                update testCase;
              }
            }
            catch(DmlException ex){
              if(ex.getDmlMessage(0) == 'Please take ownership and save.') {
                isValidationError = true;
              }
            }

            Case uCase = [Select Id, Status from Case where Id =: testCase.Id];
            //no validation error
            //System.assertEquals(false, isValidationError);
            //case status is updated
            //System.assertEquals('Closed', uCase.Status);

        Test.stopTest();         
    }

    // Test validation rule when Case ownership has been changed
    static testMethod void testValidationRule3() {
        
        //create users
        List<User> usrList = E2C_Util_TestDataFactory.createUserList(2, null, true);
        Case testCase = BR_Util01_TestMethods.CreateCase();
        
        boolean isValidationError = false;
        Test.startTest();  
            try
            {
              // Create case as 1st user 
              System.runAs(usrList[0]) {
                // create case
                insert testCase;
              }

              // Change case ownership
              System.runAs(usrList[1]) {
                // update case owner
                testCase.OwnerId = usrList[1].Id;
                update testCase;
              }
            }
            catch(DmlException ex){
              if(ex.getDmlMessage(0) == 'Please take ownership and save.') {
                isValidationError = true;
              }
            }
        Test.stopTest();

            Case uCase = [Select Id, OwnerId from Case where Id =: testCase.Id];
            //no validation error
            //System.assertEquals(false, isValidationError);
            //ownership is updated
            //System.assertEquals(usrList[1].Id, uCase.OwnerId);                 
    }

    // Test validation rule when updating Case as Spam (BR_Is_Spam__c = true)
    static testMethod void testValidationRule4() {
        
        //create users
        List<User> usrList = E2C_Util_TestDataFactory.createUserList(2, null, true);
        Case testCase = BR_Util01_TestMethods.CreateCase();
        
        boolean isValidationError = false;
        Test.startTest();  
            try
            {
              // Create case as 1st user 
              System.runAs(usrList[0]) {
                // create case
                testCase.Origin = 'Email';
                insert testCase;
              }

              System.runAs(usrList[1]) {
                // check Is Spam field
                testCase.BR_Is_Spam__c = true;
                update testCase;
              }
            }
            catch(DmlException ex){
              if(ex.getDmlMessage(0) == 'Please take ownership and save.') {
                isValidationError = true;
              }
            }
        Test.stopTest();

            Case uCase = [Select Id, BR_Is_Spam__c from Case where Id =: testCase.Id];
            //no validation error
            //System.assertEquals(false, isValidationError);
            //case is updated
            //System.assertEquals(true, uCase.BR_Is_Spam__c);                 
    }

    // Test validation rule when User record's BypassVR__c field is set to true
    static testMethod void testValidationRule5() {
        
        //create users
        List<User> usrList = E2C_Util_TestDataFactory.createUserList(2, null, true);
        usrList[1].BypassVR__c = true;
        update usrList[1];

        Case testCase = BR_Util01_TestMethods.CreateCase();
        
        boolean isValidationError = false;
        Test.startTest();  
            try
            {
              // Create case as 1st user 
              System.runAs(usrList[0]) {
                // create case
                insert testCase;
              }

              System.runAs(usrList[1]) {
                // update case
                testCase.Description = 'Test New Description';
                update testCase;
              }
            }
            catch(DmlException ex){
              if(ex.getDmlMessage(0) == 'Please take ownership and save.') {
                isValidationError = true;
              }
            }
        Test.stopTest();

            Case uCase = [Select Id, Description from Case where Id =: testCase.Id];
            //no validation error
            //System.assertEquals(false, isValidationError);
            //case is updated
            //System.assertEquals('Test New Description', uCase.Description);                 
    }

    //Test update of New_Email_Timestamp__c field on case when a new e-mail is received for Case
    static testMethod void testNewEmailTimeStamp() {
        
        User testUser=BR_Util01_TestMethods.CreateTestUser();
        insert(testUser);
        system.runAs(testUser){
            Id btsCaseId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('BTS Case').getRecordTypeId();
            Case c = new Case(Origin = 'Email', Subject = 'Test Email To Case', Status = 'New', OwnerId = testUser.Id, RecordTypeId = btsCaseId);
            insert c;

            // Create new e-mail for case
            EmailMessage[] newEmail = new EmailMessage[0];
            newEmail.add(new EmailMessage(FromAddress = 'nagarjuna.kaipu@accenture.com', Incoming = True, ToAddress= 'kishore.jonnadula@accenture.com', Subject = 'Email to Case Test email', TextBody = 'Test', ParentId = c.Id, CcAddress = 'boss.redone@gmail.com', BccAddress = 'sir.redone@gmail.com'));
            
            Test.startTest();  
            try
            {
                insert newEmail;
            }
            catch(Exception ex){
                System.debug('Exception in Test Class'+ex.getMessage());
            }
            Test.stopTest(); 
                
            Case emailCase = [SELECT Id, Status, OwnerId, New_Email_Timestamp__c FROM CASE WHERE ID =: c.Id];
            
            //Check if New Email Timestamp field was updated
            //System.assertEquals(emailCase.New_Email_Timestamp__c.format('h:mm a'), DateTime.now().format('h:mm a'));
        }
    }
}