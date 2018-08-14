/*******************************************************************
 * Class Name  : CaseTriggerHandler
 * Created By  : IDC Offshore
 * Created Date: 8/9/2017
 * Description : This is the trigger handler class for Case Object
 *******************************************************************/
public class CaseTriggerHandler {
    /******************************************************************************************
     * Method Name  : onAfterInsert
     * Created By   : IDC Offshore
     * Created Date : 8/9/2017
     * Description  : This is used for calling the business logic classes onAfterInsert trigger
     *******************************************************************************************/
    public static void onAfterInsert(Map<ID,Case> newCaseMap){
        //To to create/update stage / status / owner in line item records
        SGA_AP25_UpdateStageStatusOwner updateStageObj = new SGA_AP25_UpdateStageStatusOwner();
        updateStageObj.createStatusStageLineItems(newCaseMap);
        
        /*if(SGA_AP30_CreateTaskToConnetTeam.RUN_Evt_RecCheck)
        {
            //create task for connect team on status of Scrub Completed
            SGA_AP30_CreateTaskToConnetTeam createTaskObj = new SGA_AP30_CreateTaskToConnetTeam();
            createTaskObj.createTaskforConnectTeam(newCaseMap, NULL);
        }*/
        // call method to update Tech fields for Case stage on Account
        SGA_AP32_UpdateCaseStageTechFieldsOnAcc.updateNewCaseStageTechFields(newCaseMap);
        // call method to apply Case Team Association for Multiple Brokers
        SGA_AP39_CaseTeamAssocation.onInsertProcessCaseTeam(newCaseMap);
    }
    
    /******************************************************************************************
     * Method Name  : onAfterUpdate
     * Created By   : IDC Offshore
     * Created Date : 8/9/2017
     * Description  : This is used for calling the business logic classes onAfterUpdate trigger
     *******************************************************************************************/
    public static void onAfterUpdate(Map<ID, Case> newCaseMap, Map<ID, Case> oldCaseMap){
        system.debug('------------- Inside Case Handler method ------------');
        //if(SGA_AP25_UpdateStageStatusOwner.isAfterUpdate){
            //To to create/update stage / status / owner in line item records
            SGA_AP25_UpdateStageStatusOwner updateStageObj = new SGA_AP25_UpdateStageStatusOwner();
            updateStageObj.updateStatusStageLineItems(newCaseMap,oldCaseMap);
        //    SGA_AP25_UpdateStageStatusOwner.isAfterUpdate = false;
        //}
        
        
        /*if(SGA_AP30_CreateTaskToConnetTeam.RUN_Evt_RecCheck)
        {
            //create task for connect team on status of Scrub Completed
            SGA_AP30_CreateTaskToConnetTeam createTaskObj = new SGA_AP30_CreateTaskToConnetTeam();
            createTaskObj.createTaskforConnectTeam(newCaseMap, oldCaseMap);
        }*/
        // call method to update Application Status Based on Case Stage
       SGA_AP19_UpdateAppStatus.updateAppStatusForStage(newCaseMap.values(),oldCaseMap);
         // call method to apply Case Team Association for Multiple Brokers
       //SGA_AP31_CaseAssociation.associateCaseToBrokerOrAgency(newCaseMap.values(),oldCaseMap);
       SGA_AP39_CaseTeamAssocation.onUpdateProcessCaseTeam(oldCaseMap,newCaseMap);
        // call method to update Tech fields for Case stage on Account
       SGA_AP32_UpdateCaseStageTechFieldsOnAcc.updateCaseStageTechFields(newCaseMap,oldCaseMap);
        //call method to Create Event when Case Stage is GroupReturned on Case
        SGA_AP35_CreateEventonGroupReturned createEventObj = new SGA_AP35_CreateEventonGroupReturned();
        createEventObj.createEventOnGrpReturned(newCaseMap,oldCaseMap);
        
        //Call true blue class to send an email to true blue team
        SGA_AP38_SendEmailToTrueBlue sendTrueBlueObj = new SGA_AP38_SendEmailToTrueBlue();
        sendTrueBlueObj.fetchTrueBlueCases(newCaseMap,oldCaseMap);
        
    }
    /******************************************************************************************
     * Method Name  : onBeforeUpdate
     * Created By   : IDC Offshore
     * Created Date : 8/23/2017
     * Description  : This is used for turning on/off the automated emails based on state
     *******************************************************************************************/
    public static void onBeforeUpdate(Map<ID, Case> newCaseMap, Map<ID, Case> oldCaseMap){
        /*if(SGA_AP40_UpdateCaseTechFields.SGA_AP40_UpdateCaseTechFields_Flag){
            SGA_AP40_UpdateCaseTechFields.getEmailTurnOnValues(newCaseMap.values());
            SGA_AP40_UpdateCaseTechFields.SGA_AP40_UpdateCaseTechFields_Flag = false;
        }*/
    }
    
    /******************************************************************************************
     * Method Name  : onBeforeInsert
     * Created By   : IDC Offshore
     * Created Date : 8/23/2017
     * Description  : This is used for turning on/off the automated emails based on state
     *******************************************************************************************/
    public static void onBeforeInsert(List<Case> newList){
        /*if(SGA_AP40_UpdateCaseTechFields.SGA_AP40_InsertCaseTechFields_Flag){
            SGA_AP40_UpdateCaseTechFields.getEmailTurnOnValues(newList);
            SGA_AP40_UpdateCaseTechFields.SGA_AP40_InsertCaseTechFields_Flag = false;
        }*/
    }
    // The method can be used in future to Turn on or off the email based on the state. 
    
}