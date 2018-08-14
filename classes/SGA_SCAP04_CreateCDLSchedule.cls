/*****************************************************************************************
* Class Name   : SGA_SCAP04_CreateCDLSchedule
* Created Date : 10/27/2017
* Created By   : IDC Offshore
* Description  : Schedulable class to execute the SGA_BAP04_CreateContentDocLink
*******************************************************************************************/
global class SGA_SCAP04_CreateCDLSchedule implements Schedulable {
    /****************************************************************************************************
    Method Name : execute
    Parameters  : SchedulableContext sc
    Description : 1. Method to fetch the batchSize from SG22_BATCH_200
    2. Executes the SGA_BAP04_CreateContentDocLink Batch Class as per the Scheduled Job
    ******************************************************************************************************/ 
    global void execute(SchedulableContext sc) 
    {
        SGA_BAP04_CreateContentDocLink docLinkObj = new SGA_BAP04_CreateContentDocLink();
        Database.ExecuteBatch(docLinkObj, 200);
    }
}