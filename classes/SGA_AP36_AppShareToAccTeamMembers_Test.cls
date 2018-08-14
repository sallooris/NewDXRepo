/*******************************************************************************************
* Class Name  : SGA_AP36_AppShareToAccTeamMembers_Test
* Created By  : IDC Offshore
* CreatedDate : 8/4/2017
* Description : This test class for SGA_AP36_AppShareToAccTeamMembers
********************************************************************************************/
@isTest 
private class SGA_AP36_AppShareToAccTeamMembers_Test {
    
/************************************************************************************
    Method Name : createApplicationAndSharePositiveTest
    Parameters  : None
    Return type : void
    Description : This is the testmethod for createApplicationAndShare 
*************************************************************************************/
    private testMethod static void createApplicationAndSharePositiveTest(){
    	User testUser = Util02_TestData.createUser();
        //Account record creation
        Account testAccount = Util02_TestData.createGroupAccountForRelatedList();
        //Application record creation
        vlocity_ins__Application__c testApplication = Util02_TestData.createApplicationForRelatedList(SG01_Constants.STATUSINENROLLMENTCOMPLETED, System.today() +5);
        //Business Custom Setting insertion
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        //Record Type Assignment Custom Setting insertion
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        //Account Team Member creation
        AccountTeamMember accountTeamMember = Util02_TestData.createAccountTeamMember();
        
        System.runAs(testUser){
            Test.startTest();
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.Insert(testAccount);
            
            accountTeamMember.AccountId = testAccount.id;
            accountTeamMember.UserId = testUser.id;
            Database.insert(accountTeamMember);
            
            testApplication.vlocity_ins__AccountId__c = testAccount.id;
            testApplication.vlocity_ins__Type__c = System.Label.SG42_PaperApplication;
            Database.insert(testApplication);
            
            List<vlocity_ins__Application__Share> applicationShare = [select UserOrGroupId, RowCause from vlocity_ins__Application__Share where ParentId =: testApplication.Id];
        	Test.stopTest();
            system.assertEquals(testUser.id, applicationShare[0].UserOrGroupId);
            
        }
    }
    
    private testMethod static void createApplicationAndShareOpportunityTest(){
    	User testUser = Util02_TestData.createUser();
        //Account record creation
        Account testAccount = Util02_TestData.createGroupAccountForRelatedList();
        //Application record creation
        vlocity_ins__Application__c testApplication = Util02_TestData.createApplicationForRelatedList(SG01_Constants.STATUSINENROLLMENTCOMPLETED, System.today() +5);
        //Business Custom Setting insertion
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        //Record Type Assignment Custom Setting insertion
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        
        Opportunity opp = Util02_TestData.insertOpportunity();
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SG Quoting').getRecordTypeId();
        
        System.runAs(testUser){
            Test.startTest();
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.Insert(testAccount);
            opp.AccountId = testAccount.Id;
            Database.Insert(opp);
            testApplication.vlocity_ins__AccountId__c = testAccount.id;
            testApplication.vlocity_ins__Type__c = System.Label.SG42_PaperApplication;
            
            Database.insert(testApplication);
            
			testApplication.Opportunity_Id__c = opp.Id;
            VlocityApplicationTriggerHandler.isFirstRunAfterUpdate = true;
            update testApplication;
        	Test.stopTest();
            
        }
    }
}