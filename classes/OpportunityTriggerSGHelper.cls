/*
* Name:        OpportunityTriggerSGHelper
* Purpose:     Helper class for Oppty and Acct sharing for SG Quoting
* Vlocity, 7/2016
*/

public class OpportunityTriggerSGHelper { 
    Public static Boolean isRecursive = false;
    // AFTER INSERT 
    public static void doAfterInsert(Map<Id, Opportunity> newMap) {
        setOpptyVisibility_new(newMap);
    }
    
    // AFTER UPDATE 
    public static void doAfterUpdate(Map<Id, Opportunity> oldMap, Map<Id, Opportunity> newMap) {
        setOpptyVisiblity_update(oldMap, newMap);
    }
    
    private static void setOpptyVisibility_new(Map<Id, Opportunity> newMap) {
        
        List<AccountShare> paAcctShare = new List<AccountShare>();        
        List<OpportunityShare> paOpptyShare = new List<OpportunityShare>();
        List<AccountShare> gaAcctShare = new List<AccountShare>();
        List<OpportunityShare> gaOpptyShare = new List<OpportunityShare>();
        List<OpportunityTeamMember> oppTeamList = new List<OpportunityTeamMember>();
        List<AccountTeamMember> accTeamList = new List<AccountTeamMember>();
        //added Lists to avoid SOQL within for loop
        List<Id> paidAgencyList = new List<Id>();
        List<Id> generalAgencyList = new List<Id>();
        List<Id> brokerList = new List<Id>();
        List<UserRole> paidAgencyUserRoleList = new List<UserRole>();
        List<UserRole> generalAgencyUserRoleList = new List<UserRole>();
        List<User> brokerUserList = new List<User>();
       
        
        for (Opportunity oppty : newMap.values()) {
            
            // get Accts for Paid Agency
            if (oppty.PaidAgency__c != null) {
                paidAgencyList.add(oppty.PaidAgency__c);          
            }
            // get Accts for General Agency
            if (oppty.GeneralAgency__c != null) { 
                generalAgencyList.add(oppty.GeneralAgency__c);    
            }
            // get Conts for Writing Agent
            if (oppty.Broker__c != null) {      
                brokerList.add(oppty.Broker__c);      
            }
        }
        Set<Id> roleIdSet=new Set<Id>();
        //Lists to hold the userRoles for PaidAgency and General Agency
        paidAgencyUserRoleList =  [SELECT ur.PortalType, ur.PortalAccountId, ur.Name, ur.Id FROM UserRole ur
                                   WHERE ur.PortalAccountId IN :paidAgencyList
                                   AND PortalType = 'Partner'
                                   AND (PortalRole = 'Executive' OR PortalRole = 'Manager')];
        for(UserRole ur: paidAgencyUserRoleList)
          roleIdSet.add(ur.Id);                 
        generalAgencyUserRoleList = [SELECT ur.PortalType, ur.PortalAccountId, ur.Name, ur.Id FROM UserRole ur
                                     WHERE ur.PortalAccountId IN :generalAgencyList
                                     AND PortalType = 'Partner'
                                     AND (PortalRole = 'Executive' OR PortalRole = 'Manager')];
        for(UserRole ur: generalAgencyUserRoleList)
          roleIdSet.add(ur.Id);
        // get Group IDs for  Roles related to the paid agency and general agency
        List<Group> groupList = new List<Group>([SELECT Id, RelatedId, Type FROM Group WHERE Type = 'Role' and RelatedId IN :roleIdSet]);
        Map<Id, Id> groupMap = new Map<Id, Id>();
        for (Group g : groupList) {
            groupMap.put(g.RelatedId, g.Id);
        }
        //List to hold the User for broker
        brokerUserList = [SELECT u.Id, u.Name, u.IsActive FROM User u
                          WHERE u.ContactId IN :brokerList];              
        
        //Adding values to lists to populate them depending on UserRole/User
        for (Opportunity oppty : newMap.values()) {
            if(!paidAgencyList.isEmpty()){
                for (UserRole ur:paidAgencyUserRoleList) {
                    paAcctShare.add(new AccountShare(AccountId = oppty.AccountId, AccountAccessLevel = 'Edit', CaseAccessLevel = 'None', OpportunityAccessLevel = 'None', UserOrGroupId = groupMap.get(ur.Id)));
                    paOpptyShare.add(new OpportunityShare(OpportunityId = oppty.Id, OpportunityAccessLevel = 'Edit', UserOrGroupId = groupMap.get(ur.Id)));            
                }
            } 
            if(!generalAgencyList.isEmpty()){
                for (UserRole ur:generalAgencyUserRoleList) {
                    gaAcctShare.add(new AccountShare(AccountId = oppty.AccountId, AccountAccessLevel = 'Edit',  CaseAccessLevel = 'None', OpportunityAccessLevel = 'None', UserOrGroupId = groupMap.get(ur.Id)));
                    gaOpptyShare.add(new OpportunityShare(OpportunityId = oppty.Id, OpportunityAccessLevel = 'Edit', UserOrGroupId = groupMap.get(ur.Id)));            
                }
            }
            if(!brokerUserList.isEmpty()){
                for (User u:brokerUserList) {
                    oppTeamList.add(new OpportunityTeamMember(OpportunityId = oppty.Id, UserId = u.Id, TeamMemberRole = 'Broker', OpportunityAccessLevel = 'Edit'));
                    accTeamList.add(new AccountTeamMember(AccountId = oppty.AccountId, UserId = u.Id, TeamMemberRole = 'Broker', AccountAccessLevel = 'Edit'));        
                }
            }                    
        }
        
        // create the Acct and Oppty shares
        if (! gaAcctShare.isEmpty()) {
            insert gaAcctShare;
        }
        if (! gaOpptyShare.isEmpty()) {
            insert gaOpptyShare;
        }
        if (! paAcctShare.isEmpty() ) {
            insert paAcctShare;
        }
        if (! paOpptyShare.isEmpty() ) {
            insert paOpptyShare;
        }
        // create the Oppty team members
        if (! oppTeamList.isEmpty() ) {
            insert oppTeamList;
            insert accTeamList;
        }
    }
    
    private static void setOpptyVisiblity_update(Map<Id, Opportunity> oldMap, Map<Id, Opportunity> newMap) {
        List<AccountShare> paAcctShare = new List<AccountShare>();
        List<OpportunityShare> paOpptyShare = new List<OpportunityShare>();
        List<AccountShare> gaAcctShare = new List<AccountShare>();
        List<OpportunityShare> gaOpptyShare = new List<OpportunityShare>();
        List<OpportunityTeamMember> oppTeamList = new List<OpportunityTeamMember>();
        List<OpportunityTeamMember> oppTeamListDel = new List<OpportunityTeamMember>();
        List<AccountTeamMember> accTeamList = new List<AccountTeamMember>();
        List<AccountTeamMember> accTeamListDel = new List<AccountTeamMember>();
        List<Id> oldOpptyAgencyList = new List<Id>();
        List<ID> oldOpptyAccountIDList = new List<Id>();
        List<Id> oldOpptyList = new List<Id>();
        List<Id>  oldOpptyBrokerList = new List<Id>();
        List<UserRole> oldOpptyAgencyRoleList = new List<UserRole>();
        List<AccountShare> todeleteAccountShares = new List<AccountShare>();
        List<OpportunityShare> todeleteOppShares = new List<OpportunityShare>();
        List<Id> paidAgencyList = new List<Id>();
        List<Id> generalAgencyList = new List<Id>();
        List<Id> brokerList = new List<Id>();
        List<UserRole> paidAgencyUserRoleList = new List<UserRole>();
        List<UserRole> generalAgencyUserRoleList = new List<UserRole>();
        List<User> brokerUserList = new List<User>();
        List<User> oldOpptyBrokerUserList = new List<User>();
        List<AccountTeamMember> todeleteAccountTeamMember = new List<AccountTeamMember>();
        List<OpportunityTeamMember> todeleteOpportunityTeamMember = new List<OpportunityTeamMember>();
        
        List<Id> groupIds = new List<Id>();
        // get Group IDs for all Roles
       // List<Group> groupList = new List<Group>([SELECT Id, RelatedId, Type FROM Group WHERE Type = 'Role']);
       // Map<Id, Id> groupMap = new Map<Id, Id>();
       // for (Group g : groupList) {
        //    groupMap.put(g.RelatedId, g.Id);
       // }
        
        for (Opportunity newOppty : newMap.values()) {        
            Opportunity oldOppty = oldMap.get(newOppty.Id);            
            
            if(oldOppty.PaidAgency__c != newOppty.PaidAgency__c && oldOppty.PaidAgency__c != null) {
                //populating the lists to avoid SOQL in for loops- for deleting existing account and opp share records
                oldOpptyAgencyList.add(oldOppty.PaidAgency__c);
                oldOpptyList.add(newOppty.Id);
                oldOpptyAccountIDList.add(oldOppty.AccountId);
            }        
            if (newOppty.PaidAgency__c != null) {            
                //populating list to create new accountshare and oppshare records
                paidAgencyList.add(newOppty.PaidAgency__c);
            }
            
            // check previous GA        
            if(oldOppty.GeneralAgency__c != newOppty.GeneralAgency__c && oldOppty.GeneralAgency__c != null) {
                oldOpptyAgencyList.add(oldOppty.GeneralAgency__c);
                oldOpptyList.add(oldOppty.Id);
                oldOpptyAccountIDList.add(oldOppty.AccountId);
            }
            
            // get Accts for General Agency
            if (newOppty.GeneralAgency__c != null) {     
                generalAgencyList.add(newOppty.GeneralAgency__c);                 
            }
            
            // check previous WA        
            if(oldOppty.Broker__c != newOppty.Broker__c && oldOppty.Broker__c != null) {
                oldOpptyBrokerList.add(oldOppty.Broker__c);
                oldOpptyList.add(oldOppty.Id);
                oldOpptyAccountIDList.add(oldOppty.AccountId);
            }
            // get Conts for Writing Agent
            if (newOppty.Broker__c != null) { 
                brokerList.add(newOppty.Broker__c);           
            }
            
        }
        
        oldOpptyBrokerUserList= [SELECT u.Id, u.Name, u.IsActive FROM User u
                                 WHERE u.ContactId IN :oldOpptyBrokerList];
        todeleteAccountTeamMember = [SELECT Id FROM AccountTeamMember
                                     WHERE AccountId IN :oldOpptyAccountIDList
                                     AND UserId IN :oldOpptyBrokerUserList
                                     AND TeamMemberRole = 'Broker'];    
        // delete Oppty team member
        todeleteOpportunityTeamMember =  [SELECT Id FROM OpportunityTeamMember
                                          WHERE OpportunityId IN :oldOpptyList
                                          AND UserId IN :oldOpptyBrokerUserList
                                          AND TeamMemberRole = 'Broker'];
        oldOpptyAgencyRoleList = [SELECT ur.Id FROM UserRole ur
                                  WHERE ur.PortalAccountId IN :oldOpptyAgencyList
                                  AND PortalType = 'Partner'
                                  AND (PortalRole = 'Executive' OR PortalRole = 'Manager')];
        Set<Id> roleIdSet=new Set<Id>();
        for(UserRole ur: oldOpptyAgencyRoleList)
          roleIdSet.add(ur.Id);
        
        // create the Acct and Oppty shares
        
        paidAgencyUserRoleList =  [SELECT ur.PortalType, ur.PortalAccountId, ur.Name, ur.Id FROM UserRole ur
                                   WHERE ur.PortalAccountId IN :paidAgencyList
                                   AND PortalType = 'Partner'
                                   AND (PortalRole = 'Executive' OR PortalRole = 'Manager')];
        for(UserRole ur: paidAgencyUserRoleList)
          roleIdSet.add(ur.Id);                           
        generalAgencyUserRoleList = [SELECT ur.PortalType, ur.PortalAccountId, ur.Name, ur.Id FROM UserRole ur
                                     WHERE ur.PortalAccountId IN :generalAgencyList
                                     AND PortalType = 'Partner'
                                     AND (PortalRole = 'Executive' OR PortalRole = 'Manager')];
        for(UserRole ur: generalAgencyUserRoleList)
          roleIdSet.add(ur.Id);                               
        brokerUserList = [SELECT u.Id, u.Name, u.IsActive FROM User u
                          WHERE u.ContactId IN :brokerList]  ;              
        
        // get Group IDs for  Roles related to the paid agency and general agency
        List<Group> groupList = new List<Group>([SELECT Id, RelatedId, Type FROM Group WHERE Type = 'Role' and RelatedId IN :roleIdSet]);
        Map<Id, Id> groupMap = new Map<Id, Id>();
        for (Group g : groupList) {
            groupMap.put(g.RelatedId, g.Id);
        }
        for(UserRole u:oldOpptyAgencyRoleList)
        {
            groupIds.add(groupMap.get(u.Id));
        }
        
        todeleteAccountShares = [SELECT Id FROM AccountShare
                                 WHERE AccountId IN :oldOpptyAccountIDList
                                 AND UserOrGroupId IN :groupIds
                                 AND RowCause = 'Manual'];
        
        todeleteOppShares = [SELECT Id FROM OpportunityShare
                             WHERE OpportunityId IN :oldOpptyList
                             AND UserOrGroupId IN :groupIds
                             AND RowCause = 'Manual'];
                             
        for (Opportunity oppty : newMap.values()) {
            if(!paidAgencyList.isEmpty()){
                for (UserRole ur:paidAgencyUserRoleList) {
                    paAcctShare.add(new AccountShare(AccountId = oppty.AccountId, AccountAccessLevel = 'Edit', CaseAccessLevel = 'None', OpportunityAccessLevel = 'None', UserOrGroupId = groupMap.get(ur.Id)));
                    paOpptyShare.add(new OpportunityShare(OpportunityId = oppty.Id, OpportunityAccessLevel = 'Edit', UserOrGroupId = groupMap.get(ur.Id)));            
                }
            } 
            if(!generalAgencyList.isEmpty()){
                for (UserRole ur:generalAgencyUserRoleList) {
                    gaAcctShare.add(new AccountShare(AccountId = oppty.AccountId, AccountAccessLevel = 'Edit',  CaseAccessLevel = 'None', OpportunityAccessLevel = 'None', UserOrGroupId = groupMap.get(ur.Id)));
                    gaOpptyShare.add(new OpportunityShare(OpportunityId = oppty.Id, OpportunityAccessLevel = 'Edit', UserOrGroupId = groupMap.get(ur.Id)));            
                }
            }
            if(!brokerUserList.isEmpty()){
                for (User u:brokerUserList) {
                    oppTeamList.add(new OpportunityTeamMember(OpportunityId = oppty.Id, UserId = u.Id, TeamMemberRole = 'Broker', OpportunityAccessLevel = 'Edit'));
                    accTeamList.add(new AccountTeamMember(AccountId = oppty.AccountId, UserId = u.Id, TeamMemberRole = 'Broker', AccountAccessLevel = 'Edit'));        
                }
            }                    
        }
        
        if(!todeleteAccountShares.isEmpty())
        {   
            delete todeleteOppShares;
            delete todeleteAccountShares;
        }
        if(!todeleteAccountTeamMember.isEmpty())
        {
            delete todeleteAccountTeamMember;
        }
        if(!todeleteOpportunityTeamMember.isEmpty())
        {
            delete todeleteOpportunityTeamMember;
        }
        if (! gaAcctShare.isEmpty()) {
            insert gaAcctShare;
        }        
        if (! gaOpptyShare.isEmpty()) {
            insert gaOpptyShare;
        }
        if (! paAcctShare.isEmpty()) {
            insert paAcctShare;
        }
        if (! paOpptyShare.isEmpty()) {
            insert paOpptyShare;
        }
        // create the Oppty team members
        if (! oppTeamList.isEmpty()) {
            insert oppTeamList;
            insert accTeamList;
        }  
    }    
}