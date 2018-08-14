/*************************************************************
Class Name     : AP10_ValidateSuppressOnTask
Date Created   : 11-June-2015
Created By     : Bhaskar
Description    : This class is used to validate the Suppression fields on Account and Leads
Used in Trigger: TaskBeforeInsert/TaskBeforeUpdate
Audit History  : Added by Santosh
                 Description : validation to provide a reason for outbound calls based on the DNC flag.
*****************************************************************/
public with sharing class AP10_ValidateSuppressOnTask{
     public static boolean isBeforeInsertFirstRun = true;
     public static boolean isBeforeUpdateFirstRun = true;
     Set<Id> accountIDs = new Set<Id>();
     Set<Id> leadIDs = new Set<Id>();
     Set<Id> suppressAccIds = New Set<Id>();
     Set<Id> suppressEmailAccIds = New Set<Id>();
     Set<Id> suppressPostalAccIds = New Set<Id>();
     Set<Id> suppressLeadIds = New Set<Id>();
     Set<Id> suppressEmailLeadIds = New Set<Id>();
     Set<Id> suppressPostalLeadIds = New Set<Id>();
     Set<Id> suppressPhoneAccIds=new Set<Id>();
     Set<Id> suppressPhoneLeadIds=new Set<Id>();
     /*
         Method Name : checkSuppress
         Param1      : List of Tasks
         return type : void
         Description : This method is used to check is there any email or postal field suppressed on Account/Lead
                         1. If yes, this will restrict the user to create email fulfillment/postal fulfillment
                         2. If no, email/postal fulfillment will be created.
                         
     */
     public void checkSuppress(List<TasK> taskList){
        for(Task t: taskList){ 
             if(t.whatId !=null && string.valueOf(t.WhatId).startsWith('001')){
                 accountIDs.add(t.whatId);
             }  
             if(t.whoId!=null && string.valueOf(t.whoId).startsWith('00Q')){
                 leadIDs.add(t.whoId);
             } 
         }     
    /* Removed Suppress , add after field chane Suppress__c,*/
        if(!accountIDs.isEmpty()){
             List<Account> accList =[Select Suppress__c,Suppressed_Email__c,Suppressed_Mail__c,Suppressed_Phone__c,Suppressed_HomePhone__c,
                                     Suppressed_WorkPhone__c,state__c,Consent_Days__c From Account where Id in :accountIDs AND Tech_Businesstrack__c='TELESALES'];
             costructAccuntSets(accList);
         }
         /* Removed Suppress , add after field chane Suppress__c,*/
         if(!leadIDs.isEmpty()){
             List<Lead> ldList =[Select Suppress__c,Suppressed_Email__c,Suppressed_Mail__c,Suppressed_Phone__c,Suppressed_HomePhone__c,
                                 Suppressed_WorkPhone__c,state__c,Consent_Days__c From Lead where Id in :leadIds AND Tech_Businesstrack__c='TELESALES'];
             costructLeadSets(ldList);
         }
         validateSupress(taskList);
       }
     /*
         Method Name : costructAccuntSets
         Param1      : List of accounts
         return type : void
         Description : This method is used to contruct the suppressed accounts               
     */
       public void costructAccuntSets(List<Account> accList){
            for(Account a : accList){
            
                if (a.Consent_Days__c < SYSTEM.NOW() && (a.Suppressed_Phone__c == true || a.Suppressed_HomePhone__c == true || a.Suppressed_WorkPhone__c == true)){
                     suppressPhoneAccIds.add(a.id);
                }
                if(a.Suppress__c == true){
                    suppressAccIds.add(a.id);        
                }
                else if(a.Suppressed_Email__c){
                    suppressEmailAccIds.add(a.id);
                }
                else if(a.Suppressed_Mail__c){
                    suppressPostalAccIds.add(a.id);
                }
          }
        }
        /*
         Method Name : costructLeadSets
         Param1      : List of leads
         return type : void
         Description : This method is used to contruct the suppressed leads
        */
        public void costructLeadSets(List<lead> ldList){
            for(Lead l : ldList){
            
                if (l.Consent_Days__c < SYSTEM.NOW() && (l.Suppressed_Phone__c == true || l.Suppressed_HomePhone__c == true || l.Suppressed_WorkPhone__c == true)){
                     suppressPhoneLeadIds.add(l.id);
                }
                if(l.Suppress__c == true){
                    suppressLeadIds.add(l.id);        
                }
                else if(l.Suppressed_Email__c){
                    suppressEmailLeadIds.add(l.id);
                }
                else if(l.Suppressed_Mail__c){
                    suppressPostalLeadIds.add(l.id);
                } 
            }
        }
        /*
         Method Name : validateSupress
         Param1      : List of tasks
         return type : void
         Description : This method is used to validate the suppression fields of accounts / leads with respective tasks.
        */
        public void validateSupress(List<Task> taskList){
        id sendCommrecordtypeId =[select Id,Name from Recordtype where Name = 'Send Fulfillment' and SobjectType = 'Task'].Id;
        Id InboundOutboundRecordtypeID=[select Id,Name from Recordtype where Name = 'Inbound/Outbound Call Activity' and SobjectType = 'Task'].Id;
            for(Task t: taskList){
                  if(t.whatId !=null && string.valueOf(t.WhatId).startsWith('001') && t.recordTypeid == InboundOutboundRecordtypeID && t.Activity_Type__c=='Outbound Call' && (t.Override_Exception_Reasons__c == null || t.Override_Exception_Reasons__c == '')){
                    if(suppressPhoneAccIds.contains(t.whatID)){
                          throw new CustomException('Please select an Override/Exception Reasons');
                     }
                  }
                  if(t.whatId !=null && string.valueOf(t.WhatId).startsWith('001') && t.recordTypeid == sendCommrecordtypeId ){
                     if(suppressAccIds.contains(t.whatID)){
                          throw new CustomException(System.Label.suppresserrormsg);
                     } 
                     else if(suppressEmailAccIds.contains(t.whatID) && t.Email_Address__c!=null){
                          throw new CustomException(System.Label.suppresserrormsg);
                     }
                     else if(suppressPostalAccIds.contains(t.whatID) && t.Postal_Address__c!=null){
                          throw new CustomException(System.Label.suppresserrormsg);
                     }        
                 }  
                 if(t.whoId !=null && string.valueOf(t.whoId).startsWith('00Q') && t.recordTypeid == InboundOutboundRecordtypeID && t.Activity_Type__c=='Outbound Call' && (t.Override_Exception_Reasons__c == null || t.Override_Exception_Reasons__c == '')){
                    if(suppressPhoneLeadIds.contains(t.whoId)){
                          throw new CustomException('Please select an Override/Exception Reasons');
                     }
                  }
                 if(t.whoId!=null && string.valueOf(t.whoId).startsWith('00Q') && t.recordTypeid == sendCommrecordtypeId){
                     if(suppressLeadIds.contains(t.whoId)){
                         throw new CustomException(System.Label.suppresserrormsg);
                     }
                     else if(suppressEmailLeadIds.contains(t.whoId) && t.Email_Address__c!=null){
                          throw new CustomException(System.Label.suppresserrormsg);
                     }
                     else if(suppressPostalLeadIds.contains(t.whoId) && t.Postal_Address__c!=null){
                         throw new CustomException(System.Label.suppresserrormsg);
                     }
                 }
             }
        }
     
}