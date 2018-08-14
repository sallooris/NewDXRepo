/*****************************************************************************************
Class Name   : SGA_Util12_CaseDataAccessHelper
Date Created : 8/1/2017
Created By   : IDC Offshore
Description  : 1. This is the util data access class for Case. Which is used to fetch 
the details from Case based on some parameters
2. This is used for DML Operations.
Change History : 
******************************************************************************************/
public without sharing class SGA_Util12_CaseDataAccessHelper {
    
    //Below are the final variables to check the operation on the list of records.
    public static final String INSERT_OPERATION = 'Insert';
    public static final String UPDATE_OPERATION = 'Update';
    public static final String DELETE_OPERATION = 'Delete';
    public static final String UPSERT_OPERATION = 'Upsert';
    public static String statusClosed ;
    public static set<id> caseIDSet;
    public static set<id> accIdSet;
    public static set<id> applicationIDSet;
    public static Id caseRecordTypeID;

    /****************************************************************************************************
    Method Name : fetchCaseMap
    Parameters  : String selectQuery,String whereClause,String orderByClause,String limitClause
    Return type : Map<Id,Case>
    Description : This method is used to fetch the Account record based on parameters passed.
    It will return the Map<ID,Account> if user wants the Map, they can perform the logic on 
    Map, else they can covert the map to list of accounts.
    ******************************************************************************************************/
    public static Map<ID,Case> fetchCaseMap(String selectQuery,String whereClause,String orderByClause,String limitClause){
        String dynaQuery = SG01_Constants.BLANK;
        Map<ID,Case> accountMap = NULL;
        
        dynaQuery = String.isNotBlank(selectQuery) ? selectQuery : SG01_Constants.BLANK;
        dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(whereClause) ? dynaQuery+=whereClause : dynaQuery;
        dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(orderByClause) ? dynaQuery+=orderByClause : dynaQuery;
        dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(limitClause) ? dynaQuery+=limitClause : dynaQuery;
        if(String.isNotBlank(dynaQuery))
        {
            accountMap = new Map<ID,Case>((List<Case>)Database.query(dynaQuery));
        }
        return accountMap;
    }
    
    /****************************************************************************************************
    Method Name : dmlOnCase
    Parameters  : List<Case> accList, String operation
    Return type : List<Case>
    Description : This method is used to perform the DML operations on Acocunt.
    Operation value need to pass to perform the respective dml operation.
    Operation name should be passed from SG01_Constants class.
    ******************************************************************************************************/
    public static List<Case> dmlOnCase(List<Case> caseList, String operation){
        
        if(caseList != NULL && !caseList.isEmpty())
        {
            if(String.isNotBlank(operation) && INSERT_OPERATION.equalsIgnoreCase(operation)){
                Database.Insert(caseList);
            }else if(String.isNotBlank(operation) && UPDATE_OPERATION.equalsIgnoreCase(operation)){
                Database.Update(caseList);
            }else if(String.isNotBlank(operation) && DELETE_OPERATION.equalsIgnoreCase(operation)){
                Database.Delete(caseList);
            }else if(String.isNotBlank(operation) && UPSERT_OPERATION.equalsIgnoreCase(operation)){
                Database.Upsert(caseList);
            }
            
        }
        return caseList;
    }
}