/*****************************************************************
* Class Name   : SGA_AP45_StateSpecificDetails_Test
* Created Date : 9/12/2017
* Created By   : IDC Offshore
* Description  : This is test class SGA_AP45_StateSpecificDetails
******************************************************************/
@isTest
private class SGA_AP45_StateSpecificDetails_Test {
    
    /************************************************************************************
    Method Name : stateSpecificDetailsTest
    Parameters  : None
    Return type : void
    Description : This is the testmethod getting Brand,Product Tag Line,Sales Email ID,
                  Configuration Para from SGA_State_Product_Taglines__c
    *************************************************************************************/
    private testMethod static void stateSpecificDetailsTest(){
        User testUser = Util02_TestData.createUser();
        System.runAs(testUser){
            List<SGA_State_Product_Taglines__c> pTagLineList = Util02_TestData.createStateSpecificDetails();
            Database.Insert(pTagLineList);
            
            Test.startTest();
            SGA_AP45_RetrieveStateSpecificDetails stateobj = new SGA_AP45_RetrieveStateSpecificDetails();
            stateobj.stateName1 = pTagLineList[0].Name;
            stateobj.stateName2 = pTagLineList[1].Name;
            stateobj.stateName3 = pTagLineList[2].Name;
            stateobj.stateName4 = pTagLineList[3].Name;
            stateobj.getBrand();
            stateobj.getConfigPara();
            stateobj.getSalesEmail();
            stateobj.getTagLine();
            Test.stopTest();
        }
    }
    /************************************************************************************
    Method Name : productCodesTest
    Parameters  : None
    Return type : void
    Description : This is the testmethod getting product code and names for QuoteLineItem
    *************************************************************************************/
    private static testMethod void productCodesTest() {
        User testUser = Util02_TestData.createUser();
        System.runAs(testUser){
            //product creation
            List<Product2> pList = Util02_TestData.createProductsForSGA();
            Database.insert(pList);
            Id pricebookId = Test.getStandardPricebookId();
            List<PricebookEntry> listPriceBook = new List<PricebookEntry>();
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = pList[0].Id,UnitPrice = 10000, IsActive = true);
            insert standardPrice;
            
            //PriceBook creation
            PriceBook2 customPB = Util02_TestData.createPricebook2SGA();
            Database.insert(customPB);
            PricebookEntry customPrice = new PricebookEntry(
                Pricebook2Id = customPB.Id, Product2Id = pList[0].Id,
                UnitPrice = 12000, IsActive = true);
            insert customPrice;
            
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
            Product2 prod3 = new Product2(Name = 'Testing Product', Family = 'Best Practices', IsActive = true, vlocity_ins__Type__c = 'Medical');
            Database.insert(prod3);
            
            vlocity_ins__Application__c testApplication =Util02_TestData.createApplicationForRelatedList(SG01_Constants.STATUSINENROLLMENTCOMPLETED, System.today() +5);
            Database.insert(testApplication);
            Application_Product__c appPrd1 = new Application_Product__c(Product__c=prod3.Id,Application_Name__c =testApplication.Id);
            Database.Insert(appPrd1);
            
            QuoteLineItem qli = new QuoteLineItem(QuoteId = q.id , Quantity = 3.00 ,UnitPrice = 12 , PricebookEntryId = customPrice.id,  Product2Id = pList[0].Id);
            Insert qli;
            
            SGA_AP45_RetrieveStateSpecificDetails stateobj = new SGA_AP45_RetrieveStateSpecificDetails();
            stateobj.quoteId = q.Id;
            stateobj.appId = testApplication.Id;
            
            stateobj.getProductQuoteLineItems();
        }
        
    }
}