/*****************************************************************************************
Class Name   : SGA_Util10_ObjectRecordTypeHelper
Date Created : 08/01/2017
Created By   : IDC Offshore
Description  : 1. This is the util class to provide RecordType Infoprmation based on Sobject Type 
                and RecordType Name

******************************************************************************************/
public class SGA_Util11_ObjectRecordTypeHelper {
    
  /****************************************************************************************************
    Method Name : getObjectRecordTypeId
    Parameters  : sObjectType,recordTypeName
    Return type : String
    Description : 1. This method is used to fetch the Record Type Name based on sObjectType and recordTypeName
                  2. Throws Exception if recordTypeNamed does not exist
    Example Usage :
    String recordTypeId = SGA_Util11_ObjectRecordTypeHelper.getObjectRecordTypeId(Case.SObjectType, 'RECORDTYPE_NAME');
*/
   public static String getObjectRecordTypeId(SObjectType sObjectType, String recordTypeName)
    {
        //Generate a map of tokens for all the Record Types for the desired object
        Map<String,Schema.RecordTypeInfo> recordTypeInfo = sObjectType.getDescribe().getRecordTypeInfosByName();

        if(!recordTypeInfo.containsKey(recordTypeName))
            throw new RecordTypeException('Record type "'+ recordTypeName +'" does not exist.');

        //Retrieve the record type id by name
        return recordTypeInfo.get(recordTypeName).getRecordTypeId();
    }

    public class RecordTypeException extends Exception{}
}