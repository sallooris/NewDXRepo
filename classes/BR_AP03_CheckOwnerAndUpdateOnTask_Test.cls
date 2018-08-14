/*************************************************************
Trigger Name : BR_AP03_CheckOwnerAndUpdateOnTask_Test
Date Created : 25-Aug-2015
Created By   : Nagarjuna Kaipu
Description  : Test class for BR_AP02_UpdateCompletedDateOnTask class, TaskBeforeInsert and TaskBeforeUpdate triggers
Change History: 
*****************************************************************/
@isTest
private class BR_AP03_CheckOwnerAndUpdateOnTask_Test {

    static testMethod void CreateEmailToCase() {
        List<CS001_RecordTypeBusinessTrack__c> cs001List = BR_Util01_TestMethods.createBusinessTrack();
        insert cs001List; 
        User testUser=BR_Util01_TestMethods.CreateTestUser();
        insert(testUser);
        Task t= BR_Util01_TestMethods.CreateTask();
        t.Subject = 'Email: ref:';
        t.Status='New';
        Task t1= BR_Util01_TestMethods.CreateTask();
        t1.subject = 'nagasubject';
        t1.Status = 'New';
        
        System.runAs(testUser){
            Test.startTest();  
            try
            {
                insert t;
                insert t1;
                t1.Status = 'Completed';
                update t1;
            }
            catch(Exception ex){
                  System.debug('Exception in Test Class'+ex.getMessage());
              }
            Test.stopTest(); 
        }
        
        Task tt = [SELECT BR_Completed_Date__c FROM TASK WHERE ID =: t.Id];
        System.AssertEquals(System.today(), tt.BR_Completed_Date__c);           
    }
}