/*******************************************************************************************
* Class Name  : SGA_AP46_UpdateOppTeamWithAccTeam
* Created By  : IDC Offshore
* CreatedDate : 9/13/2017
* Description : This class is used to update Opportunity Team with Account Team.
********************************************************************************************/
public without sharing class SGA_AP46_UpdateOppTeamWithAccTeam {
    public static final string CLS_SGA_AP46_UPDATEOPPTEAMWITHACCTEAM = 'SGA_AP46_UpdateOppTeamWithAccTeam';
    public static final string METHOD_UPDATEOPPTEAMWITHACCTEAM = 'updateOppTeamWithAccTeam';
    
    /*****************************************************************************************************
    * Method Name : addOppTeamWithAccTeam
    * Parameters  : Map<Id, Opportunity>
    * Return Type : void
    * Description : This method is used to add Opportunity Team with Account Team.
    ******************************************************************************************************/
    public static void updateOppTeamWithAccTeam(Map<Id, Opportunity> newMap) {
        try
        {
            Map<String, String> accountIdsMap = new Map<String, String>();
            
            for(Opportunity oppObj : newMap.values()){
                if(!String.isBlank(oppObj.AccountId)) {
                    accountIdsMap.put(oppObj.AccountId, oppObj.Id);
                }
            }
            
            if(!accountIdsMap.isEmpty()) {
                updateOppTeamMembers(accountIdsMap);
            }
            
        } catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,CLS_SGA_AP46_UPDATEOPPTEAMWITHACCTEAM, METHOD_UPDATEOPPTEAMWITHACCTEAM, SG01_Constants.BLANK, Logginglevel.ERROR);       }

    }
    
    /*****************************************************************************************************
    * Method Name : updateAccountsWithNewCaseStage
    * Parameters  : Map<ID,Case>
    * Return Type : void
    * Description : This method is used to update Tech fields in Account when the new case is created.
    ******************************************************************************************************/
    private static void updateOppTeamMembers(Map<String, String> accountIdsMap) {
        List<OpportunityTeamMember> OpportunityTeamMemberList = new List<OpportunityTeamMember>();        
        for (AccountTeamMember[] atmList : [Select UserId, TeamMemberRole, OpportunityAccessLevel, AccountId From AccountTeamMember where AccountID in :accountIdsMap.keySet()]){
            if(!atmList.isEmpty()) {
                for (AccountTeamMember atm : atmList)
                {
                    OpportunityTeamMember oppTeamMember = new OpportunityTeamMember();
                    oppTeamMember.OpportunityId = accountIdsMap.get(atm.AccountId);
                    oppTeamMember.OpportunityAccessLevel = atm.OpportunityAccessLevel;
                    oppTeamMember.UserId = atm.UserId;
                    oppTeamMember.TeamMemberRole = atm.TeamMemberRole;
                    
                    OpportunityTeamMemberList.add(oppTeamMember);                            
                }
                
            }
        }
        
        if(!OpportunityTeamMemberList.isEmpty()) {
            Database.insert(OpportunityTeamMemberList);
        }
    }
    
}