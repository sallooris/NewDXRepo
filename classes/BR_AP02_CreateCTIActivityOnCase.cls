/*************************************************************
Class Name : BR_AP02_CreateCTIActivityOnCase
Date Created : 05-Aug-2015
Created By   : Nagarjuna Kaipu
Description  : This class is used to retrieve CTI Caller Id to create the CTI activity on the case
reference: Used in Case, CaseComment after insert and after update triggers
**************************************************************/
public Class BR_AP02_CreateCTIActivityOnCase
{
    Public Static boolean isFirstRunCaseAfterUpdate = true;
    Public Static boolean isFirstRunCaseAfterInsert = true;
    Public Static boolean isFirstRunCaseCommentAfterUpdate = true;
    Public Static boolean isFirstRunCaseCommentAfterInsert = true;
    /*
    Method Name : CreateCTITaskOnCase
    Param 1 : List of Cases
    Return Type: Void
    Description : Used to Create CTI activity on task
    */
    public void CreateCTITaskOnCase(List<Id> caseIds)
    {
        try
        {
            System.Debug('#### Method:CreateCTITaskOnCase Started ####');
            Call_Info__c  callinfo;
            List<Case> listCase = new List<Case>();
            List<Task> cTask = new List<Task>();
            
            callinfo = [SELECT BR_Call_ID__C FROM Call_Info__c WHERE BR_End_Date__c = NULL AND BR_Call_ID__C !='' AND OwnerID =: UserInfo.getUserId() ORDER BY CreatedDate DESC LIMIT 1];

            if(callinfo != NULL)
            {
                listCase = [SELECT Id, ContactId, (SELECT BR_Call_ID__C FROM TASKS) FROM CASE WHERE ID IN: caseIds];
                
                List<RecordType> recList = [SELECT id, name FROM RECORDTYPE WHERE Name = 'Broker Genesys Call' and sObjectType = 'Task'];
                Boolean CallIDexists = false;
                
                for(Case lc: listCase)
                {
                    System.Debug('Task list is: '+lc.Tasks);
                    for(Task tc: lc.Tasks)
                    {
                        if(tc.BR_Call_ID__c == callinfo.BR_Call_ID__C)
                        {
                        System.Debug('Caller ID exists '+tc.BR_Call_ID__c);
                            CallIDexists = true;
                        }
                    }
                    
                    if(CallIDexists != true)
                    {
                        Task t = new Task();
                        t.WhatId = lc.Id;
                        t.WhoId = lc.ContactId;
                        t.RecordTypeId = recList[0].Id; 
                        t.BR_Call_ID__c = callinfo.BR_Call_ID__C;
                        t.Subject = 'CTI Activity';
                        t.ActivityDate = System.Today();
                        t.BR_Completed_Date__c = System.Today();
                        t.Status = 'Completed';
                        t.BR_Activity_Type__c = 'InBound Call';
                        cTask.add(t);
                    }
                }
                
                insert cTask;
            }
            else
            {
                System.Debug('There is no CTI Activity');
            }
            System.Debug('#### Method:CreateCTITaskOnCase Ended ####');
        }
        catch(Exception e)
        {
            System.Debug('Error occured in Method:CreateCTITaskOnCase and the error is: '+e.getMessage());
        }
    }
}