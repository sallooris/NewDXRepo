/*****************************************************************************************
Class Name   : SGA_Util05_FilesDataAccessHelper
Date Created : 5/29/2017
Created By   : IDC Offshore
Description  : 1. This is the util data access class for ContentVersion, ContentDocumentLink objects.
2. This is used for DML Operations.
Change History : 
******************************************************************************************/
public without sharing class SGA_Util05_FilesDataAccessHelper {
    //Below are the final variables to check the operation on the list of records.
    public static final String INSERT_OPERATION = 'Insert';
    public static final String UPDATE_OPERATION = 'Update';
    public static final String DELETE_OPERATION = 'Delete';
    public static final String UPSERT_OPERATION = 'Upsert';
    
    /****************************************************************************************************
    Method Name : fetchContentDocumentLinkMap
    Parameters  : String selectQuery,String whereClause,String orderByClause,String limitClause
    Return type : Map<Id,ContentDocumentLink>
    Description : This method is used to fetch the ContentDocumentLink record based on parameters passed.
    It will return the Map<ID,ContentDocumentLink> if user wants the Map, they can perform the logic 
	on Map, else they can covert the map to list of accounts.
    ******************************************************************************************************/
   /* public static Map<ID,ContentDocumentLink> fetchContentDocumentLinkMap(String selectQuery,String whereClause,String orderByClause,
                                                                          String limitClause)
    {
        Map<ID,ContentDocumentLink> contentDocumentLinkMap = NULL;
        try
        {
            String dynaQuery = SG01_Constants.BLANK;
            dynaQuery = String.isNotBlank(selectQuery) ? selectQuery : SG01_Constants.BLANK;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(whereClause) ? dynaQuery+=whereClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(orderByClause) ? dynaQuery+=orderByClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(limitClause) ? dynaQuery+=limitClause : dynaQuery;
            
            if(String.isNotBlank(dynaQuery))
            {
                contentDocumentLinkMap = new Map<ID,ContentDocumentLink>((List<ContentDocumentLink>)Database.query(dynaQuery));
            }
        }Catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,SG01_Constants.CLS_SGA_UTIL05_FILESDATAACCESSHELPER, SG01_Constants.CLS_SGA_FCCDLMAP, SG01_Constants.BLANK, Logginglevel.ERROR);        }
        return contentDocumentLinkMap;
    }
    */
    /****************************************************************************************************
    Method Name : dmlContentVersionlist
    Parameters  : List<ContentVersion> cvList,String operation
    Return type : List<ContentVersion>
    Description : This method is used to perform the DML operations on ContentVersion.
    Operation value need to pass to perform the respective dml operation.
    Operation name should be passed from SG01_Constants class.
    ******************************************************************************************************/
    public static List<ContentVersion> dmlContentVersionlist(List<ContentVersion> cvList, String operation){
        if(!cvList.isEmpty())
        {
            if(String.isNotBlank(operation) && INSERT_OPERATION.equalsIgnoreCase(operation)){
                Database.Upsert(cvList);
            }
            /*else if(String.isNotBlank(operation) && UPDATE_OPERATION.equalsIgnoreCase(operation)){
            Database.Update(cvList);
            }else { 
            if(String.isNotBlank(operation) && UPSERT_OPERATION.equalsIgnoreCase(operation)){
            Database.Upsert(cvList); }
            }*/
        }
        return cvList;
    }
    
    /****************************************************************************************************
    Method Name : dmlContentDCLinklist
    Parameters  : List<ContentDocumentLink> cvList,String operation
    Return type : List<ContentDocumentLink>
    Description : This method is used to perform the DML operations on ContentDocumentLink.
    Operation value need to pass to perform the respective dml operation.
    Operation name should be passed from SG01_Constants class.
    ******************************************************************************************************/
    public static List<ContentDocumentLink> dmlContentDCLinklist(List<ContentDocumentLink> contentList, String operation){
        if(!contentList.isEmpty())
        {
            if(String.isNotBlank(operation) && UPSERT_OPERATION.equalsIgnoreCase(operation)){
                Database.Upsert(contentList);
            }
            /*else if(String.isNotBlank(operation) && UPDATE_OPERATION.equalsIgnoreCase(operation)){
            Database.Update(contentList);
            }else {
            if(String.isNotBlank(operation) && UPSERT_OPERATION.equalsIgnoreCase(operation)){
            Database.Upsert(contentList); }
            }*/
		}
        return contentList;
    }
    
}