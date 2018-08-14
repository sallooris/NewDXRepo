/*************************************************************************
Class Name   : TaskAfterInsert_Test
Date Created : 03-June-2015
Created By   : Bhaskar
Description  : This class is test class for AP04_LeadStageReasonUpdate class
****************************************************************************/
/*    Test Class : - TaskAfterInsert Trigger */
@isTest
public with sharing class TaskAfterInsert_Test{
 /*
 Method Name : testStageReasonUpdation
 Param 1 : 
 Return type : void
 Description : Test Method for TaskAfterInsert_Test Class 
  */   
  private static testMethod void testStageReasonUpdation()
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
              Database.insert(ldObj);
                 for(Task tk : testTasks){
                        tk.whoId= ldObj.id;
                        tk.activity_type__c ='Outbound Call';
                        tk.recordTypeId = taskRT;
                        tk.status = 'Not Reachable';
                  }
             try{
                  Database.Insert(testTasks);
             }catch(Exception e){}
          test.stopTest();               
             
    }
} 
 private static testMethod void testMarektingIdPopulationOnLead()
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
    List<Task> testTasks=Util02_TestData.createOutboundTasks();
    Campaign c = new Campaign();
    ID campaignRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'Campaign'].Id;
    c.recordtypeId = campaignRT ;
    System.runAs(tstUser)
      {
          test.startTest();
          Database.insert(pCode); 
          pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id]; 
          id taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Inbound/Outbound Call Activity' AND SobjectType ='Task' LIMIT 1].Id;     
          ldObj.zip_code__c = pCode.Id;
          c.name = '1001';
          c.description = 'Test Marketing Campaign';
          c.isActive = true;
          Database.insert(c);
          Database.insert(ldObj);
          for(Task tk : testTasks){
                    tk.whoId= ldObj.id;
                    tk.activity_type__c ='Outbound Call';
                    tk.status = 'Not Reachable';
                    tk.recordtypeid = taskRecordTypeId ;
                    tk.Marketing_Id__c = c.name;
          }
          try{
              Database.Insert(testTasks);
           }catch(Exception e){}
              test.stopTest();                
            }
   }
private static testMethod void testMarektingIdPopulationOnAccount()
{  
    List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
    insert cs001List; 
    List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
    insert cs002List; 
    User tstUser = Util02_TestData.insertUser(); 
    Account acc=Util02_TestData.insertAccount();     
    ID accRT =[select Id,Name from Recordtype where Name = 'Person Account' and SobjectType = 'Account'].Id;
    acc.recordtypeId = accRT ; 
    List<Task> testTasks=Util02_TestData.createOutboundTasks();
    Campaign c = new Campaign();
    ID campaignRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'Campaign'].Id;
    c.recordtypeId = campaignRT ;
    System.runAs(tstUser)
    {
          test.startTest(); 
              id taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Inbound/Outbound Call Activity' AND SobjectType ='Task' LIMIT 1].Id;     
              c.name = '1001';
              c.description = 'Test Marketing Campaign';
              c.isActive = true;
              Database.insert(c);
              Database.insert(acc);
              for(Task tk : testTasks){
                        tk.whatId= acc.id;
                        tk.activity_type__c ='Outbound Call';
                        tk.status = 'Not Reachable';
                        tk.recordtypeid = taskRecordTypeId ;
                        tk.Marketing_Id__c = c.name;
              }
              try{
                  Database.Insert(testTasks);
               }catch(Exception e){}
          test.stopTest();                
    }
}
}