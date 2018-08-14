/*****************************************************************************************
Class Name :   DocumentCheckListTriggerHandler
Date Created : 15-June-2017
Created By   : IDC Offshore
Description  : 1. This is the trigger handler class for DocumentCheckList object
Change History :   
******************************************************************************************/
public without sharing class DocumentCheckListTriggerHandler {
    /****************************************************************************************************
    Method Name : afterInsert
    Parameters  : Set<ID> documentCheckListIds
    Return type : void
    Description : This method is used to upload proposal document details
    ******************************************************************************************************/
    public static void afterInsert(Set<ID> documentCheckListIds){
        SGA_AP13_UploadProposalDocument uploadPropDocObj = new SGA_AP13_UploadProposalDocument();
        uploadPropDocObj.uploadProposalDocumentDetails(documentCheckListIds);
    }
    /********************************************************************************************************
    Method Name : afterUpdate
    Parameters  : Map<ID,Application_Document_Checklist__c> newMap,Map<ID,Application_Document_Checklist__c> 
                                                                    oldMap
    Return type : void
    Description : This method is used to update reupload date time on case when the document is reuploaded
                  on Document Checklist record.
    **********************************************************************************************************/
    public static void afterUpdate(Map<ID,Application_Document_Checklist__c> newMap,Map<ID,Application_Document_Checklist__c> oldMap){
        String profileName = [Select Name from Profile where Id =:UserInfo.getProfileId() LIMIT 1].Name;
        if(System.Label.SG51_SGBrokerProfileName.equalsIgnoreCase(profileName)){
            SGA_AP27_UpdateReuploadDateTimeOnCase updateReUploadObj = new SGA_AP27_UpdateReuploadDateTimeOnCase();
            updateReUploadObj.updateReuploadTimeStamp(newMap,oldMap);
        }
    }
}