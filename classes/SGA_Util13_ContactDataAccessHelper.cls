/*****************************************************************************************
Class Name   : SGA_Util13_ContactDataAccessHelper
Date Created : 07-Aug-2017
Created By   : IDC Offshore
Description  : 1. This is the util data access class for Contact object.
Which is used to fetch the details from Contact based 
on some parameters
2. This is used for DML Operations.
Change History : 
******************************************************************************************/
public with sharing class SGA_Util13_ContactDataAccessHelper {
    //Below are the final variables to check the operation on the list of records.
    public static final String INSERT_OPERATION = 'Insert';
    public static final String UPDATE_OPERATION = 'Update';
    public static final String DELETE_OPERATION = 'Delete';
    public static final String UPSERT_OPERATION = 'Upsert';
    public static set<id> accIdSet;
    
    /****************************************************************************************************
Method Name : fetchContactMap
Parameters  : String selectQuery,String whereClause,String orderByClause,String limitClause
Return type : Map<Id,Contact>
Description : This method is used to fetch the Contact record based on 
parameters passed.
It will return the Map<ID,Contact> if user wants the Map, 
they can perform the logic on Map, else they can covert the map to list of Contact.
******************************************************************************************************/
    public static Map<ID,Contact> fetchContactMap
        (String selectQuery,String whereClause,String orderByClause,String limitClause)
    {
        String dynaQuery = SG01_Constants.BLANK;
        Map<ID,Contact> ContactMap = NULL;
        dynaQuery = String.isNotBlank(selectQuery) ? selectQuery : SG01_Constants.BLANK;
        dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(whereClause) ? dynaQuery+=whereClause : dynaQuery;
        dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(orderByClause) ? dynaQuery+=orderByClause : dynaQuery;
        dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(limitClause) ? dynaQuery+=limitClause : dynaQuery;
        if(String.isNotBlank(dynaQuery)){
            ContactMap = new Map<ID,Contact>((List<Contact>)Database.query(dynaQuery));
        }
       return ContactMap;
    } 
    
    
}