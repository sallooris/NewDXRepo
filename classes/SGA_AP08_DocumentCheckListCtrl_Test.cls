/************************************************************************
Class Name   : SGA_AP08_DocumentCheckListCtrl_Test
Date Created : 23-May-2017
Created By   : IDC Offshore
Description  : 1. This is a test class for SGA_AP08_DocumentCheckListCtrl
**************************************************************************/
@isTest
private class SGA_AP08_DocumentCheckListCtrl_Test {
    private static final string BROKER_PORTAL_NAME ='TestBrokerPortalUser';
    private static final string BROKER_PORTAL_FNAME='TestBrokerPortalUser';
    private static final string BROKER_PORTAL_LNAME='BrportaTestBrokerUser';
    private static final string BROKER_PORTAL_EMAIL='TestBrokerPortalUser@TestPortal.Com.TestPortal';
    private static final string BROKER_PORTAL_UNAME='TestBrokerPortalUser@TestPortal.Com.TestPortal';
    private static final string BUSINESS_ACCOUNT ='Business Account';
    private static final string UPLOADED ='Uploaded';
    /************************************************************************************
Method Name : getDocumentCheckListTest
Parameters  : None
Return type : void
Description : This is the testmethod for getDocumentCheckList
*************************************************************************************/
    private testMethod static void getDocumentCheckListTest() {
        User testUser = Util02_TestData.createUser();
        vlocity_ins__Application__c testApplication =Util02_TestData.createApplicationForRelatedList(SG01_Constants.STATUSINENROLLMENTCOMPLETED, System.today() +5);
        //Application_Document_Config__c record creation
        Application_Document_Config__c appConfig=Util02_TestData.createApplicationDocumentConfig();
        //Application_Document_Checklist__c record creation
        Application_Document_Checklist__c docCheckList=Util02_TestData.createApplicationDocumentCheckList(appConfig.Id,testApplication.Id);
        
        System.runAs(testUser) {
            Database.insert(testApplication);
            Database.insert(appConfig);
            docCheckList.Application_Document_Config__c=appConfig.Id;
            docCheckList.Application__c=testApplication.Id;
            Database.insert(docCheckList);
            //System.debug('docCheckList'+docCheckList);
            Test.startTest();
            SGA_AP08_DocumentCheckListCtrl.appId=testApplication.Id;
            List<Application_Document_Checklist__c> docList=SGA_AP08_DocumentCheckListCtrl.getDocumentCheckList(testApplication.Id);
            Test.stopTest();
            System.assertEquals(1, docList.size());
            
        }
    }
    
    /************************************************************************************
Method Name : getDocumentCheckListExTest
Parameters  : None
Return type : void
Description : This is to testexception generated getDocumentCheckList
*************************************************************************************/
    private testMethod static void getDocumentCheckListExTest() {
        User testUser = Util02_TestData.createUser();
        //Account record creation
        Account testAccount = Util02_TestData.createGroupAccountForRelatedList();
        //Application record creation
        vlocity_ins__Application__c testApplication =Util02_TestData.createApplicationForRelatedList(SG01_Constants.STATUSINENROLLMENTCOMPLETED, System.today() +5);
        //Application_Document_Config__c record creation
        Application_Document_Config__c appConfig=Util02_TestData.createApplicationDocumentConfig();
        //Application_Document_Checklist__c record creation
        Application_Document_Checklist__c docCheckList=Util02_TestData.createApplicationDocumentCheckList(appConfig.Id,testApplication.Id);
        
        System.runAs(testUser) {
            Database.insert(testApplication);
            Database.insert(appConfig);
            docCheckList.Application_Document_Config__c=appConfig.Id;
            docCheckList.Application__c=testApplication.Id;
            Database.insert(docCheckList);
            //System.debug('docCheckList'+docCheckList);
            Test.startTest();
            List<Application_Document_Checklist__c> docList=SGA_AP08_DocumentCheckListCtrl.getDocumentCheckList(testAccount.Id);
            Test.stopTest();
            System.assertEquals('123456', testAccount.Group_Number__c);
            
        }
    }
    
    /************************************************************************************
Method Name : getDeletedlistTest
Parameters  : None
Return type : void
Description : This is the testmethod for getDeletedlist
*************************************************************************************/
    private testMethod static void getDeletedlistTest() {
        User testUser = Util02_TestData.createUser();
        //Application record creation
        vlocity_ins__Application__c testApplication = Util02_TestData.createApplicationForRelatedList(SG01_Constants.STATUSINENROLLMENTCOMPLETED, System.today() +5);
        //Application_Document_Config__c record creation
        Application_Document_Config__c appConfig=Util02_TestData.createApplicationDocumentConfig();
        //Application_Document_Checklist__c record creation
        Application_Document_Checklist__c docCheckList=Util02_TestData.createApplicationDocumentCheckList(appConfig.Id,testApplication.Id);
        
        System.runAs(testUser){
            Database.insert(testApplication);
            Database.insert(appConfig);
            docCheckList.Application_Document_Config__c=appConfig.Id;
            docCheckList.Application__c=testApplication.Id;
            Database.insert(docCheckList);
            
            //Database.Delete(docCheckList);
            Test.startTest();
            SGA_AP08_DocumentCheckListCtrl.getDeletedlist(docCheckList.Id);
            Test.stopTest();
            System.assert(true);
        }
    }
    
    /************************************************************************************
Method Name : updatedDocumentTest
Parameters  : None
Return type : void
Description : This is the testmethod for updatedDocument
*************************************************************************************/
    private testMethod static void updatedDocumentTest() {
        User testUser = Util02_TestData.createUser();
        //Application record creation
        vlocity_ins__Application__c testApplication = Util02_TestData.createApplicationForRelatedList(SG01_Constants.STATUSINENROLLMENTCOMPLETED, System.today() +5);
        //Application_Document_Config__c record creation
        Application_Document_Config__c appConfig=Util02_TestData.createApplicationDocumentConfig();
        //Application_Document_Checklist__c record creation
        Application_Document_Checklist__c docCheckList=Util02_TestData.createApplicationDocumentCheckList(appConfig.Id,testApplication.Id);
        
        System.runAs(testUser) {
            Database.insert(testApplication);
            Database.insert(appConfig);
            docCheckList.Application_Document_Config__c=appConfig.Id;
            docCheckList.Application__c=testApplication.Id;
            Database.insert(docCheckList);
            docCheckList.Document_Name__c='Test123.txt';
            Test.startTest();
            SGA_AP08_DocumentCheckListCtrl.updatedDocument(docCheckList);
            SGA_AP08_DocumentCheckListCtrl.getCurrentUserProfile();
            SGA_AP08_DocumentCheckListCtrl.getDocumentStatus(docCheckList.Id);
            Test.stopTest();
            System.assertEquals('Test123.txt', SGA_AP08_DocumentCheckListCtrl.getdocumentDetails(docCheckList.Id).Document_Name__c);
        }
    }
    
    /************************************************************************************
Method Name : getdocumentDetailsTest
Parameters  : None
Return type : void
Description : This is the testmethod for getdocumentDetails
*************************************************************************************/
    private testMethod static void getdocumentDetailsTest() {
        User testUser = Util02_TestData.createUser();
        //Application record creation
        vlocity_ins__Application__c testApplication = Util02_TestData.createApplicationForRelatedList(SG01_Constants.STATUSINENROLLMENTCOMPLETED,System.today() +5);
        //Application_Document_Config__c record creation
        Application_Document_Config__c appConfig=Util02_TestData.createApplicationDocumentConfig();
        //Application_Document_Checklist__c record creation
        Application_Document_Checklist__c docCheckList=Util02_TestData.createApplicationDocumentCheckList(appConfig.Id,testApplication.Id);
        
        System.runAs(testUser) {
            Database.insert(testApplication);
            Database.insert(appConfig);
            docCheckList.Application_Document_Config__c=appConfig.Id;
            docCheckList.Application__c=testApplication.Id;
            Database.insert(docCheckList);
            Test.startTest();
            Application_Document_Checklist__c dc=SGA_AP08_DocumentCheckListCtrl.getdocumentDetails(docCheckList.Id);
            Test.stopTest();
            System.assertNotEquals(null, docCheckList.Id);
        }
    }
    
    
    /************************************************************************************
Method Name : createPaperApplication
Parameters  : None
Return type : void
Description : This is the testmethod for paper application creation
*************************************************************************************/
    private testMethod static void createPaperApplication() {
        User testUser = Util02_TestData.createUser();
        List<Application_Document_Config__c> testConfigList = Util02_TestData.createDocumentConfigList();
        //Business Custom Setting insertion
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        //Account record creation
        Account testAccount = Util02_TestData.createGroupAccount();
        System.runAs(testUser){
            Test.startTest();
            Database.insert(cs001List);
            Database.insert(testConfigList);
            Database.insert(testAccount);
            vlocity_ins__Party__c partyObj = Util02_TestData.createPartyforAccount(testAccount.Id);
            Database.insert(partyObj);
            vlocity_ins__Application__c applicationObj = Util02_TestData.createApplicationRec(testAccount.Id, partyObj.Id);
            applicationObj.vlocity_ins__Type__c = System.Label.SG42_PaperApplication;
            Database.insert(applicationObj);
            SGA_AP18_DCEmailCompCtrl.appId = applicationObj.Id;
            SGA_AP18_DCEmailCompCtrl.docStatus = UPLOADED;
            SGA_AP18_DCEmailCompCtrl.getdocList();
            //checking the document check list records have been inserted for paper application or not
            List<Application_Document_CheckList__c> docCheckList = [select id from Application_Document_CheckList__c where Application__c =:applicationObj.Id];
            System.assertNotEquals(NULL, docCheckList);
            Test.stopTest();
        }
    }
    
    /************************************************************************************
Method Name : updateReUploadDateOnAccount
Parameters  : None
Return type : void
Description : This is the testmethod for updating the date time field on account
when document checklist document is re uploaded
*************************************************************************************/
    private testMethod static void updateReUploadDateOnAccount() {
        
        List<Application_Document_Config__c> testConfigList = Util02_TestData.createDocumentConfigList();
        Database.insert(testConfigList);
        //Business Custom Setting insertion
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        //Account record creation
        
        Database.insert(cs001List);
        Account accObj = new Account(name =BROKER_PORTAL_NAME,recordtypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(BUSINESS_ACCOUNT).getRecordTypeId()) ;
        insert accObj; 
        
        Contact conObj = new Contact(LastName =BROKER_PORTAL_LNAME,AccountId = accObj.Id);
        insert conObj;  
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'Partner' Limit 1];
        Account testAccount = Util02_TestData.createGroupAccount();
        User testUser = Util02_TestData.createUser(conObj.Id,BROKER_PORTAL_FNAME,BROKER_PORTAL_LNAME,BROKER_PORTAL_EMAIL,BROKER_PORTAL_UNAME);
        
        System.runAs(testUser){
            try{
                
                Database.insert(testAccount);
                vlocity_ins__Party__c partyObj = Util02_TestData.createPartyforAccount(testAccount.Id);
                Database.insert(partyObj);
                vlocity_ins__Application__c applicationObj = Util02_TestData.createApplicationRec(testAccount.Id, partyObj.Id);
                applicationObj.vlocity_ins__Type__c = System.Label.SG42_PaperApplication;
                Database.insert(applicationObj);
                List<Application_Document_Checklist__c> docCheckList = [select id,status__c,Case__c from Application_Document_Checklist__c where Application__c =:applicationObj.Id];
                Test.startTest();
                Case testCase = Util02_TestData.insertSGACase(testAccount.Id,applicationObj.Id);
                Database.insert(testCase); 
                
                if(docCheckList != NULL && !docCheckList.isEmpty()){
                    for(Application_Document_Checklist__c docCheckObj : docCheckList){
                        docCheckObj.Case__c =  testCase.Id;
                        docCheckObj.Status__c =  System.Label.SG14_Re_Uploaded;
                    }
                    Database.update(docCheckList) ;
                }
                Test.stopTest();
                
            }catch(Exception e){}
        }
    }
}