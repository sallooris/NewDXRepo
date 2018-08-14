/***********************************************************************
Class Name   : Util02_TestData_Test
Date Created : 10/10/2017 (mm/dd/yyyy)
Created By   : IDC Offshore
Description  : 1. This is a test class for Util02_TestData
**************************************************************************/
@isTest
private class Util02_TestData_Test {
 /************************************************************************************
    Method Name : testMethod1
    Parameters  : None
    Return type : void
    Description : This is the testmethod for Util02_TestData 
    *************************************************************************************/
     private testMethod static void testMethod1() {
     Account acc= Util02_TestData.insertAccount();
     Lead ledInfo= Util02_TestData.insertLead();
     Postal_Code_County__c postinfo= Util02_TestData.insertZipCode();
     Postal_Code_County__c countinfo= Util02_TestData.insertZipCode1();
     Zip_DOB_Score__c zipDobInfo= Util02_TestData.insertZipDOBScore();
     Household_Member__c hsMember= Util02_TestData.insertHousehold();
     Opportunity opp= Util02_TestData.insertOpportunity();
     User testUser = Util02_TestData.createUser();
     User testUser1 = Util02_TestData.insertUser();
     List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
     List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
     Opportunity opp001= Util02_TestData.createOpportunity(NULL,NULL,NULL);
     Account acc001=Util02_TestData.createGroupAccountForRelatedList();
     Product2 prod2=Util02_TestData.createProduct();
     Pricebook2 price2=Util02_TestData.createPricebook2SGA();
     Case caseinss=Util02_TestData.createSGInstallationCase();
     Case casepeim=Util02_TestData.createSGPEIMCase();
     CaseComment casecmt=Util02_TestData.createCaseComment();
     Application_Document_Config__c docNYconfig=Util02_TestData.createApplicationDocumentConfigNY();
     AccountTeamMember accteam = Util02_TestData.createAccountTeamMember();
     Account_Stage__c accStage = Util02_TestData.insertAccountStage();
     Account grpAcc = Util02_TestData.createGroupAccount();
      Note note1=Util02_TestData.createNote(NULL);
       Geographical_Info__c geoingo=Util02_TestData.createGeoRecord(); 
        Account prepareAcc;
      vlocity_ins__Party__c party;
        System.runAs(testUser){
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.insert(acc); 
            Test.startTest();
            party = Util02_TestData.createPartyforAccount(acc.ID);
            prepareAcc=Util02_TestData.pepareForUpdate(acc,NULL);
            Test.stopTest();
        }
         System.assertNotEquals(NULL,party);
     }
     
    /************************************************************************************
    Method Name : testMethod2
    Parameters  : None
    Return type : void
    Description : This is the testmethod for Util02_TestData 
    *************************************************************************************/
     private testMethod static void testMethod2() {
     Account acc= Util02_TestData.createAccount('Testy1233');
     Contact con= Util02_TestData.createContact('Fn1233', 'ln123','test@test.com', NULL);
     User testUser = Util02_TestData.createUser();
     List<Account_Stage__c> accStageList = Util02_TestData.insertAccountStages();
     List<Account> accList = Util02_TestData.createAccounts();
     List<Task> taskList1 = Util02_TestData.createTasks();
     List<Task> taskList2 = Util02_TestData.createOutboundTasks();
     List<Lead> leadList = Util02_TestData.createBulkLeads();
     List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
     List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
     vlocity_ins__Application__c application001= Util02_TestData.createApplication();
     Quote quote001=Util02_TestData.createQuote();
     Account brokaccacc=Util02_TestData.createBrokerAgentAccount();
     Account brokagaccdata=Util02_TestData.createBrokerAgentAccountData();
     Opportunity opp02=Util02_TestData.createGrpAccOpportunity();
     User user2 = Util02_TestData.createUser(NULL,'UF2n1233', 'Ul2n123','testuser22@test.com','testuser22@test.com');
     System.runAs(testUser){
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.insert(acc); 
            con.AccountID= acc.Id;
            Test.startTest();
            Database.insert(con); 
            user2.ContactId= con.Id;
            Test.stopTest();
            System.assertNotEquals(NULL,con.Id);
      }
     }
     

     
    /************************************************************************************
    Method Name : testMethod3
    Parameters  : None
    Return type : void
    Description : This is the testmethod for Util02_TestData 
    *************************************************************************************/
       private testMethod static void testMethod3() {
        Account acc= Util02_TestData.createAccount('Testy1233');
        User testUser = Util02_TestData.createUser();
        User user22 = Util02_TestData.createByPassUser();
        vlocity_ins__Application__c testApplication =Util02_TestData.createApplicationForRelatedList(SG01_Constants.STATUSINENROLLMENTCOMPLETED, System.today() +5);
        //Application_Document_Config__c record creation
        Application_Document_Config__c appConfig=Util02_TestData.createApplicationDocumentConfig();
        //Application_Document_Checklist__c record creation
        Application_Document_Checklist__c docCheckList=Util02_TestData.createApplicationDocumentCheckList(appConfig.Id,testApplication.Id);
        vlocity_ins__ApplicationPartyRelationship__c appParty=Util02_TestData.createApplicationPartyRelationship(NULL,NULL);
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        System.runAs(testUser) {
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.insert(acc);
            Database.insert(testApplication);
            Database.insert(appConfig);
            docCheckList.Application_Document_Config__c=appConfig.Id;
            docCheckList.Application__c=testApplication.Id;
            Database.insert(docCheckList);
            Test.startTest();
            SGA_AP08_DocumentCheckListCtrl.appId=testApplication.Id;
            List<Application_Document_Checklist__c> docList=SGA_AP08_DocumentCheckListCtrl.getDocumentCheckList(testApplication.Id);
             Util02_TestData.insertSGACase(acc.Id,testApplication.Id);
            Test.stopTest();
            System.assertNotEquals(NULL, user22.Id);
            System.assertEquals(1, docList.size());
            
        }
    }
    
    /************************************************************************************
    Method Name : testMethod4
    Parameters  : None
    Return type : void
    Description : This is the testmethod for Util02_TestData 
    *************************************************************************************/
       private testMethod static void testMethod4() {
         User testUser = Util02_TestData.createUser();
        //Account record creation
        Account testAccount = Util02_TestData.createGroupAccountForRelatedList();
       //vlocity_ins__OmniScript__c record creation
        vlocity_ins__OmniScript__c omniSript=Util02_TestData.createOmniScript(SG01_Constants.SG_QUOTING ,SG01_Constants.SUBTYPE_NEWYORK1 );
        //Business Custom Setting insertion
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        //Record Type Assignment Custom Setting insertion
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        System.runAs(testUser){
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.insert(testAccount);
            Database.insert(omniSript);
            Test.startTest();
            vlocity_ins__OmniScriptInstance__c omniSriptIntance=Util02_TestData.createOmniScriptInstance(testAccount,SG01_Constants.ACCOUNT ,omniSript.Id,SG01_Constants.STATUSINPROGRESS);
            Database.insert(omniSriptIntance);
            Test.stopTest();
            System.assertNotEquals(null, omniSript.Id);
        }
       }
       
    /************************************************************************************
    Method Name : testMethod5
    Parameters  : None
    Return type : void
    Description : This is the testmethod for Util02_TestData 
    *************************************************************************************/
       private testMethod static void testMethod5() {
        User testUser = Util02_TestData.createUser();
        User user22 = Util02_TestData.createByPassUser();
        vlocity_ins__Application__c testApplication =Util02_TestData.createApplicationForRelatedList(SG01_Constants.STATUSINENROLLMENTCOMPLETED, System.today() +5);
        //Application_Document_Config__c record creation
        Application_Document_Config__c appConfig=Util02_TestData.createApplicationDocumentConfig();
        //Application_Document_Checklist__c record creation
      
        vlocity_ins__ApplicationPartyRelationship__c appParty=Util02_TestData.createApplicationPartyRelationship(NULL,NULL);
         Application_Document_Checklist__c docCheckList=Util02_TestData.createApplicationDocumentCheckList(NULL,NULL);
        System.runAs(testUser) {
            Database.insert(testApplication);
            Database.insert(appConfig);
           docCheckList=Util02_TestData.createApplicationDocumentCheckList(appConfig.Id,testApplication.Id);
            Database.insert(docCheckList);
            Test.startTest();
           
            List<Application_Document_Checklist__c> apDoc=Util02_TestData.createAppDocumentCheckList(appConfig.Id,testApplication.Id);
            Test.stopTest();  
            System.assertNotEquals(NULL, docCheckList.Id);
         
         }
       }
       
    /************************************************************************************
    Method Name : testMethod6
    Parameters  : None
    Return type : void
    Description : This is the testmethod for Util02_TestData 
    *************************************************************************************/
       private testMethod static void testMethod6() {
         User testUser = Util02_TestData.createUser();
        Id standardPBId = Test.getStandardPricebookId();
        Product2 prod1 = Util02_TestData.createProduct();
        Pricebook2 customPB=Util02_TestData.createPricebook2SGA();
        Account testAcc = Util02_TestData.createGroupAccount();
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        vlocity_ins__Application__c testApplication = Util02_TestData.createApplicationForRelatedList(SG01_Constants.STATUSINENROLLMENTCOMPLETED, NULL);
        ID oppRT =[select Id,Name from Recordtype where Name = 'SG Quoting' and SobjectType = 'Opportunity'].Id;
        Opportunity testOpp=Util02_TestData.createGrpAccOpportunity();
        Util02_TestData.createDocusignSubjectValues();
        Util02_TestData.createStateSpecificDetails();
        Util02_TestData.createBrokerDatesCustomSettings();
        Util02_TestData.createProductsForSGA();
        Util02_TestData.createDocumentConfigList();
        Util02_TestData.createApplicationRec(NULL,NULL);
        Quote qt;
        System.runAs(testUser){
            
        Database.insert(prod1);
        Database.insert(customPB);
        
        PricebookEntry pbEntry = Util02_TestData.createPricebookEntrySGA(prod1.Id,standardPBId,false);
        
        Database.insert(pbEntry);
        Database.insert(cs001List);
        Database.insert(cs002List);
        Database.insert(testAcc);
        
        Database.insert(testApplication);
        // attach application to Account 
        testApplication.vlocity_ins__AccountId__c=testAcc.Id;
        Database.update(testApplication);
        
        testOpp.accountid=testAcc.id;
        testOpp.recordtypeId = oppRT ;   
        
        AP08_RestrictMultipleOpenOpportunities.isFirstRunOPPBeforeInsert = true;
        Database.insert(testOpp);
        
         Test.startTest();
        qt= Util02_TestData.createQuoteSGA( NULL,Date.today(),customPB.Id,'EBC');
         Test.stopTest();
         System.assertNotEquals(NULL, qt);
         }
         
      }
       
}