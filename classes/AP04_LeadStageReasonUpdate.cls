/*************************************************************
Class Name   : AP04_LeadStageReasonUpdate
Date Created : 26-May-2015
Created By   : Bhaskar
Description  : This class is helper class for TaskAfterInsert trigger
*****************************************************************/
public with sharing class AP04_LeadStageReasonUpdate{
public static boolean isFirstRun = true;
/*
Method Name: updateStageReason
Parameter1 : List of tasks, which are inserting.
Return Type: void
Description: This method is used to update the Outbound Call Count on Lead and it will update the Customer Stage
and Reason once the outbound call count reached to 10
*/
public static void updateStageReason(List<Task> taskList){
    Set<Id> leadIDs = new Set<Id>(); 
    List<Lead> leadsToUpdate = new List<Lead>();
    List<Lead> leadStatusUpdate = new List<Lead>();
    for(Task t: taskList){ 
        if(t.whoId !=null){
            if(string.valueOf(t.WhoId).startsWith('00Q')) 
                leadIDs.add(t.WhoId); 
        }
    } 
    if(!LeadIDs.isEmpty()){
        List<Lead> leadList = [Select l.Id,l.Status,l.Reason__c,l.Number_of_Call_Attempts__c, (Select Id From Tasks where Activity_Type__c =:System.Label.OutboundCall
        and Call_Disposition__c!=:System.Label.CustomerReached) From Lead l where Id in :leadIDs AND Tech_Businesstrack__c='TELESALES'];
        for(Lead l: leadList) {
            leadsToUpdate.add(new Lead(Id=l.Id, Number_of_Call_Attempts__c = l.Tasks.size()));
            if(l.Tasks.size()>=10){
                leadStatusUpdate.add(new Lead(Id=l.Id,Status='Exhausted',Reason__c='Unable to Contact'));
            }
        }
        if(leadsToUpdate!=null){
            update leadsToUpdate;
        }
        if(leadStatusUpdate!=null){
            update leadStatusUpdate;
        }
    }
}
}