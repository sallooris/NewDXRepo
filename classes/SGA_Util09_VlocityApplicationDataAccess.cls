/*****************************************************************************************
Class Name   : SGA_Util09_VlocityApplicationDataAccess
Date Created : 6/01/2017
Created By   : IDC Offshore
Description  : 1. This is the data access class for Vlocity_Application Trigger.
2. This is used for DML Operations.
Change History : 
******************************************************************************************/
public without sharing class SGA_Util09_VlocityApplicationDataAccess {
    /****************************************************************************************************
    Method Name : createDocumentCheckRecords
    Parameters  : List<Application_Document_Checklist__c> documentList,
    Return type : Void
    Description : This method is used to perform the DML operations on Application_Document_Checklist__c.
    ******************************************************************************************************/
    public static void createDocumentCheckRecords(List<Application_Document_Checklist__c> documentList){
        if(!documentList.isEmpty()){
            Database.insert(documentList);
        }
    }
    /****************************************************************************************************
    Method Name : retrieveApplicationList
    Parameters  : Map<Id, vlocity_ins__Application__c> newApplicationMap,
    Return type : Void
    Description : This method is used to fetch the application records.
    ******************************************************************************************************/    
    public static List<vlocity_ins__Application__c> retrieveApplicationList(Map<Id, vlocity_ins__Application__c> newApplicationMap){
        List<vlocity_ins__Application__c> applicationObjList = new List<vlocity_ins__Application__c>();
        if(!newApplicationMap.isEmpty()){
            System.debug(':::newApplicationMap.keySet():::'+newApplicationMap.keySet());
            applicationObjList = [Select id,vlocity_ins__Type__c,vlocity_ins__AccountId__r.Company_State__c,vlocity_ins__AccountId__r.BillingState,Total_Num_of_Enrolling_Employees__c,
                                  vlocity_ins__QuoteId__c,Total_Num_of_Employees__c,vlocity_ins__PrimaryPartyId__r.vlocity_ins__AccountId__r.BillingState,
                                  vlocity_ins__PrimaryPartyId__r.vlocity_ins__AccountId__r.Company_State__c
                                  from vlocity_ins__Application__c where Id IN: newApplicationMap.keySet() LIMIT 500];
            System.debug(':::applicationObjList:::'+applicationObjList);
        }
        return applicationObjList;
    }
    /****************************************************************************************************
    Method Name : retrieveApplicationList
    Parameters  : Map<Id, vlocity_ins__Application__c> newApplicationMap,
    Return type : Void
    Description : This method is used to fetch the application records.
    ******************************************************************************************************/ 
    public static List<Application_Document_Config__c> retrieveDocumentConfigList(Set<String> stateSet){
        List<Application_Document_Config__c> docConfigList = new List<Application_Document_Config__c>();
        if(!stateSet.isEmpty()){
            docConfigList = [select id, name, Document_Name__c, State__c, Required__c, Doc_Type__c, Form_Type__c from Application_Document_Config__c where State__c IN: stateSet LIMIT 150];
        }
        return docConfigList;
    }
    /****************************************************************************************************
    Method Name : retrieveExistingDCList
    Parameters  : Map<Id, vlocity_ins__Application__c>
    Return type : List<Application_Document_Checklist__c>
    Description : This method is used to retrieve the existing document checklist records
    ******************************************************************************************************/
    public static List<Application_Document_Checklist__c> retrieveExistingDCList(Map<Id, vlocity_ins__Application__c> newApplicationMap){
        List<Application_Document_Checklist__c> existingDCList = new List<Application_Document_Checklist__c>();
        if(!newApplicationMap.isEmpty()){
            existingDCList = [Select id, Document_Name__c from Application_Document_Checklist__c where Application__c IN: newApplicationMap.keySet() LIMIT 100];
        }
        return existingDCList;
    }
}