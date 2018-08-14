/*************************************************************
Trigger Name : TaskBeforeInsert 
Date Created : 05-June-2015
Created By   : Bhaskar
Description  :1.This class is used to update the kit codes on task
*****************************************************************/

public with sharing class AP07_PopulateKitIDOnTask{
    public static boolean isBeforeInsertFirstRun = true;
    public static boolean isBeforeUpdateFirstRun = true;
    /*
    Method Name: populateKitCodes
    Parameter1 : List of tasks, which are inserting.
    Return Type: void
    Description: This method is used to populate the kit ids 
                 based on the user selected language/state/email or postal address in the task
*/
    public static void populateKitIds(List<Task> taskList,String isUpdateorInsert){
             Set<Id> accountIDs = new Set<Id>();
             Set<Id> leadIDs = new Set<Id>();
             List<Id> taskIds = new List<Id>();
             Map<String,String> kitIdMap = new Map<String,String>();
             Map<String,String> brandMap = new Map<String,String>();
             Map<String,String> smcMap = new Map<String,String>();
             Map<String,String> smcBrandMap = new Map<String,String>();
             Map<String,String> smcLanguageMap = new Map<String,String>();
             List<String> lang = new List<String>();
             List<String> stateNames = new List<String>();  
             Set<String> kitNames = new Set<String>();
             List<Postcard_Proposal__c> postCardProposal =null;
             List<Postcard_Proposal__c> postCardProposal2 =null;
             List<Account> acc = new List<Account>();
             List<Lead> ld = new List<Lead>();
             Map<String,String> uniqueKitNames = new Map<String,String>();
             ID sendCommrecordtypeId =[select Id,Name from Recordtype where Name = 'Send Fulfillment' and SobjectType = 'Task'].Id;
             for(Task tt : taskList){
                 if(tt.recordTypeId == sendCommrecordtypeId){
                     taskIds.add(tt.id);
                 }
             }
             if(!taskIds.isEmpty() && taskIds != NULL){
                List<Postcard_Proposal__c> prr = [SELECT id,name,kit_name__c FROM Postcard_Proposal__c];
                for(Postcard_Proposal__c p : prr){
                    uniqueKitNames.put(p.kit_name__c.toLowerCase(),p.kit_name__c);
                }
                for(Task t: taskList){ 
                    if(t.whatId !=null && string.valueOf(t.WhatId).startsWith('001') && t.recordTypeId == sendCommrecordtypeId
                      && t.communication_type__c != NULL && t.communication_type__c != ''){
                        accountIDs.add(t.whatId);
                        lang.add(t.language__c);
                        if(uniqueKitNames.containsKey(t.communication_type__c.toLowerCase())){
                            kitNames.add(uniqueKitNames.get(t.communication_type__c.toLowerCase()));
                        }
                     } 
                     if(t.whoId!=null && string.valueOf(t.whoId).startsWith('00Q') && t.recordTypeId == sendCommrecordtypeId){
                        leadIDs.add(t.whoId);
                        lang.add(t.language__c);
                        if(uniqueKitNames.containsKey(t.communication_type__c.toLowerCase())){
                            kitNames.add(uniqueKitNames.get(t.communication_type__c.toLowerCase()));
                        }           
                     } 
                 }
                if(!accountIDs.isEmpty()){
                    acc =[Select ID,Name,state__c From Account where Id in :accountIDs AND Tech_Businesstrack__c='TELESALES'];
                }
                if(!leadIds.isEmpty()){
                    ld =[Select ID,Name,state__c From Lead where Id in :leadIds AND Tech_Businesstrack__c='TELESALES'];
                }
                for(Account a : acc){
                     stateNames.add(a.state__c);         
                }
                for(Lead l : ld){
                     stateNames.add(l.state__c);         
                }
                postCardProposal = [select Name,Language__c,State__c,Kit_Name__c,Brand__c from Postcard_Proposal__c
                                                   where Kit_Name__c in : kitNames and language__c in :lang and state__c in :stateNames ];   
                for(Postcard_Proposal__c pp : postCardProposal){
                          kitIdMap.put(pp.Kit_Name__c+pp.Language__c+pp.State__c,pp.Name);
                          brandMap.put(pp.Kit_Name__c+pp.Language__c+pp.State__c,pp.Brand__c);
                }
                postCardProposal2 = [select Name,Language__c,State__c,Kit_Name__c,Brand__c,SMC_Customer_Key__c,SMC_Brand__c,SMC_Language__c from Postcard_Proposal__c
                                                   where Kit_Name__c in : kitNames and language__c in :lang and state__c in :stateNames
                                                   and brand__c in :brandMap.values()]; 
                for(Postcard_Proposal__c pp1 : postCardProposal2){
                    smcMap.put(pp1.Kit_Name__c+pp1.Language__c+pp1.State__c+pp1.Brand__c,pp1.SMC_Customer_Key__c);
                    smcBrandMap.put(pp1.Kit_Name__c+pp1.Language__c+pp1.State__c+pp1.Brand__c,pp1.SMC_Brand__c);
                    smcLanguageMap.put(pp1.Kit_Name__c+pp1.Language__c+pp1.State__c+pp1.Brand__c,pp1.SMC_Language__c);
                } 
                if(!acc.isEmpty()){
                    for(Account a : acc){
                        for(Task t : taskList){
                            if(string.valueOf(t.whatId).equals(a.id) && isUpdateorInsert.equalsIgnoreCase('insert')){
                                String uniqueId = uniqueKitNames.get(t.communication_type__c.toLowerCase())+t.language__c+a.state__c;
                                t.Kit_ID__c = kitIdMap.get(uniqueId);
                                t.Brand__c = brandMap.get(uniqueId);
                                t.Created_Date__c = System.now();
                                if (t.Email_Address__c !=null && t.Email_Address__c != ''){
                                    String smcUniqueId = uniqueKitNames.get(t.communication_type__c.toLowerCase())+t.language__c+a.state__c+t.Brand__c;
                                    t.SMC_Customer_Key__c = smcMap.get(smcUniqueId);
                                    t.SMC_Brand__c = smcBrandMap.get(smcUniqueId);
                                    t.SMC_Language__c = smcLanguageMap.get(smcUniqueId);
                                }else{
                                   t.SMC_Customer_Key__c = ''; 
                                   t.SMC_Brand__c = '';
                                   t.SMC_Language__c = '';
                                }
                             }else if(string.valueOf(t.whatId).equals(a.id) && isUpdateorInsert.equalsIgnoreCase('update')){
                                String uniqueId = uniqueKitNames.get(t.communication_type__c.toLowerCase())+t.language__c+a.state__c;
                                t.Kit_ID__c = kitIdMap.get(uniqueId);
                                t.Brand__c = brandMap.get(uniqueId);
                                if (t.Email_Address__c !=null && t.Email_Address__c != ''){
                                    String smcUniqueId = uniqueKitNames.get(t.communication_type__c.toLowerCase())+t.language__c+a.state__c+t.Brand__c;
                                    t.SMC_Customer_Key__c = smcMap.get(smcUniqueId);
                                    t.SMC_Brand__c = smcBrandMap.get(smcUniqueId);
                                    t.SMC_Language__c = smcLanguageMap.get(smcUniqueId);
                                }else{
                                   t.SMC_Customer_Key__c = ''; 
                                   t.SMC_Brand__c = '';
                                   t.SMC_Language__c = '';
                                }
                             }
                        }
                    } 
                }
                if(!ld.isEmpty()){
                    for(Lead l: ld){
                        for(Task t : taskList){
                            if(string.valueOf(t.whoId).equals(l.id) && isUpdateorInsert.equalsIgnoreCase('insert')){
                                String uniqueId = uniqueKitNames.get(t.communication_type__c.toLowerCase())+t.language__c+l.state__c;
                                t.Kit_ID__c = kitIdMap.get(uniqueId);
                                t.Brand__c = brandMap.get(uniqueId);
                                t.Created_Date__c = System.now();
                                if (t.Email_Address__c !=null && t.Email_Address__c != ''){
                                    String smcUniqueId = uniqueKitNames.get(t.communication_type__c.toLowerCase())+t.language__c+l.state__c+t.Brand__c;
                                    t.SMC_Customer_Key__c = smcMap.get(smcUniqueId);
                                    t.SMC_Brand__c = smcBrandMap.get(smcUniqueId);
                                    t.SMC_Language__c = smcLanguageMap.get(smcUniqueId);
                                }else{
                                   t.SMC_Customer_Key__c = ''; 
                                   t.SMC_Brand__c = '';
                                   t.SMC_Language__c = '';
                                }
                             }else if(string.valueOf(t.whoId).equals(l.id) && isUpdateorInsert.equalsIgnoreCase('update')){
                                String uniqueId = uniqueKitNames.get(t.communication_type__c.toLowerCase())+t.language__c+l.state__c;
                                t.Kit_ID__c = kitIdMap.get(uniqueId);
                                t.Brand__c = brandMap.get(uniqueId);
                                if (t.Email_Address__c !=null && t.Email_Address__c != ''){
                                    String smcUniqueId = uniqueKitNames.get(t.communication_type__c.toLowerCase())+t.language__c+l.state__c+t.Brand__c;
                                    t.SMC_Customer_Key__c = smcMap.get(smcUniqueId);
                                    t.SMC_Brand__c = smcBrandMap.get(smcUniqueId);
                                    t.SMC_Language__c = smcLanguageMap.get(smcUniqueId);
                                }else{
                                   t.SMC_Customer_Key__c = ''; 
                                   t.SMC_Brand__c = '';
                                   t.SMC_Language__c = '';
                                }
                             }
                        }
                    }   
                }
           }
    }
    
}