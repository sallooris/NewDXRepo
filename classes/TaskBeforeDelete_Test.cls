/*************************************************************
Trigger Name : TaskBeforeDelete_Test
Date Created : 23-Sep-2015
Created By   : Nagarjuna Kaipu
Description  : Test class for taskBeforeDelete trigger
Change History: 
*****************************************************************/
@isTest
private class TaskBeforeDelete_Test{

    static testMethod void CreateCompletedTask() {
        List<CS001_RecordTypeBusinessTrack__c> cs001List = BR_Util01_TestMethods.createBusinessTrack();
        insert cs001List;
        User testUser=BR_Util01_TestMethods.CreateTestUser();
        insert(testUser);
        
        Task t= BR_Util01_TestMethods.CreateTask();
        t.Subject = 'Nagarjuna completed task';
        t.Status='Completed';
        insert t;
        System.runAs(testUser){
            Test.startTest();  
            try
            {
                Delete [SELECT Id, Tech_Businesstrack__c FROM TASK where subject = 'Nagarjuna completed task'];
                //System.Debug('task is: '+td+ 'track is: '+td.Tech_Businesstrack__c);
                //Delete td;
            }
            catch(DmlException ex){
              System.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION, ex.getDmlType(0));
              System.assertEquals('You do not have privileges to delete task.', ex.getDmlMessage(0));
            }
            Test.stopTest(); 
        }
    }
}