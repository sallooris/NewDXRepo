/************************************************************************
Class Name   : SGA_AP37_CaseFileUploadController_Test
Date Created : 28-Jun-2017
Created By   : IDC Offshore
Description  : Test class for SGA_AP37_CaseFileUploadController.
**************************************************************************/
@isTest
private class SGA_AP37_CaseFileUploadController_Test {
    private static SGA_AP37_CaseFileUploadController fileUploadController;
    private Static Final String CASEID_CONSTANT = 'caseId';
    private Static Final String TESTADATA_CONSTANT = 'StringToBlobttttt';
    private Static Final String FILENAME_CONSTANT = 'Employer Application Testttttt';
    private Static Final String FILETYPE_CONSTANT = 'Txt';
    private Static Final String FILESIZE_CONSTANT = '600';
    private Static Final String WRITINGAGENT1_CONSTANT = 'Test12345';
    private Static Final String FILENAME1_CONSTANT = 'Employer Application document12';
    private Static Final String FILESIZE1_CONSTANT = '1234';
    private Static Final String FILENAME2_CONSTANT = 'DocumentTest111';
    private Static Final String FILESIZE2_CONSTANT = '5000000';
    private Static Final String STATUS_CONSTANT = 'Group Submitted, Under Review';
      
    
    /************************************************************************************
    Method Name : fileUploadPositiveTest
    Parameters  : None
    Return type : void
    Description : This is the testmethod for Upload Documents with positive values
    *************************************************************************************/
    private static testMethod void  fileUploadPositiveTest(){
        User testUser = Util02_TestData.createUser();
        List<Application_Document_Config__c> testConfigList = Util02_TestData.createDocumentConfigList();
        //Business Custom Setting insertion
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        //List<SGA_InternalUser_Email__c> csEmailList = Util02_TestData.createInternalUserEmailData();
        //Account record creation
        Account testAccount = Util02_TestData.createGroupAccount();
        System.runAs(testUser){
            Database.insert(cs001List);
            //Database.insert(csEmailList);
            Database.insert(testConfigList);
            Database.insert(testAccount);
            vlocity_ins__Party__c partyObj = Util02_TestData.createPartyforAccount(testAccount.Id);
            Database.insert(partyObj);
            vlocity_ins__Application__c applicationObj = Util02_TestData.createApplicationRec(testAccount.Id, partyObj.Id);
            Database.insert(applicationObj);
            applicationObj.Broker_Writing_Agent_Name_2__c = WRITINGAGENT1_CONSTANT;
            Database.update(applicationObj);
            Case casObj = new Case();
            if(applicationObj.Id != null){
                casObj.Application_Name__c = applicationObj.Id;
                casObj.AccountId = testAccount.Id; 
              Database.insert(casObj); 
            }
            List<Application_Document_Checklist__c> documentChckObjList = new List<Application_Document_Checklist__c>();
            List<Application_Document_Checklist__c> updatedList = new List<Application_Document_Checklist__c>();
            if(casObj != null){
                documentChckObjList = [Select id, Case__c from Application_Document_Checklist__c where Application__c =: casObj.Application_Name__c]; 
                if(!documentChckObjList.isEmpty()){
                    for(Application_Document_Checklist__c docChkObj : documentChckObjList){
                        docChkObj.Case__c = casObj.Id;
                        updatedList.add(docChkObj);
                    }
                   Database.update(updatedList); 
                }
            }
            Test.startTest();
            System.currentPageReference().getParameters().put(CASEID_CONSTANT, casObj.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(casObj);
            fileUploadController = new SGA_AP37_CaseFileUploadController(sc);
            fileUploadController.loadApplicationandDocuments();
            Integer i = 0;
            for(SGA_AP37_CaseFileUploadController.WrapFileUploadHolder wrapFileH : fileUploadController.wrapFileUploadHolderList){
                String myString = TESTADATA_CONSTANT;
                Blob myBlob = Blob.valueof(myString);        
                wrapFileH.fileContent = myBlob;   
                wrapFileH.fileName = FILENAME_CONSTANT + i;
                wrapFileH.contentType = FILETYPE_CONSTANT;  
                wrapFileH.documentCheckObj.File_Size__c = FILESIZE_CONSTANT;
                i++;
                break;
            }
            fileUploadController.saveFiles(); 
            Test.stopTest();
            System.assert(fileUploadController.docCheckIdsList.size() > 0);
            System.assert(fileUploadController.wrapFileUploadHolderList.size() > 0);
        }
    }
    /************************************************************************************
    Method Name : fileUpload1024Test
    Parameters  : 
    Return type : void
    Description : This is the testmethod to save the files greater than 1024 size
    *************************************************************************************/
    private static testMethod void  fileUpload1024Test(){
        User testUser = Util02_TestData.createUser();
        List<Application_Document_Config__c> testConfigList = Util02_TestData.createDocumentConfigList();
        //Business Custom Setting insertion
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        //Account record creation
        Account testAccount = Util02_TestData.createGroupAccount();
        
        System.runAs(testUser){
            Database.insert(cs001List);
            
            Database.insert(testConfigList);
            Database.insert(testAccount);
            vlocity_ins__Party__c partyObj = Util02_TestData.createPartyforAccount(testAccount.Id);
            Database.insert(partyObj);
            vlocity_ins__Application__c applicationObj = Util02_TestData.createApplicationRec(testAccount.Id, partyObj.Id);
            Database.insert(applicationObj);
            applicationObj.Broker_Writing_Agent_Name_2__c = WRITINGAGENT1_CONSTANT;
            Database.update(applicationObj);
            Case casObj = new Case();
            if(applicationObj.Id != null){
                casObj.Application_Name__c = applicationObj.Id;
                casObj.AccountId = testAccount.Id; 
              Database.insert(casObj); 
            }
            List<Application_Document_Checklist__c> documentChckObjList = new List<Application_Document_Checklist__c>();
            List<Application_Document_Checklist__c> updatedList = new List<Application_Document_Checklist__c>();
            if(casObj != null){
                documentChckObjList = [Select id, Case__c from Application_Document_Checklist__c where Application__c =: casObj.Application_Name__c]; 
                if(!documentChckObjList.isEmpty()){
                    for(Application_Document_Checklist__c docChkObj : documentChckObjList){
                        docChkObj.Case__c = casObj.Id;
                        updatedList.add(docChkObj);
                    }
                   Database.update(updatedList); 
                }
            }
            Test.startTest();
            System.currentPageReference().getParameters().put(CASEID_CONSTANT, casObj.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(casObj);
            fileUploadController = new SGA_AP37_CaseFileUploadController(sc);
            fileUploadController.loadApplicationandDocuments();
            Integer i = 0;
            for(SGA_AP37_CaseFileUploadController.WrapFileUploadHolder wrapFileH : fileUploadController.wrapFileUploadHolderList){
                String myString = TESTADATA_CONSTANT;
                Blob myBlob = Blob.valueof(myString);        
                wrapFileH.fileContent = myBlob;   
                wrapFileH.fileName = FILENAME1_CONSTANT + i;
                wrapFileH.contentType = FILETYPE_CONSTANT;  
                wrapFileH.documentCheckObj.File_Size__c = FILESIZE1_CONSTANT;
                i++;
                break;
            }
            fileUploadController.saveFiles();
            Test.stopTest();
            System.assert(fileUploadController.docCheckIdsList.size() > 0);
            System.assert(fileUploadController.wrapFileUploadHolderList.size() > 0);
        }
    }
    
    /************************************************************************************
    Method Name : fileUploadMBTest
    Parameters  : 
    Return type : void
    Description : This is the testmethod to save the files greater than 2MB size
    *************************************************************************************/
    private static testMethod void  fileUploadMBTest(){
        User testUser = Util02_TestData.createUser();
        List<Application_Document_Config__c> testConfigList = Util02_TestData.createDocumentConfigList();
        //Business Custom Setting insertion
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        //Account record creation
        Account testAccount = Util02_TestData.createGroupAccount();
        
        System.runAs(testUser){
            Database.insert(cs001List);
            
            Database.insert(testConfigList);
            Database.insert(testAccount);
            vlocity_ins__Party__c partyObj = Util02_TestData.createPartyforAccount(testAccount.Id);
            Database.insert(partyObj);
            vlocity_ins__Application__c applicationObj = Util02_TestData.createApplicationRec(testAccount.Id, partyObj.Id);
            Database.insert(applicationObj);
            applicationObj.Broker_Writing_Agent_Name_2__c = WRITINGAGENT1_CONSTANT;
            applicationObj.Tech_Employer_Application__c = true;
            applicationObj.Tech_HRA_Form__c = true;
            applicationObj.Tech_Initial_Payment_Form__c = true;
            Database.update(applicationObj);
            
            Case casObj = new Case();
            if(applicationObj.Id != null){
                casObj.Application_Name__c = applicationObj.Id;
                casObj.AccountId = testAccount.Id; 
              Database.insert(casObj); 
            }
            List<Application_Document_Checklist__c> documentChckObjList = new List<Application_Document_Checklist__c>();
            List<Application_Document_Checklist__c> updatedList = new List<Application_Document_Checklist__c>();
            if(casObj != null){
                documentChckObjList = [Select id, Case__c from Application_Document_Checklist__c where Application__c =: casObj.Application_Name__c]; 
                if(!documentChckObjList.isEmpty()){
                    for(Application_Document_Checklist__c docChkObj : documentChckObjList){
                        docChkObj.Case__c = casObj.Id;
                        updatedList.add(docChkObj);
                    }
                   Database.update(updatedList); 
                }
            }
            Test.startTest();
            System.currentPageReference().getParameters().put(CASEID_CONSTANT, casObj.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(casObj);
            fileUploadController = new SGA_AP37_CaseFileUploadController(sc);
            fileUploadController.loadApplicationandDocuments();
            Integer i = 0;
            for(SGA_AP37_CaseFileUploadController.WrapFileUploadHolder wrapFileH : fileUploadController.wrapFileUploadHolderList){
                String myString = TESTADATA_CONSTANT;
                Blob myBlob = Blob.valueof(myString);        
                wrapFileH.fileContent = myBlob;   
                wrapFileH.fileName = FILENAME2_CONSTANT + i;
                wrapFileH.contentType = FILETYPE_CONSTANT;  
                wrapFileH.documentCheckObj.File_Size__c = FILESIZE2_CONSTANT;
                i++;
                break;
            }
            fileUploadController.saveFiles();
            Test.stopTest();
            System.assert(fileUploadController.docCheckIdsList.size() > 0);
            System.assert(fileUploadController.wrapFileUploadHolderList.size() > 0);
        }
    }

}