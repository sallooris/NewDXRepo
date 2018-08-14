/*************************************************************
Class Name   : E2C_Util_TestDataFactory
Date Created : 12-JUN-16
Created By   : Wendy Kelley
Description  : Utility class for creating test data for test classes
**************************************************************/
public class E2C_Util_TestDataFactory {
    
    /*
    Method Name : createUserList
    Parameter   : Integer, Profile (nillable), boolean
    Return type : List<User>
    Description : Method for creating test User records, set isInsert to true to perform insert
    */
    public static List<User> createUserList(Integer num, Profile testProfile, boolean isInsert) {
        List<User> usrList = new List<User>();

        if(testProfile == null) {
            testProfile = [SELECT Id FROM Profile WHERE Name='System Administrator' Limit 1]; 
        }

        User usr = null;
        for(Integer i = 0; i < num; i++) {
            usr = new User(Alias = 'standt' + i, Email='standarduser@testorg.com', 
                                               EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                               LocaleSidKey='en_US', ProfileId = testProfile.Id,enabled_to_work__c ='CA', 
                                               TimeZoneSidKey='America/Los_Angeles', UserName='standarduser' + i + '@testorg111.com');
            usrList.add(usr);
        }

        if(isInsert) {
            insert usrList;
        }                 
        return usrList;
    }
    
    /*
    Method Name : createCaseList
    Parameter   : Integer, boolean
    Return type : List<Case>
    Description : Method for creating test Case records, set isInsert to true to perform insert
    */
    public static List<Case> createCaseList(Integer num, boolean isInsert) {
        List<Case> caseList = new List<Case>();
        Case c = null;
        for(Integer i = 0; i < num; i++) {
            c = new Case(
                Origin = 'Email',
                Priority = 'High',
                BR_State__c = 'CA',
                BR_Department__c = 'Sales Support',
                BR_Line_of_Business__c = 'Individual',
                BR_Category__c = 'Billing',
                BR_Tech_Case_RoutingAddress__c = 'testroutingemail@test.com',
                BR_Product_Type__c = 'Medical'
            );
            caseList.add(c);
        }

        if(isInsert) {
            insert caseList;
        }
        return caseList;
    }
    
    /*
    Method Name : createEmailMessageList
    Parameter   : Case, Integer, boolean
    Return type : List<EmailMessage>
    Description : Method for creating test Email Message records, set isInsert to true to perform insert
    */
    public static List<EmailMessage> createEmailMessageList(Case caseRec, Integer num, boolean isInsert) {
        List<EmailMessage> emList = new List<EmailMessage>();
        if(caseRec != null) {         
            EmailMessage msg = null;
            for(Integer i = 0; i < num; i++) {
                msg = new EmailMessage(
                    FromAddress = 'test@test.com',
                    Subject = 'Test Case ' + i,
                    ParentId = caseRec.Id
                );
                emList.add(msg);
            }

            if(isInsert) {
                insert emList;
            }
        }
        return emList;
    }
    
}