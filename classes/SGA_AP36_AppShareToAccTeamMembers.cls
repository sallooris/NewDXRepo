/*******************************************************************************************
* Class Name  : SGA_AP36_AppShareToAccTeamMembers
* Created By  : IDC Offshore
* CreatedDate : 8/17/2017
* Description : This class is used to Share application record to the Account Team Members.
********************************************************************************************/
public class SGA_AP36_AppShareToAccTeamMembers {
    public static final string ROW_CAUSE = 'Manual';
    public static final string BROKER = 'Broker';
    
    public static final string CLS_SGA_AP36_APPSHARETOACCTEAMMEMBERS = 'SGA_AP36_AppShareToAccTeamMembers';
    public static final string METHOD_CREATEAPPSHARINGTOTEAMMEMBERS = 'createAppSharingToTeamMembers';
    
    /*****************************************************************************************************
    * Method Name : createAppSharingToTeamMembers
    * Parameters  : Map<ID,vlocity_ins__Application__c>
    * Return Type : void
    * Description : This method is used to create sharing access to the account team members.
    ******************************************************************************************************/
    public static void createAppSharingToTeamMembers(Map<Id, vlocity_ins__Application__c> newApplicationMap) {
        Map<Id, Id> accIdToApplicationIdMap = new Map<Id, Id>();
        Map<Id, Set<Id>> accIdToAccTeamMemberIdsMap = new Map<Id, Set<Id>>();
        List<vlocity_ins__Application__Share> applicationShareToBeInsertedList = new List<vlocity_ins__Application__Share>();
        try
        {
            for(vlocity_ins__Application__c appObj : newApplicationMap.values()){
                //Checking the accountId on the created application for type paper.
            	accIdToApplicationIdMap.put(appObj.vlocity_ins__AccountId__c, appObj.id);
            }
            
            if(!accIdToApplicationIdMap.isEmpty()) {
            	List<AccountTeamMember> accountTeamMembers = [SELECT id, userId, accountId FROM AccountTeamMember WHERE AccountId IN: accIdToApplicationIdMap.keySet() AND TeamMemberRole =: BROKER];

                for(AccountTeamMember accTeamMember : accountTeamMembers) {
                    vlocity_ins__Application__Share appShare = new vlocity_ins__Application__Share();
                    appShare.ParentId = accIdToApplicationIdMap.get(accTeamMember.accountId);
                    appShare.AccessLevel = Label.Application_Access_Level;
                    appShare.RowCause = ROW_CAUSE;
                    appShare.UserOrGroupId = accTeamMember.userId;
                    
                    applicationShareToBeInsertedList.add(appShare);
                    
                }
                
                if(!applicationShareToBeInsertedList.isEmpty()) {
                    Database.insert(applicationShareToBeInsertedList);
                }
            }
            
        } catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,CLS_SGA_AP36_APPSHARETOACCTEAMMEMBERS, METHOD_CREATEAPPSHARINGTOTEAMMEMBERS, SG01_Constants.BLANK, Logginglevel.ERROR);       }
 
    }
 
}