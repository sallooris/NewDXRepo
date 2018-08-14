/************************************************************************
Class Name   : SGA_AP02_MyProfileController_Test
Date Created : 05-May-2017
Created By   : IDC Offshore
Description  : 1. This is a test class for SGA_AP02_MyProfileController
**************************************************************************/
@isTest
private class SGA_AP02_MyProfileController_Test {
    
    /************************************************************************************
Method Name : getUsersContactIdTest
Parameters  : None
Return type : void
Description : This is the testmethod to get user contact Id
*************************************************************************************/
    private static testMethod void  getUsersContactIdTest(){
        User testUser = Util02_TestData.createUser();
        List<CS001_RecordTypeBusinessTrack__c> recordTypeBusinessTrackList = Util02_TestData.createCS001Data();
        System.runAs(testUser){
            Database.insert(recordTypeBusinessTrackList);
            Account testAccount = new Account(Name = SG01_Constants.ACCNAME_TEST);
            testAccount.RecordTypeId=[Select id from RecordType where sObjectType =: SG01_Constants.SOBJECT_TEST 
                                      and Name =: SG01_Constants.RNAME_TEST LIMIT 1].id;
            Database.insert(testAccount);
            Contact contact1 = new Contact(FirstName = SG01_Constants.FNAME_TEST, Lastname = SG01_Constants.LNAME_TEST,
                                           AccountId = testAccount.Id, Email = System.now().millisecond() + SG01_Constants.EMAIL_TEST);
            Database.insert(contact1); //Create contact
            Profile portalProfile = [SELECT Id FROM Profile where name =: SG01_Constants.PNAME_TEST Limit 1];
            User user1 = new User(Username = System.now().millisecond() + SG01_Constants.USERNAME_TEST,
                                  ContactId = contact1.Id, ProfileId = portalProfile.Id,
                                  Alias = SG01_Constants.ALIAS_TEST, Email = SG01_Constants.USERNAME_TEST,
                                  EmailEncodingKey = SG01_Constants.ENCODING_TEST,
                                  LastName = SG01_Constants.LNAME_TEST, CommunityNickname = SG01_Constants.NICKNAME_TEST,
                                  TimeZoneSidKey = SG01_Constants.TIMEZONE_TEST, LocaleSidKey = SG01_Constants.LOCALE_TEST,
                                  LanguageLocaleKey = SG01_Constants.LANG_TEST);
            Database.insert(user1); //Create user
            String result = null;
            Test.startTest();
            System.runAs(user1){
                result = SGA_AP02_MyProfileController.getUsersContactId();
            }
            Test.stopTest();
            System.assert(result != null);
        }
    }
    /************************************************************************************
Method Name : getUsersContactIdTest2
Parameters  : None
Return type : void
Description : This is the testmethod to get user Id
*************************************************************************************/
    private static testMethod void  getUsersContactIdTest2(){
        User testUser = Util02_TestData.createUser();
        List<CS001_RecordTypeBusinessTrack__c> recordTypeBusinessTrackList = Util02_TestData.createCS001Data();
        System.runAs(testUser){
            Database.insert(recordTypeBusinessTrackList);
            Account testAccount = new Account(Name = SG01_Constants.ACCNAME_TEST);
            testAccount.RecordTypeId=[Select id from RecordType where sObjectType =: SG01_Constants.SOBJECT_TEST 
                                      and Name =: SG01_Constants.RNAME_TEST LIMIT 1].id;
            Database.insert(testAccount); //Create account
            Contact contact1 = new Contact(
                FirstName = SG01_Constants.FNAME_TEST, Lastname = SG01_Constants.LNAME_TEST,
                AccountId = testAccount.Id, Email = System.now().millisecond() + SG01_Constants.EMAIL_TEST
            );
            Database.insert(contact1); //Create contact
            //Create user
            Profile portalProfile = [SELECT Id FROM Profile where name =: SG01_Constants.PNAME_TEST Limit 1];
            User user1 = new User(Username = System.now().millisecond() + SG01_Constants.USERNAME_TEST,
                                  ContactId = contact1.Id, ProfileId = portalProfile.Id,
                                  Alias = SG01_Constants.ALIAS_TEST, Email = SG01_Constants.USERNAME_TEST,
                                  EmailEncodingKey = SG01_Constants.ENCODING_TEST,
                                  LastName = SG01_Constants.LNAME_TEST,
                                  CommunityNickname = SG01_Constants.NICKNAME_TEST,
                                  TimeZoneSidKey = SG01_Constants.TIMEZONE_TEST,
                                  LocaleSidKey = SG01_Constants.LOCALE_TEST,
                                  LanguageLocaleKey = SG01_Constants.LANG_TEST
                                 );
            Database.insert(user1);
            String result = null;
            Test.startTest();
            result = SGA_AP02_MyProfileController.getUsersContactId();
            Test.stopTest();
            System.assert(result != null);
        }
    }
}