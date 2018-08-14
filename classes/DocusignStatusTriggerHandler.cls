/*****************************************************************************************
Class Name :   DocusignStatusTriggerHandler
Date Created : 22-June-2017
Created By   : IDC Offshore
Description  : 1. This class is called from DocuSignStatusAfterUpdate trigger to update 
				the document checklist details
Change History : 
*******************************************************************************************/
public class DocusignStatusTriggerHandler {
    /***************************************************************************************************
     * Method Name : onAfterUpdate
     * Parameters  : NewMap, OldMap
     * return type : void
     * Description : This method is a handler method which calls the updateDCList method to document 
     * 				 check list records whenever docusign status record is updated
     ***************************************************************************************************/
    public static void onAfterUpdate(Map<ID,dsfs__DocuSign_Status__c> newMap,Map<ID,dsfs__DocuSign_Status__c> oldMap){
        SGA_AP17_UpdateDocCheckListDSStatus.updateDCList(newMap.keySet());
    }
}