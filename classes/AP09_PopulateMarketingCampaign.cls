/*************************************************************
Trigger Name : LeadBeforeInsert/LeadBeforeUpdate
ClassName    : AP09_PopulateMarketingCampaign
Date Created : 10-June-2015
Created By   : Bhaskar
Description  : This class is used to auto populate the marketing campaign based on the marketing event id#
*****************************************************************/
public with sharing class AP09_PopulateMarketingCampaign{
 public static boolean isLeadInsertFirstRun = true;
 public static boolean isLeadUpdateFirstRun = true;
 public static boolean isAccInsertFirstRun = true;
 public static boolean isAccUpdateFirstRun = true;
 public static boolean isTaskInsertFirstRun = true;
 public static boolean isTaskUpdateFirstRun = true;
 private List<Task> taskList= New List<Task>();
 Map<String,String> campaignMap= New Map<String,String>();
 private List<Campaign> campaignList = null;
    /*
    Method Name: populateLeadMarketingCampaign
    Parameter1 : List of lead records, which are inserting/updating.
    Return Type: void
    Description: This method is used to populate the marketing campaign 
                
*/
  /*   public void populateLeadMarketingCampaign(List<Lead> ldList,Boolean isUpdate){
      Set<string> leadMarketingEventIds = new Set<string>();
      List<Lead> leadwithActivities = New List<Lead>();
      Map<id,task> leadTaskMap = New Map<id,task>();
        if(isUpdate == true){
            leadwithActivities = [select id,Marketing_Event__c,Marketing_Campaign__c,(Select Id,Marketing_ID__c,Marketing_Campaign__c From Tasks where Marketing_ID__c!=NULL ORDER BY createddate DESC LIMIT 1) From Lead where Id in :ldList AND Tech_Businesstrack__c='TELESALES'];
            for(lead l : leadwithActivities){
                for(task tsk : l.tasks){
                    leadTaskMap.put(l.id,tsk);    
                }
            } 
            for(Lead l : ldList){
                if(leadTaskMap.containsKey(l.Id)){
                    l.Marketing_Event__c = leadTaskMap.get(l.id).Marketing_ID__c;
                    l.Marketing_Campaign__c = leadTaskMap.get(l.id).Marketing_Campaign__c;    
                }else{
                    leadMarketingEventIds.add(l.Marketing_Event__c);
                }
            }
        }else{
            for(Lead l : ldList){
                leadMarketingEventIds.add(l.Marketing_Event__c);
            }
        }
        if(!leadMarketingEventIds.isEmpty()){
            for(campaign c : [select Name,Description from Campaign where name in :leadMarketingEventIds]){
                campaignMap.put(c.Name,c.Description);
            }
            for(Lead l : ldList){
                if(campaignMap.containsKey(l.Marketing_Event__c)){
                    l.Marketing_Campaign__c = campaignMap.get(l.Marketing_Event__c);
                }
                else{
                    l.Marketing_Campaign__c = ''; 
                }
            }
        }
        
    }*/
/*
    Method Name: populateAccMarketingCampaign
    Parameter1 : List of Account records, which are inserting/updating.
    Return Type: void
    Description: This method is used to populate the marketing campaign 
*/
   /* public void populateAccMarketingCampaign(List<Account> accList,Boolean isUpdate){
        Set<string> accMarketingEventIds = new Set<string>();
        List<Account> accwithActivities = New List<Account>();
        Map<id,task> accTaskMap = New Map<id,task>();
        if(isUpdate == true){
            accwithActivities = [select id,Marketing_Event__c,Marketing_Campaign__c,(Select Id,Marketing_ID__c,Marketing_Campaign__c From Tasks where Marketing_ID__c!=NULL ORDER BY createddate DESC LIMIT 1) From Account where Id in :accList AND Tech_Businesstrack__c='TELESALES'];
            for(Account a : accwithActivities ){
                for(task tsk : a.tasks){
                    accTaskMap.put(a.id,tsk);    
                }
            } 
            for(Account a : accList){
                if(accTaskMap.containsKey(a.Id)){
                   a.Marketing_Event__c = accTaskMap.get(a.id).Marketing_ID__c;
                    a.Marketing_Campaign__c = accTaskMap.get(a.id).Marketing_Campaign__c;    
                }else{
                    accMarketingEventIds.add(a.Marketing_Event__c);
                }
            }
        }else{
            for(Account ac : accList){
                    accMarketingEventIds.add(ac.Marketing_Event__c);
            }
        }
        if(!accMarketingEventIds.isEmpty()){
            for(campaign c : [select Name,Description from Campaign where name in :accMarketingEventIds]){
                campaignMap.put(c.Name,c.Description);
            }
            for(Account acc : accList){
                if(campaignMap.containsKey(acc.Marketing_Event__c)){
                    acc.Marketing_Campaign__c = campaignMap.get(acc.Marketing_Event__c);
                }
                else{
                    acc.Marketing_Campaign__c = '';    
               }
            }
        }
    }*/
    
    
    /*
    Method Name: populateTaskMarketingCampaign
    Parameter1 : List of task records, which are inserting/updating.
    Return Type: void
    Description: This method is used to populate the marketing campaign           
    */
    
    public void populateTaskMarketingCampaign(List<Task> tasksList){
        Set<string> taskLeadMarketingEventIds = new Set<string>();
        Set<String> taskLeadDNIS = new Set<String>();
        Set<String> taskLeadStates = new Set<String>();
        Set<string> taskAccMarketingEventIds = new Set<string>();
        Set<String> taskAccDNIS = new Set<String>();
        Set<String> taskAccStates = new Set<String>();
        Set<ID> leadIds = new Set<ID>();
        Set<ID> accIds = new Set<ID>();
        for(Task t : tasksList){
            if(t.whoId != null && string.valueOf(t.WhoId).startsWith('00Q')){
                taskLeadMarketingEventIds.add(t.Marketing_ID__c);
                taskLeadDNIS.add(t.DNIS__c);
                leadIds.add(t.whoId);
            }
            if(t.whatId != null && string.valueOf(t.WhatId).startsWith('001')){
                taskAccMarketingEventIds.add(t.Marketing_ID__c);
                taskAccDNIS.add(t.DNIS__c);
                accIds.add(t.whatId);
            }
        }
        if(!leadIds.isEmpty()){
            populateMarketingCampaignONTaskANDLead(leadIds,taskLeadMarketingEventIds,taskLeadDNIS,tasksList);
        }
        if(!accIds.isEmpty()){
            populateMarketingCampaignONTaskANDAccount(accIds,taskAccMarketingEventIds,taskAccDNIS,tasksList);
        }
    }
    /*
    Method Name: populateTaskMarketingCampaign
    Parameter1 : List of task records, which are inserting/updating.
    Return Type: void
    Description: This method is used to populate the marketing campaign           
    */    
    public void populateMarketingCampaignONTaskANDLead(Set<ID> ldId,Set<String> taskMarketingEventIds,Set<String> taskDNIS,List<Task> leadTasks){
        List<Lead> taskLeads = [SELECT State__c FROM LEAD WHERE ID IN : ldId];
        Set<String> taskLeadStates = new Set<String>();
        for(Lead l : taskLeads){
            taskLeadStates.add(l.state__c);
        }
        if(!taskMarketingEventIds.isEmpty()){
                for(campaign c : [select Id,Name,Description from Campaign where name in :taskMarketingEventIds and toll_free_number__c in :taskDNIS and Brand__c in :taskLeadStates]){
                    campaignMap.put(c.Name,c.Description);
                }
                for(task tk : leadTasks){
                    if(campaignMap.containsKey(tk.Marketing_ID__c)){
                        tk.Marketing_Campaign__c = campaignMap.get(tk.Marketing_ID__c);
                    }
                    else{
                        tk.Marketing_Campaign__c = '';
                    }
                }
        }
    }
    /*
    Method Name: populateTaskMarketingCampaign
    Parameter1 : List of task records, which are inserting/updating.
    Return Type: void
    Description: This method is used to populate the marketing campaign           
    */
    public void populateMarketingCampaignONTaskANDAccount(Set<ID> accId,Set<String> taskMarketingEventIds,Set<String> taskDNIS,List<Task> accTasks){
        List<Account> taskAccount = [SELECT State__c FROM Account WHERE ID IN : accId];
        
        Set<String> taskAccStates = new Set<String>();
        for(Account a : taskAccount){
            taskAccStates.add(a.state__c);
        }
        if(!taskMarketingEventIds.isEmpty()){
                for(campaign c : [select Id,Name,Description from Campaign where name in :taskMarketingEventIds and toll_free_number__c in :taskDNIS and Brand__c in :taskAccStates]){
                    campaignMap.put(c.Name,c.Description);
                }
                for(task tk : accTasks){
                    if(campaignMap.containsKey(tk.Marketing_ID__c)){
                        tk.Marketing_Campaign__c = campaignMap.get(tk.Marketing_ID__c);
                    }
                    else{
                        tk.Marketing_Campaign__c = '';
                    }
                }
        }
    }
}