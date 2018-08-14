/*************************************************************
Class Name     : AP08_RestrictMultipleOpenOpportunities
Date Created   : 23-June-2015
Created By     : Bhaskar
TriggerEvent   : OpportunityBeforeInsert/OpportunityBeforeUpdate
Description    : This class is used to only allow one "open: Opportunity on a Household (Person Account) at a time.
                 for each Open Enrollment value
*****************************************************************/
public with sharing Class AP08_RestrictMultipleOpenOpportunities{  
private SET<ID> oppAccSet= new SET<ID>();
private SET<ID> oppAccUpdateSet= new SET<ID>();
private set<ID> oppIds = new set<ID>();
private MAP<ID,Set<String>> oppMap=new MAP<ID,Set<String>>();
private MAP<ID,Set<String>> oppUpdateMap=new MAP<ID,Set<String>>();
private Map<ID,Map<string,integer>> oppCountMap = new Map<ID,Map<string,integer>>();

public static boolean isFirstRunOPPBeforeInsert= true;
public static boolean isFirstRunOPPBeforeUpdate= true;
    /*
         Method Name : restrictMultipleOpenOpp
         Param1      : List of Opportunities
         return type : void
         Description : This method is used to only allow one "open: Opportunity on a Household (Person Account) at a time
    */
    
    public void restrictMultipleOpenOpp(List<Opportunity> OppList){
        try{
            for(Opportunity opp: oppList){     
                    oppAccSet.add(opp.AccountID);            
              }
            List<Account> accList = [SELECT id,(select id,stagename,Open_Enrollment__c from opportunities where stagename not in (:System.Label.ClosedWon,:System.Label.ClosedLost)) from Account
                                        where id in :oppAccSet AND Tech_Businesstrack__c='TELESALES']; 
            for(Account a : accList){
                Set<String> oppSet = new Set<String>();
                for(Opportunity opp: a.opportunities){
                    oppSet.add(opp.Open_Enrollment__c);
                }
                oppMap.put(a.id,oppSet);
            }
           for(Opportunity oppr: oppList){
               if(oppMap.containsKey(oppr.AccountID) && oppMap.get(oppr.AccountID).contains(oppr.Open_Enrollment__c) && (oppr.stagename!=System.Label.ClosedWon && oppr.stagename!=System.Label.ClosedLost)){
                   oppr.addError(System.Label.RetrictMultipleOpp);
               }
           }
            
        }catch(Exception e){ 
               System.debug(e);
        }
 }
  /*
         Method Name : restrictMultipleOpenOppUpdate
         Param1      : List of Opportunities
         return type : void
         Description : This method is used to only allow one "open: Opportunity on a Household (Person Account) at a time
 */
        public void restrictMultipleOpenOppUpdate(List<Opportunity> newOppList){
        try{
           
           for(Opportunity opp: newOppList){
                       oppAccUpdateSet.add(opp.AccountID); 
                   }
            List<Account> accList = [SELECT id,(select id,stagename,Open_Enrollment__c from opportunities where stagename not in (:System.Label.ClosedWon,:System.Label.ClosedLost)) from Account
                                        where id in :oppAccUpdateSet AND Tech_Businesstrack__c='TELESALES'];  
            for(Account a : accList){
                Set<String> oppSet = new Set<String>();
                for(Opportunity opp: a.opportunities){
                    oppSet.add(opp.Open_Enrollment__c);
                }
                oppUpdateMap.put(a.id,oppSet);
            }
           for(Opportunity oppr: newOppList){
               if(oppUpdateMap.containsKey(oppr.AccountID) && oppUpdateMap.get(oppr.AccountID).contains(oppr.Open_Enrollment__c) && (oppr.stagename!=System.Label.ClosedWon && oppr.stagename!=System.Label.ClosedLost)){
                       oppr.addError(System.Label.RetrictMultipleOpp);
                  
               }
           }
            
        }catch(Exception e){ 
               System.debug(e);
        }
    }
}