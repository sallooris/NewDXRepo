/**********************************************************************
Class Name   : BAP01_UpdateFollowUpDaysOnAccount 
Date Created : 04-Jun-2015
Created By   : Nagarjuna
Description  : Used to update next follow up date on account
Referenced/Used in : Used to in batch apex
**********************************************************************/
global with sharing class BAP01_UpdateFollowUpDaysOnAccount implements Database.Batchable<sObject>
{
    global String str_SOQL = 'SELECT Id, Tech_Next_Follow_up_Date__c, (SELECT ActivityDate FROM Tasks WHERE (ActivityDate > TODAY AND RecordType.Name = \'Schedule Followup\' AND Status != \'Complete\') ORDER BY activitydate LIMIT 1) FROM Account WHERE (Account.Tech_Next_Follow_up_Date__c < = TODAY OR Tech_Next_Follow_up_Date__c = NULL)';
   
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
         System.Debug('Query in start is: '+str_SOQL);    
        return Database.getQueryLocator(str_SOQL);
    }
   
    global void execute(Database.BatchableContext BC, List<Account> scope)
    {
        AP06_UpdateNextFollowUpDaysOnAccount accUpdate = new AP06_UpdateNextFollowUpDaysOnAccount();
        System.Debug('Scope is: '+scope);    
        accUpdate.updateFollowUpDate(scope);
    }   
    global void finish(Database.BatchableContext BC)
    {
    }
}