/**********************************************************************************
Class Name :   SGA_AP43_PreventNotesOnOpp_Test
Date Created : 09/13/2017 (mm/dd/yyyy)
Created By   : IDC Offshore
Description  : 1. This class is the test class for SGA_AP43_PreventNotesOnOpp
*************************************************************************************/
@isTest
private class SGA_AP43_PreventNotesOnOpp_Test {
/************************************************************************************
    Method Name : blockNoteModificationTest
    Parameters  : None
    Return type : void
    Description : This is positive testmethod for blockNoteModification Method
*************************************************************************************/
    private static testMethod void blockNoteModificationTest(){
        User testUser = Util02_TestData.createUser();
        Account testAcc = Util02_TestData.createGroupAccount();
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        ID oppRT =[select Id,Name from Recordtype where Name = 'SG Quoting' and SobjectType = 'Opportunity'].Id;
        Opportunity testOpp=Util02_TestData.createGrpAccOpportunity();
        Note testNote=Util02_TestData.createNote(NULL);
        System.runAs(testUser){
        Database.insert(cs001List);
        Database.insert(cs002List);
        Database.insert(testAcc);
        testOpp.accountid=testAcc.id;
        testOpp.recordtypeId = oppRT ;   
        testOpp.Effective_Date__c = Date.newInstance(2017, 1, 1);
        AP08_RestrictMultipleOpenOpportunities.isFirstRunOPPBeforeInsert = true;
        Database.insert(testOpp);
        testNote.ParentId=testOpp.Id;
        Database.insert(testNote);
        testNote.Body='test1234';
        Test.startTest();
         try{
            Database.Update(testNote);
            }Catch(Exception ex){ testNote=NULL;}
        Test.stopTest();
        Note noteData=[Select Id,Body from Note Where parentID =:testOpp.Id limit 1];
        System.assertNotEquals('test1234', noteData.Body);
        }
     }
     
/************************************************************************************
    Method Name : blockNoteModificationNegTest
    Parameters  : None
    Return type : void
    Description : This is the Negative test for blockNoteModification Method
*************************************************************************************/
     private static testMethod void blockNoteModificationNegTest(){
        User testUser = Util02_TestData.createUser();
        Account testAcc = Util02_TestData.createGroupAccount();
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        Note testNote=Util02_TestData.createNote(NULL);
        ID oppRT =[select Id,Name from Recordtype where Name = 'SG Quoting' and SobjectType = 'Opportunity'].Id;
        Opportunity testOpp=Util02_TestData.createGrpAccOpportunity();
        System.runAs(testUser){
        Database.insert(cs001List);
        Database.insert(cs002List);
        Database.insert(testAcc);
        // attach application to Account  
        testOpp.accountid=testAcc.id;
        testOpp.recordtypeId = oppRT ;   
        testOpp.Effective_Date__c = Date.newInstance(2017, 1, 1);  
        AP08_RestrictMultipleOpenOpportunities.isFirstRunOPPBeforeInsert = true;
        Database.insert(testOpp);
        testNote.ParentId=testOpp.Id;
        Database.insert(testNote);
        testNote.Body='test1234';
        Test.startTest();
            try{
                Database.delete(testNote);
            }Catch(Exception ex){testNote = NULL; }
         
         Test.stopTest();
        List<Note> noteData=[Select Id,Body from Note Where parentID =:testOpp.Id limit 1];
        System.assertNotEquals(True, noteData.isEmpty());
        }
     }
     /************************************************************************************
    Method Name : bulkNoteModificationTest
    Parameters  : None
    Return type : void
    Description : This is positive testmethod for blockNoteModification Method in Bulk
*************************************************************************************/
    private static testMethod void bulkNoteModificationTest(){
        User testUser = Util02_TestData.createUser();
        List<Note> noteList= new List<Note>();
        Account testAcc = Util02_TestData.createGroupAccount();
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        ID oppRT =[select Id,Name from Recordtype where Name = 'SG Quoting' and SobjectType = 'Opportunity'].Id;
        Opportunity testOpp=Util02_TestData.createGrpAccOpportunity();
        System.runAs(testUser){
        Database.insert(cs001List);
        Database.insert(cs002List);
        Database.insert(testAcc);
        testOpp.accountid=testAcc.id;
        testOpp.recordtypeId = oppRT ;   
        testOpp.Effective_Date__c = Date.newInstance(2017, 1, 1);
       // AP08_RestrictMultipleOpenOpportunities.isFirstRunOPPBeforeInsert = true;
        Database.insert(testOpp);
        for(Integer i=0; i< 200;i++){
        Note testNote=Util02_TestData.createNote(NULL); 
        testNote.ParentId=testOpp.Id;
       // Database.insert(testNote);
        testNote.Body='test1234'+i;
        noteList.add(testNote);
        }
         Database.insert(noteList);
         List<Note> noteData=[Select Id,parentID from Note Where parentID =:testOpp.Id];
        Test.startTest();
         try{
             for(Note ntDate:noteData){
                ntDate.body ='test123';
               }
            Database.Update(noteData);       
            }Catch(Exception ex){ noteData = noteData; } 
         Test.stopTest();
        System.assertEquals(200, noteData.size());
        }
    }

}