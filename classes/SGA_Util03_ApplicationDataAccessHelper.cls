/*****************************************************************************************
Class Name   : SGA_Util03_ApplicationDataAccessHelper
Date Created : 5/24/2017
Created By   : IDC Offshore
Description  : 1. This is the util data access class for vlocity_ins__Application__c object.
Which is used to fetch the details from vlocity_ins__Application__c based 
on some parameters
2. This is used for DML Operations.
Change History : 
******************************************************************************************/
public without sharing class SGA_Util03_ApplicationDataAccessHelper {
    //Below are the final variables to check the operation on the list of records.
    public static final String INSERT_OPERATION = 'Insert';
    public static final String UPDATE_OPERATION = 'Update';
    public static final String DELETE_OPERATION = 'Delete';
    public static final String UPSERT_OPERATION = 'Upsert';
    public static Set<Id> applicationIdSet;

/****************************************************************************************************
Method Name : fetchApplicationMap
Parameters  : String selectQuery,String whereClause,String orderByClause,String limitClause
Return type : Map<Id,vlocity_ins__Application__c>
Description : This method is used to fetch the vlocity_ins__Application__c record based on 
parameters passed.
It will return the Map<ID,vlocity_ins__Application__c> if user wants the Map, 
they can perform the logic on Map, else they can covert the map to list of accounts.
******************************************************************************************************/
    public static Map<ID,vlocity_ins__Application__c> fetchApplicationMap
        (String selectQuery,String whereClause,String orderByClause,String limitClause)
    {
        String dynaQuery = SG01_Constants.BLANK;
        Map<ID,vlocity_ins__Application__c> applicationMap = NULL;
        dynaQuery = String.isNotBlank(selectQuery) ? selectQuery : SG01_Constants.BLANK;
        dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(whereClause) ? dynaQuery+=whereClause : dynaQuery;
        dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(orderByClause) ? dynaQuery+=orderByClause : dynaQuery;
        dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(limitClause) ? dynaQuery+=limitClause : dynaQuery;
        
       // System.debug('dynaQuery>>'+dynaQuery);
        if(String.isNotBlank(dynaQuery))
        {
            //System.debug('dynaQuery in SGA_Util03_ApplicationDataAccessHelper::>'+dynaQuery);
            applicationMap = new Map<ID,vlocity_ins__Application__c>((List<vlocity_ins__Application__c>)Database.query(dynaQuery));
        }
        
        //System.debug('applicationMap in SGA_Util03_ApplicationDataAccessHelper::>'+applicationMap);  
        
        return applicationMap;
    } 
    
/****************************************************************************************************
Method Name : dmlApplicationlist
Parameters  : List<vlocity_ins__Application__c> appList,String operation
Return type : List<vlocity_ins__Application__c>
Description : This method is used to perform the DML operations on vlocity_ins__Application__c.
Operation value need to pass to perform the respective dml operation.
Operation name should be passed from SG01_Constants class.
******************************************************************************************************/

public static List<vlocity_ins__Application__c> dmlApplicationlist(List<vlocity_ins__Application__c> appList, String operation){

	  if(appList != NULL && !appList.isEmpty())
	 {
	if(String.isNotBlank(operation) && INSERT_OPERATION.equalsIgnoreCase(operation)){
	Database.Insert(appList);
	}else if(String.isNotBlank(operation) && UPDATE_OPERATION.equalsIgnoreCase(operation)){
	Database.Update(appList);
	}else if(String.isNotBlank(operation) && DELETE_OPERATION.equalsIgnoreCase(operation)){
	Database.Delete(appList);
	}else if(String.isNotBlank(operation) && UPSERT_OPERATION.equalsIgnoreCase(operation)){
	Database.Upsert(appList);
	}

   }

return appList;
}
}