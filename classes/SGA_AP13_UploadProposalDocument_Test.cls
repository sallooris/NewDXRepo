/************************************************************************
Class Name   : SGA_AP13_UploadProposalDocument_Test
Date Created : 19-June-2017
Created By   : IDC Offshore
Description  : 1. This is a test class for SGA_AP13_UploadProposalDocument
**************************************************************************/
@isTest
private class SGA_AP13_UploadProposalDocument_Test {
    /************************************************************************************
Method Name : createDocumentChecklistTest
Parameters  : None
Return type : void
Description : This is the testmethod for document check list creation and updating 
quote document
*************************************************************************************/
    private testMethod static void createDocumentChecklistTest() {
        User testUser = Util02_TestData.createUser();
        System.runAs(testUser){
            //custom setting data creation
            List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
            Database.insert(cs001List); 
            List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
            Database.insert(cs002List);
            
            //account record insertion
            Account testAcc = Util02_TestData.createGroupAccount();
            //Opportunity record insertion
            Opportunity testOpp=Util02_TestData.createGrpAccOpportunity();
            //account stages and opportunity stages insertion
            List<Account_Stage__c> astage = Util02_TestData.insertAccountStages();
            Database.insert(astage);
            
            //fetching opportunity record type details
            Id oppRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(SG01_Constants.SG_QUOTING).getRecordTypeId();
            //Inserting account
            Database.insert(testAcc);
            
            
            
            //populating account id to opportunity
            testOpp.accountid=testAcc.id;
            testOpp.recordtypeId = oppRT ;      
            AP08_RestrictMultipleOpenOpportunities.isFirstRunOPPBeforeInsert = true;
            Database.insert(testOpp);
            
            
            //Quote Creation
            Quote q = Util02_TestData.createQuote();
            q.OpportunityId = testOpp.id;
            Database.insert(q);
            
            PageReference pageRef = Page.QuotePdf;
            Test.setCurrentPage(pageRef);
            SGA_AP11_GenerateAndAttachQuotePDF con= new SGA_AP11_GenerateAndAttachQuotePDF(new ApexPages.StandardController(q));
            con.attachQuoteFromOmniScript();
            
            //Application record creation
            vlocity_ins__Application__c testApplication = Util02_TestData.createApplicationForRelatedList(SG01_Constants.STATUSINENROLLMENTCOMPLETED,System.today() +5);
            testApplication.vlocity_ins__QuoteId__c = q.Id;
            //Application_Document_Config__c record creation
            Application_Document_Config__c appConfig=Util02_TestData.createApplicationDocumentConfig();
            //Application_Document_Checklist__c record creation
            List<Application_Document_Checklist__c> docCheckList=Util02_TestData.createAppDocumentCheckList(appConfig.Id,testApplication.Id);
            
            Test.startTest();
            Database.insert(testApplication);
            Database.insert(appConfig);
            for(Application_Document_Checklist__c adc : docCheckList){
                adc.Application_Document_Config__c=appConfig.Id;
                adc.Application__c=testApplication.Id;
            }
            Database.insert(docCheckList);
            Test.stopTest();
            //System.debug('dc in getdocumentDetailsTest '+dc);
            System.assertNotEquals(null, docCheckList[0].Id);
            System.assertNotEquals(NULL, testAcc.Id);
            System.assertNotEquals(NULL, testOpp.Id);
        }
        
    }
}