/*****************************************************************************************
Class Name   : SGA_Util04_DCDataAccessHelper
Date Created : 5/25/2017
Created By   : IDC Offshore
Description  : 1. This is the util data access class for Application_Document_Checklist__c object.
Which is used to fetch the details from Application_Document_Checklist__c based 
on some parameters
2. This is used for DML Operations.
Change History : 
******************************************************************************************/
public without sharing class SGA_Util04_DCDataAccessHelper {
    //Below are the final variables to check the operation on the list of records.
    public static final String INSERT_OPERATION = 'Insert';
    public static final String UPDATE_OPERATION = 'Update';
    public static final String DELETE_OPERATION = 'Delete';
    public static final String UPSERT_OPERATION = 'Upsert';
    
    public static Set<ID> caseIdSet;
    public static Set<String> statusSet;
    /****************************************************************************************************
    Method Name : fetchDocumentChecklistMap
    Parameters  : String selectQuery,String whereClause,String orderByClause,String limitClause
    Return type : Map<Id,Application_Document_Checklist__c>
    Description : This method is used to fetch the Application_Document_Checklist__c record based on 
    parameters passed.
    It will return the Map<ID,Application_Document_Checklist__c> if user wants the Map, 
    they can perform the logic on Map, else they can covert the map to list of accounts.
    ******************************************************************************************************/
    public static Map<ID,Application_Document_Checklist__c> fetchDocumentChecklistMap(String selectQuery,String whereClause,String orderByClause,
                                                                                      String limitClause)
    {
        Map<ID,Application_Document_Checklist__c> documentChecklistMap = NULL;
        String dynaQuery = SG01_Constants.BLANK;
            dynaQuery = String.isNotBlank(selectQuery) ? selectQuery : SG01_Constants.BLANK;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(whereClause) ? dynaQuery+=whereClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(orderByClause) ? dynaQuery+=orderByClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(limitClause) ? dynaQuery+=limitClause : dynaQuery;

            if(String.isNotBlank(dynaQuery))
            {
                documentChecklistMap = new Map<ID,Application_Document_Checklist__c>((List<Application_Document_Checklist__c>)Database.query(dynaQuery));
			}
        return documentChecklistMap;
    }
    
    /****************************************************************************************************
    Method Name : dmlDocChecklist
    Parameters  : List<Application_Document_Checklist__c> dcList,String operation
    Return type : List<Application_Document_Checklist__c>
    Description : This method is used to perform the DML operations on Application_Document_Checklist__c.
    Operation value need to pass to perform the respective dml operation.
    Operation name should be passed from SG01_Constants class.
    ******************************************************************************************************/
    public static List<Application_Document_Checklist__c> dmlDocChecklist(List<Application_Document_Checklist__c> dcList,String operation){
        if(!dcList.isEmpty())
            {
                if(String.isNotBlank(operation) && INSERT_OPERATION.equalsIgnoreCase(operation)){
                    Database.Insert(dcList);
                }else if(String.isNotBlank(operation) && UPDATE_OPERATION.equalsIgnoreCase(operation)){
                    System.debug('dc list:::'+dcList);
                    Database.Update(dcList);
                }else if(String.isNotBlank(operation) && DELETE_OPERATION.equalsIgnoreCase(operation)){
                    Database.Delete(dcList);
                }else{ 
                    if(String.isNotBlank(operation) && UPSERT_OPERATION.equalsIgnoreCase(operation)){
                        Database.Upsert(dcList);
                    }
                }
            }
        return dcList;
    }
}