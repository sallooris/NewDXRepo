/*****************************************************************************************
* Class Name   : SGA_SCAP02_CloseOppByEffectiveDate
* Created Date : 09/13/2017 (mm/dd/yyyy)
* Created By   : IDC Offshore
* Description  :  Schedulable class to execute the SGA_BAP02_CloseOppByEffectiveDate 
*****************************************************************************************/
global class SGA_SCAP02_CloseOppByEffectiveDate implements Schedulable {

private static Final String CLS_SGA_SCAP02 = 'SGA_SCAP02_CloseOppByEffectiveDate';

/****************************************************************************************************
Method Name : execute
Parameters  : SchedulableContext sc
Description : 1. Method to fetch the batchSize from SG22_BATCH_200
2. Executes the SGA_BAP02_CloseOppByEffectiveDate Batch Class as per the Scheduled Job
******************************************************************************************************/ 
global void execute(SchedulableContext sc) {
       try{
            // fetch the batch size from SG22_BATCH_200
          Integer batchSize=Integer.valueof(Label.SG22_BATCH_200);
          Integer cutOffDays=Integer.valueof(Label.SG74_DAYS_30);
         //execute batch calss
         if( batchSize > 0) {
             SGA_BAP02_CloseOppByEffectiveDate bt = new SGA_BAP02_CloseOppByEffectiveDate(cutOffDays);
             database.executebatch(bt,batchSize);
             }
       }Catch(Exception ex){UTIL_LoggingService.logHandledException(ex,SG01_Constants.ORGID,SG01_Constants.APPLICATIONNAME,CLS_SGA_SCAP02, SG01_Constants.CLS_SGA_SCAP01_EXECUTE, SG01_Constants.BLANK, Logginglevel.ERROR);}      
   }
}