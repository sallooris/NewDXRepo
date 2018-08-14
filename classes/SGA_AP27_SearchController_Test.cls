/************************************************************************
Class Name   : SGA_AP27_SearchController_Test
Date Created : 08-August-2017
Created By   : IDC Offshore
Description  : 1. This is a test class for SGA_AP27_searchController
**************************************************************************/
@isTest
private class SGA_AP27_SearchController_Test{

    static final string PGREF = '/apex/SGA_VF10_CustomSearch';
/************************************************************************************
Method Name : searchPositiveTest
Parameters  : None
Return type : void
Description : This is the testmethod for Broker Search criteria with positive values
*************************************************************************************/
    private static testMethod void searchPositiveTest()
    {  
        User testUser = Util02_TestData.createUser();
        //Account data creation
        Account testAccount = Util02_TestData.createGroupAccount();
        //Business Custom Setting insertion
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        //Record Type Assignment Custom Setting insertion
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        
        
        System.runAs(testUser)
        {
            Database.insert(cs001List);
            Database.insert(cs002List);
            database.insert(testAccount);
            
            Test.StartTest();  
                SGA_AP27_searchController sct = new SGA_AP27_searchController();
                sct.TINText = Util02_TestData.createGroupAccount().BR_Encrypted_TIN__c;
                sct.EINText = Util02_TestData.createGroupAccount().Employer_EIN__c;
                sct.NameText = Util02_TestData.createGroupAccount().Name;
                sct.doSearch();
                sct.ClearFields();
            Test.StopTest();
            
            
            PageReference pageRef = new PageReference(PGREF);
            System.AssertEquals(PGREF, pageRef.getUrl());
        }             
    }
    

}