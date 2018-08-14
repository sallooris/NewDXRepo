/*****************************************************************
Class Name :   BR_AP03_CheckOwnerAndUpdateOnTask
Date Created : 21-Aug-2015
Created By   : Nagarjuna Kaipu
Description  : This class used to update completed date on task and to update recordtype and task status for tasks created from email.
Referenced/Used in : CaseBeforeInsert and CaseBeforeUpdate Triggers
Changed History : 
	** Updated by Joseph Henzi/AD70229 - added profile exemption for Broker: Sales Executive profile allowing activites to unowned cases.
**********************************************************************/
public Class BR_AP03_CheckOwnerAndUpdateOnTask
{
    public Static boolean isBrokerTaskBeforeInsertFirstRun = true;
    public Static boolean isBrokerTaskBeforeUpdateFirstRun = true;
    public List<Task> listTask = new List<Task>();
    public List<Case> tCase = new List<Case>();
    Set<Id> cIds = new Set<Id>();
                
    /*
    Method Name : CheckTaskOwnerWithCase
    Param 1 : List of Tasks
    Return Type: Void
    Description : Used to restrict activity creation.
    */
    public void CheckTaskOwnerWithCase(List<Task> cTask)
    {
        List<RecordType> taskrecList = [SELECT id FROM RECORDTYPE WHERE sObjectType = 'TASK' AND Name = 'BR-Schedule Followup'];
        CS003_BrokerEmail2CaseDefaultOwner__c brokerCaseDefOwner = CS003_BrokerEmail2CaseDefaultOwner__c.getInstance(UserInfo.getUserId());
        System.debug('************* brokerCaseDefOwner = '+brokerCaseDefOwner);
        System.Debug('CS owner ID is: '+brokerCaseDefOwner.BR_CaseDefaultOwnerId__c+' Logged in User is: '+UserInfo.getUserId());

        for(Task tl: cTask)
        {
            cIds.add(tl.WhatId);
            
        }
        
        tCase = [SELECT Id, OwnerId FROM CASE WHERE Id IN :cIds];

        Id profileId=userinfo.getProfileId();
    	String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
    
        for(Task tc: cTask)
        {
            for(Case c: tCase)
            {
                if (profileName == 'Broker: Sales Executive'){system.debug('PROFILENAME:::'+ profilename);}
                else if(tc.WhatId == c.Id && c.OwnerId != UserInfo.getUserId() && tc.BR_Call_ID__c == NULL && brokerCaseDefOwner.BR_CaseDefaultOwnerId__c != UserInfo.getUserId().Substring(0,15))
                {
                     throw new CustomException('Please take ownership on case to save the task.');
                }
            }
        }
    }
    
    /*
    Method Name : UpdateCompletedDateOnTask
    Param 1 : List of Tasks
    Return Type: Void
    Description : Used to update task rec type, status and completed date.
    */
    public void UpdateCompletedDateOnTask(List<Task> lTask)
    {
        List<RecordType> taskrecList = [SELECT id FROM RECORDTYPE WHERE sObjectType = 'TASK' AND Name = 'BR-Schedule Followup'];
        for(Task t: lTask)
        {
            if(t.BR_Completed_Date__c == NULL && t.status == 'Completed')
            {
                t.BR_Completed_Date__c = System.Today();
            }
            else if(t.subject.Contains('Email:') && t.subject.Contains('ref:') && t.BR_Completed_Date__c == NULL)
            {
                t.RecordTypeId = taskrecList[0].Id;
                t.Status = 'Completed';
                t.BR_Completed_Date__c = System.Today();
            }
            
        }
    }
    
}