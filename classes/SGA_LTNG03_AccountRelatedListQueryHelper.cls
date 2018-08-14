/**********************************************************************************
Class Name :   SGA_LTNG03_AccountRelatedListQueryHelper
Date Created : 
Created By   : IDC Offshore
Description  : 1. This class is helper class
Change History : 
*************************************************************************************/
public with sharing class SGA_LTNG03_AccountRelatedListQueryHelper {
    
    /****************************************************************************************************
Method Name : getCurrentAccountDetails
Parameters  : Id accId
Return type : Map<Id,Account>
Description : This method is used to fetch the Account record based on Account Id 
******************************************************************************************************/
    Public static Map<Id,Account> getSGACurrentAccountDetails(Id acId) {
        Map<Id,Account> accountDetails = new Map<Id,Account>();
        try{
            String whereClause = SG01_Constants.WHERE_CLAUSE+SG01_Constants.SPACE+SG01_Constants.ID+SG01_Constants.EQUALS_SLASH+String.escapeSingleQuotes(acId)+SG01_Constants.BACK_SLASH; 
            AccountDetails =  SGA_Util01_AccountDataAccessHelper.fetchAccountsMap(SG01_Constants.CLS_SGA_LTNG03_ACC_QUERY,
                                                                                  whereClause,SG01_Constants.BLANK,SG01_Constants.LIMIT_1);
        }Catch (Exception ex){ UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_LTNG03_ACCOUNTRELATEDLISTQUERYHELPER, SG01_Constants.GETCURRENTACCOUNTDETAILS, SG01_Constants.BLANK, Logginglevel.ERROR);}
        return AccountDetails;
    }
    
    /****************************************************************************************************
Method Name : getSGAApplicationList
Parameters  : String partyId
Return type : List<vlocity_ins__Application__c>
Description : This method is used to fetch the Application List record based on Party Id
******************************************************************************************************/
    @AuraEnabled 
    Public static List<vlocity_ins__Application__c> getSGAApplicationList(Id partyId) {
        List<vlocity_ins__Application__c> appList = new List<vlocity_ins__Application__c>();
        try {
            String whereClause = SG01_Constants.CLS_SGA_LTNG03_APP_QUERY_WHERE+SG01_Constants.EQUALS_SLASH+String.escapeSingleQuotes(partyId)+SG01_Constants.BACK_SLASH+SG01_Constants.RIGHT_BRACKET;
            Map<Id,vlocity_ins__Application__c> applicationMap = SGA_Util03_ApplicationDataAccessHelper.fetchApplicationMap(SG01_Constants.CLS_SGA_LTNG03_APP_QUERY,
                                                                                                                            whereClause,SG01_Constants.CLS_SGA_LTNG03_APP_QUERY_ORDERBY,SG01_Constants.LIMIT_100);
           if(!applicationMap.isEmpty()){
                appList = applicationMap.values();                                                                                                           
            }                                                                                                               
        }Catch(Exception ex) { UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_LTNG03_ACCOUNTRELATEDLISTQUERYHELPER, SG01_Constants.GETAPPLICATIONLIST, SG01_Constants.BLANK, Logginglevel.ERROR);}
        // System.debug('appList in SGA_LTNG03_AccountRelatedListQueryHelper::>'+appList);
        return appList;
       
    }
    
    /****************************************************************************************************
Method Name : getInProcessQuotesList
Parameters  : String accId
Return type :  List<vlocity_ins__OmniScriptInstance__c>
Description : This method is used to fetch the vlocity_ins__OmniScriptInstance__c List record based on Account Id
******************************************************************************************************/
    public static List<vlocity_ins__OmniScriptInstance__c> getInProcessQuotesList(String ObjectLabel,String status,List<String>StatLst,String SubType,String OmniScriptType,String accId) {
        List<vlocity_ins__OmniScriptInstance__c> savedOmniscripts = new List<vlocity_ins__OmniScriptInstance__c>();
        try{
            String whereClause = SG01_Constants.WHERE_CLAUSE+SG01_Constants.CLS_SGA_LTNG03_OBJ_LABEL+
                SG01_Constants.EQUALS_SLASH+String.escapeSingleQuotes(ObjectLabel)+SG01_Constants.BACK_SLASH+SG01_Constants.AND_SPACE+
                SG01_Constants.CLS_SGA_LTNG03_STATUS+SG01_Constants.EQUALS_SLASH+String.escapeSingleQuotes(status)+SG01_Constants.BACK_SLASH+SG01_Constants.AND_SPACE+
                SG01_Constants.CLS_SGA_LTNG03_OSSUBTYPE+SG01_Constants.EQUALS_SLASH+String.escapeSingleQuotes(SubType)+SG01_Constants.BACK_SLASH+SG01_Constants.AND_SPACE+
                SG01_Constants.CLS_SGA_LTNG03_OSTYPE+SG01_Constants.EQUALS_SLASH+String.escapeSingleQuotes(OmniScriptType)+SG01_Constants.BACK_SLASH+SG01_Constants.AND_SPACE+
                SG01_Constants.CLS_SGA_LTNG03_OBJ_ID+SG01_Constants.EQUALS_SLASH+String.escapeSingleQuotes(accId)+SG01_Constants.BACK_SLASH;
            String whereClause1 = SG01_Constants.WHERE_CLAUSE+SG01_Constants.CLS_SGA_LTNG03_OBJ_LABEL+
                SG01_Constants.EQUALS_SLASH+String.escapeSingleQuotes(ObjectLabel)+SG01_Constants.BACK_SLASH+SG01_Constants.AND_SPACE+
                //SG01_Constants.CLS_SGA_LTNG03_STATUS+SG01_Constants.EQUALS_SLASH+String.escapeSingleQuotes(status)+SG01_Constants.BACK_SLASH+SG01_Constants.AND_SPACE+
                SG01_Constants.CLS_SGA_LTNG03_OSSUBTYPE+SG01_Constants.EQUALS_SLASH+String.escapeSingleQuotes(SubType)+SG01_Constants.BACK_SLASH+SG01_Constants.AND_SPACE+
                SG01_Constants.CLS_SGA_LTNG03_OSTYPE+SG01_Constants.EQUALS_SLASH+String.escapeSingleQuotes(OmniScriptType)+SG01_Constants.BACK_SLASH+SG01_Constants.AND_SPACE+
                SG01_Constants.CLS_SGA_LTNG03_OBJ_ID+SG01_Constants.EQUALS_SLASH+String.escapeSingleQuotes(accId)+SG01_Constants.BACK_SLASH+SG01_Constants.AND_SPACE;
            for(integer i=0;i<StatLst.size();i++){
                if(i==0)  
                    whereClause1+=SG01_Constants.LEFT_BRACKET;
                if(i!=StatLst.size()-1)
                    whereClause1+=SG01_Constants.CLS_SGA_LTNG03_STATUS+SG01_Constants.EQUALS_SLASH+String.escapeSingleQuotes(StatLst[i])+SG01_Constants.BACK_SLASH+SG01_Constants.OR_SPACE;
                if(i== StatLst.size()-1){
                    whereClause1+=SG01_Constants.CLS_SGA_LTNG03_STATUS+SG01_Constants.EQUALS_SLASH+String.escapeSingleQuotes(StatLst[i])+SG01_Constants.BACK_SLASH;
                    whereClause1+=SG01_Constants.RIGHT_BRACKET;
                }
            } 
            Map<ID,vlocity_ins__OmniScriptInstance__c> returnMap = SGA_Util02_OSInstanceDataAccessHelper.fetchOSInstanceMap(SG01_Constants.CLS_SGA_LTNG03_OSINSTANCE_QUERY,
                                                                                                                            whereClause1,SG01_Constants.CLS_SGA_LTNG03_OSINSTANCE_QUERY_ORDERBY,SG01_Constants.LIMIT_100);
            if(!returnMap.isEmpty()){
                savedOmniscripts = returnMap.values();
            }                   
        }Catch(Exception ex) { UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_LTNG03_ACCOUNTRELATEDLISTQUERYHELPER, SG01_Constants.SGA_LTNG03_INPROCESSQUOTESLIST, SG01_Constants.BLANK, Logginglevel.ERROR);}
        return savedOmniscripts;
    }
}