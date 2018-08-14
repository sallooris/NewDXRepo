/*****************************************************************************************
Class Name   : SGA_Util10_ProfileDataAccessHelper
Date Created : 06/27/2017
Created By   : IDC Offshore
Description  : 1. This is the util data access class for Profile object.
Which is used to fetch the details from Profile based 
on some parameters

******************************************************************************************/
public with sharing class SGA_Util10_ProfileDataAccessHelper {
   
/****************************************************************************************************
Method Name : fetchProfileMap
Parameters  : String selectQuery,String whereClause,String orderByClause,String limitClause
Return type : Map<Id,Profile>
Description : This method is used to fetch the Quote record based on 
parameters passed.
It will return the Map<ID,Profile> if user wants the Map, 
they can perform the logic on Map, else they can covert the map to list of Profile.
******************************************************************************************************/
    public static Map<ID,Profile> fetchProfileMap
        (String selectQuery,String whereClause,String orderByClause,String limitClause)
    {
        String dynaQuery = SG01_Constants.BLANK;
        Map<ID,Profile> ProfileMap = NULL;
        dynaQuery = String.isNotBlank(selectQuery) ? selectQuery : SG01_Constants.BLANK;
        dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(whereClause) ? dynaQuery+=whereClause : dynaQuery;
        dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(orderByClause) ? dynaQuery+=orderByClause : dynaQuery;
        dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(limitClause) ? dynaQuery+=limitClause : dynaQuery;
        if(String.isNotBlank(dynaQuery)) {
            ProfileMap = new Map<ID,Profile>((List<Profile>)Database.query(dynaQuery));
        }
        return ProfileMap;
    } 
    
    
}