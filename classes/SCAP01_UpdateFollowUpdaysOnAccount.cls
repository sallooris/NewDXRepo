/**********************************************************************
Class Name   : SCAP01_UpdateFollowUpdaysOnAccount 
Date Created : 04-Jun-2015
Created By   : Nagarjuna
Description  : job update next follow up date on account 
Referenced/Used in : Used for BAP01_UpdateFollowUpDaysOnAccount 
**********************************************************************/
global with sharing Class SCAP01_UpdateFollowUpdaysOnAccount implements Schedulable
{
    global void Execute(SchedulableContext SC)
    {
        BAP01_UpdateFollowUpDaysOnAccount b = new BAP01_UpdateFollowUpDaysOnAccount();
        Database.ExecuteBatch(b);
    }
}