/*
* Class Name   : SGA_BAP02_CloseOppByEffectiveDate
* Created Date : 09/12/2017
* Created By   : IDC Offshore
* Description  :  1. Batch class to Filter Opportunity records based on Effective Date
* 2. Set the set Disposition = Lost
**/
global class SGA_BAP02_CloseOppByEffectiveDate implements Database.Batchable<SObject> {
   public Integer cutoffDays;
   private DateTime lastModifiedCutoff;
   private DateTime todayDate = System.Today();
   private static final String  REC_TYPE= 'SGQUOTING';
   private static final String  DISPOSITION_LOST= 'Lost';
   private static final String  CLS_SGA_BAP02= 'SGA_BAP02_CloseOppByEffectiveDate';
   private String queryString;  
   public static final String SGA_BAP02_QUERY = 'Select Id,LastModifiedDate,Effective_Date__c,StageName from Opportunity Where isClosed =false AND LastModifiedDate <= :lastModifiedCutoff AND Tech_Businesstrack__c =:REC_TYPE AND Effective_Date__c != NULL';
   
/****************************************************************************************************
Method Name : SGA_BAP02_CloseOppByEffectiveDate
Parameters  : Database.BatchableContext context
Description : Method to fetch the records based on query and return Sobject to execute Method 
******************************************************************************************************/ 
 public SGA_BAP02_CloseOppByEffectiveDate(integer cutoffDays ){
        this.cutoffDays=cutoffDays;
        lastModifiedCutoff = System.Now() -cutoffDays;
        queryString = SGA_BAP02_QUERY;
    }
    
/****************************************************************************************************
Method Name : start
Parameters  : Database.BatchableContext context
Description : Method to fetch the records based on query and return Sobject to execute Method 
******************************************************************************************************/
    global Database.Querylocator start(Database.BatchableContext context) {
        return Database.getQueryLocator(queryString);
    }
    
/****************************************************************************************************
Method Name : execute
Parameters  : Database.BatchableContext context, List<SObject> scope
Description : 
1. Method Filter Opportunity records based on cuttoff Date and Opportunity Stae
2. Updates the Opportunity records in Batch if Opportunity is not  modified for past 30 days
******************************************************************************************************/    
    global void execute(Database.BatchableContext context, List<Opportunity> scope){
        try{
        List<Opportunity> oppListToUpdate=new List<Opportunity>();
                       
            for(Opportunity currentOpp : scope) {
                if(currentOpp.Effective_Date__c.addDays(cutoffDays) <= todayDate){
                    currentOpp.StageName=DISPOSITION_LOST;
                    oppListToUpdate.add(currentOpp);
                }
            }
            if(!oppListToUpdate.isEmpty()){
               Database.update(oppListToUpdate,false);
            }   
        } catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,CLS_SGA_BAP02, SG01_Constants.CLS_SGA_BAP01_EXECUTE, SG01_Constants.BLANK, Logginglevel.ERROR);}
    }
    
/****************************************************************************************************
Method Name : finish
Parameters  : Database.BatchableContext context
******************************************************************************************************/    
    global void finish(Database.BatchableContext context) {
        
    }
}