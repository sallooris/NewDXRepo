/****************************************************************************
Class Name  :  AP05_ActivityTimeInteraction_Test
Date Created:  27-May-2015
Created By  :  Shivakanth/Santosh
Description :  Test Class for task after insert trigger. Task after insert trigger populates the Task duedate in account/lead.
Change History :   
****************************************************************************/

@isTest
public class  AP05_ActivityTimeInteraction_Test
{
/**Method Name : testPopulateCreatedDate 
Param 1 :  Task
Return type : void 
Description : Test Method for Class  AP05_TimeSinceLastActivity class Respective to Account **/
private static testMethod void testPopulateAccountAcitivty()  
{  
    //creating a account.
    Account acc=Util02_TestData.insertAccount(); 
    List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
    insert cs001List; 
    List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
    insert cs002List;
    ID accRT =[select Id,Name from Recordtype where Name = 'Person Account' and SobjectType = 'Account'].Id;
    acc.recordtypeId = accRT ; 
    acc.mobile_Phone__c='12345';      
    Database.Insert(acc);
    //User tstUser = Util02_TestData.insertUser(); 
    List<Task> tsk1 = new List<Task>();
    //creating a Task with 'Activity_Type__c='Inbound Call'  and assigning to Account acc.
    ID taskRT =[select Id,Name from Recordtype where Name = 'Schedule Followup' and SobjectType = 'Task'].Id;
    Task t1 = new Task(WhatId = acc.Id,ActivityDate = date.today(),Status = 'Complete',Activity_Type__c='Inbound Call' ); 
    t1.recordTypeId=taskRT;
    tsk1.add(t1);
    try{
    Database.insert (tsk1);
    }catch(Exception e){}
    acc.Tech_Task_time__c = t1.ActivityDate;
    Database.update (acc);
    //creating a account.
    Account acc1=Util02_TestData.insertAccount();
    acc1.recordTypeId = accRT;
    Database.Insert(acc1);
    List<Task> tsk2 = new List<Task>();
    Task t2 = new Task(WhatId = acc1.Id,ActivityDate = date.today(), 
    Status = 'Complete',Activity_Type__c='Outbound Call' ); 
    ID taskIBRT =[select Id,Name from Recordtype where Name = 'Inbound/Outbound Call Activity' and SobjectType = 'Task'].Id;
    t2.recordTypeId = taskIBRT;
    tsk2.add(t2);
    try{
        Database.insert(tsk2);
    }catch(Exception e){}        
    acc1.Tech_Task_time__c = t2.ActivityDate;
    Map <String,Schema.RecordTypeInfo> recordTypesadjustment = TASK.sObjectType.getDescribe().getRecordTypeInfosByName();
    Id RecTypeIdAcc = recordTypesadjustment.get('Schedule Followup').getRecordTypeId();
    Task tSchFollowup = new Task(WhatId = acc.Id,Status = 'In Progress',recordtypeid=RecTypeIdAcc);
    Database.Insert(tSchFollowup);
    Account acc03=Util02_TestData.insertAccount();
    acc03.recordTypeId = accRT;
    Database.Insert(acc03);
    Task tSchAgentInt = new Task(WhatId = acc03.Id,Status='In Progress',activitydate=System.Today()-7);
    tSchAgentInt.recordTypeId = taskRT;
    Database.Insert(tSchAgentInt);
}
private static testMethod void testPopulateLeadAcitivty()  
{
    Lead l= Util02_TestData.insertLead();
    Postal_Code_County__c zipscode=Util02_TestData.insertZipCode();
    Database.Insert(zipscode);
    l.Zip_Code__c=zipscode.id;
    l.mobile_phone__c='12345';
    List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
    insert cs001List; 
    List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
    insert cs002List;
    ID leadRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'Lead'].Id;
    l.recordtypeId = leadRT;
    Database.Insert(l);        
    List<Task> tskLeadList= Util02_TestData.createTasks();
    Task t3Inbound = new Task(whoid= l.Id,ActivityDate = date.today(),Status = 'Complete',Activity_Type__c='Inbound Call' );
    try{
    Database.Insert(t3Inbound); 
    }catch(Exception e){}
    l.Tech_Task_time__c = t3Inbound.ActivityDate;     
    try{   
        Database.update(l);
    }Catch(Exception e){
    }
    Lead l1= Util02_TestData.insertLead();
    Postal_Code_County__c zipscode1=Util02_TestData.insertZipCode();
    Database.Insert(zipscode1);
    l1.Zip_Code__c=zipscode1.id;
    l1.recordTypeId = leadRT;
    Database.Insert(l1);
    Map <String,Schema.RecordTypeInfo> recordTypesadjustment = TASK.sObjectType.getDescribe().getRecordTypeInfosByName();
    Id RecTypeId = recordTypesadjustment.get('Schedule Followup').getRecordTypeId();
    Task t4Inbound = new Task(whoid= l.Id,ActivityDate = date.today(),Status = 'Not Started');
    t4Inbound.recordtypeid=RecTypeId; 
    Database.Insert(t4Inbound);         
    Lead l2= Util02_TestData.insertLead();
    Postal_Code_County__c zipscode2=Util02_TestData.insertZipCode();
    Database.Insert(zipscode2);
    l2.Zip_Code__c=zipscode2.id;
    l2.recordTypeId = leadRT;
    Database.Insert(l2);
    Task tAgentInt = new Task(WhoId = l2.Id,Status='In Progress',activitydate=System.Today()-7);
    tAgentInt.recordtypeid = RecTypeId;
    Database.Insert(tAgentInt);
}
}