/***********************************************************************
Class Name   : SGA_AP22_LookUpController
Date Created : 08/04/2017 (MM/DD/YYYY)
Created By   : IDC Offshore
Description  : 1. This is a Handler Class for Lookup Ligtning Component
**************************************************************************/
public without sharing class SGA_AP22_LookUpController {
   
 /****************************************************************************************************
    Method Name : getSobjectNameField 
    Parameters  : SobjectType sobjType
    Return type : String
    Description : Returns the "Name" field for a given SObject (e.g. Case has CaseNumber, Account has Name)
 ******************************************************************************************************/

    private static String getSobjectNameField(SobjectType sobjType){
        
        //describes lookup obj and gets its name field
        String nameField = SG01_Constants.SGA_AP22_NAME_FIELD;
        Schema.DescribeSObjectResult dfrLkp = sobjType.getDescribe();
        for(schema.SObjectField sotype : dfrLkp.fields.getMap().values()){
            Schema.DescribeFieldResult fieldDescObj = sotype.getDescribe();
            if(fieldDescObj.isNameField() ){
              nameField = fieldDescObj.getName();
                break;
            }
        }
        return nameField;
    }
  
  /****************************************************************************************************
    Method Name : searchSObject 
    Parameters  : String searchString,String obType 
    Return type : List<SObject>
    Description : 1.Searches (using SOSL) for a given Sobject type and SearchString
                2. return List<SObject>
 ******************************************************************************************************/

    @AuraEnabled
    public static List<SObject> searchSObject(String searchString,String obType) {
        // System.debug('inside fetch acc>>'+searchString);
    SObjectType objType = Schema.getGlobalDescribe().get(obType);
    List<SObject> outputRes = new List<SObject>();
    Try{
      if(String.isBlank(obType) || String.isBlank(searchString)){
            outputRes = null;
        }
        
        if(objType == null){
            outputRes = null;
        }
        String nameField = getSobjectNameField(objType);
        searchString = searchString+'*\'';
        String soslQuery = 'FIND :searchString IN NAME FIELDS RETURNING '
                          + obType +'(Id,RecordTypeID, '+nameField+') LIMIT 100';
    
        //String query = 'Select Id,RecordTypeID, '+nameField+' From '+obType+' Where nameField Like = \''+searchString+'\'';
        List<List<SObject>> results =  Search.query(soslQuery);

        if(results.size()>0){
            for(SObject sobj : results[0]){
                outputRes.add(sobj);
            }
        }
    if( !outputRes.isEmpty() && obType.equalsIgnoreCase(SG01_Constants.ACCOUNT)){
      outputRes = filterWitRecType(outputRes);
    }
    }Catch(Exception ex) { UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_AP22_LOOKUPCONTROLLER, SG01_Constants.SGA_AP22_SEARCHSOBJECT, SG01_Constants.BLANK, Logginglevel.ERROR);}
        
        return outputRes;
    }
 
 /****************************************************************************************************
    Method Name : filterWitRecType 
    Parameters  : List<SObject>
    Return type : List<SObject>
    Description : 1.Filter Based on RecordTypeID for Account
 ******************************************************************************************************/
  public Static List<SObject>  filterWitRecType(List<SObject> listToFilter){
     List<SObject> filterListToSend= new List<SObject>();
       Id grpRecId=SGA_Util11_ObjectRecordTypeHelper.getObjectRecordTypeId(Account.sobjectType, Label.SG61_GROUP_RECTYPE);
       if( !listToFilter.isEmpty()){
         for(SObject sobj : listToFilter){
           Account acc=(Account)sobj;
           if(acc.RecordTypeId.equals(grpRecId)){
             filterListToSend.add(sobj);   
           }
               }
       }
       return filterListToSend;
   }
    
}