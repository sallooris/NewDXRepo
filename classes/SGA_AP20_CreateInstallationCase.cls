/***********************************************************************
Class Name   : SGA_AP20_CreateInstallationCase
Date Created : 08/04/2017 (MM/DD/YYYY)
Created By   : IDC Offshore
Description  : 1. This is a Handler Class for Creating Installation Case records based on Application Status
**************************************************************************/
public without sharing class SGA_AP20_CreateInstallationCase
{   
    public static boolean isUpdated = false; 
    private static Final sObjectType OBJECT_TYPE=Case.sobjectType;
    
    private static Id recType_Id =  SGA_Util11_ObjectRecordTypeHelper.getObjectRecordTypeId(OBJECT_TYPE, SG01_Constants.CASE_RECORDTYPE_INSTALLATION);
    
    public static final string APP_SELECT_QUERY = 'Select Id,Name,Optional_Supp_Vol_Life_ADD_Dep_Life__c,Life_ADD_Dep_Life__c,STD_VSTD__c,LTD_VLTD__c,EAP__c,vlocity_ins__PrimaryPartyId__c,vlocity_ins__AccountId__r.BillingState,vlocity_ins__AccountId__r.Company_State__c,vlocity_ins__PrimaryPartyId__r.vlocity_ins__AccountId__c,Account_State__c,vlocity_ins__AccountId__c,vlocity_ins__Type__c,State__c,Group_Coverage_Date__c,Member_Count__c,vlocity_ins__QuoteId__c,vlocity_ins__QuoteId__r.Name,Medical__c,Vision__c,Dental__c,vlocity_ins__Status__c,Total_Num_of_Enrolling_Employees__c,Total_Num_of_Employees__c,Num_of_Eligible_Full_Time_Employees__c,WritingAgentETIN__c,Broker_Agent_Name_1__c,Paid_Agency_Name1__c,General_Agency_Name1__c,Broker_Contact__c from vlocity_ins__Application__c';
    
    public static final string DC_LIST_QUERY='SELECT Id,Application__c,Case__c from Application_Document_Checklist__c';
    
    public static final string DOC_QUERY_WHERE = SG01_Constants.SPACE+'where Application__c =:caseIdSet';
    
    public static final string APP_QUERY_WHERE = SG01_Constants.SPACE+'Where Id IN : applicationIdSet';
    public static final string EXIST_CASE_QUERY_SELECT = 'SELECT ID,Application_Name__c,Stage__c,Status From Case';
    public static final string EXIST_CASE_QUERY_WHERE =SG01_Constants.SPACE+ 'Where Application_Name__c IN : applicationIdSet AND RecordTypeID =: caseRecordTypeID AND Status !=: statusClosed'; 
    
    public static final string ORDER_BY_CLAUSE =SG01_Constants.SPACE +'ORDER BY CreatedDate DESC ';
    private static List<Case> cslistToInsert=new List<Case>();     
    private static Map <Id,Case> csMapToInsert=new Map<Id,Case>();     
    private static List<Case> cslistToUpdate=new List<Case>();     
    private static Map<Id,Case> apIdCaseMapToUpdate=new Map<Id,Case>();
    private static List<vlocity_ins__Application__c> aplist=new List<vlocity_ins__Application__c>();
    private static Map<String,String> etinAppMap = new Map<String,String>();
    private static Map<String,String> etinConMap = new Map<String,String>();
    /****************************************************************************************************
Method Name : appCaseUpdate
Parameters  : apNewMap,apOldMap
Return type : void
Description : 1.fetches the application records in bulk based on Status
2. calls actionAfterFilterization to perform final insert/update operation in Bulk
****************************************************************************/
    public static void createOrUpdateInstallationCase(Map<id, vlocity_ins__Application__c> apNewMap, Map<id, vlocity_ins__Application__c> apOldMap) { 
        System.debug('Enter createOrUpdateInstallationCase Trigger::>');   
        set<Id> appId=new Set<Id>();
        try{
            Map<Id,vlocity_ins__Application__c> appDetailMapToSend= new Map<Id,vlocity_ins__Application__c>();
            if( !apNewMap.isEmpty() && !apOldMap.isEmpty() ){ 
                for(vlocity_ins__Application__c tmp:apNewMap.values()){ 
                    if(tmp.vlocity_ins__Status__c != NULL){
                        if(tmp.vlocity_ins__Status__c != apOldMap.get(tmp.id).vlocity_ins__Status__c && tmp.vlocity_ins__Status__c.equalsIgnoreCase(SG01_Constants.APP_STATUS_GROUP_SUBMITED)){
                            appId.add(tmp.id);
                            if(tmp.WritingAgentETIN__c != null){
                                etinAppMap.put(tmp.Id,tmp.WritingAgentETIN__c);
                            }
                        }
                    }
                }
            } 
            else if(!apNewMap.isEmpty()){
                for(vlocity_ins__Application__c tmp:apNewMap.values()){
                    if(tmp.vlocity_ins__Status__c != NULL){
                        if(tmp.vlocity_ins__Status__c.equalsIgnoreCase(SG01_Constants.APP_STATUS_GROUP_SUBMITED)){
                            appId.add(tmp.id);
                            if(tmp.WritingAgentETIN__c != null){
                                etinAppMap.put(tmp.Id,tmp.WritingAgentETIN__c);
                            }
                        }
                    }
                }
            }
            if(!appId.isEmpty() )
            {     
                //set appId to applicationIdSet before invoking fetchApplicationMap method
                SGA_Util03_ApplicationDataAccessHelper.applicationIdSet =appId;
                //call SGA_Util03_ApplicationDataAccessHelper class to fetch application details
                appDetailMapToSend = SGA_Util03_ApplicationDataAccessHelper.fetchApplicationMap(APP_SELECT_QUERY,APP_QUERY_WHERE,ORDER_BY_CLAUSE,SG01_Constants.LIMIT_100);  
                
            }
            
            if(!etinAppMap.isEmpty() && etinAppMap != null){
                List<Contact> brokerConList = new List<Contact>();
                brokerConList = [select id,ETIN__c from Contact where ETIN__c IN :etinAppMap.values() and ETIN__c != null];
                if(!brokerConList.isEmpty() && brokerConList != null){
                    for(Contact conObj : brokerConList){
                        if(!String.isBlank(conObj.ETIN__c)){
                            etinConMap.put(conObj.ETIN__c, conObj.Id);
                        }
                    }
                }
            }
            //System.debug('Enter appDetailMapToSend:::'+appDetailMapToSend); 
            //call actionAfterFilterization method to take final action on Bulk
            if( !appDetailMapToSend.isEmpty()) {
                actionAfterFilterization(appDetailMapToSend);
            }
        }Catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_AP20_CREATEINSTALCASE, SG01_Constants.AP20_CREATEORUPDATE, SG01_Constants.BLANK, Logginglevel.ERROR);}
        
    } 
    
    /****************************************************************************************************
Method Name : actionAfterFilterization
Parameters  : Map<Id,vlocity_ins__Application__c>
Return type : Map<Id,Opportunity>
Description :  1. calls checkExistCaseRecord() method to check existing case records
2. performs insert or update operation on cases based on filtered result
******************************************************************************************************/
    private static void actionAfterFilterization( Map<Id,vlocity_ins__Application__c> appDetailMap){  
        /* Check Existing Case records in Bulk*/
        WrpFilteredApp wrpFiltered=checkExistCaseRecord(appDetailMap.keyset());
        /* End Check Existing Case records in Bulk*/
        //fetch existing Application & Case Ids
        Map<Id,Id> caseExist=new Map<Id,Id>();
        caseExist=wrpFiltered.existingAppCaseMap;
        if(!caseExist.isEmpty()){
            for(Id cid:caseExist.keySet()){
                Id apId=caseExist.get(cid);
                Case cstoUpdate=createCaseRecord(appDetailMap.get(apId),false);
                cstoUpdate.Id=cid;
                apIdCaseMapToUpdate.put(apId,cstoUpdate);
            }
        }
        //fetch Application Ids for New Case
        Set<Id> apIdForNewCase=new Set<Id>();
        apIdForNewCase=wrpFiltered.appIdsWithoutCaseSet;
        if(!apIdForNewCase.isEmpty()) { 
            for(Id appNew:apIdForNewCase) {   
                Case cstoInsert=createCaseRecord(appDetailMap.get(appNew),true);
                csMapToInsert.put(appNew,cstoInsert);
            }
        }
        //perform Final Operation
        //System.debug('Case insert list::>'+csMapToInsert);
        //System.debug('Case update list::>'+apIdCaseMapToUpdate);
        Try{  
            if(!csMapToInsert.isEmpty() && !isUpdated) {
                
                SGA_Util12_CaseDataAccessHelper.dmlOnCase(csMapToInsert.values(),SGA_Util12_CaseDataAccessHelper.INSERT_OPERATION);
                //perform Document Checklist Updattion with new Case Ids
                updateDocChecklist(csMapToInsert);
                isUpdated = true;
            }     
            if(!apIdCaseMapToUpdate.isEmpty()) { 
                SGA_Util12_CaseDataAccessHelper.dmlOnCase(apIdCaseMapToUpdate.values(),SGA_Util12_CaseDataAccessHelper.UPDATE_OPERATION);
            }
        } Catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_AP20_CREATEINSTALCASE, SG01_Constants.AP20_ACTIONAFTERFILTER, SG01_Constants.BLANK, Logginglevel.ERROR);}
    }
    
    /****************************************************************************************************
Method Name : checkExistCaseRecord
Parameters  : Set<Id>
Return type : WrpFilteredApp
Description : 1. performs the Filteing operation based on incoming apId in bulk
2. returns WrpFilteredApp instace based on three mentioned conditions 
*****************************************************************************/
    private static void updateDocChecklist(Map<Id,Case> appCaseMap){
        Map<Id,Application_Document_Checklist__c> dcMap = new Map<Id,Application_Document_Checklist__c>();
        List<Application_Document_Checklist__c> dcListToUpdate = new List<Application_Document_Checklist__c>();
        
        if( !appCaseMap.isEmpty()){
            SGA_Util04_DCDataAccessHelper.caseIdSet= appCaseMap.keySet();
            dcMap=SGA_Util04_DCDataAccessHelper.fetchDocumentChecklistMap(DC_LIST_QUERY,DOC_QUERY_WHERE,SG01_Constants.BLANK,SG01_Constants.BLANK);
        }
        
        if( !dcMap.isEmpty() && !appCaseMap.isEmpty()){
            For(Id dcId : dcMap.keySet()){
                Application_Document_Checklist__c dc = dcMap.get(dcId);
                dc.Case__c = appCaseMap.get(dc.Application__c).Id;
                dcListToUpdate.add(dc);
            }
        }
        //System.debug('dcListToUpdate::>'+dcListToUpdate);
        Try{
            if(!dcListToUpdate.isEmpty()){
                SGA_Util04_DCDataAccessHelper.dmlDocChecklist(dcListToUpdate,SGA_Util04_DCDataAccessHelper.UPDATE_OPERATION);
            }    
        }Catch(Exception ex){ System.debug('excp at updateDocChecklist'+ex.getMessage());}  
        
    }
    
    
    /****************************************************************************************************
Method Name : checkExistCaseRecord
Parameters  : Set<Id>
Return type : WrpFilteredApp
Description : 1. performs the Filteing operation based on incoming apId in bulk
2. returns WrpFilteredApp instace based on three mentioned conditions 
*****************************************************************************/
    private static WrpFilteredApp checkExistCaseRecord(Set<Id> apId){
        
        SGA_Util12_CaseDataAccessHelper.applicationIDSet =apId;
        SGA_Util12_CaseDataAccessHelper.caseRecordTypeID =recType_Id;
        SGA_Util12_CaseDataAccessHelper.statusClosed = SG01_Constants.STATUS_CLOSED;
        Map<Id,Id> csAppIdMap=new Map<Id,Id>();
        Map<Id,Id> appCsIdMap=new Map<Id,Id>();
        Set<Id> appIdWithoutCase=new Set<Id>();
        //Case Query
        Map<Id,Case> csMap = SGA_Util12_CaseDataAccessHelper.fetchCaseMap(EXIST_CASE_QUERY_SELECT,EXIST_CASE_QUERY_WHERE,ORDER_BY_CLAUSE,SG01_Constants.BLANK);
        
        WrpFilteredApp wrpToSend= new WrpFilteredApp();
        
        /* condition 1: No application is not associated with any case*/
        if(csMap.isEmpty()){
            wrpToSend.appIdsWithoutCaseSet = apId;
        }else{
            /* condition 2: some Application is associated with case*/
            for(Id tmp:csMap.keySet()){
                csAppIdMap.put(tmp,csMap.get(tmp).Application_Name__c);
                appCsIdMap.put(csMap.get(tmp).Application_Name__c,tmp);
            }
            wrpToSend.existingAppCaseMap =csAppIdMap;
        }
        /* condition 3: Remaining Application not associated with case*/
        for(String ap:apId){
            if(!appCsIdMap.isEmpty()){
                if(!appCsIdMap.containsKey(ap)){
                    appIdWithoutCase.add(ap);
                    wrpToSend.appIdsWithoutCaseSet =appIdWithoutCase;
                    
                }
            }   
        }   
        return wrpToSend;   
    }
    
    /****************************************************************************************************
Method Name : createCaseRecord
Parameters  : vlocity_ins__Application__c
Return type : Case
Description : 1.Create case record to be utilized to perform insert or update operation based on incoming vlocity_ins__Application__c record
2. apply DML Option to invoke case Assignemnt Rule.                
****************************************************************************/
    
    private static Case createCaseRecord(vlocity_ins__Application__c appUpdate,boolean applyAssignmentRule){
        Case csData = new Case(); 
        if( appUpdate != NULL ) {
            // call createCaseEssentialsData to prepare Case Record
            csData=createCaseEssentialsData(appUpdate);
            //apply assignement Rule if Case is created for Online Application
            if(!String.isBlank(appUpdate.vlocity_ins__Type__c)){
                if(System.Label.SG73_OnlineApplication.equalsIgnoreCase(appUpdate.vlocity_ins__Type__c)){
                    Database.DMLOptions dmo = new Database.DMLOptions();
                    dmo.assignmentRuleHeader.useDefaultRule = applyAssignmentRule;
                    csData.setOptions(dmo);
                }
            }   
        }
        
        return csData;
    }
    
    /****************************************************************************************************
Method Name : createCaseEssentialsData
Parameters  : vlocity_ins__Application__c
Return type : Case
Description : 1.Create case essential Data from Application record                 
****************************************************************************/
    
    private static Case createCaseEssentialsData(vlocity_ins__Application__c incomingApp){
        Case cs = new Case();
        cs.RecordTypeId = recType_Id;
        cs.Application_Name__c =incomingApp.Id;
        // provide State Information to be used for Case Assigment
        if(!String.isBlank(incomingApp.vlocity_ins__AccountId__c) && incomingApp.vlocity_ins__AccountId__c != NULL){
            cs.AccountId=incomingApp.vlocity_ins__AccountId__c;
            cs.BR_State__c = incomingApp.vlocity_ins__AccountId__r.Company_State__c;
        }else if(incomingApp.vlocity_ins__PrimaryPartyId__c != NULL){
            cs.AccountId= incomingApp.vlocity_ins__PrimaryPartyId__r.vlocity_ins__AccountId__c;
            cs.BR_State__c = incomingApp.vlocity_ins__PrimaryPartyId__r.vlocity_ins__AccountId__r.Company_State__c;
        }
        if(!String.isBlank(incomingApp.Broker_Contact__c) && incomingApp.Broker_Contact__c != NULL) {
            cs.ContactId = incomingApp.Broker_Contact__c;
        } else {
            if(!etinAppMap.isEmpty() && etinAppMap.get(incomingApp.Id) != NULL ){
                String ETIN = etinAppMap.get(incomingApp.Id);
                if(!etinConMap.isEmpty() && etinConMap.get(ETIN) != NULL){
                    cs.ContactId = etinConMap.get(ETIN);
                } 
            } 
        }
        // provide Quote Information
        if( !String.isBlank(incomingApp.vlocity_ins__QuoteId__c) && incomingApp.vlocity_ins__QuoteId__c != NULL ) {
            cs.Quote_Name__c = incomingApp.vlocity_ins__QuoteId__c; 
        }
        cs.Stage__c=SG01_Constants.APP_STATUS_GROUP_SUBMITED;
        cs.BR_Department__c=SG01_Constants.DEPART_SALES_SUPPORT;
        cs.Effective_Date__c=incomingApp.Group_Coverage_Date__c;
        cs.Member_Count__c=incomingApp.Member_Count__c;
        cs.Total_Num_of_Employees__c=incomingApp.Total_Num_of_Employees__c;
        cs.Num_of_Eligible_Full_Time_Employees__c=incomingApp.Num_of_Eligible_Full_Time_Employees__c;
        cs.Total_Num_of_Enrolling_Employees__c=incomingApp.Total_Num_of_Enrolling_Employees__c;
        cs.Medical__c=incomingApp.Medical__c;
        cs.Vision__c=incomingApp.Vision__c;
        cs.Dental__c=incomingApp.Dental__c;
        cs.EAP__c = incomingApp.EAP__c;
        cs.Optional_Supp_Vol_Life_ADD_Dep_Life__c = incomingApp.Optional_Supp_Vol_Life_ADD_Dep_Life__c;
        cs.LTD_VLTD__c = incomingApp.LTD_VLTD__c;
        cs.STD_VSTD__c = incomingApp.STD_VSTD__c;
        cs.Life_ADD_Dep_Life__c = incomingApp.Life_ADD_Dep_Life__c;
        cs.Broker_Writing_Agent_1__c = incomingApp.Broker_Agent_Name_1__c;
        cs.Paid_Agency__c = incomingApp.Paid_Agency_Name1__c;
        cs.General_Agency__c = incomingApp.General_Agency_Name1__c;
        
        return cs;
    }
    
    /****************************************************************************************************
Class Name : WrpFilteredApp
Description : wrapper class to hold existingAppCaseMap and appIdsWithoutCaseSet values  
*****************************************************************************/
    public class WrpFilteredApp{
        Map<Id,Id> existingAppCaseMap=new Map<Id,Id>();
        Set<Id> appIdsWithoutCaseSet= new Set<Id>();
        
    }
}