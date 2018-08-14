/*****************************************************************************************
Class Name   : SGA_Util08_QuoteDataAccessHelper
Date Created : 06/21/2017
Created By   : IDC Offshore
Description  : 1. This is the util data access class for Quote object.
Which is used to fetch the details from Quote based 
on some parameters
2. This is used for DML Operations.
Change History : 
******************************************************************************************/
public with sharing class SGA_Util08_QuoteDataAccessHelper {
    //Below are the final variables to check the operation on the list of records.
    public static final String INSERT_OPERATION = 'Insert';
    public static final String UPDATE_OPERATION = 'Update';
    public static final String DELETE_OPERATION = 'Delete';
    public static final String UPSERT_OPERATION = 'Upsert';
    public static set<id> accIdSet;
    
    /****************************************************************************************************
Method Name : fetchQuoteMap
Parameters  : String selectQuery,String whereClause,String orderByClause,String limitClause
Return type : Map<Id,Quote>
Description : This method is used to fetch the Quote record based on 
parameters passed.
It will return the Map<ID,Quote> if user wants the Map, 
they can perform the logic on Map, else they can covert the map to list of Quotes.
******************************************************************************************************/
    public static Map<ID,Quote> fetchQuoteMap
        (String selectQuery,String whereClause,String orderByClause,String limitClause)
    {
        String dynaQuery = SG01_Constants.BLANK;
        Map<ID,Quote> QuoteMap = NULL;
        dynaQuery = String.isNotBlank(selectQuery) ? selectQuery : SG01_Constants.BLANK;
        dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(whereClause) ? dynaQuery+=whereClause : dynaQuery;
        dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(orderByClause) ? dynaQuery+=orderByClause : dynaQuery;
        dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(limitClause) ? dynaQuery+=limitClause : dynaQuery;
        if(String.isNotBlank(dynaQuery)) {
            QuoteMap = new Map<ID,Quote>((List<Quote>)Database.query(dynaQuery));
        }
        return QuoteMap;
    } 
    
    
}