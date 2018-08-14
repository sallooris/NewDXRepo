/**********************************************************************************
Class Name :   SGA_AP15_EmailTempComponentCtrl_Test
Date Created : 20-June-2017
Created By   : IDC Offshore
Description  : 1. This class is the test class for SGA_AP15_EmailTempComponentCtrl
*************************************************************************************/
@isTest
private class SGA_AP15_EmailTempComponentCtrl_Test {
/************************************************************************************
    Method Name : testGetBrand
    Parameters  : None
    Return type : void
    Description : This is positive testmethod for getBrand Method
*************************************************************************************/
    private static testMethod void testGetBrand(){
        User testUser = Util02_TestData.createUser();
        Id standardPBId = Test.getStandardPricebookId();
        Product2 prod1 = Util02_TestData.createProduct();
		Pricebook2 customPB=Util02_TestData.createPricebook2SGA();
		Account testAcc = Util02_TestData.createGroupAccount();
		List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
		List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
		vlocity_ins__Application__c testApplication = Util02_TestData.createApplicationForRelatedList(SG01_Constants.STATUSINENROLLMENTCOMPLETED, NULL);
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
        // attach application to Account 
        testApplication.vlocity_ins__AccountId__c=testAcc.Id;
        Database.update(testApplication);
        
        testOpp.accountid=testAcc.id;
        testOpp.recordtypeId = oppRT ;   
        
        AP08_RestrictMultipleOpenOpportunities.isFirstRunOPPBeforeInsert = true;
        Database.insert(testOpp);
        
		Quote qt= Util02_TestData.createQuoteSGA(testOpp.id,Date.today(),customPB.Id,'EBC');
       
        Database.insert(qt);
        
        Test.startTest();
         SGA_AP15_EmailTempComponentCtrl emp= new SGA_AP15_EmailTempComponentCtrl();
         
		 emp.appId=testApplication.Id;
         emp.getBrand();
         Test.stopTest();
         System.assertEquals('EBC', emp.getBrand());
        }
     }
	 
/************************************************************************************
    Method Name : testGetBrandNeg
    Parameters  : None
    Return type : void
    Description : This is the Negative test for getBrand Method
*************************************************************************************/
	 private static testMethod void testGetBrandNeg(){
        User testUser = Util02_TestData.createUser();
        Id standardPBId = Test.getStandardPricebookId();
        Product2 prod1 = Util02_TestData.createProduct();
		Pricebook2 customPB=Util02_TestData.createPricebook2SGA();
		Account testAcc = Util02_TestData.createGroupAccount();
		List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
		List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
		vlocity_ins__Application__c testApplication = Util02_TestData.createApplicationForRelatedList(SG01_Constants.STATUSINENROLLMENTCOMPLETED, NULL);
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
        // attach application to Account 
        testApplication.vlocity_ins__AccountId__c=testAcc.Id;
        Database.update(testApplication);
        
        testOpp.accountid=testAcc.id;
        testOpp.recordtypeId = oppRT ;   
        
        AP08_RestrictMultipleOpenOpportunities.isFirstRunOPPBeforeInsert = true;
        Database.insert(testOpp);
        
		Quote qt= Util02_TestData.createQuoteSGA(testOpp.id,Date.today(),customPB.Id,'EBCBS');
       
        Database.insert(qt);
        
        Test.startTest();
         SGA_AP15_EmailTempComponentCtrl emp= new SGA_AP15_EmailTempComponentCtrl();
         
		 emp.appId=testApplication.Id;
         emp.getBrand();
         Test.stopTest();
         System.assertNotEquals('EBC', emp.getBrand());
        }
     }

}