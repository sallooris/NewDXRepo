/*
* Class Name   : SGA_AP09_ApplicationActionBtnRenderer
* Created Date : 05/06/2017
* Created By   : IDC Offshore
* Description  :  1. Apex Extension to Show/Hide ActionButton
**/
public with Sharing class SGA_AP09_ApplicationActionBtnRenderer {
    
    public string appId {get;set;}
    public Boolean renderBtn{get;set;}
	public vlocity_ins__Application__c app{get;set;}
	public vlocity_ins__Application__c appDetails{get;set;}
     
/****************************************************************************************************
Method Name : SGA_AP09_ApplicationActionBtnRenderer
Parameters  : ApexPages.StandardController controller
Description : Constructor to intialize application ID and set the ActionButton Visibility
******************************************************************************************************/
    public SGA_AP09_ApplicationActionBtnRenderer(ApexPages.StandardController controller) {
       	 
	   try { 
	       appDetails=new vlocity_ins__Application__c(); 
		 	app= (vlocity_ins__Application__c)controller.getRecord();
			appId= app.Id;
			renderBtn=true;
			//System.debug('Application ID in extension'+ appId);
		   
			String selectClause=SG01_Constants.SGA_AP06_APPLICATIONOBJQUERY;
			
			String whereClause = SG01_Constants.WHERE_CLAUSE+SG01_Constants.SPACE+SG01_Constants.ID+SG01_Constants.EQUALS_SLASH+String.escapeSingleQuotes(appId)+SG01_Constants.BACK_SLASH; 
			
			Map<Id,vlocity_ins__Application__c> applicationMap = new Map<Id,vlocity_ins__Application__c>();
            applicationMap =  SGA_Util03_ApplicationDataAccessHelper.fetchApplicationMap(selectClause,whereClause,SG01_Constants.BLANK,SG01_Constants.LIMIT_1);
    
	   //System.debug('applicationMap '+ applicationMap);
	   
	   if(!applicationMap.isEmpty()) {
		   appDetails=applicationMap.get(appId);
	    }
	   
        if( appDetails != NULL && appDetails.Group_Coverage_Date__c != NULL){
           getButtonVisibility(appDetails.Group_Coverage_Date__c,appDetails.vlocity_ins__Status__c);
        }
			 
		}Catch(Exception ex) {UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,SG01_Constants.CLS_SGA_AP09_ApplicationActionBtnRenderer,SG01_Constants.CLS_SGA_AP09_ApplicationActionBtnRenderer,SG01_Constants.BLANK, Logginglevel.ERROR);}
     }
	
/****************************************************************************************************
Method Name : getButtonVisibility
Parameters  : Date effectiveDate,String appStatus
Description : Method to set the Button Visibility based on Effective date and Application Status
******************************************************************************************************/
	 public void getButtonVisibility(Date effectiveDate,String appStatus) {
		 try {
		    Date todayDate= System.today();
            //System.debug('appStatus ::>'+ appStatus);
            Integer cutoffDays=Integer.valueof(Label.SG21_Day_7);
            User usr =[Select Id,ContactId from user Where Id=: UserInfo.getUserId() limit 1 ];
			
            if( String.isNotBlank(usr.ContactId) && (effectiveDate.addDays(-cutoffDays) < todayDate && !appStatus.equalsIgnoreCase(SG01_Constants.DOCUMENT_SUBMITTED_STATUS))){
				renderBtn=false;
            }
             if(!String.isBlank(appStatus) ){
                  if( appStatus.equals(SG01_Constants.ENROLLMENT_EXPIRED_STATUS )) {
                renderBtn=false;
               }
            }
           
			//System.debug('renderBtn final ::>'+ renderBtn);
			
		 }Catch(Exception ex) {UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,SG01_Constants.CLS_SGA_AP09_ApplicationActionBtnRenderer,SG01_Constants.CLS_SGA_AP09_GETBUTTONVISIBILITY, SG01_Constants.BLANK, Logginglevel.ERROR);}
	}
}