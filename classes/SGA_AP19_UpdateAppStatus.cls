/*
* Class Name   : SGA_AP19_UpdateAppStatus
* Created Date : 07/26/2017
* Created By   : IDC Offshore
* Description  :  1.Utility Class to Update Application Status
                  2. This Class is without Sharing so it will perform Application Update logic without Sharing 

**/
public without sharing class SGA_AP19_UpdateAppStatus {

 /****************************************************************************************************
    Method Name : updateAppStatusForStage
    Parameters  : List<Case> csList, Map<id, case> csOldMap
    Return type : Void
    Description : Updates the Application Status as per the incoming Case Stage values
******************************************************************************************************/
public static void updateAppStatusForStage(List<Case> csList, Map<id, case> csOldMap)
{  
    Map<Id,String> appCaseStageMap=new Map<Id,String>();
	Try{
		String recordTypeName = SG01_Constants.CASE_RECORDTYPE_INSTALLATION;
        Id recType_Id =  SGA_Util11_ObjectRecordTypeHelper.getObjectRecordTypeId(Case.sobjectType, recordTypeName);
    for(Case cs:csList){
        if(!String.isBlank(cs.Stage__c)){
          if(cs.Stage__c != csOldMap.get(cs.Id).Stage__c && cs.Application_Name__c != NULL && cs.RecordTypeId.equals(recType_Id)  )
           {
            appCaseStageMap.put(cs.Application_Name__c,cs.Stage__c);
           }
        }
    } 
    // call updateApplication for filtered case records   
     if(!appCaseStageMap.isEmpty()){
     updateApplication(appCaseStageMap);
    } 
	}Catch(Exception ex){ UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,SG01_Constants.CLS_SGA_AP22_UPDATEAPPSTATUS, SG01_Constants.AP22_UPDATEAPPLICATION, SG01_Constants.BLANK, Logginglevel.ERROR);}
     
    
}

/****************************************************************************************************
    Method Name : updateApplication
    Parameters  : Map<Id,String>
    Return type : Void
    Description : Updates the Application Status as per the incoming Case Stage values
******************************************************************************************************/ 
public static void updateApplication(Map<Id,String> appCaseStageMap){
    List<vlocity_ins__Application__c> appListToUpdate = new List<vlocity_ins__Application__c>();
    try{  
        if( !appCaseStageMap.isEmpty()){
            for(Id apId: appCaseStageMap.keySet()){
                vlocity_ins__Application__c app= new vlocity_ins__Application__c();
                if(apId != NULL){
                 app.Id = apId;
                 String apStatus= getStatusForApp(appCaseStageMap.get(apId));
                    if(!String.isBlank(apStatus)){
                     app.vlocity_ins__Status__c  =apStatus;
                     appListToUpdate.add(app);
                    } 
                }  
            }
         }
         if( !appListToUpdate.isEmpty()){
             SGA_Util03_ApplicationDataAccessHelper.dmlApplicationlist(appListToUpdate,SGA_Util03_ApplicationDataAccessHelper.UPDATE_OPERATION);
         }
    }Catch(Exception ex){ UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,SG01_Constants.CLS_SGA_AP22_UPDATEAPPSTATUS, SG01_Constants.AP22_UPDATEAPPLICATION, SG01_Constants.BLANK, Logginglevel.ERROR);}

}

/****************************************************************************************************
    Method Name : getStatusForApp
    Parameters  : String
    Return type : String
    Description : performs evaluation of Application Status based on Case Status 
******************************************************************************************************/
    private static String getStatusForApp(String caseStage){
        String statusToSend='';
        try{ 
            // call custom setting to fetch Application Status value
            SGA_CS03_CaseStage_AppStatus__c csc = SGA_CS03_CaseStage_AppStatus__c.getValues(caseStage);
            if( !String.isBlank(csc.Application_Status__c)){
                statusToSend=csc.Application_Status__c;
            }
        }Catch(Exception ex){ UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,SG01_Constants.CLS_SGA_AP22_UPDATEAPPSTATUS, SG01_Constants.AP22_GETSTATUSFORAPP, SG01_Constants.BLANK, Logginglevel.ERROR);}
        
        return statusToSend;
    }

}