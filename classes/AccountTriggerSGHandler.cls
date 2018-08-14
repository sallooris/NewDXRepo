/*******************************************************************
* Class Name  : AccountTriggerSGHandler
* Created By  : IDC Offshore
* Created Date: 09/18/2017 (mm/dd/yyyy)
* Description : This is the trigger handler class for Account Object
*******************************************************************/
public without sharing class AccountTriggerSGHandler {
    /******************************************************************************************
* Method Name  : onAfterInsert
* Parameters  : Map<id, Account> oldAccountMap
* Return type : Void
* Description  : This is used for calling the business logic classes onAfterInsert trigger
*******************************************************************************************/
    public static void onAfterInsert(Map<ID,Account> newAccountMap){
        /*  method call to create Opportunity Type:SGQUOTING for Prospect Type on Insert and
		insert the account team member from the broker account to group account */
        
        SGA_AP42_AccountTeamOwner_Update.updateAccTeam(newAccountMap,null);
        new SGA_AP50_RenewalUpsellOps().createRenewalUpsellOpps(newAccountMap,NULL,'Insert');
        
    }
    
    
    /******************************************************************************************
    * Method Name  : onAfterUpdate
    * Parameters  : Map<id, Account> newAccountMap
    * Return type : Void
    * Description  : This is used for calling the business logic classes onAfterUpdate trigger *******************************************************************************************/
    public static void onAfterUpdate(Map<ID, Account> newAccountMap,Map<ID, Account> oldAccountMap){
        /*  method call to create Opportunity Type:SGQUOTING for Prospect Type on Update and
i		nsert the account team member from the broker account to group account */
        if(!SGA_AP42_AccountTeamOwner_Update.isUpdateRecursive ){
            SGA_AP42_AccountTeamOwner_Update.isUpdateRecursive = true;
            SGA_AP42_AccountTeamOwner_Update.updateAccTeam(newAccountMap,oldAccountMap);   
        }
        new SGA_AP50_RenewalUpsellOps().createRenewalUpsellOpps(newAccountMap,oldAccountMap ,'Update');
    }
    
    
    /******************************************************************************************
    * Method Name  : onBeforeInsert
    * Parameters   :  List<Account> newAccList
    * Return type  :  Void
    * Description  :  This is used for calling the business logic classes onBeforeInsert trigger *******************************************************************************************/
    public static void onBeforeInsert(List<Account> newAccList){
        /*  method call to populate Rating Area based on Zipcode and State */
        SGA_AP51_UpdateRatingArea.populateRatingArea(newAccList);
        
    }
    /******************************************************************************************
    * Method Name  : onBeforeUpdate
    * Parameters  : Map<id, Account> newAccountMap
    * Return type : Void
    * Description  : This is used for calling the business logic classes onBeforeUpdate trigger *******************************************************************************************/
    public static void onBeforeUpdate(Map<ID, Account> newAccountMap,Map<ID, Account> oldAccountMap){
        /*  method call to update Rating Area based on Zipcode and State */
        system.debug('<.....before update call.....>');
        List<Account> accList = new List<Account>(); 
        if(oldAccountMap != NULL){
            for(Account acc : newAccountMap.Values()){
                if((newAccountMap.get(acc.id).Company_State__c != oldAccountMap.get(acc.id).Company_State__c || newAccountMap.get(acc.id).Company_Zip__c != oldAccountMap.get(acc.id).Company_Zip__c || newAccountMap.get(acc.id).County__c != oldAccountMap.get(acc.id).County__c)  ){
                    accList.add(acc);    
                }
            }
        } 
        
        if(!accList.isEmpty()){
            SGA_AP51_UpdateRatingArea.populateRatingArea(accList);
        }         
    }
}