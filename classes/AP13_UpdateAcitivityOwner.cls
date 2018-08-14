/*************************************************************
Trigger Name : LeadBeforeUpdate/AccountBeforeUpdate
Date Created : 23-June-2015
Created By   : Bhaskar
Description  : This class is used to update the acitivity onwer name when lead or account name gets changed
*****************************************************************/
public with sharing class AP13_UpdateAcitivityOwner{
    public static boolean isLeadAfterUpdate = true;
    public static boolean isAccAfterUpdate = true;
    private Set<Id> leadIds = new Set<Id>();
    private Set<Id> accIds = new Set<Id>();
    private List<Task> leadTaskList = new List<Task>();
    private List<Task> accTaskList = new List<Task>();
    /*
    Method Name: changeLeadAcitivityOwner
    Parameter1 : List of Lead records, which are updating.
    Return Type: void
    Description: This method is used to update the lead acitivity owner once the lead owner gets changed.
    */
    public void changeLeadAcitivityOwner(List<Lead> newLeadList){
        for(Lead newLead : newLeadList){
                  if(string.valueOf(newLead.OwnerId).startsWith('005')){
                      leadIds.add(newLead.id);
                  }
        }
        List<Lead> leadList = [Select ownerId, (Select ownerid From Tasks where status!='Complete' AND status!='Cancelled') From Lead where Id in :leadIds AND Tech_Businesstrack__c='TELESALES'];
        for(Lead l: leadList) {
              for(Task t : l.Tasks){
                     t.ownerId = l.ownerId;
                     leadTaskList.add(t);
              }
        }
        if(leadTaskList!=null)
        update leadTaskList;
    }
    /*
    Method Name: changeAccountAcitivityOwner
    Parameter1 : List of Account records, which are updating.
    Return Type: void
    Description: This method is used to update the account acitivity owner once the lead owner gets changed.
    */
    public void changeAccountAcitivityOwner(List<Account> newAccountList){
        for(Account newAcc : newAccountList){
                  if(string.valueOf(newAcc.OwnerId).startsWith('005')){
                      accIds.add(newAcc.id);
                  }
        }
        List<Account> accList = [Select ownerId, (Select id,ownerid From Tasks where status not in ('Complete','Cancelled')) From Account where Id in :accIds AND Tech_Businesstrack__c='TELESALES'];
        for(Account a: accList ) {
              for(Task t : a.Tasks){
                     t.ownerId = a.ownerId;
                     accTaskList.add(t);
              }
        }
        if(accTaskList !=null)
        update accTaskList;
    }
        
}