/*******************************************************************************************
* Class Name  : SGA_AP32_UpdateCaseStageTechFieldsOnAcc
* Created By  : IDC Offshore
* CreatedDate : 8/9/2017
* Description : This class is used to track the changes of stage and state on case.
********************************************************************************************/
public without sharing class SGA_AP32_UpdateCaseStageTechFieldsOnAcc {
    public static final string TECH_CASE_STAGE_SC = 'Tech Case Stage Is SC';
    public static final string TECH_CASE_STAGE_PL = 'Tech Case Stage Is PL';
    public static final string SCRUB_COMPLETED = 'Scrub Completed';
    public static final string PRODUCTS_LOADED = 'Products Loaded';
    public static final string STATE_NY = 'NY';
    public static final string STATE_ME = 'ME';
    public static final string STATE_CA = 'CA';
    public static final string STATE_CO = 'CO';
    public static final string TECH_CASE_STAGE_OTHERS = 'Tech Case Stage Is OTHERS';
    public static final string CLS_SGA_AP32_UPDATECASESTAGETECHFIELDSONACC = 'SGA_AP32_UpdateCaseStageTechFieldsOnAcc';
    public static final string METHOD_UPDATECASESTAGETECHFIELDS = 'updateCaseStageTechFields';
    
    /*****************************************************************************************************
    * Method Name : updateCaseStageTechFields
    * Parameters  : Map<ID,Case>,Map<ID,Case>
    * Return Type : void
    * Description : This method is used to List the Accounts which needs to be updated with the updated case stage fields.
    ******************************************************************************************************/
    public static void updateCaseStageTechFields(Map<ID,Case> caseNewMap,Map<ID,Case> caseOldMap) {
        try
        {
            Map<String, String> accountIdsMap = new Map<String, String>();
            
            for(Case caseObj : caseNewMap.values()){
                //checking case stage and state is not changed.
                if(caseObj.Stage__c != caseOldMap.get(caseObj.Id).Stage__c || caseObj.BR_State__c != caseOldMap.get(caseObj.Id).BR_State__c) {
                    if((SCRUB_COMPLETED.equals(caseObj.Stage__c)) && (STATE_NY.equals(caseObj.BR_State__c) || STATE_ME.equals(caseObj.BR_State__c))){
                        //Update Tech_case_stage in Account 
                        //Tech Case Stage Is SC to TRUE
                        accountIdsMap.put(caseObj.AccountId, TECH_CASE_STAGE_SC);
                    } else if((PRODUCTS_LOADED.equals(caseObj.Stage__c)) && (STATE_CA.equals(caseObj.BR_State__c) || STATE_CO.equals(caseObj.BR_State__c))){
                        //Update Tech_case_stage field in Account 
                        //Tech Case Stage Is PL to TRUE
                        accountIdsMap.put(caseObj.AccountId, TECH_CASE_STAGE_PL);
                    } else {
                        //Update both Tech fields to false
                        accountIdsMap.put(caseObj.AccountId, TECH_CASE_STAGE_OTHERS);
                    }
                }
            }
            
            if(!accountIdsMap.isEmpty()) {
                updateAccountsWithNewCaseStage(accountIdsMap);
            }
        } catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,CLS_SGA_AP32_UPDATECASESTAGETECHFIELDSONACC, METHOD_UPDATECASESTAGETECHFIELDS, SG01_Constants.BLANK, Logginglevel.ERROR);       }
    }
    
    /*****************************************************************************************************
    * Method Name : updateNewCaseStageTechFields
    * Parameters  : Map<ID,Case>
    * Return Type : void
    * Description : This method is used to List the Accounts which needs to be updated with the new case stage fields.
    ******************************************************************************************************/
    public static void updateNewCaseStageTechFields(Map<ID,Case> caseNewMap) {
        try{ 
            Map<String, String> accountIdsMap = new Map<String, String>();
            
            for(Case caseObj : caseNewMap.values()){
                //checking case stage and state is not changed.
                if((SCRUB_COMPLETED.equals(caseObj.Stage__c)) && (STATE_NY.equals(caseObj.BR_State__c) || STATE_ME.equals(caseObj.BR_State__c))){
                    //Update SC Tech field in Account 
                    //Tech Case Stage Is SC to TRUE
                    accountIdsMap.put(caseObj.AccountId, TECH_CASE_STAGE_SC);
                } else if((PRODUCTS_LOADED.equals(caseObj.Stage__c)) && (STATE_CA.equals(caseObj.BR_State__c) || STATE_CO.equals(caseObj.BR_State__c))){
                    //Update SC Tech field in Account 
                    //Tech Case Stage Is PL to TRUE
                    accountIdsMap.put(caseObj.AccountId, TECH_CASE_STAGE_PL);
                } else {
                    //Update both Tech fields to false
                    accountIdsMap.put(caseObj.AccountId, TECH_CASE_STAGE_OTHERS);
                }
                
            }
            
            if(!accountIdsMap.isEmpty()) {
                updateAccountsWithNewCaseStage(accountIdsMap);	
            }
        } catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,CLS_SGA_AP32_UPDATECASESTAGETECHFIELDSONACC, METHOD_UPDATECASESTAGETECHFIELDS, SG01_Constants.BLANK, Logginglevel.ERROR);       }
    }
    
    /*****************************************************************************************************
    * Method Name : updateAccountsWithNewCaseStage
    * Parameters  : Map<ID,Case>
    * Return Type : void
    * Description : This method is used to update Tech fields in Account when the new case is created.
    ******************************************************************************************************/
    private static void updateAccountsWithNewCaseStage(Map<String, String> accountIdsMap) {
        List<Account> accountListToUpdate = new List<Account>();
        for(Account newAccount : [SELECT id, Tech_Case_Stage_Is_PL__c, Tech_Case_Stage_Is_SC__c FROM Account where id IN: accountIdsMap.keySet()]) {
            if(accountIdsMap.get(newAccount.Id).equals(TECH_CASE_STAGE_SC)) {
                if(!newAccount.Tech_Case_Stage_Is_SC__c) {
                    newAccount.Tech_Case_Stage_Is_SC__c = true;
                    newAccount.Tech_Case_Stage_Is_PL__c = false;
                    accountListToUpdate.add(newAccount);
                }
            } else if(accountIdsMap.get(newAccount.Id).equals(TECH_CASE_STAGE_PL)) {
                if(!newAccount.Tech_Case_Stage_Is_PL__c) {
                    newAccount.Tech_Case_Stage_Is_PL__c = true;
                    newAccount.Tech_Case_Stage_Is_SC__c = false;
                    accountListToUpdate.add(newAccount);
                }
            } else {
                if(newAccount.Tech_Case_Stage_Is_PL__c || newAccount.Tech_Case_Stage_Is_SC__c) {
                    newAccount.Tech_Case_Stage_Is_PL__c = false;
                    newAccount.Tech_Case_Stage_Is_SC__c = false;
                    accountListToUpdate.add(newAccount);
                }
            }
        }	
        Database.update(accountListToUpdate);
    }
    
}