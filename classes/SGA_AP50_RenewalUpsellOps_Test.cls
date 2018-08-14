/************************************************************************
Class Name   : SGA_AP50_RenewalUpsellOps_Test
Date Created : 21-Sept-2017
Created By   : IDC Offshore
Description  : 1. This is a test class for SGA_AP50_RenewalUpsellOps
**************************************************************************/
@isTest
private class SGA_AP50_RenewalUpsellOps_Test
{
    private static final String ACC_NAME = 'Test Account';
    private static final String MED_PRD = 'Medical';
    private static final String ENROLLED = 'Enrolled';
    private static final String NEW_SALES = 'New Sales';
    /************************************************************************************
    Method Name : insertAccountTest
    Parameters  : None
    Return type : void
    Description : This is the testmethod for Enrolled Insertion
    *************************************************************************************/
    private static testMethod void insertAccountTest()
    {   
        User testUser = Util02_TestData.createUser();
        testUser.BypassVR__c = true;
        database.update(testUser);
		
        Account testAccount = Util02_TestData.createBrokerAgentAccountData();
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();   
        
        System.runAs(testUser)
        {
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.insert(testAccount);
            
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
                testGroupAccount.name = ACC_NAME+i; 
                testGroupAccount.Type = ENROLLED;//creating enrolled accounts
                testGroupAccount.Tech_Sold_Products__c = MED_PRD;
                testGroupAccount.Agency_Brokerage__c = testAccount.id;
                accList.add(testGroupAccount);
            }       
            database.insert(accList);   
            Set<ID> accountIds = new Set<ID>();
            for(Account acc : accList){
                accountIds.add(acc.Id);
            }
            List<Opportunity> renewalUpsellOppList = [select id from Opportunity where AccountId IN:accountIds and Type != :NEW_SALES];
            Test.StopTest();
            //checking 400 records have been created or not. 
            System.assertEquals(400, renewalUpsellOppList.size());
        }
    }
}