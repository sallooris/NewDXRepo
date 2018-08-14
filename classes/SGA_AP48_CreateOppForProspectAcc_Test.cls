/************************************************************************
Class Name   : SGA_AP48_CreateOppForProspectAcc_Test
Date Created : 22-Sept-2017
Created By   : IDC Offshore
Description  : 1. This is a test class for SGA_AP48_CreateOppForProspectAccount
**************************************************************************/
@isTest
private class SGA_AP48_CreateOppForProspectAcc_Test
{
    private static final String ACC_NAME = 'Test Account';
    private static final String MED_PRD = 'Medical';
    private static final String ENROLLED = 'Enrolled';
    private static final String NEW_SALES = 'New Sales';
    private static final String SYS_ADMIN = 'System Administrator';
    
/************************************************************************************
    Method Name : createOppForProspectTest
    Parameters  : None
    Return type : void
    Description : This is the testmethod for createOppForProspect with positive values
*************************************************************************************/
private static testMethod void  createOppForProspectTest() {   
    User testUser = Util02_TestData.createUser();
    testUser.BypassVR__c = true;
    Update testUser;
    Account testAgencyAccount = Util02_TestData.createBrokerAgentAccountData();
    List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
    List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data(); 
    SGA_CS07_UserProfile__c cs003 =  new SGA_CS07_UserProfile__c();
    cs003.Profile_Name__c = SYS_ADMIN;   
    cs003.Name = SYS_ADMIN; 
    System.runAs(testUser)
    {   
     Database.insert(cs001List);
     Database.insert(cs002List);
     Database.insert(cs003);
     Database.insert(testAgencyAccount);
     List<AccountTeamMember> actmList = new List<AccountTeamMember>();
     AccountTeamMember actm = Util02_TestData.createAccountTeamMember();
     actm.TeamMemberRole = System.Label.SG81_Account_Executive;
     actm.AccountId = testAgencyAccount.Id;
     actm.UserId = testUser.Id;
     actmList.add(actm);
     AccountTeamMember actm1 = Util02_TestData.createAccountTeamMember();
     actm1.TeamMemberRole = System.Label.SG86_SalesRep;
     actm1.AccountId = testAgencyAccount.Id;
     actm1.UserId = testUser.Id;
     actmList.add(actm1);
     database.insert(actmList); 
     Account testGroupAccount = Util02_TestData.createGroupAccount();
     testGroupAccount.name ='Test Acc'; 
     testGroupAccount.Type = System.Label.SG83_Prospect;
     testGroupAccount.Agency_Brokerage__c = testAgencyAccount.id;
     SGA_AP42_AccountTeamOwner_Update.isInsertRecursive = false;
     Test.StartTest();
     database.insert(testGroupAccount); 
     Test.StopTest();
     List<Opportunity> opListCreated=[Select Id,AccountId,StageName from Opportunity Where AccountId =: testGroupAccount.Id ];
     System.assertEquals(1,opListCreated.size()); 
    }
}
    
/************************************************************************************
    Method Name : createOppForProspectBulkTest
    Parameters  : None
    Return type : void
    Description : This is the testmethod for createOppForProspect in Bulk operation
    *************************************************************************************/
private static testMethod void  createOppForProspectBulkTest(){   
    User testUser = Util02_TestData.createUser();
    Account testAgencyAccount = Util02_TestData.createBrokerAgentAccountData();
    List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
    List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();   
    List<Account> grpAccListBulk = new List<Account>();
    SGA_CS07_UserProfile__c cs003 =  new SGA_CS07_UserProfile__c();
    cs003.Profile_Name__c = SYS_ADMIN;
    cs003.Name = SYS_ADMIN;
    System.runAs(testUser) {
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.insert(cs003);
            Database.insert(testAgencyAccount);
            List<AccountTeamMember> actmList = new List<AccountTeamMember>();
            AccountTeamMember actm = Util02_TestData.createAccountTeamMember();
            actm.TeamMemberRole = System.Label.SG81_Account_Executive;
            actm.AccountId = testAgencyAccount.Id;
            actm.UserId = testUser.Id;
            actmList.add(actm);
            AccountTeamMember actm1 = Util02_TestData.createAccountTeamMember();
            actm1.TeamMemberRole = System.Label.SG86_SalesRep;
            actm1.AccountId = testAgencyAccount.Id;
            actm1.UserId = testUser.Id;
            actmList.add(actm1);
            Test.StartTest();
            database.insert(actmList); 
            For(Integer i=0;i<200;i++){
                Account testGroupAccount = Util02_TestData.createGroupAccount();
                testGroupAccount.name ='Test Acc'+i; 
                testGroupAccount.Type = System.Label.SG83_Prospect;
                testGroupAccount.Agency_Brokerage__c = testAgencyAccount.id;
                grpAccListBulk.add(testGroupAccount);
            }
            SGA_AP42_AccountTeamOwner_Update.isInsertRecursive = false;
            database.insert(grpAccListBulk); 
            Test.StopTest();
            List<Opportunity> opListCreated=[Select Id,AccountId,StageName from Opportunity Where Account.Agency_Brokerage__c =: testAgencyAccount.Id ];
            System.assertEquals(200,opListCreated.size());
         }
 }

/************************************************************************************
    Method Name : createOppForProspectNegTest
    Parameters  : None
    Return type : void
    Description : This is the Negative testmethod for createOppForProspect to check exception scenario
*************************************************************************************/
private static testMethod void  createOppForProspectNegTest() {   
        User testUser = Util02_TestData.createUser();
        testUser.BypassVR__c = true;
        Update testUser;
        Account testAgencyAccount = Util02_TestData.createBrokerAgentAccountData();
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data(); 
        SGA_CS07_UserProfile__c cs003 =  new SGA_CS07_UserProfile__c();
        cs003.Profile_Name__c = SYS_ADMIN;  
        cs003.Name = SYS_ADMIN;
        System.runAs(testUser){   
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.insert(cs003);
            Database.insert(testAgencyAccount);
            List<AccountTeamMember> actmList = new List<AccountTeamMember>();
            AccountTeamMember actm = Util02_TestData.createAccountTeamMember();
            actm.TeamMemberRole = System.Label.SG81_Account_Executive;
            actm.AccountId = testAgencyAccount.Id;
            actm.UserId = testUser.Id;
            actmList.add(actm);
            AccountTeamMember actm1 = Util02_TestData.createAccountTeamMember();
            actm1.TeamMemberRole = System.Label.SG86_SalesRep;
            actm1.AccountId = testAgencyAccount.Id;
            actm1.UserId = testUser.Id;
            actmList.add(actm1);
            database.insert(actmList);
            Account testGroupAccount = Util02_TestData.createGroupAccount();
            testGroupAccount.name ='Test Acc'; 
            testGroupAccount.Type = System.Label.SG83_Prospect;
            testGroupAccount.Agency_Brokerage__c = testAgencyAccount.id;
            SGA_AP42_AccountTeamOwner_Update.isInsertRecursive = false;
            database.insert(testGroupAccount);
            testGroupAccount.Type = ENROLLED;
            database.update(testGroupAccount);
            SGA_AP42_AccountTeamOwner_Update.isUpdateRecursive = false;
             testGroupAccount.Type = System.Label.SG83_Prospect;
            Test.StartTest();
           // try{
                database.update(testGroupAccount);
            //}Catch(Exception ex){testGroupAccount = testGroupAccount;}
            Test.StopTest();
            List<Opportunity> opListCreated=[Select Id,AccountId,StageName,Effective_Date__c from Opportunity Where AccountId =: testGroupAccount.Id ];
            SGA_AP48_CreateOppForProspectAccount.checkExistingDupOpportunities(opListCreated);
            SGA_AP48_CreateOppForProspectAccount.showDupErrMsgForAccount(new List<Account>{testGroupAccount});
            System.assertEquals(1,opListCreated.size());
            
        }
    }     
}