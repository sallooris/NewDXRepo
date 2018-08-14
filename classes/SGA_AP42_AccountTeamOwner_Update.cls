/********************************************************************************************************************
* Class Name  : SGA_AP42_AccountTeamOwner_Update
* Created By  : IDC Offshore
* Created Date: 9/11/2017
* Description : 1. Apex class to get the account team members of broker/ agency account to group account
2. Update the Account Owner when the account team member is of AM or AE
*********************************************************************************************************************/
public without sharing class SGA_AP42_AccountTeamOwner_Update
{    
    
    public static final string UPDATEACCTEAMMEMBERSMTD = 'updateAccTeamMembers';
    public static final string CLS_AP42_ACCOUNTTEAMOWNER_UPDATE = 'SGA_AP42_AccountTeamOwner_Update ';
    public static final string UPDATEACCTEAMMTD = 'updateAccTeam';
    public static Map<Id, Account> allNewAccountMap;
    public static Map<Id, Account> allNewAccountMapForOpp;
    public static Map<Id, Account> alloldAccountMap;
    public static boolean isInsertRecursive = false;
    public static boolean isUpdateRecursive = false;
    private static boolean OOP_FLAG_UP = false;
    private static boolean OOP_FLAG_INS = false;
    private static List<SGA_CS07_UserProfile__c> allowProf = SGA_CS07_UserProfile__c.getall().values();
    /******************************************************************************************
* Method Name  : updateAccTeam
* Parameters  : Map<id, Account> newAccMap
* Return type : Void
* Description  : Method fetches the account team members of broker/agency account to group account
*******************************************************************************************/
    public static void updateAccTeam(Map<id, Account> newMap, Map<Id,Account> oldMap)
    {
    system.debug('inside SGA_AP42_AccountTeamOwner_Update.updateAccTeam');
        allNewAccountMap = new Map<Id, Account>();
        alloldAccountMap = new Map<Id, Account>();
        allNewAccountMapForOpp = new Map<Id, Account>();
        if(oldMap != NULL){

            alloldAccountMap = oldMap;
            for(Account a : newMap.Values()){
                if(newMap.get(a.id).Type != NULL && newMap.get(a.id).Type != oldMap.get(a.id).Type){
                    allNewAccountMapForOpp.put(a.id,a);
                    OOP_FLAG_UP= true;
                }
                if((newMap.get(a.id).Type != NULL && newMap.get(a.id).Type != oldMap.get(a.id).Type) || (newMap.get(a.id).Agency_Brokerage__c != NULL)){
                    allNewAccountMap.put(a.id,a);    
                }
            }
        }
        else
        {
            allNewAccountMap = newMap;
            OOP_FLAG_INS =true;
        }
        
      try
        { 
            set<id> accountIdSet = new set<id>();
            Map<String, Set<String>> accountIdsMap = new Map<String, set<String>>();
            Map<String, String> accountIdStatusMap = new Map<String, String>();
            Map<String,String> accountIdStateMap = new Map<String,String>();
            List<AccountTeamMember> actmList = new List<AccountTeamMember>();
            Map<String,String> grpAccBrkAccMap = new Map<String,String>();
            for(Account acc: allNewAccountMap.values())
            {
                if(string.isNotBlank(acc.Agency_Brokerage__c) && (acc.Type == System.Label.SG_82_Enrolled || acc.Type == System.Label.SG83_Prospect))
                {
                    grpAccBrkAccMap.put(acc.Id,acc.Agency_Brokerage__c);
                    accountIdStateMap.put(acc.Id, acc.company_state__c);
                    accountIdStatusMap.put(acc.Id, acc.Type);
                }
            }
            if(!allNewAccountMap.isEmpty())
            {
                updateAccTeamMembers(grpAccBrkAccMap, accountIdStatusMap,accountIdStateMap);
            }
        }
      catch(exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, CLS_AP42_ACCOUNTTEAMOWNER_UPDATE, UPDATEACCTEAMMTD, SG01_Constants.BLANK,Logginglevel.ERROR);        }
     }
    
    /***************************************************************************************************
* Method Name  : updateAccTeamMembers
* Parameters  : Map<string, string> accountIdsMap
* Return type : Void
* Description  : Method fetches the account team members of broker/agency account to group account
***************************************************************************************************/
    private static void updateAccTeamMembers(Map<String,String> accountIdsMap, Map<String, String> accIdStatusMap,Map<String,String> accountIdStateMap)
    {
        List<AccountTeamMember> actList = new List<AccountTeamMember>();
        List<Account> updateOwnerAccList = new List<Account>();
        Map<Id,Account> accUpdateSet = new Map<Id,Account>();
        List<String> brkAgencyList = accountIdsMap.values();
        Set<String> brkAgencySet = new Set<String>();
        brkAgencySet.addAll(brkAgencyList);
            if(!accountIdsMap.isEmpty() && !accIdStatusMap.isEmpty()) {
                Set<String> userIds = new Set<String>();
                Map<String,List<AccountTeamMember>> accTeamMemMap = new Map<String,List<AccountTeamMember>>();
                for(AccountTeamMember accTeamMemObj : [Select ID,UserId, TeamMemberRole, AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, AccountId From AccountTeamMember
                                                             where AccountId IN :brkAgencySet LIMIT 10000])
                {
                    userIds.add(accTeamMemObj.UserId);
                    if(accTeamMemMap.containsKey(accTeamMemObj.AccountId)){
                        List<AccountTeamMember> teamMemList = accTeamMemMap.get(accTeamMemObj.AccountId);
                        teamMemList.add(accTeamMemObj);
                        accTeamMemMap.put(accTeamMemObj.AccountId,teamMemList);
                    }else{
                        List<AccountTeamMember> teamMemList = new List<AccountTeamMember>();
                        teamMemList.add(accTeamMemObj);
                        accTeamMemMap.put(accTeamMemObj.AccountId,teamMemList);
                    }
                }
                Map<String,String> salesRepStateMap = new Map<String,String>();
                for(User_Sales_Rep_Code__c salesRepObj : [Select id, User__c, state__c from User_Sales_Rep_Code__c where User__c IN:userIds LIMIT 10000])
                {
                    salesRepStateMap.put(salesRepObj.User__c, salesRepObj.State__c);
                }
                                
                for(string accId: accountIdsMap.keySet())
                {
                    String brokerId = accountIdsMap.get(accId);
                    if(brokerId != NULL && String.isNotBlank(brokerId)){
                        List<AccountTeamMember> atmList = accTeamMemMap.get(brokerId);
                        if(atmList != NULL && !atmList.isEmpty()){
                            for(AccountTeamMember atm : atmList){
                                if(salesRepStateMap.containsKey(atm.UserId) && accountIdStateMap.get(accId) != NULL && accountIdStateMap.get(accId).equalsIgnoreCase(salesRepStateMap.get(atm.UserId))){
                                    AccountTeamMember act = new AccountTeamMember();
                                    act.AccountId = accId;
                                    act.AccountAccessLevel = System.Label.SG85_Edit;
                                    act.OpportunityAccessLevel = System.Label.SG85_Edit;
                                    act.CaseAccessLevel = System.Label.SG_84_Read;
                                    act.UserId = atm.UserId;
                                    act.TeamMemberRole = atm.TeamMemberRole;
                                    if(atm.TeamMemberRole == System.Label.SG81_Account_Executive && System.Label.SG83_Prospect.equalsIgnoreCase(accIdStatusMap.get(accId)))
                                    {
                                        Account updateAcc = new Account(Id=accId);
                                        updateAcc.OwnerId = atm.UserId;
                                        updateAcc.Tech_AccountTeamCheck__c = true;
                                        accUpdateSet.put(accId,updateAcc);
                                    }
                                    else if(atm.TeamMemberRole == System.Label.SG80_Account_Manager && System.Label.SG_82_Enrolled.equalsIgnoreCase(accIdStatusMap.get(accId)))
                                    {
                                        Account updateAcc = new Account(Id=accId);
                                        updateAcc.OwnerId = atm.UserId;
                                        updateAcc.Tech_AccountTeamCheck__c = true;
                                        accUpdateSet.put(accId,updateAcc);
                                    }
                                    else if(atm.TeamMemberRole == System.Label.SG86_SalesRep)
                                    {
                                        Account updateAcc = new Account(Id=accId);
                                        updateAcc.OwnerId = atm.UserId;
                                        updateAcc.Tech_AccountTeamCheck__c = true;
                                        accUpdateSet.put(accId,updateAcc);
                                    }
                                    actList.add(act);
                                }
                            }  
                        }
                    }
                    
                                      
                }             
            }            
            if(!actList.isEmpty()){
                database.insert(actList, false);
            }
            
            // call Opportunity and Product Creation LOgic for Prospect Accounts
            // insert operation for Opportunity
            
            String usrProfileName = [Select Name from Profile where Id =: userinfo.getProfileId()].Name;
            Map<String,String> allowedProfilesMap = new Map<String,String>();
            if(!allowProf.isEmpty())
            {
                for(SGA_CS07_UserProfile__c cs:allowProf){
                    allowedProfilesMap.put(cs.Name, cs.Profile_Name__c);
                }
                if(!allowedProfilesMap.isEmpty() && allowedProfilesMap.containsKey(usrProfileName)){            
                    if(OOP_FLAG_INS == true && !allNewAccountMap.isEmpty()){
                        SGA_AP48_CreateOppForProspectAccount.createOppForProspect(allNewAccountMap);
                    }
                    // Update operation for Opportunity
                    if(OOP_FLAG_UP == true && !allNewAccountMapForOpp.isEmpty()){
                        SGA_AP48_CreateOppForProspectAccount.createOppForProspect(allNewAccountMapForOpp);
                    }
                }
            }
            
            if(!accUpdateSet.isEmpty()){
                database.update(accUpdateSet.Values(), false);
            }
        
    }
    
}