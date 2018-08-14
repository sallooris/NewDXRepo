/*************************************************************************
Class Name   : TaskAfterDelete_Test
Date Created : 13-July-2015
Created By   : Santosh
Description  : This class is test class for TaskAfterDelete_Test class
****************************************************************************/
/*    Test Class : - TaskAfterDelete Trigger */
@isTest
public with sharing class TaskAfterDelete_Test{
/*
Method Name : deleteTaskMethod01
Param 1 : 
Return type : void
Description : Test Method for TaskAfterDelete_Test Class 
*/   
private static testMethod void deleteTaskMethod01()
{  
    List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
    insert cs001List; 
    List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
    insert cs002List;
    User tstUser = Util02_TestData.insertUser(); 
    Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
    Lead ldObj=Util02_TestData.insertLead();  
    ID leadRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'LEAD'].Id;
    ldObj.recordtypeId = leadRT ;     
    ID taskRT =[select Id,Name from Recordtype where Name = 'Inbound/Outbound Call Activity' and SobjectType = 'Task'].Id;   
    List<Task> testTasks=Util02_TestData.createOutboundTasks();
    System.runAs(tstUser)
    {
        test.startTest();
        Database.insert(pCode); 
        pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];      
        ldObj.zip_code__c = pCode.Id;
        ldObj.Mobile_Phone__c='12345678';
        Database.insert(ldObj);
        for(Task tk : testTasks){
        tk.whoId= ldObj.id;
        tk.activity_type__c ='Outbound Call';
        tk.recordTypeId = taskRT;
        tk.status = 'Not Reachable';
    }
    Database.Insert(testTasks);
    AP05_ActivityTimeInteraction.isNotstartedInprogressFirstRun=true;
    AP05_ActivityTimeInteraction.islastactivityFirstRun=true;
    AP05_ActivityTimeInteraction.isInteractedFirstRun=true;
    Database.delete(testTasks);
    test.stopTest();               
    }
} 
}