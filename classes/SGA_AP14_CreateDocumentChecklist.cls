/*****************************************************************************************
Class Name   : SGA_AP14_CreateDocumentChecklist
Date Created : 6/01/2017
Created By   : IDC Offshore
Description  : 1. This is the helper class contains the business logic to create Document 
Checklist records, when the application is created.
Change History : 
******************************************************************************************/
public without sharing class SGA_AP14_CreateDocumentChecklist {
    public static final string ME_STATE_VAL = 'ME';
    public static final string CO_STATE_VAL = 'CO';
    public static final string NY_STATE_VAL = 'NY';
    public static final String HSA_VALUE = 'HSA';
    /****************************************************************************************************
    Method Name : createDocumentsForApplication
    Parameters  : oldAppObj, newAppObj
    Return type : Void
    Description : This method is used to retrieve documents from Application Document Config object and
    prepares document checklist records List to insert.
    ******************************************************************************************************/
    public static void createDocumentsForApplication(Map<Id, vlocity_ins__Application__c> oldApplicationMap, Map<Id, vlocity_ins__Application__c> newApplicationMap){
        List<vlocity_ins__Application__c> applicationList = new List<vlocity_ins__Application__c>();
        List<Application_Document_Checklist__c> existingDoccheckList = new List<Application_Document_Checklist__c>();
        Map<String, List<Application_Document_Config__c>> docConfigMap = new Map<String, List<Application_Document_Config__c>>();
        List<Application_Document_Checklist__c> docCheckList = new List<Application_Document_Checklist__c>();
        Set<String> stateSet = new Set<String>();
        
        Application_Document_Checklist__c documentCheck = null;
        String stateValue = null;
        try{
            applicationList = SGA_Util09_VlocityApplicationDataAccess.retrieveApplicationList(newApplicationMap);
            if(!applicationList.isEmpty()){
                for(vlocity_ins__Application__c applObj : applicationList){
                    if(applObj.vlocity_ins__PrimaryPartyId__c != NULL){
                        stateSet.add(applObj.vlocity_ins__PrimaryPartyId__r.vlocity_ins__AccountId__r.Company_State__c);
                    }else{
                        if(applObj.vlocity_ins__AccountId__c != NULL){
                            stateSet.add(applObj.vlocity_ins__AccountId__r.Company_State__c);
                        }
                    }
                }
                if(!stateSet.isEmpty() && stateSet != null){
                    docConfigMap = getDocumentConfigList(stateSet);
                    existingDoccheckList = SGA_Util09_VlocityApplicationDataAccess.retrieveExistingDCList(newApplicationMap);
                    if(!applicationList.isEmpty() && !docConfigMap.isEmpty() && existingDoccheckList.isEmpty()){
                        for(vlocity_ins__Application__c appObj : applicationList){
                            if(appObj.vlocity_ins__PrimaryPartyId__c != NULL){
                                stateValue = appObj.vlocity_ins__PrimaryPartyId__r.vlocity_ins__AccountId__r.Company_State__c;
                            }else{
                                if(appObj.vlocity_ins__AccountId__c != NULL){
                                    stateValue = appObj.vlocity_ins__AccountId__r.Company_State__c;
                                }
                            }
                            if(docConfigMap.containsKey(stateValue)){
                                List<Application_Document_Config__c> configList = docConfigMap.get(stateValue);
                                for(Application_Document_Config__c configObj : configList){
                                    documentCheck = new Application_Document_Checklist__c();
                                    if(ME_STATE_VAL.equalsIgnoreCase(stateValue) && appObj.Total_Num_of_Enrolling_Employees__c != NULL && appObj.Total_Num_of_Enrolling_Employees__c >= 5 && System.Label.SG62_AttestationForm.equalsIgnoreCase(configObj.Document_Name__c)){
                                        documentCheck.Required__c = TRUE;
                                    }else if(CO_STATE_VAL.equalsIgnoreCase(stateValue) && appObj.Total_Num_of_Employees__c != NULL && (appObj.Total_Num_of_Employees__c < 10 || appObj.Total_Num_of_Employees__c > 75) && System.Label.SG64_QUART_WH_Reporting.equalsIgnoreCase(configObj.Document_Name__c)){
                                        documentCheck.Required__c = TRUE;
                                    } else{
                                        documentCheck.Required__c = configObj.Required__c;
                                    }
                                    documentCheck.Application__c = appObj.Id;
                                    documentCheck.Application_Document_Config__c = configObj.Id;
                                    documentCheck.Document_Name__c = configObj.Document_Name__c;
                                    documentCheck.Status__c = Label.SG11_Not_Submitted;
                                    documentCheck.Form_Type__c = configObj.Form_Type__c;
                                    documentCheck.Doc_Type__c = configObj.Doc_Type__c;
                                    docCheckList.add(documentCheck); 
                                }
                            }
                        }
                    } 
                    if(!doccheckList.isEmpty()){ SGA_Util09_VlocityApplicationDataAccess.createDocumentCheckRecords(doccheckList); }
                }
            }
        }Catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,SG01_Constants.CLS_VLOCITYAPPL_TRIGGERHELPER, SG01_Constants.CREATEDOCUMENTS, SG01_Constants.BLANK, Logginglevel.ERROR);        }
    }
    /****************************************************************************************************
    Method Name : getDocumentConfigList
    Parameters  : Set<String> stateSet
    Return type : Map<String, List<Application_Document_Config__c>>
    Description : This method is used to retrieve documents from Application Document Config object based on state
    ******************************************************************************************************/
    private static Map<String, List<Application_Document_Config__c>> getDocumentConfigList(Set<String> stateSet){
        List<Application_Document_Config__c> docConfigList = new List<Application_Document_Config__c>();
        Map<String, List<Application_Document_Config__c>> configMap = new Map<String, List<Application_Document_Config__c>>();
        docConfigList = SGA_Util09_VlocityApplicationDataAccess.retrieveDocumentConfigList(stateSet);
        if(!docConfigList.isEmpty()){
            for(Application_Document_Config__c docConfig : docConfigList){
                if(configMap.containskey(docConfig.State__c)){
                    configMap.get(docConfig.State__c).add(docConfig);
                }else{
                    List<Application_Document_Config__c> dcList = new List<Application_Document_Config__c>();
                    dcList.add(docConfig);
                    configMap.put(docConfig.State__c , dcList);
                }
            }
        }
        return configMap;
    }
    /******************************************************************************************************
    Method Name : updateDocumentsForApplication
    Parameters  : oldAppObj, newAppObj
    Return type : Void
    Description : This method is used to update the document checklist records based on the docusign form 
    selection in omniscript
    ******************************************************************************************************/
    public static void updateDocumentsForApplication(Map<Id, vlocity_ins__Application__c> oldApplicationMap, Map<Id, vlocity_ins__Application__c> newApplicationMap){
        Map<String,String> docNameAppIdMap = new Map<String,String>();
        Map<String,String> appIdStatusMap = new Map<String,String>();
        for(vlocity_ins__Application__c applObj : newApplicationMap.values()){
            //checking the Employer Application form is send or not
            if(applObj.Tech_Employer_Application__c != oldApplicationMap.get(applObj.Id).Tech_Employer_Application__c && 
               applObj.Tech_Employer_Application__c)
            {
                docNameAppIdMap.put(System.Label.SG23_EmployerApplication, applObj.Id);
                appIdStatusMap.put(applObj.Id,System.Label.SG13_Document_Sent_for_Signature);
            }
            
            if(applObj.Tech_Emp_App_Print_Sign_Now__c != oldApplicationMap.get(applObj.Id).Tech_Emp_App_Print_Sign_Now__c && 
               applObj.Tech_Emp_App_Print_Sign_Now__c)
            {
                docNameAppIdMap.put(System.Label.SG23_EmployerApplication, applObj.Id);
                System.debug('inside sign');
                appIdStatusMap.put(applObj.Id,System.Label.SG33_Doucment_Signed);
            }
            //checking the HRA form is send or not
            if(applObj.Tech_HRA_Form__c != oldApplicationMap.get(applObj.Id).Tech_HRA_Form__c && 
               applObj.Tech_HRA_Form__c)
            {
                docNameAppIdMap.put(System.Label.SG27_HRA, applObj.Id);
                appIdStatusMap.put(applObj.Id,System.Label.SG13_Document_Sent_for_Signature);
            }
            //checking the Initial Payment form is send or not
            if(applObj.Tech_Initial_Payment_Form__c != oldApplicationMap.get(applObj.Id).Tech_Initial_Payment_Form__c && 
               applObj.Tech_Initial_Payment_Form__c)
            {
                docNameAppIdMap.put(System.Label.SG25_Initial_Payment, applObj.Id);
                appIdStatusMap.put(applObj.Id,System.Label.SG13_Document_Sent_for_Signature);
                //docNameAppIdMap.put(System.Label.SG32_Voided_Cheque, applObj.Id);
            }
        }
        List<Application_Document_CheckList__c> docCheckList = [Select Id,Document_Name__c, Status__c,Application__c from Application_Document_CheckList__c
                                                                where Application__c IN :docNameAppIdMap.values()];
        System.debug('docCheckList:::'+docCheckList);
        if(docCheckList != NULL && !docCheckList.isEmpty()){
            for(Application_Document_Checklist__c adcObj : docCheckList){
                if(docNameAppIdMap.containsKey(adcObj.Document_Name__c)){
                    //adcObj.Status__c = System.Label.SG13_Document_Sent_for_Signature;
                    adcObj.Status__c = appIdStatusMap.get(adcObj.Application__c);
                    System.debug('adcObj.Status__c:::'+adcObj.Status__c);
                }
            }
            Database.update(docCheckList);
        }
    }
    
}