/**
* Class Name : VlocityApplicationTriggerHandler
* Author : nmishra@vlocity.com
* Description : Trigger Handler for the vlocity_ins__Application__c SObject. This class provides as an handler for events in VlocityApplication.Trigger
* Last Modified Date : 22-08-2016
*/

public without sharing class VlocityApplicationTriggerHandler {
    Public Static boolean isFirstRunAfterUpdate = true;
    
    /**
* Method Name : onAfterInsert
* Author : nmishra@vlocity.com
* Description : Accepts Trigger.new values from the AfterInsert event on VlocityApplication.Trigger
* Param : List<vlocity_ins__Application__c>
* Return : Void
*/
    public void onAfterInsert(Map<Id, vlocity_ins__Application__c> oldApplicationMap, final List<vlocity_ins__Application__c> newApplicationList) {
        List<ApplicationAndAccountWrapper> applicationAndAccountWrapperList = new List<ApplicationAndAccountWrapper>();
        Set<Id> opportunityIdSet = new Set<Id>();
        Map<Id, Set<Id>> accIdToGroupIdsMap = new Map<Id, Set<Id>>();
        List<vlocity_ins__Application__Share> applicationShareToBeInsertedList = new List<vlocity_ins__Application__Share>();
        
        
        for(vlocity_ins__Application__c tmpApp : newApplicationList) {
            if(tmpApp.Opportunity_Id__c != null && oldApplicationMap.get(tmpApp.Id).Opportunity_Id__c != tmpApp.Opportunity_Id__c) {
                opportunityIdSet.add(tmpApp.Opportunity_Id__c);
                
            }
        }
        try {
            Map<Id, Opportunity> oppIdToOpportunityMap ;
            if(opportunityIdSet.size() > 0)
                oppIdToOpportunityMap = new Map<Id, Opportunity>([SELECT AccountId,Broker__c,GeneralAgency__c,PaidAgency__c,Broker__r.Account.Id FROM Opportunity WHERE Id IN : opportunityIdSet]);
            if(oppIdToOpportunityMap != null && !oppIdToOpportunityMap.isEmpty()) {
                for(vlocity_ins__Application__c tmpApp : newApplicationList) {
                    if(String.isNotBlank(tmpApp.Opportunity_Id__c)) {
                        applicationAndAccountWrapperList.add(new ApplicationAndAccountWrapper(tmpApp.Id, tmpApp.Opportunity_Id__c, oppIdToOpportunityMap.get(tmpApp.Opportunity_Id__c).GeneralAgency__c, oppIdToOpportunityMap.get(tmpApp.Opportunity_Id__c).PaidAgency__c, oppIdToOpportunityMap.get(tmpApp.Opportunity_Id__c).Broker__r.Account.Id));
                    }
                }
            }
            if(!applicationAndAccountWrapperList.isEmpty()) {
                ApplicationSharingHelper appSharingHelper = new ApplicationSharingHelper();
                
                accIdToGroupIdsMap = appSharingHelper.getAccountIdToGroupRoleIds(applicationAndAccountWrapperList);
                if(!accIdToGroupIdsMap.isEmpty()) {
                    for(ApplicationAndAccountWrapper tmpWrap : applicationAndAccountWrapperList) {
                        for(Id tmpAccId : tmpWrap.agenciesIdSet) {
                            if(accIdToGroupIdsMap.containsKey(tmpAccId)) {
                                for(Id tmpGrpId : accIdToGroupIdsMap.get(tmpAccId)) {
                                    vlocity_ins__Application__Share appShare = new vlocity_ins__Application__Share();
                                    appShare.ParentId = tmpWrap.applicationId;
                                    appShare.AccessLevel = Label.Application_Access_Level;
                                    appShare.RowCause = 'Manual';
                                    appShare.UserOrGroupId = tmpGrpId;
                                    
                                    applicationShareToBeInsertedList.add(appShare);
                                    
                                }
                            }
                            
                            
                        }
                    }
                }
            }
            
            if(!applicationShareToBeInsertedList.isEmpty())
                Database.insert(applicationShareToBeInsertedList);
        }catch(Exception exptn) {
            System.debug('##001 '+exptn.getMessage());
        }
    }
    
    /**
    * Method Name : onAfterUpdate
    * Author : IDC Offshore
    * Description : Accepts Trigger.newMap, Trigger.OldMap values from the AfterUpdate event on VlocityApplication.Trigger
    * Param : Trigger.OldMap, Trigger.NewMap
    * Return : Void
    * Author : IDC Offshore
    */
    public void onAfterUpdate(Map<Id, vlocity_ins__Application__c> oldApplicationMap, Map<Id, vlocity_ins__Application__c> newApplicationMap){
        
        SGA_AP14_CreateDocumentChecklist.createDocumentsForApplication(oldApplicationMap, newApplicationMap);
        SGA_AP14_CreateDocumentChecklist.updateDocumentsForApplication(oldApplicationMap, newApplicationMap);
        
        
		//this is for updating the created/updated date on account.
        handlerUtilInsertUpdate(newApplicationMap.values());        
    }
    
    /**
    * Method Name : onAfterInsert
    * Author : IDC Offshore
    * Description : Accepts Trigger.newMap values from the AfterInsert event on VlocityApplication.Trigger
    * Param : Trigger.NewMap
    * Return : Void
    * Author : IDC Offshore
    */
    public void onAfterInsert(Map<Id, vlocity_ins__Application__c> newApplicationMap){
        Map<ID,vlocity_ins__Application__c> applicationMap = new Map<ID,vlocity_ins__Application__c>();
        Map<ID,vlocity_ins__Application__c> applicationOldMap = new Map<ID,vlocity_ins__Application__c>();
        for(vlocity_ins__Application__c appObj : newApplicationMap.values()){
            //creating a map if the application type is only Paper Application
            if(System.Label.SG42_PaperApplication.equalsIgnoreCase(appObj.vlocity_ins__Type__c)){
                applicationMap.put(appObj.Id,appObj);
            }
        }
        //this is for document checklist creation
        SGA_AP14_CreateDocumentChecklist.createDocumentsForApplication(null, applicationMap);
        //this is for updating the created/updated date on account.
        handlerUtilInsertUpdate(newApplicationMap.values());
        //this is for sharing application access to the team members.
        SGA_AP36_AppShareToAccTeamMembers.createAppSharingToTeamMembers(applicationMap);
         // call createOrUpdateInstallationCase() to create  Cases if status is Group Submitted Under Review
        SGA_AP20_CreateInstallationCase.createOrUpdateInstallationCase(newApplicationMap,applicationOldMap);
    }
    
    /*****************************************************************************************************
     * Method Name  : handlerUtilInsertUpdate
     * Created Date : 8-Aug-2017
     * Created By   : IDC Offshore
     * Description  : Used to update Application created/last modified date on Account
     *****************************************************************************************************/
    public static void handlerUtilInsertUpdate(List<vlocity_ins__Application__c> appList){
        Map<ID,String> accountIdAppMap = new Map<ID,String>();
        for(vlocity_ins__Application__c appObj : appList){
            if(String.isNotBlank(appObj.vlocity_ins__AccountId__c)){
                accountIdAppMap.put(appObj.vlocity_ins__AccountId__c,System.Label.SG53_ApplicationObjName);
            }
        }
        if(!accountIdAppMap.isEmpty()){
            SGA_AP28_UpdateLastModifiedDateOnAccount updateLMDObj = new SGA_AP28_UpdateLastModifiedDateOnAccount();
            updateLMDObj.updateLMDOnAccountFromQuoteorApp(accountIdAppMap);
        }
    }
    /*****************************************************************************************************
     * Method Name  : onAfterUpdateStatus
     * Created Date : 12-Aug-2017
     * Parameters   : Map<Id, vlocity_ins__Application__c>,Map<Id, vlocity_ins__Application__c>
     * Return type  : void
     * Created By   : IDC Offshore
     * Description  : Used to create case installation case when the application status is changed to 
     * 				  Group Submitted, Under Review
     *****************************************************************************************************/
    public static void onAfterUpdateStatus(Map<Id, vlocity_ins__Application__c> newApplicationMap,
                                           Map<Id, vlocity_ins__Application__c> oldApplicationMap){
        // call createOrUpdateInstallationCase() to create or update Installation case based on Application Status
        SGA_AP20_CreateInstallationCase.createOrUpdateInstallationCase(newApplicationMap,oldApplicationMap);                                   
        
    }
     /*****************************************************************************************************
     * Method Name  : onBeforeInsert
     * Created Date : 25-Aug-2017
     * Parameters   : List<vlocity_ins__Application__c>
     * Return type  : void
     * Created By   : IDC Offshore
     * Description  : Used to update party id on application record.
     *****************************************************************************************************/
    public static void onBeforeInsert(List<vlocity_ins__Application__c> newAppList){
        SGA_AP41_UpdatePartyIdOnApplication updatePartyObj = new SGA_AP41_UpdatePartyIdOnApplication();
        updatePartyObj.updatePartyAccount(newAppList);
    }
}