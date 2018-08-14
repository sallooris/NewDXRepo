/*
* Class Name   : SGA_AP08_DocumentCheckListCtrl
* Created Date : 16/5/2017
* Created By   : IDC Offshore
* Description  :  1. Apex Controller to handle In SGA_LTNG10_DocumentCheckList Component
*                 2. Performs Update, Delete and Displaying of DocumentCheckList for particular Application record.
**/
public without sharing class SGA_AP08_DocumentCheckListCtrl {   
  
   @AuraEnabled
  public static Id appId{get;set;}
  private static Final String APP_START='a20';
  private static Final String CASE_START='500';
  private static final string RELATED_CASE = ' Case__c ';
/****************************************************************************************************
Method Name : getDocumentCheckList
Parameters  : String Name
Return type : List<Application_Document_Checklist__c>
Description : This method is used to fetch the Document_Checklist record based on applicationId
******************************************************************************************************/
    @AuraEnabled
    public static List<Application_Document_Checklist__c> getDocumentCheckList(String applicationId) {
       Map<Id,Application_Document_Checklist__c> documentCheckListMap= new Map<Id,Application_Document_Checklist__c>();
       String whereClause ='';
       try{ 
           if(applicationId.startsWith(APP_START)){
               whereClause= SG01_Constants.SPACE+SG01_Constants.WHERE_CLAUSE+SG01_Constants.APPLICATION_API_NAME+
                         SG01_Constants.EQUALS_SLASH+String.escapeSingleQuotes(applicationId)+SG01_Constants.BACK_SLASH;
           }
           if(applicationId.startsWith(CASE_START)){
               whereClause= SG01_Constants.SPACE+SG01_Constants.WHERE_CLAUSE+RELATED_CASE+
                         SG01_Constants.EQUALS_SLASH+String.escapeSingleQuotes(applicationId)+SG01_Constants.BACK_SLASH;
           }
            
            documentCheckListMap = SGA_Util04_DCDataAccessHelper.fetchDocumentChecklistMap(SG01_Constants.CLS_SGA_AP08_DCQUERY,
                                                                                           whereClause,SG01_Constants.BLANK,
                                                                                           SG01_Constants.BLANK);
        } Catch(Exception ex) { UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_AP08_DOCUMENTCHECKLIST, SG01_Constants.GETDOCUMENTCHECKLIST, SG01_Constants.BLANK, Logginglevel.ERROR);
        }
        return new List<Application_Document_Checklist__c>(documentCheckListMap.values());
    }
    
@AuraEnabled
/****************************************************************************************************
    Method Name : getDeletedlist
    Parameters  : String docId
    Return type : void
    Description : This method is used to fetch the Document_Checklist record to be deleted
                  and calls SGA_Util04_DCDataAccessHelper.dmlDocChecklist to delete it
******************************************************************************************************/
  public static void getDeletedlist(String docId) {
        List<Application_Document_Checklist__c> documentCheckListFromQuery = new List<Application_Document_Checklist__c>();
        try{
            String whereClause = SG01_Constants.SPACE+SG01_Constants.WHERE_CLAUSE+SG01_Constants.SPACE+SG01_Constants.ID+
                SG01_Constants.EQUALS_SLASH+String.escapeSingleQuotes(docId)+SG01_Constants.BACK_SLASH;
            Map<ID,Application_Document_Checklist__c> docChecklistMap = SGA_Util04_DCDataAccessHelper.fetchDocumentChecklistMap(SG01_Constants.CLS_SGA_AP08_DCQUERY_DOCID,
                                                                  whereClause,SG01_Constants.BLANK,SG01_Constants.BLANK);
            if(!docChecklistMap.isEmpty())
            {
                documentCheckListFromQuery = docChecklistMap.values();
            }
            SGA_Util04_DCDataAccessHelper.dmlDocChecklist(documentCheckListFromQuery,SG01_Constants.DELETE_OPERATION);
        } Catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_AP08_DOCUMENTCHECKLIST, SG01_Constants.GETDELETEDLIST, SG01_Constants.BLANK, Logginglevel.ERROR);}
        
    }
    
@AuraEnabled
/****************************************************************************************************
    Method Name : updatedDocument
    Parameters  : Application_Document_Checklist__c updatedDC
    Return type : void
    Description : This method is used to fetch the Document_Checklist record to be updated
                  and calls SGA_Util04_DCDataAccessHelper.dmlDocChecklist to update it
******************************************************************************************************/
   public static void updatedDocument(Application_Document_Checklist__c updatedDC) {
       try{
            SGA_Util04_DCDataAccessHelper.dmlDocChecklist(new List<Application_Document_Checklist__c>{updatedDC},
                                                          SG01_Constants.UPDATE_OPERATION);
        } Catch(Exception ex) { UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_AP08_DOCUMENTCHECKLIST, SG01_Constants.UPDATEDDOCUMENT, SG01_Constants.BLANK, Logginglevel.ERROR);}
        
    }

/****************************************************************************************************
    Method Name : getdocumentDetails
    Parameters  : String docId
    Return type : Application_Document_Checklist__c
    Description : This method is used to fetch the single Document_Checklist record based on docId
******************************************************************************************************/  
    @AuraEnabled
    public static Application_Document_Checklist__c getdocumentDetails(String docId) {
        Application_Document_Checklist__c details = new Application_Document_Checklist__c();
        try{
             String whereClause = SG01_Constants.SPACE+SG01_Constants.WHERE_CLAUSE+SG01_Constants.SPACE+SG01_Constants.ID+
                SG01_Constants.EQUALS_SLASH+String.escapeSingleQuotes(docId)+SG01_Constants.BACK_SLASH;
            
            Map<Id,Application_Document_Checklist__c> docChecklistMap = SGA_Util04_DCDataAccessHelper.fetchDocumentChecklistMap(SG01_Constants.CLS_SGA_AP08_DCQUERY_DOCID,
                                                                                           whereClause,SG01_Constants.BLANK,
                                                                                           SG01_Constants.BLANK);
			if(docChecklistMap != NULL && !docChecklistMap.isEmpty()){
			details = docChecklistMap.values()[0];
			  if( details != NULL){
				  appId=details.Application__c;
			  }
            }	
        } Catch(Exception ex) { UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_AP08_DOCUMENTCHECKLIST, SG01_Constants.GETDOCUMENTDETAILS, SG01_Constants.BLANK, Logginglevel.ERROR);}
        return details ;
     }
	
    
    @AuraEnabled
    /****************************************************************************************************
    Method Name : getDocumentStatus
    Parameters  : String docId
    Return type : List<PicklistOption>
    Description : This method is used to fetch status value from document check list records
    ******************************************************************************************************/
    public static List<PicklistOption> getDocumentStatus(String docId){
        List<PicklistOption> options = new List<PicklistOption>();
        try{
            String currentStatus = [select status__c from Application_Document_CheckList__c where Id=:docId].status__c;
            
            options.add( new PicklistOption(currentStatus,currentStatus) );
            Schema.DescribeFieldResult fieldResult = Application_Document_CheckList__c.status__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry f: ple) {
                if(!f.getLabel().equalsIgnoreCase(currentStatus)){
                    options.add(new PicklistOption(f.getLabel(),f.getLabel()));
                }
            }
        } Catch(Exception ex) { UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_AP08_DOCUMENTCHECKLIST, SG01_Constants.GETDOCUMENTDETAILS, SG01_Constants.BLANK, Logginglevel.ERROR);}
        return options ;
    }
    
	/****************************************************************************************************
    Method Name : getCurrentUserProfile
    Parameters  : None
    Return type : String
    Description : This method is used to fetch the current Logged In user Profile and returns Profile Name
    ******************************************************************************************************/
     @AuraEnabled
    public static String getCurrentUserProfile() {
        String profileName='';
		Try{
			Map<Id,Profile> profileMap=new Map<Id,Profile>();
		// Select clause for Profile            
        String appSelectClause=SG01_Constants.PROFILE_QUERY;
        // Where clause for Profile
        String profileWhereClause = SG01_Constants.WHERE_CLAUSE+SG01_Constants.SPACE+SG01_Constants.ID+SG01_Constants.EQUALS_SLASH+String.escapeSingleQuotes(userinfo.getProfileId())+SG01_Constants.BACK_SLASH; 
        // fetch the Profile details from SGA_Util10_ProfileDataAccessHelper
        profileMap = SGA_Util10_ProfileDataAccessHelper.fetchProfileMap(appSelectClause,profileWhereClause,SG01_Constants.BLANK,SG01_Constants.LIMIT_1 );
				if( profileMap != NULL && !profileMap.isEmpty() ){
				 profileName = profileMap.get(userinfo.getProfileId()).Name;	
				}
		}Catch(Exception ex){ UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_AP08_DOCUMENTCHECKLIST, SG01_Constants.GETCURRENTUSERPROFILE, SG01_Constants.BLANK, Logginglevel.ERROR);}
        
        return profileName;
    }
    
     /**
     * The system class PicklistEntry is not aura enabled so cannot be returned from @AuraEnabled method.
     * Workaround is to define our own class with aura enabled properties.
     */
    public without sharing class PicklistOption {
        
        @AuraEnabled
        public String label { get; set; }
        
        @AuraEnabled
        public String value { get; set; }
        /**
        * The system class PicklistEntry is not aura enabled so cannot be returned from @AuraEnabled method.
        * Workaround is to define our own class with aura enabled properties.
        */
        public PicklistOption( String label, String value ) {
            this.label = label;
            this.value = value;
        }
        
    }
}