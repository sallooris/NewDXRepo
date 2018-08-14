/*
* Class Name   : SGA_AP18_DCEmailCompCtrl
* Created Date : 14-July-2017
* Created By   : IDC Offshore
* Description  :  1. Apex Controller to handle In SGA_C02_DocumentChkEmailComponent Component
*                 2. Fetches the value for Document Checklist record for Application
                with Status 'Missing Information'.
**/
public with Sharing class SGA_AP18_DCEmailCompCtrl {
    public static String appId{get;set;}
    public static String docStatus{get;set;}
    public static List<Application_Document_Checklist__c> docList;
    /****************************************************************************************************
    Method Name : getDocList
    Parameters  : NONE
    Return type : String
    Description : Fetches the value for BRAND from Quote record for the related Application.
******************************************************************************************************/
    public static List<Application_Document_Checklist__c> getdocList(){
         List<Application_Document_Checklist__c> dcList=new List<Application_Document_Checklist__c>();
         System.debug('appId::>'+appId);
         System.debug('docStatus::>'+docStatus);
        if(appId != NULL && docStatus != NULL ) {
            // Select clause for Application            
           // String dcSelectClause=SG01_Constants.CLS_SGA_AP18_DCQUERY;
            //String docStatus=SG01_Constants.DC_STATUS_MISSINFO;
           // Where clause for Application
          // String dcWhereClause = SG01_Constants.WHERE_CLAUSE+SG01_Constants.SPACE+SG01_Constants.ID+SG01_Constants.EQUALS_SLASH+String.escapeSingleQuotes(appId)+SG01_Constants.BACK_SLASH+SG01_Constants.SPACE+SG01_Constants.AND_SPACE +SG01_Constants.DC_STATUS +SG01_Constants.SPACE +docStatus; 
           //Map<Id,Application_Document_Checklist__c> dcMap=SGA_Util04_DCDataAccessHelper.fetchDocumentChecklistMap(dcSelectClause,dcWhereClause,SG01_Constants.BLANK,SG01_Constants.LIMIT_1);
            try{
                dcList=[SELECT Id,Name,Document_Returned_Reason__c,Application__c,Required__c,Document_Name__c,Status__c,File_Name__c,File_Size__c,File_URL__c,Reviewer_Notes__c FROM Application_Document_Checklist__c where Application__c =:appId and Status__c =:docStatus];
           
       
            }Catch(Exception ex){ System.debug('msg::>>'+ex.getMessage());}
           
          System.debug('dcList::>'+dcList);
           }
         return dcList;
    }
    
  

}