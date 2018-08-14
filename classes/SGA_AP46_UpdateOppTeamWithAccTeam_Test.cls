/*******************************************************************************************
* Class Name  : SGA_AP46_UpdateOppTeamWithAccTeam_Test
* Created By  : IDC Offshore
* CreatedDate : 9/14/2017
* Description : This test class for SGA_AP46_UpdateOppTeamWithAccTeam_Test
********************************************************************************************/
@isTest
private class SGA_AP46_UpdateOppTeamWithAccTeam_Test {
    /************************************************************************
    * Method Name : createOpportunityPositiveTest
    * Description : To test the Opportunity Team Members updated 
    *                with the account team members.
    ************************************************************************/
    private testMethod static void createOpportunityPositiveTest(){
        //User testUser = Util02_TestData.createUser();
        //Account record creation
        Account testAccount = Util02_TestData.createGroupAccountForRelatedList();
        //Account Team Member creation
        AccountTeamMember accountTeamMember = Util02_TestData.createAccountTeamMember();
        //Business Custom Setting insertion
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        //Record Type Assignment Custom Setting insertion
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        //System.runAs(testUser){
            Test.startTest();
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.Insert(testAccount);
            
            
            accountTeamMember.AccountId = testAccount.Id;
        accountTeamMember.UserId = UserInfo.getUserId();
            //accountTeamMember.UserId = testUser.Id;
            
            Insert accountTeamMember;
            Id brokerRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Agency/Brokerage').getRecordTypeId();
            Account brokerAcc = new Account(recordtypeId=brokerRecType,Name='Test Account1', AgencyType__c = 'Brokerage', Employer_EIN__c = '000000000');
            Insert brokerAcc;
            Id brokerConRecType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
            Contact brokerCon = new Contact(recordtypeId=brokerConRecType,LastName='Test Con', AgencyType__c = 'Brokerage');
            Insert brokerCon;
            Account paidAgency = new Account(recordtypeId=brokerRecType,Name='Test Account1', AgencyType__c = 'Paid Agency', Employer_EIN__c = '000000000');
            Insert paidAgency;
            
            Account genAgency = new Account(recordtypeId=brokerRecType,Name='Test Account1', AgencyType__c = 'General Agency', Employer_EIN__c = '000000000');
            Insert genAgency;
        
            Contact brokerCon1 = new Contact(recordtypeId=brokerConRecType,LastName='Test Con', AgencyType__c = 'Brokerage');
            Insert brokerCon1;
            Account paidAgency1 = new Account(recordtypeId=brokerRecType,Name='Test Account1', AgencyType__c = 'Paid Agency', Employer_EIN__c = '000000000');
            Insert paidAgency1;
            
            Account genAgency1 = new Account(recordtypeId=brokerRecType,Name='Test Account1', AgencyType__c = 'General Agency', Employer_EIN__c = '000000000');
            Insert genAgency1;
        
            //Opportunity record creation
            Opportunity testOpportunity = Util02_TestData.createGrpAccOpportunity();
            testOpportunity.AccountId = testAccount.Id;
            testOpportunity.Broker__c = brokerCon.Id;
            testOpportunity.PaidAgency__c = paidAgency.Id;
            testOpportunity.GeneralAgency__c = genAgency.Id;
            Insert testOpportunity;
            Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>([select id,stagename,PaidAgency__c,GeneralAgency__c,Broker__c from opportunity where id=:testOpportunity.Id]);
            OpportunityTriggerSGHelper.doAfterInsert(oppMap);
        	
			testOpportunity.Broker__c = brokerCon1.Id;
            testOpportunity.PaidAgency__c = paidAgency1.Id;
            testOpportunity.GeneralAgency__c = genAgency1.Id;
            update testOpportunity;
        
            //OpportunityTeamMember oppTeamMember = [SELECT Id, OpportunityId, UserId, OpportunityAccessLevel, TeamMemberRole FROM OpportunityTeamMember where OpportunityId =: testOpportunity.Id];
            Test.stopTest();
            
           // System.assertEquals('Broker', oppTeamMember.TeamMemberRole);
           // System.assertEquals(testUser.Id, oppTeamMember.UserId);
        //}
    }
}