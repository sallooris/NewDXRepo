/**********************************************************************
Class Name   : AP06_UpdateNextFollowUpDaysOnAcconut
Date Created : 27-May-2015
Created By   : Nagarjuna
Description  : Used to populate next follow up days on account
Referenced/Used in : Used in after insert, update and delete triggers 
**********************************************************************/
Public with sharing Class AP06_UpdateNextFollowUpDaysOnAccount
{
    Set<Id> accIDs = new Set<Id>();
    List<Account> accList = new List<Account>(); 
    List<Account> accUpdateList = new List<Account>(); 
    Public Static boolean isFirstRunTaskAfterInsert = true;
    Public Static boolean isFirstRunTaskAfterUpdate = true;
    Public Static boolean isFirstRunTaskAfterDelete = true;
  
    /*
    Method Name : PopulateNExtFollowUpDays
    Param 1 : List of tasks
    Return Type: Void
    Description : Used to get the next follow up date based on the activities
    */
    Public Void PopulateNExtFollowUpDays(List<Task> taskList)
    {
    System.Debug('#### PopulateNExtFollowUpDays Started ####');
        try
        {
        System.Debug('Task list is: '+taskList);
            for(Task t: taskList )
            {
             if(t.WhatId!=null)
                {
                    if(String.ValueOf(t.WhatId).StartsWith('001'))
                    {
                        accIDs.add(t.WhatId);
                    }
                }
            }
            System.Debug('Account Ids are: '+accIDs);
            accList = [SELECT 
                           Id, 
                           Tech_Next_Follow_up_Date__c, 
                           (SELECT ActivityDate FROM Tasks WHERE (ActivityDate > TODAY AND Task.RecordType.Name='Schedule Followup' AND Status != 'Complete') ORDER BY activitydate LIMIT 1)
                           FROM Account 
                       WHERE ID IN: accIDs AND Tech_Businesstrack__c='TELESALES'
                      ];
            System.Debug('Account list is: '+accList);
            
            updateFollowUpDate(accList );
        }
        catch(Exception ex)
        {
        throw ex;
        }
        System.Debug('#### PopulateNExtFollowUpDays Ended####');
    }
    
    /*
    Method Name : updateFollowUpDate
    Param 1 : List of Accounts
    Return Type: Void
    Description : Used to update next follow up date
    */
    Public void updateFollowUpDate(List<Account> listAcc)
    {
        System.Debug('#### updateFollowUpDate Started ####');
        
        for(Account a: listAcc)
            {
            System.Debug('Inside Account'+a.tasks.Size());
            
                if(a.tasks!=null && a.tasks.Size() > 0 )
                {
                System.Debug('Inside Tasks'+a.tasks);
                    for(Task t: a.Tasks)
                    {
                    System.Debug('Inside Task loop');
                        if(a.Tech_Next_Follow_up_Date__c != t.ActivityDate)
                        {
                            System.debug('Inside update');
                            a.Tech_Next_Follow_up_Date__c = t.ActivityDate;
                            accUpdateList.add(a);
                        }

                    }
                }
                else
                {
                    System.debug('Inside else');
                    a.Tech_Next_Follow_up_Date__c = null;
                    accUpdateList.add(a);
                     
                }
            }
            
            System.debug('Account list to update is: '+accUpdateList);
            update accUpdateList;
            
        System.Debug('#### updateFollowUpDate Ended ####');
    }
}