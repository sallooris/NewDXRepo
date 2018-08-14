/*************************************************************
Trigger Name : LeadBeforeUpdate/AccountBeforeUpdate
Date Created : 23-June-2015
Created By   : Bhaskar
Description  : This class is used to restrict the user to take the ownership(lead/account) 
               that resides in a state that the Agent is not "Enabled to Work"
*****************************************************************/
public with sharing class AP12_RestrictOwnerChangeStateBase{
private List<Id> accUserIds = new List<Id>();
private List<Id> leadUserIds = new List<Id>();
private Map<Id,set<String>> userMap = new Map<Id,set<String>>();
public static boolean leadFirstRun = true;
public static boolean accFirstRun = true;
/*
    Method Name: restrictLeadOwnerChange
    Parameter1 : List of leads, which are updating.
    Return Type: void
    Description: This method is used to restrict the user to take the ownership of Lead 
                 that resides in a state that the Agent is not "Enabled to Work"
*/
    public void restrictLeadOwnerChange(List<Lead> leadList){
             User u = [select id,profile.name,enabled_to_work__c from user where id =:UserInfo.getUserId()];
             for(Lead l: leadList){
                 if(u.Profile.Name!='System Administrator' && l.ownerId!=u.id && (u.enabled_to_work__c==null || !u.enabled_to_work__c.contains(l.state__c))){
                         l.addError(System.Label.RestrictStateOwner);
                  }
              }
    }
/*
    Method Name: restrictAccountOwnerChange
    Parameter1 : List of accounts, which are updating.
    Return Type: void
    Description: This method is used to restrict the user to take the ownership of Account
                 that resides in a state that the Agent is not "Enabled to Work"
*/
    public void restrictAccountOwnerChange(List<Account> accList){
          User u = [select id,profile.name,enabled_to_work__c from user where id =:UserInfo.getUserId()];
             for(Account a: accList){
                 if(u.Profile.Name!='System Administrator' && a.ownerId!=u.id && (u.enabled_to_work__c==null || !u.enabled_to_work__c.contains(a.state__c))){
                         a.addError(System.Label.RestrictStateOwner);
                  }
              }
    }
}