/***********************************************************************
Class Name   : SGA_Util07_OppDataAccessHelper_Test
Date Created : 10/10/2017 (mm/dd/yyyy)
Created By   : IDC Offshore
Description  : 1. This is a test class for SGA_Util07_OpportunityDataAccessHelper
**************************************************************************/
@isTest
private class SGA_Util07_OppDataAccessHelper_Test {
 /************************************************************************************
    Method Name : testInsert
    Parameters  : None
    Return type : void
    Description : This is the positive test for dmlOnOpportunity with Insert
    *************************************************************************************/
     private testMethod static void testInsert() {
         Account testAcc = Util02_TestData.createGroupAccount();
         User testUser = Util02_TestData.createUser();
         Date curDate= System.Today();
         List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
         List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
         Opportunity testOpp=Util02_TestData.createGrpAccOpportunity();
         List<Opportunity> opplistToinsert= new  List<Opportunity>();
         System.runAs(testUser){
         Database.insert(cs001List);
         Database.insert(cs002List);
         Database.insert(testAcc);
         testOpp.accountid=testAcc.id;
         testOpp.Effective_Date__c = Date.newInstance(curDate.year(),curDate.month(), 1);
         opplistToinsert.add(testOpp);
             Test.startTest();
             SGA_Util07_OpportunityDataAccessHelper.dmlOnOpportunity(opplistToinsert, SGA_Util07_OpportunityDataAccessHelper.INSERT_OPERATION);
             Test.stopTest();
           Opportunity opp=[Select Id,StageName from Opportunity limit 1];
           System.assertNotEquals('Lost', opp.StageName);
         }
     }
    
      /************************************************************************************
    Method Name : testUpdate
    Parameters  : None
    Return type : void
    Description : This is the positive test for dmlOnOpportunity with Update
    *************************************************************************************/
     private testMethod static void testUpdate() {
        Account testAcc = Util02_TestData.createGroupAccount();
         User testUser = Util02_TestData.createUser();
         Date curDate= System.Today();
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        Opportunity testOpp=Util02_TestData.createGrpAccOpportunity();
         List<Opportunity> opplistToinsert= new  List<Opportunity>();
           List<Opportunity> opplistToUpdate= new  List<Opportunity>();
         System.runAs(testUser){
         Database.insert(cs001List);
         Database.insert(cs002List);
         Database.insert(testAcc);
         testOpp.accountid=testAcc.id;
         testOpp.Effective_Date__c = Date.newInstance(curDate.year(),curDate.month(), 1);
         opplistToinsert.add(testOpp);
           
         SGA_Util07_OpportunityDataAccessHelper.dmlOnOpportunity(opplistToinsert, SGA_Util07_OpportunityDataAccessHelper.INSERT_OPERATION);
          
         opplistToUpdate=[Select Id,StageName from Opportunity];
               
             For(Opportunity op:opplistToUpdate){
                 op.StageName= 'Lost';
             }
             Test.startTest();
             SGA_Util07_OpportunityDataAccessHelper.dmlOnOpportunity(opplistToUpdate, SGA_Util07_OpportunityDataAccessHelper.UPDATE_OPERATION);
             Test.stopTest();
            Opportunity opp=[Select Id,StageName from Opportunity limit 1];
           System.assertEquals('Lost', opp.StageName);
         }
     }
     
     /************************************************************************************
    Method Name : testUpsert
    Parameters  : None
    Return type : void
    Description : This is the positive test for dmlOnOpportunity with Upsert
    *************************************************************************************/
     private testMethod static void testUpsert() {
        Account testAcc = Util02_TestData.createGroupAccount();
         User testUser = Util02_TestData.createUser();
         Date curDate= System.Today();
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        Opportunity testOpp=Util02_TestData.createGrpAccOpportunity();
         List<Opportunity> opplistToinsert= new  List<Opportunity>();
           List<Opportunity> opplistToUpdate= new  List<Opportunity>();
         System.runAs(testUser){
         Database.insert(cs001List);
         Database.insert(cs002List);
         Database.insert(testAcc);
         testOpp.accountid=testAcc.id;
         testOpp.Effective_Date__c = Date.newInstance(curDate.year(),curDate.month(), 1);
         opplistToinsert.add(testOpp);
           
         SGA_Util07_OpportunityDataAccessHelper.dmlOnOpportunity(opplistToinsert, SGA_Util07_OpportunityDataAccessHelper.INSERT_OPERATION); 
         opplistToUpdate=[Select Id,StageName from Opportunity];
             For(Opportunity op:opplistToUpdate){
                 op.StageName= 'Lost';
             }
             Test.startTest();
             SGA_Util07_OpportunityDataAccessHelper.dmlOnOpportunity(opplistToUpdate, SGA_Util07_OpportunityDataAccessHelper.UPSERT_OPERATION);
             Test.stopTest();
            Opportunity opp=[Select Id,StageName from Opportunity limit 1];
           System.assertEquals('Lost', opp.StageName);
         }
     }
     /************************************************************************************
    Method Name : testDelete
    Parameters  : None
    Return type : void
    Description : This is the positive test for dmlOnOpportunity with Delete
    *************************************************************************************/
     private testMethod static void testDelete() {
        Account testAcc = Util02_TestData.createGroupAccount();
         User testUser = Util02_TestData.createUser();
         Date curDate= System.Today();
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        Opportunity testOpp=Util02_TestData.createGrpAccOpportunity();
         List<Opportunity> opplistToinsert= new  List<Opportunity>();
           List<Opportunity> opplistToDelete= new  List<Opportunity>();
         System.runAs(testUser){
         Database.insert(cs001List);
         Database.insert(cs002List);
         Database.insert(testAcc);
         testOpp.accountid=testAcc.id;
         testOpp.Effective_Date__c = Date.newInstance(curDate.year(),curDate.month(), 1);
         opplistToinsert.add(testOpp);
           
         SGA_Util07_OpportunityDataAccessHelper.dmlOnOpportunity(opplistToinsert, SGA_Util07_OpportunityDataAccessHelper.INSERT_OPERATION);
          
         opplistToDelete=[Select Id,StageName from Opportunity];
         
             Test.startTest();
             SGA_Util07_OpportunityDataAccessHelper.dmlOnOpportunity(opplistToDelete, SGA_Util07_OpportunityDataAccessHelper.DELETE_OPERATION);
             Test.stopTest();
            
         }
     }
     /************************************************************************************
    Method Name : testFetch
    Parameters  : None
    Return type : void
    Description : This is the positive test for fetchOpportunityMap
    *************************************************************************************/
     private testMethod static void testfetchOpportunityMap() {
         Account testAcc = Util02_TestData.createGroupAccount();
         User testUser = Util02_TestData.createUser();
         Date curDate= System.Today();
         List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
         List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
         Opportunity testOpp=Util02_TestData.createGrpAccOpportunity();
         List<Opportunity> opplistToinsert= new  List<Opportunity>();
         List<Opportunity> opplistToinserted= new  List<Opportunity>();
         Map<ID,Opportunity> opGot= new Map<ID,Opportunity>();
         String selectQuery='Select Id,StageName from Opportunity';
         String whereClause = SG01_Constants.SPACE+'Where Id IN : oppIdSet';
         System.runAs(testUser){
         Database.insert(cs001List);
         Database.insert(cs002List);
         Database.insert(testAcc);
         testOpp.accountid=testAcc.id;
         testOpp.Effective_Date__c = Date.newInstance(curDate.year(),curDate.month(), 1);
         opplistToinsert.add(testOpp);
          
          SGA_Util07_OpportunityDataAccessHelper.dmlOnOpportunity(opplistToinsert, SGA_Util07_OpportunityDataAccessHelper.INSERT_OPERATION);
             
           opGot = new Map<Id,Opportunity>([Select Id,StageName from Opportunity ]);
             Test.startTest();
             SGA_Util07_OpportunityDataAccessHelper.oppIdSet= opGot.keySet();
             SGA_Util07_OpportunityDataAccessHelper.fetchOpportunityMap(selectQuery, whereClause,NULL,NULL);
             Test.stopTest();
          System.assertEquals('Opportunity', opGot.get(testOpp.Id).StageName);
         }
     }
    
}