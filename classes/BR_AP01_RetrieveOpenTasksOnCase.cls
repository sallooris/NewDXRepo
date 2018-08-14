/*****************************************************************
Class Name :   BR_AP01_RetrieveOpenTasksOnCase
Date Created : 24-July-2015
Created By   : Kishore/Nagarjuna Kaipu
Description  : This class used in Before Update trigger on Case to Restrict Case Close, if there is any open tasks
Referenced/Used in : CaseBeforeUpdate Trigger
Changed History : 
**********************************************************************/
public class BR_AP01_RetrieveOpenTasksOnCase{
    Public Static boolean isFirstRunCaseBeforeUpdate = true;
    public static Map<Id, List<Task>> mapCaseToInternalTasks = new Map<Id, List<Task>>();
    public List<Case> listCase = new List<Case>();
    /*
    Method Name : retrieveOpenTasksOnCase
    Param 1 : List of Cases
    Return Type: Void
    Description : Used to get open activities on case
    */
    public void retrieveOpenTasksOnCase(List<Case> caseList){
        
        Set<Id> closeCaseIds = New Set<Id>();
        for(case cc: caseList){
            if(cc.Status == 'Closed')
            {
                closeCaseIds.add(cc.Id);
            }
        }
        
        listCase = [SELECT Id, (SELECT Id FROM TASKS WHERE Status NOT IN ('Complete','Completed','Created In Error')) FROM CASE WHERE ID IN: closeCaseIds];
        
        for(Case c: listCase)
        {
            if(!c.tasks.IsEmpty())
            {
                throw new CustomException('Please Check, Cannot close the case until the open activities are closed.');
            }
        }
   }
}