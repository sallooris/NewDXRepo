/*************************************************************
Class Name     : AP21_PopulateDueDate
Date Created   : 22-Sept-2015
Created By     : Amanjot
Description    : This class is used to populate Due Date Value
Used in Trigger: TaskBeforeInsert/TaskBeforeUpdate
Audit History  :
Description    : 
*****************************************************************/
public with sharing class AP21_PopulateDueDate{

  public static boolean isBeforeInsertFirstRun = true;
    public static boolean isBeforeUpdateFirstRun = true;
    
     /*
         Method Name : copyDueDate
         Param1      : List of Tasks
         return type : void
         Description : 
                         
     */
     public void copyDueDate(List<TasK> taskList){
        id scheduleFollowuprecordtypeId =[select Id,Name from Recordtype where Name = 'Schedule Followup' and SobjectType = 'Task'].Id;
        id InboundOutboundrecordtypeId=[select Id,Name from Recordtype where Name = 'Inbound/Outbound Call Activity' and SobjectType='Task'].Id;
        id SendcommunicationrecordtypeId=[select Id,Name from Recordtype where Name='Send Fulfillment' and SobjectType = 'Task'].Id; 
        /*Set<Id> Idset=new Set<Id>();
        for(Task tid:taskList)
         {
           Idset.add(tid.Id); 
           system.debug('collected the ID'+ idset);
           }*/
      System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>' + taskList);
          for(Task t: taskList)
             {
             system.debug('****'+ t);
                if(t.recordTypeId == scheduleFollowuprecordtypeId)
                   {
                       t.ActivityDate=Date.ValueOf(t.Due_Date_Time__c);
                       System.debug('>>>>>>>>>>>>>>>>>>>>>>>>.' + t.ActivityDate);
                    }
                     if(t.recordTypeId == InboundOutboundrecordtypeId)
                     {
                       t.ActivityDate=Date.ValueOf(t.Date_Time_of_Call__c);
                       System.debug('2nd>>>>>>>>>>>>>>>>>>>>>>>>.' + t.ActivityDate);
                     
                     }
                     if(t.recordTypeId ==SendcommunicationrecordtypeId)
                     {
                      t.ActivityDate=Date.ValueOf(t.Desired_Effective_Date__c);
                       System.debug('3rd>>>>>>>>>>>>>>>>>>>>>>>>.' + t.ActivityDate);
                       
                     }
                     
             }
         
   
        }
    }