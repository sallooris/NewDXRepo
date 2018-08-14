/*
* Class Name   : SGA_AP33_CreateCaseComment
* Created Date : 08-Aug-2017
* Created By   : IDC Offshore
* Description  :  1. Apex Controller to handle In SGA_LTNG11_CreateCaseComment Lightning Component
*             
**/
public without sharing class SGA_AP33_CreateCaseComment {

    public Case cas{get;set;}
    
/****************************************************************************************************
Method Name : SGA_AP33_CreateCaseComment
Parameters  : ApexPages.StandardController
Return type : 
Description : This is Parameterized Constructor to intialize Case data
******************************************************************************************************/
    public SGA_AP33_CreateCaseComment(ApexPages.StandardController controller) 
    {
        this.cas = (Case)controller.getRecord();
    }
    
    @AuraEnabled
      /****************************************************************************************************
    Method Name : getInProcessQuotesList
    Parameters  : CaseComment, String ParentId
    Return type : NA
    Description : This method is used to Insert CaseCommebt
    ******************************************************************************************************/
    public static void createCaseComment(CaseComment cc, string caseParnt)
    {
        try
        {
            if(cc != NULL && caseParnt != NULL)
            {
                CaseComment caseCommentObj = new CaseComment();
                caseCommentObj.parentId = caseParnt;
                caseCommentObj.CommentBody = cc.CommentBody;
                caseCommentObj.IsPublished = cc.IsPublished;
                if(caseCommentObj != NULL)
                {
                    database.insert(caseCommentObj);
                }
            }
        }
        catch(exception ex)
        {
             UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, 
             SG01_Constants.CLS_SGA_AP33_CREATECASECOMMENT, SG01_Constants.SGA_AP33_CREATECASECOMMENT, SG01_Constants.BLANK, 
             Logginglevel.ERROR);
        }
    }      
}