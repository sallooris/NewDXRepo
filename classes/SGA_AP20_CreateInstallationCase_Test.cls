/***********************************************************************
Class Name   : SGA_AP20_CreateInstallationCase_Test
Date Created : 08/04/2017 (MM/DD/YYYY)
Created By   : IDC Offshore
Description  : 1. This is a test class for SGA_AP20_CreateInstallationCase
**************************************************************************/
@isTest
private class SGA_AP20_CreateInstallationCase_Test {
   
/************************************************************************************
    Method Name : appCaseUpdateTest1
    Parameters  : None
    Return type : void
    Description : This is the testmethod for createOrUpdateInstallationCase to 
	              check Case insert operation
*************************************************************************************/
private testMethod static void appCaseUpdateTest1() {
        User testUser = Util02_TestData.createUser();
        Id standardPBId = Test.getStandardPricebookId();
        Product2 prod1 = Util02_TestData.createProduct();
		Pricebook2 customPB=Util02_TestData.createPricebook2SGA();
		Account testAcc = Util02_TestData.createGroupAccount();
		List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
		List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
		vlocity_ins__Application__c testApplication = Util02_TestData.createApplicationForRelatedList('Application Created', NULL);
		ID oppRT =[select Id,Name from Recordtype where Name = 'SG Quoting' and SobjectType = 'Opportunity'].Id;
		Opportunity testOpp=Util02_TestData.createGrpAccOpportunity();
		
        System.runAs(testUser){
            
        Database.insert(prod1);
        Database.insert(customPB);
		
        PricebookEntry pbEntry = Util02_TestData.createPricebookEntrySGA(prod1.Id,standardPBId,false);
        
        Database.insert(pbEntry);
        Database.insert(cs001List);
        Database.insert(cs002List);
        Database.insert(testAcc);
        
        Database.insert(testApplication);
        testOpp.accountid=testAcc.id;
        testOpp.recordtypeId = oppRT ;   
        
        AP08_RestrictMultipleOpenOpportunities.isFirstRunOPPBeforeInsert = true;
        Database.insert(testOpp);
        
		Quote qt= Util02_TestData.createQuoteSGA(testOpp.id,Date.today(),customPB.Id,'EBC');
       
        Database.insert(qt);
           Test.startTest();
		    // attach application to Account and Update status to create Case Installation 
           testApplication.vlocity_ins__AccountId__c=testAcc.Id;
           testApplication.vlocity_ins__Status__c = SG01_Constants.APP_STATUS_GROUP_SUBMITED;
		   Database.Update(testApplication);
           Test.stopTest();    
           System.assertNotEquals(null, testApplication.Id);
	      
        }
    }
	
/************************************************************************************
    Method Name : appCaseUpdateTest2
    Parameters  : None
    Return type : void
    Description : This is the testmethod for createOrUpdateInstallationCase to 
	              check Case Update operation
************************************************************************************/
private testMethod static void appCaseUpdateTest2() {
		User testUser = Util02_TestData.createUser();
		Account testAcc = Util02_TestData.createGroupAccount();
		List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
		List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
		vlocity_ins__Application__c testApplication = Util02_TestData.createApplicationForRelatedList('Application Created', NULL);

        System.runAs(testUser){
        Database.insert(cs001List);
        Database.insert(cs002List);
        Database.insert(testAcc);
        testApplication.vlocity_ins__AccountId__c=testAcc.Id;
        Database.insert(testApplication);
        // Set app to Status =APP_STATUS_GROUP_SUBMITED to create Case record;
        testApplication.vlocity_ins__Status__c = SG01_Constants.APP_STATUS_GROUP_SUBMITED;
		Database.Update(testApplication);
		// reset app to Status ='Application Created';
        testApplication.vlocity_ins__Status__c = 'Application Created';
		Database.Update(testApplication);
        Test.startTest();
		   	// check exising Case for Application
		     Map<Id,Case> csMap = SGA_Util12_CaseDataAccessHelper.fetchCaseMap(SGA_AP20_CreateInstallationCase.EXIST_CASE_QUERY_SELECT,SGA_AP20_CreateInstallationCase.EXIST_CASE_QUERY_WHERE,SGA_AP20_CreateInstallationCase.ORDER_BY_CLAUSE,SG01_Constants.BLANK);
			 // Set app to Status =APP_STATUS_GROUP_SUBMITED Back to test Case Update ;
             testApplication.vlocity_ins__Status__c = SG01_Constants.APP_STATUS_GROUP_SUBMITED;
		    Database.Update(testApplication);
          Test.stopTest();    
          System.assertNotEquals(null, csMap);
		  System.assertEquals(SG01_Constants.APP_STATUS_GROUP_SUBMITED, csMap.values()[0].Stage__c);
		  }
		}

/************************************************************************************
    Method Name : appCaseUpdateNegTest
    Parameters  : None
    Return type : void
    Description : This is the testmethod for checking Negative Condition for
               	createOrUpdateInstallationCase
*************************************************************************************/
private testMethod static void appCaseUpdateNegTest() {
        User testUser = Util02_TestData.createUser();
		Account testAcc = Util02_TestData.createGroupAccount();
		List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
		List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
		vlocity_ins__Application__c testApplication = Util02_TestData.createApplicationForRelatedList('Application Created', NULL);

        System.runAs(testUser){
        Database.insert(cs001List);
        Database.insert(cs002List);
        Database.insert(testAcc);
        testApplication.vlocity_ins__AccountId__c=testAcc.Id;
        Database.insert(testApplication);
        // Set app to Status =APP_STATUS_GROUP_SUBMITED to create Case record;
        testApplication.vlocity_ins__Status__c = 'Application Created';
		Database.Update(testApplication);
		
        Test.startTest();
		   	// check exising Case for Application
            SGA_Util12_CaseDataAccessHelper.applicationIDSet =new Set<Id>{testApplication.Id};
		     Map<Id,Case> csMap = SGA_Util12_CaseDataAccessHelper.fetchCaseMap(SGA_AP20_CreateInstallationCase.EXIST_CASE_QUERY_SELECT,SGA_AP20_CreateInstallationCase.EXIST_CASE_QUERY_WHERE,SGA_AP20_CreateInstallationCase.ORDER_BY_CLAUSE,SG01_Constants.BLANK);
        Test.stopTest();    
	    System.assertEquals(TRUE, csMap.isEmpty());
        }
    }		
      
}