/**********************************************************************************
Class Name :   SGA_AP11_GenerateAndAttachQuotePDF_Test
Date Created : 13-June-2017
Created By   : IDC Offshore
Description  : 1. This class is the test class for SGA_AP11_GenerateAndAttachQuotePDF
Change History : 
*************************************************************************************/
@isTest
private class SGA_AP10_AttachQuotePDFToQuote_Test {
    /**
* Method Name : createQuoteFromOmniscript
* Description : This is the test method for calling the quote pdf creation logic from Omniscript.
**/
    private static testMethod void createQuoteFromOmniscript() {
        User testUser = Util02_TestData.createUser();
        System.runAs(testUser){
            //product creation
            List<Product2> pList = Util02_TestData.createProductsForSGA();
            Database.insert(pList);
            //priccebook id fetching
            Id pricebookId = Test.getStandardPricebookId();
            //PriceBookEntry creation
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = pList[0].Id,UnitPrice = 10000, IsActive = true);
            Database.insert(standardPrice);
            
            //PriceBook creation
            PriceBook2 customPB = Util02_TestData.createPricebook2SGA();
            Database.insert(customPB);
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
            
            System.assertNotEquals(NULL, testAcc.Id);
            
            //populating account id to opportunity
            testOpp.accountid=testAcc.id;
            testOpp.recordtypeId = oppRT ;      
            AP08_RestrictMultipleOpenOpportunities.isFirstRunOPPBeforeInsert = true;
            Database.insert(testOpp);
            
            System.assertNotEquals(NULL, testOpp.Id);
            
            //Quote Creation
            Quote q = Util02_TestData.createQuote();
            q.OpportunityId = testOpp.id;
            q.Pricebook2Id = customPB.Id;
            Database.insert(q);
            
            System.assertNotEquals(NULL, q.Id);
            
            Map<String,Object> inputMap = new Map<String,Object>();
            Map<String,Object> outMap = new Map<String,Object>();
            Map<String,Object> options = new Map<String,Object>();
            
            inputMap.put(SG01_Constants.DRID_QUOTE,q.Id);
            
            SGA_AP10_AttachQuotePDFToQuote attachQuotePdfObj = new SGA_AP10_AttachQuotePDFToQuote();
            attachQuotePdfObj.invokeMethod(SG01_Constants.ATTACH_PDF_METHOD, inputMap, outMap, options);
            attachQuotePdfObj.invokeMethod(SG01_Constants.ATTACH_PDF_METHOD, NULL, outMap, options);
        }
        
        
    }
}