/*************************************************************
Trigger Name : TaskAfterInsert/TaskAfterUpdate
Date Created : 30-July-2015
Created By   : Bhaskar
Description  : This class is used to populate the marketing id on lead / account, once maketing id inserted/updated in Inbound/Outbound Call Acitivity.
*****************************************************************/
public with sharing class AP17_PopulateMrktngIDONLeadORAccount{
    public static boolean isTaskAfterInsertFirstRun = true;
    public static boolean isTaskAfterUpdateFirstRun = true;
    Set<Id> leadIds = new Set<Id>(); 
    Set<Id> accIDs = new Set<ID>();
    List<Lead> leadsToUpdate = new List<Lead>();
    List<Lead> leadList = new List<Lead>();
    List<Account> accToUpdate = new List<Account>();
    List<Account> accList = new List<Account>();
    Set<String> marketingIds = new Set<String>();
    List<Campaign> campaignList = new List<Campaign>();
    Map<Id,String> campaignMap = new Map<Id,String>();
    Map<Id,Id> leadCampaignMap = new Map<Id,Id>();
    Map<Id,Id> accCampaignMap = new Map<Id,Id>();
    /*  
    Method name : populateMarketingIDONLeadORAccount
    Param 1     : List of Task Ids
    Return Type : Void
    Description : This method is used to populate Marketing ID on lead/account
                  when Inbound/Outbound call acitivity gets created/updated with Marketing ID
    */
    public void populateMarketingIDONLeadORAccount(List<Task> taskList){
        for(Task t : taskList){
            if(t.whoId != null && string.valueOf(t.WhoId).startsWith('00Q')){
                leadIds.add(t.whoId);
            }
            if(t.whatId != null && string.valueOf(t.whatId).startsWith('001')){
                accIds.add(t.whatId);
            }
        }
        if(!leadIds.isEmpty()){
            populateLeadMarketingCampaign(leadIds);
        }
        if(!accIds.isEmpty()){
            populateAccMarketingCampaign(accIds);
        }
    }
    /*  
    Method name : populateLeadMarketingCampaign
    Param 1     : Set of Lead Ids
    Return Type : Void
    Description : This method is used to populate Marketing ID on lead
                  when Inbound/Outbound call acitivity gets created/updated with Marketing ID
    */
    public void populateLeadMarketingCampaign(Set<ID> leadIds){
          leadList = [SELECT ID,NAME,Marketing_Event__c,Marketing_Campaign__c,(Select Id,Marketing_ID__c,Marketing_Campaign__c From Tasks where Marketing_ID__c!=NULL ORDER BY createddate DESC LIMIT 1) FROM LEAD WHERE ID IN : leadIds];
            for(Lead l : leadList){
                for(Task t : l.tasks){
                        campaignMap.put(l.id,t.Marketing_ID__c);
                        marketingIds.add(t.Marketing_ID__c);
                }
            }
            if(!marketingIds.isEmpty()){
                campaignList = [SELECT ID,NAME FROM Campaign where NAME IN :marketingIds];
            }
            for(Lead l : leadList){
                for(Campaign c : campaignList){
                    if(c.name == campaignMap.get(l.id)){
                        leadCampaignMap.put(l.id,c.id);
                    }
                }
            }
            for(Lead l : leadList){
                if(leadCampaignMap.containsKey(l.id)){
                    l.Marketing_Event__c = leadCampaignMap.get(l.id);
                    leadsToUpdate.add(l);
                }
            }
            if(!leadsToUpdate.isEmpty()){
                update leadsToUpdate;
            }
    }
    /*  
    Method name : populateAccMarketingCampaign
    Param 1     : Set of Account Ids
    Return Type : Void
    Description : This method is used to populate Marketing ID on Account 
                  when Inbound/Outbound call acitivity gets created/updated with Marketing ID
    */
    public void populateAccMarketingCampaign(Set<ID> accIds){
        accList = [SELECT ID,Marketing_Event__c,Marketing_Campaign__c,(Select Id,Marketing_ID__c,Marketing_Campaign__c From Tasks where Marketing_ID__c!=NULL ORDER BY createddate DESC LIMIT 1) FROM Account WHERE ID IN : accIDs];
            for(Account a : accList){
                for(Task t : a.tasks){
                        campaignMap.put(a.id,t.Marketing_ID__c);
                        marketingIds.add(t.Marketing_ID__c);
                }
            }
            if(!marketingIds.isEmpty()){
                campaignList = [SELECT ID,NAME FROM Campaign where NAME IN :marketingIds];
            }
            for(Account a : accList){
                for(Campaign c : campaignList){
                    if(c.name == campaignMap.get(a.id)){
                        accCampaignMap.put(a.id,c.id);
                    }
                }
            }
            for(Account a : accList){
                if(accCampaignMap.containsKey(a.id)){
                    a.Marketing_Event__c = accCampaignMap.get(a.id);
                    accToUpdate.add(a);
                }
            }
            if(!accToUpdate.isEmpty()){
                update accToUpdate;
            }
    }
}