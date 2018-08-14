/**********************************************************************
Class Name   : AP06_UpdateNextFollowUpDaysAccount_Test
Date Created : 01-June-2015
Created By   : Nagarjuna
Description  : Used to test AP06_UpdateNextFollowUpDaysOnAccount
**********************************************************************/
@isTest 
Public Class AP06_UpdateNextFollowUpDaysAccount_Test
{
static TestMethod void testfollowUpDaysOnAccounts()
{
    List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
    insert cs001List; 
    List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
    insert cs002List;
    Account a = Util02_TestData.insertAccount();
    ID accRT =[select Id,Name from Recordtype where Name = 'Person Account' and SobjectType = 'Account'].Id;
    a.recordtypeId = accRT ; 
    a.mobile_phone__c='12345';
    insert a;
    // DC
    String accId = a.Id;
    // DC
    id taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Schedule Followup' AND SobjectType ='Task' LIMIT 1].Id;
    List<Task> insTaskList = new List<Task>();
    List<Task> listTask = new List<Task>();
    listTask = Util02_TestData.createTasks();
    for(Task t: listTask)
    {
        t.WhatId = a.Id;
        t.recordtypeid = taskRecordTypeId;
        insTaskList.add(t);
    }
    try{
        insert insTaskList;
    }catch(Exception e){
    }
        // DC
//    Account aNew = [SELECT FirstName, Tech_Next_Follow_up_Date__c, Next_Fallow_Up_Days__c FROM Account WHERE FirstName = 'test first name' AND Tech_Businesstrack__c='TELESALES'];
    Account aNew = [SELECT FirstName, Tech_Next_Follow_up_Date__c, Next_Fallow_Up_Days__c FROM Account WHERE Id = :accId ]; //AND Tech_Businesstrack__c='TELESALES'];    
    Task tNew = [SELECT Subject, ActivityDate, WhatId FROM Task WHERE WhatId =: aNew.Id LIMIT 1];
    tnew.Subject = 'MySubject';
    Update tNew;
    System.assertEquals(tNew.WhatId, aNew.Id);
    System.assertEquals(tNew.Subject, 'MySubject');
    System.assertEquals(aNew.FirstName, 'test first name');
    System.assertEquals(aNew.Tech_Next_Follow_up_Date__c, tNew.ActivityDate);
    List<Task> tList = [SELECT Subject, ActivityDate FROM Task WHERE WhatId =: aNew.Id];
    Delete tList;
    List<Task> tDel = [SELECT Subject, ActivityDate, WhatId FROM Task WHERE WhatId =: aNew.Id];
    System.assertEquals(tDel.Size(), 0);    
}
}