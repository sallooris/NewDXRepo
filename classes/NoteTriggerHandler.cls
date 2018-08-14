/*******************************************************************
 * Class Name  : NoteTriggerHandler
 * Created By  : IDC Offshore
 * Created Date: 09/15/2017 (mm/dd/yyyy)
 * Description : This is the trigger handler class for Case Object
 *******************************************************************/
public without sharing class NoteTriggerHandler {
    private Static Final String EDIT_OPERATION='Edit';
    private Static Final String DEL_OPERATION='Delete';
    /******************************************************************************************
     * Method Name  : onBeforeDelete
     * Parameters  : Map<id, Note> oldNoteMap
     * Return type : Void
     * Description  : This is used for calling the business logic classes onBeforeDelete trigger
     *******************************************************************************************/
    public static void onBeforeDelete(Map<ID,Note> oldNoteMap){
        // method call to prevent Note Deletion Operatation for Opportunity Type:SGQUOTING
        SGA_AP43_PreventNotesOnOpp.blockNoteModification(oldNoteMap,DEL_OPERATION);
    }
    
  
    /******************************************************************************************
     * Method Name  : onBeforeUpdate
     * Parameters  : Map<id, Note> newNoteMap
     * Return type : Void
     * Description  : This is used for calling the business logic classes onBeforeUpdate trigger *******************************************************************************************/
    public static void onBeforeUpdate(Map<ID, Note> newNoteMap){
        // method call to prevent Note Updation Operatation for Opportunity Type:SGQUOTING
         SGA_AP43_PreventNotesOnOpp.blockNoteModification(newNoteMap,EDIT_OPERATION);
    }
    
    
}