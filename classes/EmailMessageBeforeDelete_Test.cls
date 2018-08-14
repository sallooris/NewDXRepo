/*************************************************************
Class Name   : EmailMessageBeforeDelete_Test
Date Created : 13-JUN-16
Created By   : Wendy Kelley
Description  : Test Class for EmailMessageBeforeDelete trigger
**************************************************************/
@isTest
private class EmailMessageBeforeDelete_Test {
    
    // Method to setup test data to be used across test methods
    static void setupData() {
        List<User> usrList = E2C_Util_TestDataFactory.createUserList(2, null, true);
        usrList[0].BypassVR__c = false;
        usrList[1].BypassVR__c = true;
        update usrList;

    }
    
    /* Test delete when User record's BypassVR__c is set to false
    static testMethod void testWithoutBypassVR() {
        // Implement test code
        setupData();
        User usr = [SELECT Id, BypassVR__c from User where BypassVR__c = false LIMIT 1];
        
        boolean isValidationError = false;
        String validationErrMsg = '';
        Test.startTest();
            System.runAs(usr) {
                try{
                    Case caseRec = E2C_Util_TestDataFactory.createCaseList(1, true)[0];
                    List<EmailMessage> emList = E2C_Util_TestDataFactory.createEmailMessageList(caseRec, 1, true);
                    EmailMessage emRec = [SELECT Id from EmailMessage LIMIT 1];
                    delete emRec;
                }
                catch(DMLException e) {
                    isValidationError = e.getDmlType(0) == StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION ? true : false;
                    validationErrMsg = e.getDmlMessage(0);
                }
            }
        Test.stopTest();

        // validation error
        System.assertEquals(true, isValidationError);
        // validation error message
        System.assertEquals(Label.E2C_EmailDeleteError, validationErrMsg);
    }
    */
    // Test delete when User record's BypassVR__c is set to true
    static testMethod void testWithBypassVR() {
        // Implement test code
        setupData();
        User usr = [SELECT Id, BypassVR__c from User where BypassVR__c = true and isactive = true LIMIT 1];
        
        boolean isValidationError = false;
        String validationErrMsg = '';
        Test.startTest();
            System.runAs(usr) {
                try{
                    Case caseRec = E2C_Util_TestDataFactory.createCaseList(1, true)[0];
                    List<EmailMessage> emList = E2C_Util_TestDataFactory.createEmailMessageList(caseRec, 1, true);
                    EmailMessage emRec = [SELECT Id from EmailMessage LIMIT 1];
                    delete emRec;
                }
                catch(DMLException e) {
                    isValidationError = e.getDmlType(0) == StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION ? true : false;
                    validationErrMsg = e.getDmlMessage(0);
                }
            }
        Test.stopTest();

        // no validation error
        System.assertEquals(false, isValidationError);
        // no validation error message
        System.assertEquals('', validationErrMsg);
    }
}