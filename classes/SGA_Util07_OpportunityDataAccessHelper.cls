/*****************************************************************************************
Class Name   : SGA_Util07_OpportunityDataAccessHelper
Date Created : 06/21/2017
Created By   : IDC Offshore
Description  : 1. This is the util data access class for Opportunity object.
Which is used to fetch the details from Opportunity based 
on some parameters
2. This is used for DML Operations.
Change History : 
******************************************************************************************/
public without sharing class SGA_Util07_OpportunityDataAccessHelper {
    //Below are the final variables to check the operation on the list of records.
    public static final String INSERT_OPERATION = 'Insert';
    public static final String UPDATE_OPERATION = 'Update';
    public static final String DELETE_OPERATION = 'Delete';
    public static final String UPSERT_OPERATION = 'Upsert';
    public static set<id> accIdSet;
    public static set<id> oppIdSet{get;set;}

/****************************************************************************************************
Method Name : fetchOpportunityMap
Parameters  : String selectQuery,String whereClause,String orderByClause,String limitClause
Return type : Map<Id,Opportunity>
Description : This method is used to fetch the Opportunity record based on 
parameters passed.
It will return the Map<ID,Opportunity> if user wants the Map, 
they can perform the logic on Map, else they can covert the map to list of Opportunity.
******************************************************************************************************/
    public static Map<ID,Opportunity> fetchOpportunityMap
        (String selectQuery,String whereClause,String orderByClause,String limitClause)
    {
        String dynaQuery = SG01_Constants.BLANK;
        Map<ID,Opportunity> opportunityMap = NULL;
        dynaQuery = String.isNotBlank(selectQuery) ? selectQuery : SG01_Constants.BLANK;
        dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(whereClause) ? dynaQuery+=whereClause : dynaQuery;
        dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(orderByClause) ? dynaQuery+=orderByClause : dynaQuery;
        dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(limitClause) ? dynaQuery+=limitClause : dynaQuery;
        if(String.isNotBlank(dynaQuery)){
            opportunityMap = new Map<ID,Opportunity>((List<Opportunity>)Database.query(dynaQuery));
        }
       return opportunityMap;
    } 
	

    /****************************************************************************************************
    Method Name : dmlOnOpportunity
    Parameters  : List<Opportunity> oppList, String operation
    Return type : List<Opportunity>
    Description : This method is used to perform the DML operations on Opportunity.
    Operation value need to pass to perform the respective dml operation.
    Operation name should be passed from SG01_Constants class.
    ******************************************************************************************************/
    public static List<Opportunity> dmlOnOpportunity(List<Opportunity> oppList, String operation){
        
        if(oppList != NULL && !oppList.isEmpty())
        {
            if(String.isNotBlank(operation) && INSERT_OPERATION.equalsIgnoreCase(operation)){
                Database.Insert(oppList);
            }else if(String.isNotBlank(operation) && UPDATE_OPERATION.equalsIgnoreCase(operation)){
                Database.Update(oppList);
            }else if(String.isNotBlank(operation) && DELETE_OPERATION.equalsIgnoreCase(operation)){
                Database.Delete(oppList);
            }else if(String.isNotBlank(operation) && UPSERT_OPERATION.equalsIgnoreCase(operation)){
                Database.Upsert(oppList);
            }
            
        }
        return oppList;
    }
    
    
}