/************************************************************************
Class Name   : SGA_AP42_AccountTeamOwner_Test
Date Created : 21-Sept-2017
Created By   : IDC Offshore
Description  : 1. This is a test class for SGA_AP42_AccountTeamOwner_Update
**************************************************************************/
@isTest
private class SGA_AP42_AccountTeamOwner_Test
{
    private static final String SYS_ADMIN = 'System Administrator';
    /****************************************************************************************************
    Method Name : searchPositiveTest
    Parameters  : None
    Return type : void
    Description : This is the testmethod for Account team criteria with positive values
    *****************************************************************************************************/
    private static testMethod void insertPositiveTest()
    {   
        User testUser = Util02_TestData.createUser();
        
        Account testAccount = Util02_TestData.createBrokerAgentAccountData();
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();   
        SGA_CS07_UserProfile__c cs003 =  new SGA_CS07_UserProfile__c();
        cs003.Profile_Name__c = SYS_ADMIN; 
        cs003.Name = SYS_ADMIN;
        
        System.runAs(testUser)
        {
            SGA_AP42_AccountTeamOwner_Update.isInsertRecursive = true;
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.insert(cs003);
            Database.insert(testAccount);
            
            User_Sales_Rep_Code__c usrc = Util02_TestData.createSalesRepCode();
            usrc.User__c = testUser.id;
            database.insert(usrc);
            
            List<AccountTeamMember> actmList = new List<AccountTeamMember>();
            AccountTeamMember actm = Util02_TestData.createAccountTeamMember();
            actm.TeamMemberRole = System.Label.SG81_Account_Executive;
            actm.AccountId = testAccount.Id;
            actm.UserId = testUser.Id;
            actmList.add(actm);
            
            AccountTeamMember actm1 = Util02_TestData.createAccountTeamMember();
            actm1.TeamMemberRole = System.Label.SG86_SalesRep;
            actm1.AccountId = testAccount.Id;
            actm1.UserId = testUser.Id;
            actmList.add(actm1);
            
            database.insert(actmList);
            
            Test.StartTest();
            list<Account> accList = new List<Account>();
            for(integer i=0;i<200;i++)
            {
                Account testGroupAccount = Util02_TestData.createGroupAccount();
                testGroupAccount.name = System.Label.SG83_Prospect+i; 
                testGroupAccount.Type = System.Label.SG83_Prospect;
                testGroupAccount.Agency_Brokerage__c = testAccount.id;
                accList.add(testGroupAccount);
                SGA_AP42_AccountTeamOwner_Update.isInsertRecursive = true;
                //database.insert(testGroupAccount);  
            }                    
            
            Account testGroupAccount2 = Util02_TestData.createGroupAccount();    
            testGroupAccount2.name = SGA_AP42_AccountTeamOwner_Update.CLS_AP42_AccountTeamOwner_Update;
            testGroupAccount2.Agency_Brokerage__c = testAccount.id;
            SGA_AP42_AccountTeamOwner_Update.isInsertRecursive = true;
            accList.add(testGroupAccount2);
            database.insert(accList);
            Test.StopTest();
            System.AssertNotEquals(testGroupAccount2.OwnerID, actm.UserId);
        }
    }
    
    /*****************************************************************************************************
    Method Name : updateScenarioTest
    Parameters  : None
    Return type : void
    Description : This is the testmethod for Account team and Owner Update criteria with positive values
    ******************************************************************************************************/    
    private static testMethod void updateScenarioTest()
    {       
        User tstUser = Util02_TestData.createUser();
        
        Account testAccount = Util02_TestData.createBrokerAgentAccountData();
        Account testAccount2 = Util02_TestData.createBrokerAgentAccountData();
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data(); 
        SGA_CS07_UserProfile__c cs003 =  new SGA_CS07_UserProfile__c();
        cs003.Profile_Name__c = SYS_ADMIN; 
        cs003.Name = SYS_ADMIN;
        
        System.runAs(tstUser)
        {
            SGA_AP42_AccountTeamOwner_Update.isInsertRecursive = true;
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.insert(cs003);
            Database.insert(testAccount);
            Database.insert(testAccount2);
            
            User_Sales_Rep_Code__c usrc = Util02_TestData.createSalesRepCode();
            usrc.User__c = tstUser.id;
            database.insert(usrc);
            
            List<AccountTeamMember> actList = new List<AccountTeamMember>();
            AccountTeamMember actm = Util02_TestData.createAccountTeamMember();
            actm.TeamMemberRole = System.Label.SG86_SalesRep;
            actm.AccountId = testAccount.Id;
            actm.UserId = tstUser.Id;
            actList.add(actm);
            
            AccountTeamMember actm1 = Util02_TestData.createAccountTeamMember();
            actm1.TeamMemberRole = System.Label.SG81_Account_Executive;
            actm1.AccountId = testAccount2.Id;
            actm1.UserId = tstUser.Id;
            actList.add(actm1);
            database.insert(actList);
            
            Test.StartTest();
                Account testGroupAccount = Util02_TestData.createGroupAccount();
                testGroupAccount.Type = System.Label.SG83_Prospect;
                testGroupAccount.Agency_Brokerage__c = testAccount.id;
                SGA_AP42_AccountTeamOwner_Update.isInsertRecursive = true;
                database.insert(testGroupAccount);
                
                testGroupAccount.Agency_Brokerage__c = testAccount2.id;
                SGA_AP42_AccountTeamOwner_Update.isInsertRecursive = true;
                database.update(testGroupAccount);                
            Test.StopTest();
            System.AssertNotEquals(testGroupAccount.OwnerID, actm.UserId);
        }       
    }
    /*****************************************************************************************************
    Method Name : UpdateTest
    Parameters  : None
    Return type : void
    Description : This is the testmethod for Account team and Owner Update for Enrolled Account
    ******************************************************************************************************/ 
    private static testMethod void updateEnrolledTest()
    {        
        User tstUser2 = Util02_TestData.createUser();
        tstUser2.BypassVR__c = true;
        database.update(tstUser2);
        
        List<account> brokerAccList = new List<account>();
        Account testAccount = Util02_TestData.createBrokerAgentAccountData();
        brokerAccList.add(testAccount);
        Account testAccount1 = Util02_TestData.createBrokerAgentAccountData();
        brokerAccList.add(testAccount1);
        Account testAccount5 = Util02_TestData.createBrokerAgentAccountData();
        brokerAccList.add(testAccount5);
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();   
        SGA_CS07_UserProfile__c cs003 =  new SGA_CS07_UserProfile__c();
        cs003.Profile_Name__c = SYS_ADMIN; 
        cs003.Name = SYS_ADMIN;
        
        System.runAs(tstUser2)
        {
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.insert(cs003);
            database.insert(brokerAccList);
            /*Database.insert(testAccount);
            Database.insert(testAccount1);
            Database.insert(testAccount5);*/
            
            User_Sales_Rep_Code__c usrc = Util02_TestData.createSalesRepCode();
            usrc.User__c = tstUser2.id;
            database.insert(usrc);
            
            List<AccountTeamMember> actmList = new List<AccountTeamMember>();
            AccountTeamMember actm = Util02_TestData.createAccountTeamMember();
            actm.TeamMemberRole = System.Label.SG80_Account_Manager;
            actm.AccountId = testAccount1.Id;
            actm.UserId = tstUser2.Id;
            actmList.add(actm);
            
            AccountTeamMember actm1 = Util02_TestData.createAccountTeamMember();
            actm1.TeamMemberRole = System.Label.SG86_SalesRep;
            actm1.AccountId = testAccount.Id;
            actm1.UserId = tstUser2.Id;
            actmList.add(actm1);
            
            AccountTeamMember actm2 = Util02_TestData.createAccountTeamMember();
            actm2.TeamMemberRole = System.Label.SG80_Account_Manager;
            actm2.AccountId = testAccount5.Id;
            actm2.UserId = tstUser2.Id;
            actmList.add(actm2);
            database.insert(actmList);
            
            Account testGroupAccount = Util02_TestData.createGroupAccount();
            testGroupAccount.Type = System.Label.SG83_Prospect;
            testGroupAccount.Agency_Brokerage__c = testAccount1.id;
            database.insert(testGroupAccount);
            
            testGroupAccount.Agency_Brokerage__c = testAccount.id;
            database.update(testGroupAccount);
            
            Account testGroupAccount4 = Util02_TestData.createGroupAccount();
            testGroupAccount4.Type = System.Label.SG_82_Enrolled;
            testGroupAccount4.Agency_Brokerage__c = testAccount5.id;
            database.insert(testGroupAccount4);
            System.AssertEquals(actm2.AccountId, testAccount5.Id);
        }
    }
}