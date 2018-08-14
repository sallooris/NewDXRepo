/*
* Class Name   : SGA_BAP01_ExpireAppByEffectiveDate
* Created Date : 07/06/2017
* Created By   : IDC Offshore
* Description  :  1. Batch class to Filter Application records based on Effective Date
* 2. Set the Status to "Enrollment Expired" if documents are not submitted by EffectiveDate 
**/
global class SGA_BAP01_ExpireAppByEffectiveDate implements Database.Batchable<SObject> {
    
    private Date todayDate = System.today();
	private String query = SG01_Constants.CLS_SGA_BAP01_QUERY; 
        
/****************************************************************************************************
Method Name : start
Parameters  : Database.BatchableContext context
Description : Method to fetch the records based on query and return Sobject to execute Method 
******************************************************************************************************/
    global Database.Querylocator start(Database.BatchableContext context) {
		
        return Database.getQueryLocator(query);
    }
    
/****************************************************************************************************
Method Name : execute
Parameters  : Database.BatchableContext context, List<SObject> scope
Description : 1. Method Filter Application records based on cuttoff Date and Application Status
              2. Updates the Application records in Batch if application is submitted before cutoff date
******************************************************************************************************/    
    global void execute(Database.BatchableContext context, List<vlocity_ins__Application__c> scope){
        //System.debug('scope.......'+scope);
        //System.debug('Record List Size ::>'+scope.size());
        try{
			List<vlocity_ins__Application__c> appListToUpdate=new List<vlocity_ins__Application__c>();
            Integer cutoffDays=Integer.valueof(Label.SG21_Day_7);           
            for(vlocity_ins__Application__c currentApp : scope) {
                //System.debug('currentApp.......'+currentApp);
                if(currentApp.Group_Coverage_Date__c.addDays(-cutoffDays) < todayDate && 
				!currentApp.vlocity_ins__Status__c.equalsIgnoreCase(SG01_Constants.DOCUMENT_SUBMITTED_STATUS)){
                    currentApp.vlocity_ins__Status__c=SG01_Constants.ENROLLMENT_EXPIRED_STATUS;
                    appListToUpdate.add(currentApp);
                }
            }
            if( !appListToUpdate.isEmpty() ){
                //System.debug('appListToUpdate size.......'+appListToUpdate.size());
                Database.update(appListToUpdate);
            } 
            
        } catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,SG01_Constants.CLS_SGA_BAP01_ExpireAppByEffectiveDate, SG01_Constants.CLS_SGA_BAP01_EXECUTE, SG01_Constants.BLANK, Logginglevel.ERROR);}
    }
    
/****************************************************************************************************
Method Name : finish
Parameters  : Database.BatchableContext context
******************************************************************************************************/    
    global void finish(Database.BatchableContext context) {
        
    }
}