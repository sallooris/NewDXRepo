/*****************************************************************************************
Class Name   : SGA_Util02_OSInstanceDataAccessHelper
Date Created : 5/24/2017
Created By   : IDC Offshore
Description  : 1. This is the util data access class for OmniScript Instance object.
Which is used to fetch the details from Account based on some parameters
2. This is used for DML Operations.
Change History : 
******************************************************************************************/
public with sharing class SGA_Util02_OSInstanceDataAccessHelper {
    //Below are the final variables to check the operation on the list of records.
    public static final String INSERT_OPERATION = 'Insert';
    public static final String UPDATE_OPERATION = 'Update';
    public static final String DELETE_OPERATION = 'Delete';
    public static final String UPSERT_OPERATION = 'Upsert';
    
    /****************************************************************************************************
    Method Name : fetchOSInstanceMap
    Parameters  : String selectQuery,String whereClause,String orderByClause,String limitClause
    Return type : Map<Id,vlocity_ins__OmniScriptInstance__c>
    Description : This method is used to fetch the vlocity_ins__OmniScriptInstance__c record based on 
    parameters passed.
    It will return the Map<ID,vlocity_ins__OmniScriptInstance__c> if user wants the Map, 
    they can perform the logic on Map, else they can covert the map to list of accounts.
    ******************************************************************************************************/
    public static Map<ID,vlocity_ins__OmniScriptInstance__c> fetchOSInstanceMap(String selectQuery,String whereClause,String orderByClause,
                                                                                String limitClause)
    {
        String dynaQuery = SG01_Constants.BLANK;
        Map<ID,vlocity_ins__OmniScriptInstance__c> osInstanceMap = NULL;
        try
        {
            dynaQuery = String.isNotBlank(selectQuery) ? selectQuery : SG01_Constants.BLANK;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(whereClause) ? dynaQuery+=whereClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(orderByClause) ? dynaQuery+=orderByClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(limitClause) ? dynaQuery+=limitClause : dynaQuery;
            if(String.isNotBlank(dynaQuery))
            {
                osInstanceMap = new Map<ID,vlocity_ins__OmniScriptInstance__c>((List<vlocity_ins__OmniScriptInstance__c>)Database.query(dynaQuery));
            }
        }Catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,SG01_Constants.CLS_SGA_UTIL02_OSDATAACCESSHELPER, SG01_Constants.CLS_SGA_UTIL04_FETCHOSMAP, SG01_Constants.BLANK, Logginglevel.ERROR);        }    
        return osInstanceMap;
    }   
    
    /****************************************************************************************************
    Method Name : dmlOnOmniScript
    Parameters  : List<vlocity_ins__OmniScriptInstance__c> osList, String operation
    Return type : List<vlocity_ins__OmniScriptInstance__c>
    Description : This method is used to perform the DML operations on vlocity_ins__OmniScriptInstance__c.
    Operation value need to pass to perform the respective dml operation.
    Operation name should be passed from SG01_Constants class.
    ******************************************************************************************************/
    /* Please un comment if we are using the dml on OSInstance and call this method.
    public static List<vlocity_ins__OmniScriptInstance__c> dmlOnOmniScript(List<vlocity_ins__OmniScriptInstance__c> osList,String operation){
        try
        {
            if(osList != NULL && !osList.isEmpty())
            {
                if(String.isNotBlank(operation) && INSERT_OPERATION.equalsIgnoreCase(operation)){
                    Database.Insert(osList);
                }else if(String.isNotBlank(operation) && UPDATE_OPERATION.equalsIgnoreCase(operation)){
                    Database.Update(osList);
                }else if(String.isNotBlank(operation) && DELETE_OPERATION.equalsIgnoreCase(operation)){
                    Database.Delete(osList);
                }else if(String.isNotBlank(operation) && UPSERT_OPERATION.equalsIgnoreCase(operation)){
                    Database.Upsert(osList);
                }
                
            }
        }Catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,SG01_Constants.CLS_SGA_UTIL02_OSDATAACCESSHELPER, SG01_Constants.CLS_SGA_UTIL04_DMLOS, SG01_Constants.BLANK, Logginglevel.ERROR);        }
        return osList;
    }*/
}