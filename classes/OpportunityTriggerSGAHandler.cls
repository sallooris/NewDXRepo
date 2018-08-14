/*******************************************************************
 * Class Name  : OpportunityTriggerSGAHandler
 * Created By  : IDC Offshore
 * Created Date: 12/10/2017
 * Description : This is the trigger handler class for Opportunity Object
 *******************************************************************/
public without sharing class OpportunityTriggerSGAHandler {
    /******************************************************************************************
    * Method Name  : doBeforInsert
    * Created By   : IDC Offshore
    * Created Date : 12/10/2017
    * Description  : This is used for calling the business logic classes doBeforInsert trigger
    *******************************************************************************************/
    
    public static void doBeforInsert(List<Opportunity> oppList)
    {
        SGA_AP52_RenewOppEndate.updateEndate(oppList);
    }
    
    /******************************************************************************************
    * Method Name  : doAfterInsert
    * Created By   : IDC Offshore
    * Created Date : 12/10/2017
    * Description  : This is used for calling the business logic classes doAfterInsert trigger
    *******************************************************************************************/
    public static void doAfterInsert(Map<Id, Opportunity> newMap) {
        //call method to Create create Opportunity Teams from Account teams.
        SGA_AP46_UpdateOppTeamWithAccTeam.updateOppTeamWithAccTeam(newMap);
    }
}