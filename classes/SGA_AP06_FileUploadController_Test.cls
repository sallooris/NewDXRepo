/************************************************************************
Class Name   : SGA_AP06_FileUploadController_Test
Date Created : 30-May-2017
Created By   : IDC Offshore
Description  : 1. This is a test class for SGA_AP06_FileUploadController
**************************************************************************/
@isTest
private class SGA_AP06_FileUploadController_Test {
    private static SGA_AP06_FileUploadController fileUploadController;
    private Static Final String APPLICATIONID_CONSTANT = 'ApplicationId';
    private Static Final String TESTADATA_CONSTANT = 'StringToBlobttttt';
    private Static Final String FILENAME_CONSTANT = 'test File test';
    private Static Final String FILETYPE_CONSTANT = 'Txt';
    private Static Final String FILESIZE_CONSTANT = '600';
    private Static Final String WRITINGAGENT1_CONSTANT = 'Test12345';
    private Static Final String FILENAME1_CONSTANT = 'test File test document12';
    private Static Final String FILESIZE1_CONSTANT = '1234';
    private Static Final String FILENAME2_CONSTANT = 'DocumentTest111';
    private Static Final String FILESIZE2_CONSTANT = '5000000';
      
    
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
            Test.startTest();
            System.currentPageReference().getParameters().put(APPLICATIONID_CONSTANT, applicationObj.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(applicationObj);
            fileUploadController = new SGA_AP06_FileUploadController(sc);
            fileUploadController.loadApplicationandDocuments();
            Integer i = 0;
            for(SGA_AP06_FileUploadController.WrapFileUploadHolder wrapFileH : fileUploadController.wrapFileUploadHolderList){
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
            Test.startTest();
            System.currentPageReference().getParameters().put(APPLICATIONID_CONSTANT, applicationObj.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(applicationObj);
            fileUploadController = new SGA_AP06_FileUploadController(sc);
            fileUploadController.loadApplicationandDocuments();
            Integer i = 0;
            for(SGA_AP06_FileUploadController.WrapFileUploadHolder wrapFileH : fileUploadController.wrapFileUploadHolderList){
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
            applicationObj.Tech_Emp_App_Print_Sign_Now__c = true;
            VlocityApplicationTriggerHandler.isFirstRunAfterUpdate = true;
            Database.update(applicationObj);
            Test.startTest();
            System.currentPageReference().getParameters().put(APPLICATIONID_CONSTANT, applicationObj.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(applicationObj);
            fileUploadController = new SGA_AP06_FileUploadController(sc);
            fileUploadController.loadApplicationandDocuments();
            Integer i = 0;
            for(SGA_AP06_FileUploadController.WrapFileUploadHolder wrapFileH : fileUploadController.wrapFileUploadHolderList){
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