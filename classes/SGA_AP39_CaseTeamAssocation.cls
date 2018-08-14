/************************************************************************
Class Name   : SGA_AP39_CaseTeamAssocation
Date Created : 23-August-2017
Created By   : IDC Offshore
Description  : 1. Class to create case team for broker when the case got populated with broker Accounts
**************************************************************************/
public class SGA_AP39_CaseTeamAssocation{
    public static FINAL String CLASSNAME = 'SGA_AP39_CaseTeamAssocation';
    public static Id caseTeamRoleId = [select Id from CaseTeamRole where Name =: Label.SG39_Broker limit 1].Id;
    public static Id caseInstallRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.SG50_CaseInstallationRecType).getRecordTypeId();
    public static Id casePreInqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.SG65_Small_Group_Pre_Enrollment_Inquiry).getRecordTypeId();
    /************************************************************************
Method Name  : onInsertProcessCaseTeam
Description  : Method to be invoked from insert trigger to process the case team creation
**************************************************************************/
    public static void onInsertProcessCaseTeam(Map<Id,Case> caseMap){
        List<Case> caseList = New List<Case>();
        for(case c: caseMap.values()){
            if(c.recordTypeId == caseInstallRecTypeId || c.recordTypeId ==casePreInqRecTypeId){
                if(c.Delegate_Contact_of_Broker_or_Agency__c != NULL || c.Broker_Writing_Agent_1__c != NULL || c.Broker_Writing_Agent_2__c != NULL || c.General_Agency__c != NULL || c.Paid_Agency__c != NULL){
                    caseList.add(c);    
                }
            }
        } 
        processCaseTeam(caseList);
    }
    /************************************************************************
Method Name  : onUpdateProcessCaseTeam
Description  : Method to be invoked from update trigger to process the case team creation
**************************************************************************/
    public static void onUpdateProcessCaseTeam(Map<Id,Case> OldCaseMap,Map<Id,Case> newCaseMap){
        List<Case> caseList = New List<Case>();
        for(case c: newCaseMap.values()){
            if(c.recordTypeId == caseInstallRecTypeId || c.recordTypeId == casePreInqRecTypeId){
                if(c.Delegate_Contact_of_Broker_or_Agency__c != OldCaseMap.get(c.Id).Delegate_Contact_of_Broker_or_Agency__c || c.Broker_Writing_Agent_1__c != OldCaseMap.get(c.Id).Broker_Writing_Agent_1__c || c.Broker_Writing_Agent_2__c != OldCaseMap.get(c.Id).Broker_Writing_Agent_2__c || c.General_Agency__c != OldCaseMap.get(c.Id).General_Agency__c || c.Paid_Agency__c != OldCaseMap.get(c.Id).Paid_Agency__c){
                    caseList.add(c);    
                } 
            }
        }
        system.debug('====>case List'+caseList);
        processCaseTeam(caseList);
    }
    /************************************************************************
Method Name  : processCaseTeam
Description  : Method to be process the creation of case teams by invoking individual helper methods
**************************************************************************/
    public static void processCaseTeam(List<Case> caseList){
        try{
            Map<Id,Set<Id>> caseAccIdMap = New Map<Id,Set<Id>>();
            Map<Id,Set<Id>> accConMap = New Map<Id,Set<Id>>();
            Map<id,id> conUserMap = New Map<id,id>();
            Map<id,Set<id>> caseUserMap = New Map<id,Set<id>>();
            Map<Id,List<CaseTeamMember>> caseTeamMap = New Map<Id,List<CaseTeamMember>>();
            Map<id,id> caseConUserMap = New Map<id,id>();
            caseAccIdMap = createCaseAccMap(caseList); 
            system.debug('====>caseAccIdMap List'+caseAccIdMap);
            accConMap = createAccConMap(caseAccIdMap);
            system.debug('====>accConMap'+accConMap);
            conUserMap = fetchPartnerUserIDs(accConMap);
            system.debug('====>conUserMap'+conUserMap);
            caseUserMap = createCaseUserMap(caseAccIdMap, accConMap, conUserMap);
            system.debug('====>caseUserMap'+caseUserMap);
            caseConUserMap = fetchPartnerUserForDelegateContacts(caseList);
            system.debug('====>caseConUserMap'+caseConUserMap);
            retriveExistingCaseTeam(caseList);   
            createCaseTeamMember(caseUserMap, caseConUserMap, caseList);
        }
        Catch(Exception ex){
            UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,CLASSNAME, CLASSNAME, SG01_Constants.BLANK, Logginglevel.ERROR);        
        }
        
    }
    /************************************************************************
Method Name  : createCaseAccMap
Description  : Method to be construct map with Case Id & related Account Ids on case record
**************************************************************************/
    public static Map<id,Set<id>> createCaseAccMap(List<Case> caseList){
        Map<Id,Set<Id>> caseAccIdMap = New Map<Id,Set<Id>>();
        for(case c : caseList){
            if(!caseAccIdMap.containsKey(c.Id)){
                Set<id> newSet = New set<Id>();
                if(c.Broker_Writing_Agent_1__c != null)
                    newSet.add(c.Broker_Writing_Agent_1__c);
                if(c.Broker_Writing_Agent_2__c != null)
                    newSet.add(c.Broker_Writing_Agent_2__c);
                if(c.General_Agency__c != null)
                    newSet.add(c.General_Agency__c);
                if(c.Paid_Agency__c != null)
                    newSet.add(c.Paid_Agency__c);
                caseAccIdMap.put(c.id,newSet);
            }
        }
        return caseAccIdMap;
    }
    /************************************************************************
Method Name  : createAccConMap
Description  : Method to be construct map with Account Id & related Contact Ids
**************************************************************************/
    public static Map<id,Set<id>> createAccConMap(Map<Id,Set<Id>> caseAccIdMap){
        List<Contact> contList = New List<Contact>();
        Set<id>accIds = New Set<id>();
        for(Set<Id> s : caseAccIdMap.values()){
            accIds.addAll(s);    
        }
        contList = [Select id,accountId from Contact where AccountId in : accIds and AccountId != NULL]; 
        Map<Id,Set<Id>> accConMap = New Map<Id,Set<Id>>();
        for(contact c : contList){
            if(!accConMap.containsKey(c.accountId)){
                Set<id> newSet = New set<Id>();
                newSet.add(c.id);
                accConMap.put(c.accountId,newSet);
            }
            else{
                Set<id> newSet = New set<Id>();
                newset = accConMap.get(c.accountId);
                newSet.add(c.id);
                accConMap.put(c.accountId,newSet);
            }
        }
        return accConMap;
    }
    /************************************************************************
Method Name  : fetchPartnerUserFoeDelegateContacts
Description  : Method to be construct map with case Id & delegated partner User Id
**************************************************************************/
    public static Map<Id,Id> fetchPartnerUserForDelegateContacts(List<Case> caseList){
        Map<id,id> caseConUserMap = New Map<id,id>();
        Map<id,id> conUserIDMap = New Map<id,id>();
        Map<id,id> caseConMap = New Map<id,id>();
        for(case c : caseList){
            if(c.Delegate_Contact_of_Broker_or_Agency__c != NULL){
                caseConMap.put(c.id,c.Delegate_Contact_of_Broker_or_Agency__c);
            }
        }
        
        Map<Id,User> userMap = New Map<Id,User>([select id,ContactId from user where ContactId in: caseConMap.values()]);
        for(user u : userMap.Values()){
            if(u.contactId != null)
                conUserIDMap.put(u.contactId,u.id);
        }
        system.debug('===>'+conUserIDMap);
        for(case c : caseList){
            if(conUserIDMap.get(caseConMap.get(c.id)) != NULL){
                caseConUserMap.put(c.id,conUserIDMap.get(caseConMap.get(c.id)));  
            }
        }
        return caseConUserMap;
    }
    /************************************************************************
Method Name  : fetchPartnerUserIDs
Description  : Method to be construct map with Contact Id & related partner User Id
**************************************************************************/
    public static Map<Id,Id> fetchPartnerUserIDs(Map<Id,Set<Id>> accConMap){
        Map<id,id> conUserMap = New Map<id,id>();
        Set<Id> conIds = New Set<Id>();
        for(id accId: accConMap.keySet()){
            conIds.addAll(accConMap.get(accId));
        }
        Map<Id,User> userMap = New Map<Id,User>([select id,ContactId from user where ContactId in: conIds]);
        for(user u : userMap.Values()){
            conUserMap.put(u.contactId,u.id);
        }
        return conUserMap;
    }
    /************************************************************************
Method Name  : createCaseUserMap
Description  : Method to be construct map with Case Id & related partner User Ids
**************************************************************************/
    public static Map<id,Set<id>> createCaseUserMap(Map<Id,Set<Id>> caseAccIdMap, Map<Id,Set<Id>> accConMap, Map<id,id> conUserMap){
        Map<id,Set<id>> caseUserMap = New Map<id,Set<id>>();
        for(id caseId : caseAccIdMap.keySet()){
            Set<id> accIds = New Set<id>();
            accIds = caseAccIdMap.get(caseId);
             Set<id> partUserIdSet = New Set<Id>();
            for(id accId : accIds){
               Set<Id> conIds = new Set<Id>();
                if(!accConMap.isEmpty() && accConMap.containsKey(accId)){
                    conIds=accConMap.get(accId);
                }              
                if(!conIds.isEmpty()){
                    for(id conId : conIds){
                    partUserIdSet.add(conUserMap.get(conId));    
                 }
                }
                
                caseUserMap.put(caseId,partUserIdSet);
            }
        }
        return caseUserMap;
    }
    /************************************************************************
Method Name  : retriveExistingCaseTeam
Description  : Method to retrieve existing case team with role SGA Broker and delete
**************************************************************************/
    public static void retriveExistingCaseTeam(List<Case> caseList){
        List<CaseTeamMember> caseTeamMemberList = new List<CaseTeamMember>();
        Set<id> caseIds = New Set<Id>();
        Map<Id,Set<Id>> caseTeamMap = New Map<id,Set<id>>();
        for(case c : caseList){
            caseIds.add(c.Id);    
        }
        caseTeamMemberList = [SELECT TeamRoleId, ParentId, MemberId, Id From CaseTeamMember where parentId in : caseIds and TeamRoleId =: caseTeamRoleId];
        Database.delete(caseTeamMemberList);
    }
    /************************************************************************
Method Name  : retriveExistingCaseTeam
Description  : Method to create new set to case team members
**************************************************************************/
    public static void createCaseTeamMember(Map<id,Set<id>> caseUserMap, Map<id,id> caseConUserMap,List<Case> caseList){
        system.debug('==>caseUseMap'+caseUserMap);
        List<CaseTeamMember> cstList= New List<CaseTeamMember>();
        for(case c : caseList){
            id caseId = c.id;
            Set<id> userIds = New Set<id>();
            userIds = caseUserMap.get(caseId);
            id conuserId = caseConUserMap.get(caseId);
            if(conUserId != NULL){
                CaseTeamMember cstCon = New CaseTeamMember(TeamRoleId = caseTeamRoleId,ParentId= caseId,MemberId = conuserId);
                cstList.add(cstCon);
            }    
            if(userIds != NULL){
                for(id userId : userIds){
                    if(userId != NULL && userId != conuserId){
                        CaseTeamMember cst = New CaseTeamMember(TeamRoleId = caseTeamRoleId,ParentId= caseId,MemberId = userId);
                        cstList.add(cst);
                    }
                }
            }
        }
        system.debug('====>cstList'+cstList);
        if(!cstList.isEmpty()){
            try{
                Database.insert(cstList);
            }
            Catch(Exception ex){
                UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,CLASSNAME, CLASSNAME, SG01_Constants.BLANK, Logginglevel.ERROR);        
            }
        }
    }
}