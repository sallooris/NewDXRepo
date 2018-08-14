/*************************************************************
Trigger Name : TaskBeforeInsert/TaskBeforeUpdate
Date Created : 13-08-2015
Created By   : Bhaskar
Description  : This class is used to restrict the user to change the residence state of task
*****************************************************************/
public class AP18_RestrictResidenceStateChange{
    public static boolean isTaskBeforeInsertFirstRun = true;
    public static boolean isTaskBeforeUpdateFirstRun = true;
    Set<Id> leadIds = new Set<Id>(); 
    Set<Id> accIDs = new Set<ID>();
    List<Lead> leadList = new List<Lead>();
    List<Account> accList = new List<Account>();
    Map<ID,Task> leadIdTaskMap = new Map<ID,Task>();
    Map<ID,Task> accIdTaskMap = new Map<ID,Task>();
    /*
    Method Name: checkTaskRStateChanged
    Parameter1 : List of tasks.
    Return Type: void
    Description: This method is used to restrict the user to change the residence state of task
    */
    public void checkTaskRStateChanged(List<Task> taskList){
    id sendCommrecordtypeId =[select Id,Name from Recordtype where Name = 'Send Fulfillment' and SobjectType = 'Task'].Id;
        for(Task t : taskList){
            if(t.whoId != null && string.valueOf(t.WhoId).startsWith('00Q') && t.recordTypeid == sendCommrecordtypeId){
                leadIdTaskMap.put(t.whoId,t);
            }
            if(t.whatId != null && string.valueOf(t.whatId).startsWith('001') && t.recordTypeid == sendCommrecordtypeId){
                accIdTaskMap.put(t.whatId,t);
            }
        }
        if(!leadIdTaskMap.keySet().isEmpty()){
            checkLeadTaskRSChanged(leadIdTaskMap);
        }
        if(!accIdTaskMap.keySet().isEmpty()){
            checkAccTaskRSChanged(accIdTaskMap);
        }
    }
    /*
    Method Name: checkLeadTaskRSChanged
    Parameter1 : List of Leadtasks.
    Return Type: void
    Description: This method is used to restrict the user to change the residence state of task
    */
    public void checkLeadTaskRSChanged(Map<ID,Task> leadMapTask){
        leadList = [SELECT ID,State FROM LEAD WHERE ID IN : leadMapTask.keySet()];
        for(Lead l : leadList){
            if(leadMapTask.containsKey(l.id)){
                Task t = leadMapTask.get(l.id);
                if(t.residence_state__c != l.state){
                    throw new CustomException(System.Label.RestrictStateChange);
                }
            }
        }
    }
    /*
    Method Name: checkAccTaskRSChanged
    Parameter1 : List of account tasks.
    Return Type: void
    Description: This method is used to restrict the user to change the residence state of task
    */
    public void checkAccTaskRSChanged(Map<ID,Task> accMapTask){
        accList = [SELECT ID,Billing_State__c FROM Account WHERE ID IN : accMapTask.keySet()];
        for(Account acc : accList){
            if(accMapTask.containsKey(acc.id)){
                Task t = accMapTask.get(acc.id);
                if(t.residence_state__c != acc.Billing_State__c){
                    throw new CustomException(System.Label.RestrictStateChange);
                }
            }
        }
    }
}