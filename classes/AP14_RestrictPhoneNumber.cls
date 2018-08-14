/*************************************************************
Class Name     : AP14_RestrictPhoneNumber
Date Created   : 07-July-2015
Created By     : Bhaskar
Description    : This class is used to validate the Phone fields on Leads/Accounts
Used in Trigger: TaskBeforeInsert/TaskBeforeUpdate
Audit History  :
Description    : If Work Phone/Mobile Phone/ Home phone is blank in Lead/Account, 
                 while adding Work Phone/Mobile Phone/Home Phone in Schedule follow up task, 
                 system should throw ERROR message that selected Phone number is blank. 
*****************************************************************/
public with sharing class AP14_RestrictPhoneNumber{
     public static boolean isBeforeInsertFirstRun = true;
     public static boolean isBeforeUpdateFirstRun = true;
     Set<Id> accountIDs = new Set<Id>();
     Set<Id> leadIDs = new Set<Id>();
     Set<Id> homePhoneAccIds = New Set<Id>();
     Set<Id> mobilePhoneAccIds = New Set<Id>();
     Set<Id> workPhoneAccIds=new Set<Id>();
     Set<Id> homePhoneLeadIds = New Set<Id>();
     Set<Id> mobilePhoneLeadIds = New Set<Id>();
     Set<Id> workPhoneLeadIds=new Set<Id>();
     /*
         Method Name : checkPhoneNumber
         Param1      : List of Tasks
         return type : void
         Description : This method is used to check phone number is empty on lead/account
                         
     */
     public void checkPhoneNumber(List<TasK> taskList){
        for(Task t: taskList){ 
             if(t.whatId !=null && string.valueOf(t.WhatId).startsWith('001')){
                 accountIDs.add(t.whatId);
             }  
             if(t.whoId!=null && string.valueOf(t.whoId).startsWith('00Q')){
                 leadIDs.add(t.whoId);
             } 
         }
         if(!accountIDs.isEmpty()){
             List<Account> accList =[Select Phone,Mobile_Phone__c,Work_Phone__c From Account where Id in :accountIDs AND Tech_Businesstrack__c='TELESALES'];
             costructAccuntSets(accList);
         }
         if(!leadIDs.isEmpty()){
             List<Lead> ldList =[Select Phone,Mobile_Phone__c,Work_Phone__c From Lead where Id in :leadIds AND Tech_Businesstrack__c='TELESALES'];
             costructLeadSets(ldList);
         }
         validatePhones(taskList);
       }
     /*
         Method Name : costructAccuntSets
         Param1      : List of accounts
         return type : void
         Description : This method is used to contruct the empty home/mobile/work phone account records               
     */
       public void costructAccuntSets(List<Account> accList){
            for(Account a : accList){
            
                if (a.Phone==NULL || a.Phone==''){
                     homePhoneAccIds.add(a.id);
                }if(a.Mobile_Phone__c==NULL || a.Mobile_Phone__c==''){
                     mobilePhoneAccIds.add(a.id);
                }if(a.Work_Phone__c==NULL || a.Work_Phone__c==''){
                     workPhoneAccIds.add(a.id);
                }
          }
        }
        /*
         Method Name : costructLeadSets
         Param1      : List of leads
         return type : void
         Description : This method is used to contruct the empty home/mobile/work phone lead records   
        */
        public void costructLeadSets(List<lead> ldList){
            for(Lead l : ldList){
            
                if (l.Phone==NULL || l.Phone==''){
                     homePhoneLeadIds.add(l.id);
                }if(l.Mobile_Phone__c==NULL || l.Mobile_Phone__c==''){
                     mobilePhoneLeadIds.add(l.id);
                }if(l.Work_Phone__c==NULL || l.Work_Phone__c==''){
                     workPhoneLeadIds.add(l.id);
                }
            }
        }
        /*
         Method Name : validatePhones
         Param1      : List of tasks
         return type : void
         Description : This method is used to validate the phone field is empty while creating tasks for 
                       accounts / leads.
        */
        public void validatePhones(List<Task> taskList){
        id scheduleFollowuprecordtypeId =[select Id,Name from Recordtype where Name = 'Schedule Followup' and SobjectType = 'Task'].Id;
           for(Task t: taskList){
                  if(t.whatId !=null && string.valueOf(t.WhatId).startsWith('001') && t.recordTypeid == scheduleFollowuprecordtypeId){
                     if(homePhoneAccIds.contains(t.whatID) && ('Home Phone').equalsIgnoreCase(t.Phone_Number__c)){
                          throw new CustomException(System.Label.RestrictedPhone);
                     } 
                     else if(mobilePhoneAccIds.contains(t.whatID) && ('Mobile Phone').equalsIgnoreCase(t.Phone_Number__c)){
                          throw new CustomException(System.Label.RestrictedPhone);
                     } 
                     else if(workPhoneAccIds.contains(t.whatID) && ('Work Phone').equalsIgnoreCase(t.Phone_Number__c)){
                          throw new CustomException(System.Label.RestrictedPhone);
                     }    
                 }
                 if(t.whoId!=null && string.valueOf(t.whoId).startsWith('00Q') && t.recordTypeid == scheduleFollowuprecordtypeId){
                     if(homePhoneLeadIds.contains(t.whoID) && ('Home Phone').equalsIgnoreCase(t.Phone_Number__c)){
                          throw new CustomException(System.Label.RestrictedPhone);
                     } 
                     else if(mobilePhoneLeadIds.contains(t.whoID) && ('Mobile Phone').equalsIgnoreCase(t.Phone_Number__c)){
                          throw new CustomException(System.Label.RestrictedPhone);
                     } 
                     else if(workPhoneLeadIds.contains(t.whoID) && ('Work Phone').equalsIgnoreCase(t.Phone_Number__c)){
                          throw new CustomException(System.Label.RestrictedPhone);
                     } 
                 }
             }
        }
     
}