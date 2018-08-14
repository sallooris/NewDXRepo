/*
* Class Name   : SGA_SCAP01_ExpireAppByEffectiveDate
* Created Date : 07/06/2017
* Created By   : IDC Offshore
* Description  :  Schedulable class to execute the SGA_BAP01_ExpireAppByEffectiveDate 
**/

global class SGA_SCAP01_ExpireAppByEffectiveDate implements Schedulable {
/****************************************************************************************************
Method Name : execute
Parameters  : SchedulableContext sc
Description : 1. Method to fetch the batchSize from SG22_BATCH_200
2. Executes the SGA_BAP01_ExpireAppByEffectiveDate Batch Class as per the Scheduled Job
******************************************************************************************************/ 
   global void execute(SchedulableContext sc) {
       try{
            // fetch the batch size from SG22_BATCH_200
          Integer batchSize=Integer.valueof(Label.SG22_BATCH_200);
         //execute batch calss
         if( batchSize > 0) {
             SGA_BAP01_ExpireAppByEffectiveDate bt = new SGA_BAP01_ExpireAppByEffectiveDate();
             database.executebatch(bt,batchSize);
             }
       }Catch(Exception ex){UTIL_LoggingService.logHandledException(ex,SG01_Constants.ORGID,SG01_Constants.APPLICATIONNAME,SG01_Constants.CLS_SGA_SCAP01_ExpireAppByEffectiveDate, SG01_Constants.CLS_SGA_SCAP01_EXECUTE, SG01_Constants.BLANK, Logginglevel.ERROR);}
       
   }
}