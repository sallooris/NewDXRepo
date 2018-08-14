public with sharing class BR_AP02_CreateCTIActivityOnNewCase {
    Public Static boolean isFirstRunCaseAfterInsert = true;
//     Public boolean CallIDexists = false;
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
            List<Case> listCase = new List<Case>();
            List<Task> cTask = new List<Task>();

            listCase = [SELECT Id, Origin, Call_Id__c, ContactId, (SELECT BR_Call_ID__C FROM TASKS) FROM CASE WHERE ID IN: caseIds];
            List<RecordType> recList = [SELECT id, name FROM RECORDTYPE WHERE Name = 'Broker Genesys Call' and sObjectType = 'Task'];

            boolean CallIDexists = false;
            
            for(Case lc: listCase)
            {
                // check case source & make sure user is on a call
                if (lc.Origin == 'Phone' && lc.Call_Id__c != null)
                {
                    for(Task tc: lc.Tasks)
                    {
                        if(tc.BR_Call_ID__c == lc.Call_Id__c)
                        {
                            System.Debug('Caller ID exists '+tc.BR_Call_ID__c);
                            CallIDexists = true;
                        }
                    }
                    System.Debug('CallIDexists = '+CallIDexists);
                    if(CallIDexists != true)
                    {
                        Task t = new Task();
                        t.WhatId = lc.Id;
                        t.WhoId = lc.ContactId;
                        t.RecordTypeId = recList[0].Id; 
                        t.BR_Call_ID__c = lc.Call_Id__c;
                        t.Subject = 'CTI Activity';
                        t.ActivityDate = System.Today();
                        t.BR_Completed_Date__c = System.Today();
                        t.Status = 'Completed';
                        t.BR_Activity_Type__c = 'InBound Call';
                        cTask.add(t);
                    }
                }
                else
                {
                    System.Debug('There is no CTI Activity');
                }
            }
            insert cTask;
            System.Debug('#### Method:CreateCTITaskOnCase Ended ####');
        }
        catch(Exception e)
        {
            System.Debug('Error occured in Method:CreateCTITaskOnCase and the error is: '+e.getMessage());
        }
    }
}