/************************************************************************
Class Name   : SGA_AP52_RenewOppEndate_Test
Date Created : 09-OCT-2017
Created By   : IDC Offshore
Description  : Apex Class to cover SGA_AP52_RenewOppEndate_Test
******************************************************************************************/
@isTest
public class SGA_AP52_RenewOppEndate_Test
{
    /****************************************************************************************************
    Method Name : renewOpptyTest
    Parameters  : None
    Return type : void
    Description : This is the testmethod for insertion of Renewla Opportunity
    *****************************************************************************************************/
    private static testMethod void renewOpptyTest()
    {   
        User testUser = Util02_TestData.createUser();
        
        Account testAccount = Util02_TestData.createBrokerAgentAccountData();
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();   
        
        System.runAs(testUser)
        {
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.insert(testAccount);
            
            Opportunity opp = Util02_TestData.createGrpAccOpportunity();
            opp.AccountId = testAccount.id;
            opp.stageName = Label.SG91_Renewal;
            database.insert(opp);   
        }       
        
    }
    
}