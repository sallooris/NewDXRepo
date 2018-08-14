/*********************************************************************************************************
* Class Name  : SGA_AP28_UpdateLastModifiedDateOnAccount
* Created By  : IDC Offshore
* Created Date: 8-Aug-2017
* Description : This class is called from QuoteTriggerHandler and ApplicationTriggerHandler
* 			     is used to update quote created/modified or application created/modified date on Account.
**********************************************************************************************************/
public without sharing class SGA_AP28_UpdateLastModifiedDateOnAccount {
    public static final string CLS_SGA_AP28_UPDATELASTMODDATE = 'SGA_AP28_UpdateLastModifiedDateOnAccount';
    public static final string UPDATE_DML_ON_ACC = 'updateLMDOnAccountFromQuoteorApp';
    public static final string ACC_QUERY = 'select id,Tech_Last_Quote_Created_Modified_Date__c,Tech_Last_App_Created_Modified_Date__c from Account ';
    public static final string WHERE_CLAUSE = 'where Id IN :accountIdSet ';
    public static final string LIMIT_CLAUSE = ' LIMIT 10000';
    public static final ID REC_TYPE = Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.Label.SG_GroupRecordTypeName).getRecordTypeId();
    /*********************************************************************************************************
    * Method Name : updateLMDOnAccountFromQuoteorApp
    * Parameters  : Map<ID,String>
    * Return Type : void
    * Description : This method is called from QuoteTriggerHandler and ApplicationTriggerHandler
    * 			     is used to update quote created/modified or application created/modified date on Account.
    **********************************************************************************************************/
    public void updateLMDOnAccountFromQuoteorApp(Map<ID,String> quoteOrAppMap){
        try
        {
            SGA_Util01_AccountDataAccessHelper.accountIdSet = quoteOrAppMap.keySet();
            SGA_Util01_AccountDataAccessHelper.recordTypeId = REC_TYPE;
            Map<ID,Account> accountMap = SGA_Util01_AccountDataAccessHelper.fetchAccountsMap(ACC_QUERY, WHERE_CLAUSE, SG01_Constants.BLANK,
                                                                                             LIMIT_CLAUSE);
            if(accountMap != NULL && !accountMap.isEmpty()){
                List<Account> updateAccountList = accountMap.values();
                for(Account accObj : updateAccountList){
                    if(quoteOrAppMap.get(accObj.Id) != NULL && System.Label.SG52_QuoteObjectName.equalsIgnoreCase(quoteOrAppMap.get(accObj.Id))){
                        accObj.Tech_Last_Quote_Created_Modified_Date__c = System.now();
                    }else if(quoteOrAppMap.get(accObj.Id) != NULL && System.Label.SG53_ApplicationObjName.equalsIgnoreCase(quoteOrAppMap.get(accObj.Id))){
                        accObj.Tech_Last_App_Created_Modified_Date__c = System.now();
                    }
                }
                
                Database.update(updateAccountList);
            }
        }Catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,CLS_SGA_AP28_UPDATELASTMODDATE, UPDATE_DML_ON_ACC, SG01_Constants.BLANK, Logginglevel.ERROR);      }
    }
    
    /*****************************************************************************************************
    * Method Name  : handlerUtilInsertUpdate
    * Created Date : 8-Aug-2017
    * Created By   : IDC Offshore
    * Description  : Used to update quote created/last modified date on Account
    *****************************************************************************************************/
    public void handlerUtilInsertUpdate(List<Quote> quoteList){
        try{
            Map<ID,String> accountIdQuoteMap = new Map<ID,String>();
            for(Quote quoteObj : quoteList){
                if(String.isNotBlank(quoteObj.AccountId)){
                    accountIdQuoteMap.put(quoteObj.AccountId,System.Label.SG52_QuoteObjectName);
                }
            }
            if(!accountIdQuoteMap.isEmpty()){
                updateLMDOnAccountFromQuoteorApp(accountIdQuoteMap);
            }
        }Catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,CLS_SGA_AP28_UPDATELASTMODDATE, UPDATE_DML_ON_ACC, SG01_Constants.BLANK, Logginglevel.ERROR);      }
    }
}