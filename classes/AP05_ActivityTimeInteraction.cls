/*************************************************************
Class Name : AP05_ActivityTimeInteraction 
Created    : 10-June-2015
Created By : Santosh/Shivakanth
Description: This class is used to Populate Task Activitydate on Account and Lead. 
*****************************************************************/
Public with sharing Class AP05_ActivityTimeInteraction { 
public static boolean islastactivityFirstRun = true;
public static boolean isInteractedFirstRun = true;
public static boolean isNotstartedInprogressFirstRun = true;
public List<Account> accGlobalList= new List<Account>();
public List<Lead> leadGlobalList=new List<Lead>();
public Set<ID> accglobalIDs=new Set<ID>();
public Set<ID> leadglobalIDs=new Set<ID>();
public Set<ID> taskGlobalIDS=new Set<ID>();
List<Account> accGlobalResults=new List<Account>();
List<Lead> leadGlobalResults=new List<Lead>();
public AP05_ActivityTimeInteraction(List<Task> TaskList){
    for(Task t:tasklist){
        if(t.whatID!=null){
            if(String.ValueOf(t.whatID).startsWith('001')){        
                accglobalIDs.add(t.whatID);   
            }
        }
        if(t.whoId!=null){
            If(String.ValueOf(t.whoId).startsWith('00Q')){                         
                leadglobalIDs.add(t.whoID);
            }
        }
    }
    if(!accglobalIDs.isEmpty()){           
        accGlobalList = [SELECT id,Tech_Task_time__c,In_Progress_Not_Started_Activity__c,
        lastactivitydate,Tech_AccTask_Untouched__c,
        (SELECT whatid,whoid,status,ActivityDate,Activity_Type__c,recordtypeId,recordtype.Name FROM Tasks 
        )FROM Account Where Id IN:accglobalIDs AND Tech_Businesstrack__c='TELESALES'];
    }
    if(!leadglobalIDs.isEmpty()){                    
        leadGlobalList= [SELECT id,Tech_Task_time__c,In_Progress_Not_Started_Activity__c,
        lastactivitydate,Tech_LeadTask_Untouched__c,
        (SELECT whatid,whoid,status,ActivityDate,Activity_Type__c,recordtypeId,recordtype.Name FROM Tasks 
        )FROM Lead Where Id IN:leadglobalIDs AND Tech_Businesstrack__c='TELESALES'];
    }     
}
/*Method Name : populateNotstartedInProgressAcitivity
Param 1 : Accepts List of Tasks
Return type : void
Description :1. This method is used to populate "In_Progress_Not_Started_Activity__c" field on Account and Lead with the Task ActivityDate.
*/
public void populateNotstartedInProgressAcitivity(){
    List<Account> listAccInprogressNotStarted = new List<Account>();
    List<Lead> listLeadInprogressNotStarted = new List<Lead>();
    Set<ID> leadInProgressNotstartedIDs=new Set<ID>();
    Set<ID> accInProgressNotstartedIDs=new Set<ID>();           
    if(!accGlobalList.isEmpty()){      
        for (Account a : accGlobalList){
            Map<ID,Integer> mapAccInprogressNotStarted = new Map<ID,Integer>();
            for(Task t : a.Tasks){                                   
                IF (t.recordtype.name=='Schedule Followup' && (t.status =='In Progress' || t.status=='Not Started')){                                                                                                                                                                       
                    mapAccInprogressNotStarted.put(t.whatid,1);
                } 
            }                                                                    
            if(!mapAccInprogressNotStarted.isEmpty()){                         
                a.In_Progress_Not_Started_Activity__c=true;
                listAccInprogressNotStarted.add(a);                         
            }
            else if (mapAccInprogressNotStarted.isEmpty()){                         
                a.In_Progress_Not_Started_Activity__c=false;
                listAccInprogressNotStarted.add(a);
            } 
        }   
        system.debug('NOT PROGRESS **********&^^&&&&&&' + listAccInprogressNotStarted);    
        update listAccInprogressNotStarted;                                               
    }          
    else if (!leadGlobalList.isEmpty()){
        for (Lead l: leadGlobalList){  
            Map<ID,Integer> mapLeadInprogressNotStarted = new Map<ID,Integer>();             
            for(Task t1 : l.Tasks){                                   
                IF (t1.recordtype.name=='Schedule Followup' && (t1.status =='In Progress' || t1.status=='Not Started')){                                                                                                                                                                       
                    mapLeadInprogressNotStarted.put(t1.whoid,1);
                } 
            }                                                                    
            if(!mapLeadInprogressNotStarted.isEmpty()){                         
                l.In_Progress_Not_Started_Activity__c=true;
                listLeadInprogressNotStarted.add(l);                         
            }
            else if (mapLeadInprogressNotStarted.isEmpty()){                         
                l.In_Progress_Not_Started_Activity__c=false;
                listLeadInprogressNotStarted.add(l);
            } 
        }    
        update listLeadInprogressNotStarted; 
    }
}
/*****************************************************Method 2*******************************************/
/*Method Name : populateTimeSinceLastActivity
Param 1 : Accepts List of Tasks
Return type : void
Description :1. This method is used to populate "Tech_Task_time__c" field on Account and Lead with the Task ActivityDate.
*/
public void populateTimeSinceLastActivity(){
    List<Account> listAcctimesinceLastActivity = new List<Account>();
    List<Lead> listLeadtimesinceLastActivity = new List<Lead>();
    if(!accGlobalList.isEmpty()){   
        for(Account a : accGlobalList){
            Map<ID,Integer> mapAccTimeSinceLastActivity = new Map<ID,Integer>();
            for (Task t: a.Tasks){
                if (t.status=='Complete' && t.recordtype.name=='Inbound/Outbound Call Activity' && (t.Activity_Type__c== 'Inbound Call' || t.Activity_Type__c== 'Outbound call')){                              
                    mapAcctimesinceLastActivity.put(t.whatid,1);
                }                            
            }    
            if(!mapAcctimesinceLastActivity.isEmpty()){                         
                a.Tech_Task_time__c = a.lastactivitydate;
                listAcctimesinceLastActivity.add(a);                         
            }
            else if (mapAcctimesinceLastActivity.isEmpty()){                         
                a.Tech_Task_time__c = system.now();
                listAcctimesinceLastActivity.add(a);
            } 
        }    
        update listAcctimesinceLastActivity;                        
    }
    else if (!leadGlobalList.isEmpty()){                   
        for(Lead l : leadGlobalList){
            Map<ID,Integer> mapLeadTimeSinceLastActivity = new Map<ID,Integer>(); 
            for (Task t1: l.Tasks){
                if (t1.status=='Complete' && t1.recordtype.name=='Inbound/Outbound Call Activity' && (t1.Activity_Type__c== 'Inbound Call' || t1.Activity_Type__c== 'Outbound Call')){
                    mapLeadtimesinceLastActivity.put(t1.whoid,1); 
                }   
            }
            if(!mapLeadtimesinceLastActivity.isEmpty()){                         
                l.Tech_Task_time__c =l.lastactivitydate;
                listLeadtimesinceLastActivity.add(l);                         
            }
            else if (mapLeadtimesinceLastActivity.isEmpty()){                         
                l.Tech_Task_time__c =system.now();
                listLeadtimesinceLastActivity.add(l);
            } 
        }    
        update listLeadtimesinceLastActivity;
    }
    }
    /*****************************************METHOD 3*******************************************/
public void populateAgentInteraction (){
    List<Account> listAccAgentInteraction = new List<Account>();
    List<Lead> listLeadAgentInteraction = new List<Lead>();
    if(!accGlobalList.isEmpty()){   
        for(Account a : accGlobalList){          
            /* Untouched functionality change (D-0488) */             
            if (a.Tech_AccTask_Untouched__c!=true){           
                a.Tech_AccTask_Untouched__c= true;
                listAccAgentInteraction.add(a); 
            }         
        }                                                        
        update listAccAgentInteraction;
    }
    else if (!leadGlobalList.isEmpty()){                   
        for(Lead l : leadGlobalList){
            if (l.Tech_LeadTask_Untouched__c!=true){           
                l.Tech_LeadTask_Untouched__c = true;
                listLeadAgentInteraction.add(l); 
            }
        }        
        update listLeadAgentInteraction;
    }
}     
}