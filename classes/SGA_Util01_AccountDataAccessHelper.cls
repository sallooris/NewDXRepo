/*****************************************************************************************
Class Name   : SGA_Util01_AccountDataAccessHelper
Date Created : 5/24/2017
Created By   : IDC Offshore
Description  : 1. This is the util data access class for Account. Which is used to fetch 
the details from Account based on some parameters
2. This is used for DML Operations.
Change History : 
******************************************************************************************/
public with sharing class SGA_Util01_AccountDataAccessHelper {
    //Below are the final variables to check the operation on the list of records.
    public static final String INSERT_OPERATION = 'Insert';
    public static final String UPDATE_OPERATION = 'Update';
    public static final String DELETE_OPERATION = 'Delete';
    public static final String UPSERT_OPERATION = 'Upsert';
    public static Set<ID> accountIdSet;
    public static String recordTypeId;
    /****************************************************************************************************
    Method Name : fetchAccountsMap
    Parameters  : String selectQuery,String whereClause,String orderByClause,String limitClause
    Return type : Map<Id,Account>
    Description : This method is used to fetch the Account record based on parameters passed.
    It will return the Map<ID,Account> if user wants the Map, they can perform the logic on 
    Map, else they can covert the map to list of accounts. 
    ******************************************************************************************************/
    public static Map<ID,Account> fetchAccountsMap(String selectQuery,String whereClause,String orderByClause,String limitClause){
        String dynaQuery = SG01_Constants.BLANK;
        Map<ID,Account> accountMap = NULL;
        
        dynaQuery = String.isNotBlank(selectQuery) ? selectQuery : SG01_Constants.BLANK;
        dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(whereClause) ? dynaQuery+=whereClause : dynaQuery;
        dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(orderByClause) ? dynaQuery+=orderByClause : dynaQuery;
        dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(limitClause) ? dynaQuery+=limitClause : dynaQuery;
        if(String.isNotBlank(dynaQuery))
        {
            System.debug('dynaQuery:::'+dynaQuery);
            accountMap = new Map<ID,Account>((List<Account>)Database.query(dynaQuery));
        }
        return accountMap;
    }
    
    /****************************************************************************************************
    Method Name : dmlOnAccount
    Parameters  : List<Account> accList, String operation
    Return type : List<Account>
    Description : This method is used to perform the DML operations on Acocunt.
    Operation value need to pass to perform the respective dml operation.
    Operation name should be passed from SG01_Constants class.
    ******************************************************************************************************/
    /* Please un comment if we are using the dml on Account and call this method.
    public static List<Account> dmlOnAccount(List<Account> accList, String operation){
   
        if(accList != NULL && !accList.isEmpty())
        {
            if(String.isNotBlank(operation) && INSERT_OPERATION.equalsIgnoreCase(operation)){
            Database.Insert(accList);
            }else if(String.isNotBlank(operation) && UPDATE_OPERATION.equalsIgnoreCase(operation)){
            Database.Update(accList);
            }else if(String.isNotBlank(operation) && DELETE_OPERATION.equalsIgnoreCase(operation)){
            Database.Delete(accList);
            }else if(String.isNotBlank(operation) && UPSERT_OPERATION.equalsIgnoreCase(operation)){
            Database.Upsert(accList);
            }
        }
        return accList;
    }*/
}