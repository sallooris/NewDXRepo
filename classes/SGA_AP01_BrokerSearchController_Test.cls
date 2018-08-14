/************************************************************************
Class Name   : SGA_AP01_BrokerSearchController_Test
Date Created : 06-April-2017
Created By   : IDC Offshore
Description  : 1. This is a test class for SGA_AP01_BrokerSearchController
**************************************************************************/
@isTest
private class SGA_AP01_BrokerSearchController_Test {
    public static final string TAX_ID = '1234';
    /************************************************************************************
    Method Name : searchPositiveTest
    Parameters  : None
    Return type : void
    Description : This is the testmethod for Broker Search criteria with positive values
    *************************************************************************************/
    private static testMethod void  searchPositiveTest(){
        User testUser = Util02_TestData.createUser();
        
        //Account record creation
        Account testAccount = Util02_TestData.createGroupAccount();
        testAccount.vlocity_ins__TaxID__c = TAX_ID;
        //Application record creation
        vlocity_ins__Application__c testApplication = Util02_TestData.createApplication();
        //Business Custom Setting insertion
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        //Record Type Assignment Custom Setting insertion
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        //Opportunity record creation
        Opportunity testOpp = Util02_TestData.createGrpAccOpportunity();
        //Quote record creation
        Quote testQuote = Util02_TestData.createQuote();
        System.runAs(testUser){
            Test.startTest();
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.insert(testAccount);
            testOpp.accountId = testAccount.Id;
            Database.insert(testOpp);
            testQuote.OpportunityId=testOpp.Id;
            Database.insert(testQuote);
            Database.insert(testApplication);
            //fetching the quote number from quote record
            //String quoteNumber = [select QuoteNumber from Quote where id=:testQuote.Id LIMIT 1].QuoteNumber;
            Test.stopTest();
            //checking the records created successfully
            System.assertNotEquals(null, testAccount.Id);
            System.assertNotEquals(null, testOpp.Id);
            System.assertNotEquals(null, testQuote.Id);
            System.assertNotEquals(null, testApplication.Id);
            System.assertNotEquals(null, testUser.Id);
            
            SGA_AP01_BrokerSearchController.getAccountSearchResults(
                testAccount.Name,testAccount.Group_Number__c,testAccount.vlocity_ins__TaxID__c);
            SGA_AP01_BrokerSearchController.getUserDetails();
        }
        
    }
    
    /************************************************************************************
    Method Name : searchNegativeTest
    Parameters  : None
    Return type : void
    Description : This is the testmethod for Broker Search criteria with negative values
    *************************************************************************************/
    private static testMethod void  searchNegativeTest(){
        User testUser = Util02_TestData.createUser();
        List<Account> accountList = new List<Account>();
        System.runAs(testUser){
            accountList = SGA_AP01_BrokerSearchController.getAccountSearchResults(SG01_Constants.SPACE,SG01_Constants.SPACE,SG01_Constants.SPACE);
        }
        System.assert(accountList != null);
    }
}