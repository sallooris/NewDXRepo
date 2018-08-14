/*************************************************************************************************************
* Class Name  : SGA_AP27_UpdateReuploadDateTimeOnCase
* Created By  : IDC Offshore
* Created Date: 8/7/2017
* Description : This class is called from DocumentCheckListAfter update trigger and is used to update the 
* 				 reupload time stamp on related case record.
***************************************************************************************************************/
public without sharing class SGA_AP27_UpdateReuploadDateTimeOnCase {
    public static final string CLS_SGA_AP27_UPDATEREUPLOAD = 'SGA_AP27_UpdateReuploadDateTimeOnCase';
    public static final string UPDATEREUPLOADMETHOD = 'updateReuploadTimeStamp';
    public static final string CASE_QUERY = 'select ID,Tech_Broker_Re_Uploaded_Documents__c from Case ';
    public static final string WHERE_CLAUSE = 'where Id IN :caseIdSet AND RecordTypeId=:caseRecordTypeID ';
    public static final string LIMIT_CLAUSE = ' Limit 10000';
    /****************************************************************************************
* Method Name : updateReuploadTimeStamp
* Parameters  : Map<ID,DateTime>
* Description : Method is used to update the time stamp on case when the document is 
* 				 reuploaded in the document checklist record
*****************************************************************************************/
    public void updateReuploadTimeStamp(Map<ID,Application_Document_Checklist__c> newMap,Map<ID,Application_Document_Checklist__c> oldMap){
        try
        {
            Set<ID> caseIdSet = new Set<ID>();
            for(Application_Document_Checklist__c docCheckObj : newMap.values()){
                if(docCheckObj.status__c != oldMap.get(docCheckObj.id).status__c && 
                   System.Label.SG14_Re_Uploaded.equalsIgnoreCase(docCheckObj.status__c)){
                       caseIdSet.add(docCheckObj.Case__c);
                   }
            }
            SGA_Util12_CaseDataAccessHelper.caseIDSet = caseIdSet;
            SGA_Util12_CaseDataAccessHelper.caseRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.SG50_CaseInstallationRecType).getRecordTypeId();
            Map<ID,Case> caseIdMap = SGA_Util12_CaseDataAccessHelper.fetchCaseMap(CASE_QUERY, WHERE_CLAUSE, SG01_Constants.BLANK, LIMIT_CLAUSE);
            
            if(caseIdMap != NULL && !caseIdMap.isEmpty()){
                List<Case> updateCaseList = caseIdMap.values();
                for(Case caseObj : updateCaseList){
                    caseObj.Tech_Broker_Re_Uploaded_Documents__c = true;
                }
                Database.update(updateCaseList);
            }
        }Catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,CLS_SGA_AP27_UPDATEREUPLOAD, UPDATEREUPLOADMETHOD, SG01_Constants.BLANK, Logginglevel.ERROR);         }
    }
}