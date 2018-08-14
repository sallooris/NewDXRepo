/*****************************************************************************
*Date Created : 7-24-2017
*Created By   : Akash Naik
*Description  : 1. Throws validation Rule if the case comments is edited.
2. Thows validation rule if the case comment is deleted.
*******************************************************************************/
public with sharing class SGA_AP26_CaseCommentHandler
{
    public static final string CLS_CASEHANDLER = 'SGA_AP26_CaseCommentHandler';
    public static final string METHOD_RESTRICTDELETE = 'restrictCaseCommentDelete';
    
    /*******************************************************************************
    * Method Name  : doNotEditComment
    * Created By   : IDC Offshore
    * Parameters   : List<CaseComment>
    * Description  : Used to restrict the user should to not edit the case comment
    *******************************************************************************/
    public static void doNotEditComment(List<CaseComment> cComment)
    {
        Map<id,CaseComment> ccMAP = new Map<id,CaseComment>();
        Map<Id,Id> commentRelatedCase= new Map<Id,Id>();
        Map<ID,Case> caseMAP  =  new Map<ID,Case>();
        
        try
        {
            for(CaseComment newCc: cComment)
            {
                ccMAP.put(newCc.Id,newCc);
                commentRelatedCase.put(newCc.Id,newCc.parentId);
            }
            
            SGA_Util12_CaseDataAccessHelper.caseIDSet = new Set<Id> (commentRelatedCase.values());
            
            string whereClause = SG01_Constants.CASE_SGA_AP26_WHERE_CLAUSE+SG01_Constants.AND_SPACE+SG01_Constants.TECH_BUSINESSTRACK_EQUALS+SG01_Constants.BACK_SLASH+SG01_Constants.SGQUOTING+SG01_Constants.BACK_SLASH;
            
            caseMAP = SGA_Util12_CaseDataAccessHelper.fetchCaseMap(SG01_Constants.CASE_SGA_AP26_QUERY, whereClause, SG01_Constants.BLANK, SG01_Constants.LIMIT_100);
            
            if(caseMAP.size() > 0)
            {
                for(Id tmp: ccMAP.keySet())
                {   
                    Id parentID= commentRelatedCase.get(tmp);
                    if(caseMAP.get(parentID) != NULL ){
                        ccMAP.get(tmp).addError(SG01_Constants.CASE_COMMENT_EDIT_ERROR);
                    }
                    else{}            
                }
            }
        }
        catch(exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_AP26_CASECOMMENTHANDLER, SG01_Constants.AP26_DONOTEDITCASECOMMENT, SG01_Constants.BLANK, Logginglevel.ERROR);}
    }
    
    /**************************************************************************
    * Method Name   : restrictCaseCommentDelete
    * Created Date : 8/28/2017
    * Created By   : IDC Offshore
    * Parameters   : List<CaseComment>
    * Description  : Used to restrict the user should to not delete the case 
    * 				  installation related case comment
    **************************************************************************/
    public static void restrictCaseCommentDelete(List<CaseComment> caseCommentList){
        try
        {
            Set<String> caseIds = new Set<String>();
            for(CaseComment caseCommentObj : caseCommentList){
                caseIds.add(caseCommentObj.ParentId);
            }
            Id caseInstllationRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.SG50_CaseInstallationRecType).getRecordTypeId();
            Map<ID,Case> caseMap = new Map<ID,Case>([SELECT ID,RECORDTYPEID FROM CASE WHERE ID IN :caseIds AND Tech_BusinessTrack__c = :System.Label.SG_BusinessTrack]);
            for(CaseComment caseCommentObj : caseCommentList){
                Case caseObj = caseMap.get(caseCommentObj.ParentId);
                if(caseInstllationRecTypeId == caseObj.RECORDTYPEID){
                    caseCommentObj.addError(System.Label.SG70_DoNotDeleteCaseComment);
                }
            }
        }catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, CLS_CASEHANDLER, METHOD_RESTRICTDELETE, SG01_Constants.BLANK, Logginglevel.ERROR);}
    }
}