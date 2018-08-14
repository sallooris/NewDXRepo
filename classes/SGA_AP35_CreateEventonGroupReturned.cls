/**
@Description: Apex class to create Event when the case stage is Group Returned
@Name : SGA_AP35_CreateEventonGroupReturned 
@Date: 
@Author: IDC offshore Resource
*/ 
public class SGA_AP35_CreateEventonGroupReturned {
    public static final string SELECT_QUERY = 'SELECT Id,Case__c,Document_Name__c,Status__c,Reviewer_Notes__c FROM Application_Document_Checklist__c';
    public static final string WHERE_CLAUSE = ' where Case__c IN :caseIdSet and Status__c IN :statusSet';
    public static final string SLASH_DOCNAME = '\n Document Name : ';
    public static final string SLASH_REVIEWERSNOTES = '\n Reviewers Notes : ';
    public static final string DOC_NAME = 'Document Name : ';
    
    /**
@Description: Method to create Event when the case stage is Group Returned
@Name : createEventOnGrpReturned
@Param :    newCaseMap(Map of ID,Case), oldCaseMap (Map of ID,Case)
@Return : void
@throws Exception : NA
*/ 
    public void createEventOnGrpReturned(Map<ID,Case> newCaseMap, Map<ID, Case> oldCaseMap){
        Set<ID> caseIdSet = new Set<ID>();
        for(Case caseObj : newCaseMap.values()){
            if(caseObj.stage__c != oldCaseMap.get(caseObj.Id).Stage__c && System.Label.SG56_GroupReturned.equalsIgnoreCase(caseObj.stage__c)){
                System.debug('hhello');
                caseIdSet.add(caseObj.Id);
            }
        }
        Map<ID,String> caseIdDocNameMap = new Map<ID,String>();
        SGA_Util04_DCDataAccessHelper.caseIdSet = caseIdSet;
        SGA_Util04_DCDataAccessHelper.statusSet = (new Set<String>{System.Label.SG57_MissingInformation});
        Map<ID,Application_Document_Checklist__c> docCheckListMap = SGA_Util04_DCDataAccessHelper.fetchDocumentChecklistMap(SELECT_QUERY,
                                                                                                                            WHERE_CLAUSE,SG01_Constants.BLANK,SG01_Constants.BLANK);
        List<Application_Document_Checklist__c> docCheckList = (docCheckListMap != NULL && !docCheckListMap.isEmpty()) ? docCheckListMap.values() : NULL;
        if(docCheckList != NULL && !docCheckList.isEmpty()){
            for(Application_Document_Checklist__c docCheckObj : docCheckList){
                if(caseIdDocNameMap.containsKey(docCheckObj.case__c)){
                    String docNameReviewesNotes = caseIdDocNameMap.get(docCheckObj.case__c);
                    docNameReviewesNotes += SLASH_DOCNAME+docCheckObj.document_name__c+SLASH_REVIEWERSNOTES+docCheckObj.Reviewer_Notes__c;
                    caseIdDocNameMap.put(docCheckObj.case__c, docNameReviewesNotes);
                }else{
                    caseIdDocNameMap.put(docCheckObj.case__c,DOC_NAME+docCheckObj.document_name__c+SLASH_REVIEWERSNOTES+docCheckObj.Reviewer_Notes__c);
                }
            }
        }
        List<Event> newEventList = new List<Event>();
        
        for(ID caseId : caseIdSet){
            Event eventObj = new Event();
            eventObj.WhatId = caseId;
            eventObj.Subject = System.Label.SG58_EventSubject;
            eventObj.StartDateTime = system.now()+1;
            eventObj.EndDateTime = system.now()+2;
            eventObj.description = caseIdDocNameMap.containsKey(caseId)  ? caseIdDocNameMap.get(caseId) : SG01_Constants.BLANK;
            eventObj.ReminderDateTime = eventObj.StartDateTime.addMinutes(-15);
            eventObj.IsReminderSet = TRUE;
            newEventList.add(eventObj);
        }
        if(!newEventList.isEmpty()){
            Database.Insert(newEventList);
        }
    }
}