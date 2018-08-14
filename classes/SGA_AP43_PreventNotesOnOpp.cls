/***********************************************************************
Class Name   : SGA_AP43_PreventNotesOnOpp
Date Created : 09/11/2017 (MM/DD/YYYY)
Created By   : IDC Offshore
Description  : 1. This is a Handler Class for SGA_AP20_PreventNotesOnOpp
**************************************************************************/
public without sharing class SGA_AP43_PreventNotesOnOpp {
  private static Final String OPP_START_DIGIT='006';
  private static Map<Id,Id> noteOppMap = NULL;
  private static set<Id> opIds = NULL;
  private static Final String BLOCKING_MSG='You do not have privilege to';
  private static Final String NOTE_OBJ='Note';
  public static final string OPP_SELECT_QUERY = 'Select Id,Tech_Businesstrack__c from Opportunity';
  public static final string OPP_QUERY_WHERE = SG01_Constants.SPACE+'where ID IN:oppIdSet';
/****************************************************************************************************
    Method Name : blockNoteModification
    Parameters  : Map<id, Note>,String 
    Return type : Void
    Description :  Check if notes are associted with Opportunity and Edit/Delete Operation is being done on Notes
                  
******************************************************************************************************/
public static void blockNoteModification(Map<id, Note> noteMap,String operation) { 
    noteOppMap = new Map<Id,Id>();
    opIds = new set<Id>();
    Map<Id,Opportunity> opMap= new Map<Id,Opportunity>();
    if(!noteMap.isEmpty()){
            for(Note nt:noteMap.values()){
                String noteParentId=nt.parentId;
                if(noteParentId.startsWith(OPP_START_DIGIT)){
                    opIds.add(nt.parentId);
                    noteOppMap.put(nt.Id,nt.parentId);        
                 }
                             
     }  
    if(!opIds.isEmpty()){
        opMap=fetchOpportunity(opIds);
    }   
   if(!opMap.isEmpty() && !noteOppMap.isEmpty()){
       // perform final validation and Show Error Message
      performValidation(opMap,noteMap,operation);
    }
   }   
 }
 
/***************************************************************
    Method Name : performValidation
    Parameters  : void 
    Return type : Map<Id,Opportunity>
    Description : performs the validation and Show Error Message
*******************************************************************/
private static void performValidation(Map<Id,Opportunity> opMapToValidate,Map<id, Note> noteMapToCheck,String operation){
    for(Id tmp:noteOppMap.keySet()){
    Id currParent=noteOppMap.get(tmp);
     if(opMapToValidate.ContainsKey(currParent)){ 
        String currBusssinessTrack = opMapToValidate.get(currParent).Tech_Businesstrack__c;
        if(!String.isBlank(currBusssinessTrack) && !noteMapToCheck.isEmpty()){
           if( System.Label.SG_BusinessTrack.equalsIgnoreCase(currBusssinessTrack)){
             Note currNote= noteMapToCheck.get(tmp);
              currNote.addError(BLOCKING_MSG+SG01_Constants.SPACE+operation+SG01_Constants.SPACE+NOTE_OBJ ); 
           }
        }
     }
    }   
    
}
/**************************************************************************
    Method Name : fetchOpportunity
    Parameters  : Set<Id> opId 
    Return type : Map<Id,Opportunity>
    Description : Fetches the Opportunity records based on Tech_Businesstrack__c : SGQUOTING and Notes related ParentID
*******************************************************************************/
  private static Map<Id,Opportunity> fetchOpportunity(Set<Id> opId){
    Map<Id,Opportunity> oppMap= new Map<Id,Opportunity>();
      SGA_Util07_OpportunityDataAccessHelper.oppIdSet=opId;
      oppMap=SGA_Util07_OpportunityDataAccessHelper.fetchOpportunityMap(OPP_SELECT_QUERY,OPP_QUERY_WHERE,SG01_Constants.BLANK,SG01_Constants.BLANK);
    return oppMap;
    
  }
}