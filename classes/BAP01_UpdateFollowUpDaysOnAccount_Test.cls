/**********************************************************************
Class Name   : BAP01_UpdateFollowUpDaysOnAccount_Test
Date Created : 04-Jun-2015
Created By   : Nagarjuna
Description  : Test class
Referenced/Used in : BAP01_UpdateFollowUpDaysOnAccount
**********************************************************************/
@isTest
Public Class BAP01_UpdateFollowUpDaysOnAccount_Test
{
    
    static TestMethod void CreateAcconutswithTasks()
    {
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        ID accRT =  [SELECT Id FROM RecordType WHERE Name = 'Person Account' AND SobjectType ='Account' LIMIT 1].Id;
        List<Account> accList = new List<Account>(); 
        List<Account> accListupdateBack = new List<Account>();
        List<Task> taskList = new List<Task>();
        accList = Util02_TestData.createAccounts();
        for(Account a : accList){
            a.recordTypeId = accRT ;
        }
        insert accList;
        id taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Schedule Followup' AND SobjectType ='Task' LIMIT 1].Id;
        Integer i = 1;
        for(Account a: accList)
        {
            Task t = new Task();
            t.WhatID = a.Id;
            t.ActivityDate = System.Today().addDays(i);
            t.Subject = 'Subject'+i;
            t.RecordTypeId = taskRecordTypeId;
            taskList.add(t);
            i++;
        }
        try{
        insert taskList;
        }catch(Exception e){}
        System.Debug('task list is: '+taskList);
        
        for(Account a: accList)
        {
            a.Tech_Next_Follow_up_Date__c = NULL;
            accListupdateBack.add(a);
        }
        update accListupdateBack;
        Test.StartTest();
        BAP01_UpdateFollowUpDaysOnAccount b = new BAP01_UpdateFollowUpDaysOnAccount();
        b.str_SOQL += ' LIMIT 200';
        Database.ExecuteBatch(b, 200);
        Test.StopTest();
        Date dt = [SELECT Tech_Next_Follow_up_Date__c FROM Account WHERE ID = :accList[0].Id AND Tech_Businesstrack__c='TELESALES'].Tech_Next_Follow_up_Date__c;        
        System.Debug('Next Date is: '+dt);
        
    

    }
    static TestMethod void TestSchedulableClass()
    {
        Test.StartTest();
        SCAP01_UpdateFollowUpdaysOnAccount sh = new SCAP01_UpdateFollowUpdaysOnAccount();
        String schedule = '0 0 23 * * ?';
        system.schedule('Nightly Update', schedule, sh );
        Test.StopTest();
    }
}