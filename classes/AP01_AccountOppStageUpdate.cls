/*************************************************************
Class Name :   AP01_AccountOppStageUpdate
Date Created : 20-April-2015
Created By   : Bhaskar/Santosh
Description  : This class is used to update opportunity stage on update of account customer stage.
Change History : 
*****************************************************************/
public with sharing class AP01_AccountOppStageUpdate{
public static boolean isFirstRun = true;

/*
Method Name : getAccountswithOpportunities
Param 1 : Accepts set of accountIds
Return type : void
Description : This method is used to get the opportunities of the account and update the opportunity stage with account customer stage 
*/
public static void getAccountswithOpportunities(List<Account> newAccList,List<Account> oldAccList){
    try{
        Set<Id> accountIds = new Set<Id>();
        for(Account acc : newAccList){
            for(Account a : oldAccList){
                if(a.id==acc.id && a.Customer_Stage__c!=acc.Customer_Stage__c){
                    accountIds.add(acc.id);
                }
            }
        }
        List<Opportunity> updateOpps = new List<Opportunity>();
        for(Opportunity opp : [SELECT id, Account.Customer_Stage__c,stagename from Opportunity 
                              where AccountId IN :accountIds and stagename not in ('Sold','Lost') AND Tech_Businesstrack__c='TELESALES']){
            Account_Stage__c accountStage= Account_Stage__c.getValues(opp.Account.Customer_Stage__c);
            if(accountStage!=null){
                opp.StageName   = accountStage.Oppty_Stage__c;
                updateOpps.add(opp);
            }   
        }
        if(updateOpps !=null){
            Database.Update(updateOpps);
        }
    }catch(Exception e) {
        for(Account aa : newAccList){
            aa.addError(System.Label.ContactSystemAdmin);
        }
    }
}
public static void getAccountswithOpportunities(Map<ID,Account> newAccList,Map<ID,Account> oldAccList){
    try{
             Set<Id> accountIds = new Set<Id>();
             
             /****************************Changes Made By Sunnish 05/03/2016 Starts***********************************/
             for(ID accid : newAccList.keyset()){
                
                    if(oldAccList.containskey(accid) && newAccList.get(accid).Customer_Stage__c != oldAccList.get(accid).Customer_Stage__c)
                    {
                         accountIds.add(accid);
                    }
              }
             /****************************Changes Made By Sunnish 05/03/2016 Ends***********************************/
             
        List<Opportunity> updateOpps = new List<Opportunity>();
        for(Opportunity opp : [SELECT id, Account.Customer_Stage__c,stagename from Opportunity 
                              where AccountId IN :accountIds and stagename not in ('Sold','Lost') AND Tech_Businesstrack__c='TELESALES']){
            Account_Stage__c accountStage= Account_Stage__c.getValues(opp.Account.Customer_Stage__c);
            if(accountStage!=null){
                opp.StageName   = accountStage.Oppty_Stage__c;
                updateOpps.add(opp);
            }   
        }
        if(updateOpps !=null){
            Database.Update(updateOpps);
        }
    }catch(Exception e) {
    
        /****************************Changes Made By Sunnish 05/03/2016 Starts***********************************/
        for(ID aa : newAccList.keyset()){
            newAccList.get(aa).addError(System.Label.ContactSystemAdmin);
        /****************************Changes Made By Sunnish 05/03/2016 Ends***********************************/
        
        }
    }
}
}