/**********************************************************************************
Class Name :   SGA_AP01_BrokerSearchController
Date Created : 29-March-2017
Created By   : IDC Offshore
Description  : 1. This class is used in BrokerSearch.cmp (lightning component)
2. This class is used to fetch the records based on the user search 
from Account, Quote and Application objects.
Change History : 
*************************************************************************************/
public with sharing class  SGA_AP01_BrokerSearchController {
    public static final string ID_SEARCH = ' ID IN :accountIdSet ';
    @AuraEnabled
    /****************************************************************************************************
    Method Name : getUserDetails
    Parameters  : None
    Return type : User
    Description : This method is used to identify the user whether the user is portal user or not.
    This is used to change the redirect the user to record detail page.
    ******************************************************************************************************/
    public static String getUserDetails() {
        String contactId = null;
        try
        {
            User userObj = [Select ContactId from User where Id=:userinfo.getUserId() LIMIT 1];
            contactId = userObj.ContactId;
        }Catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,SG01_Constants.CLS_SGA_AP01_BROKERSEARCHCONTROLLER, SG01_Constants.GETUSERDETAILS, SG01_Constants.BLANK, Logginglevel.ERROR);}
        return contactId;
    }
    
    @AuraEnabled
    /****************************************************************************************************
    Method Name : getAccountSearchResults
    Parameters  : Group Name(Account Name), Group Number, Employer Tax ID
    Return type : List<Account>
    Description : This method is used to fetch the account records which are matching the corresponding 
    Account Name, Group Number/Group Number2, Employer Tax ID.
    ******************************************************************************************************/
    public static List<Account> getAccountSearchResults(String groupName,String groupNumber,String employerTaxId){
        List<Account> accountList = null;
        try
        {
            String strAccountQuery = null;
            String strAccountWhereClause = SG01_Constants.WHERE_CLAUSE;
            accountList = new List<Account>();
            if(hasValue(groupName)){
                List<List<SObject>> searchList = [FIND :'\''+groupName+'*\'' IN ALL FIELDS RETURNING Account (Id, Name) LIMIT 100];
                List<Account> soslAccountList = ((List<Account>)searchList[0]);
                Set<ID> accountIdSet = new Set<ID>();
                for(Account acc : soslAccountList){
                    accountIdSet.add(acc.Id);
                }
                SGA_Util01_AccountDataAccessHelper.accountIdSet = accountIdSet;
                strAccountWhereClause=strAccountWhereClause+(!strAccountWhereClause.equalsIgnoreCase(SG01_Constants.WHERE_CLAUSE)?
                SG01_Constants.AND_SPACE:SG01_Constants.SPACE) + ID_SEARCH ;
                
            }
            //checking the groupNumber is empty or not to add the Group Number field in search query.
            if(hasValue(groupNumber)){
                strAccountWhereClause=strAccountWhereClause+(!strAccountWhereClause.equalsIgnoreCase(SG01_Constants.WHERE_CLAUSE)?
                    SG01_Constants.AND_SPACE:SG01_Constants.SPACE)+SG01_Constants.LEFT_BRACKET+SG01_Constants.GROUP_NUMBER +String.escapeSingleQuotes(groupNumber)+SG01_Constants.BACK_SLASH; 
            }
            //checking the groupNumber is empty or not to add the Group Number 2 field in search query.
            if(hasValue(groupNumber)){
                strAccountWhereClause=strAccountWhereClause+(!strAccountWhereClause.equalsIgnoreCase(SG01_Constants.WHERE_CLAUSE)?
                    SG01_Constants.OR_SPACE:SG01_Constants.SPACE)+SG01_Constants.GROUP_NUMBER2 +String.escapeSingleQuotes(groupNumber)+SG01_Constants.BACK_SLASH+SG01_Constants.RIGHT_BRACKET;
            }
            //checking the employerTaxId is empty or not to add the Employer Tax ID field in search query.
            if(hasValue(employerTaxId)){
                strAccountWhereClause = strAccountWhereClause+(!strAccountWhereClause.equalsIgnoreCase(SG01_Constants.WHERE_CLAUSE)?
                    SG01_Constants.AND_SPACE:SG01_Constants.SPACE)+SG01_Constants.TAX_ID+String.escapeSingleQuotes(employerTaxId)+SG01_Constants.BACK_SLASH; 
            }

            //calling the utility class
            if(accountList.isEmpty()){
                Map<ID,Account> accountMap = SGA_Util01_AccountDataAccessHelper.fetchAccountsMap(SG01_Constants.ACC_BR_SEARCH_QUERY,
                                                                                                 strAccountWhereClause, SG01_Constants.BLANK, SG01_Constants.LIMIT_100);
                if(accountMap != NULL && !accountMap.isEmpty())
                {
                    accountList = accountMap.values();
                }  
            }
        }Catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,SG01_Constants.CLS_SGA_AP01_BROKERSEARCHCONTROLLER, SG01_Constants.GETACCOUNTSEARCHRESULTS, SG01_Constants.BLANK, Logginglevel.ERROR);        }
        return accountList;
    } 
    
    /****************************************************************************************************
    Method Name : hasValue
    Parameters  : field value
    Return type : Boolean
    Description : This method is used to check the field contains the value or not.
    It returns true if the field contains the value else returns false.
    ******************************************************************************************************/
    private static Boolean hasValue (String field) {
        Boolean checkVal = false;
        if(field !=null && field.length() > 0 && field != SG01_Constants.BLANK && field != SG01_Constants.SPACE)
        {
            checkVal = true; 
        }
        else if(field == null || field == SG01_Constants.BLANK || field.length() == 0)
        {
            checkVal = false;   
        }
        else{
            checkVal = false;
        }
        return checkVal;
    }
}