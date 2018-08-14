/**********************************************************************************
Class Name   : SGA_AP28_UpdateDateOnAccount_Test
Date Created : 8-Aug-2017
Created By   : IDC Offshore
Description  : This is the test class for SGA_AP28_UpdateLastModifiedDateOnAccount
*********************************************************************************/
@isTest
public class SGA_AP28_UpdateDateOnAccount_Test {
    private static final string QUOTE_NAME = 'TestQuote';
    private static final string PB_NAME = 'Test Price Book';
    private static final string PRODUCT_NAME = 'TestProduct';
    private static final string COV_OPTIONS = 'Medical,Dental,Vision';
    private static final string BRAND = 'EBC';
    private static final string COV_OPTIONS_MOD = 'Medical,Dental';
    private static final string APP_TYPE = 'Online';
    private static final string VISION_TYPE = 'Vision';
    private static final string BENEFIT_LEVEL = 'One';
    private static final string CLASS_SELECTED = '1';
    /************************************************************************************
    Method Name : updateDateonAccountMethod
    Parameters  : None
    Return type : void
    Description : This is the testmethod for updating last modified date on Account
				  for Quote and Application objects.
	*************************************************************************************/
    private testMethod static void updateDateonAccountMethod(){
        
        User testUser = Util02_TestData.createUser();
        System.runAs(testUser){
            Product2 prod1 = new Product2(Name = PRODUCT_NAME, Family = PRODUCT_NAME, IsActive = true, vlocity_ins__Type__c = VISION_TYPE);
            insert prod1;
            
            Id pricebookId = Test.getStandardPricebookId();
            List<PricebookEntry> listPriceBook = new List<PricebookEntry>();
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod1.Id,UnitPrice = 10000, IsActive = true);
            insert standardPrice;
            
            Pricebook2 customPB = new Pricebook2(Name=PB_NAME, isActive=true);
            insert customPB;
            PricebookEntry customPrice = new PricebookEntry(
                Pricebook2Id = customPB.Id, Product2Id = prod1.Id,
                UnitPrice = 12000, IsActive = true);
            insert customPrice;
            
            List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
            insert cs001List; 
            
            Account testAccount = Util02_TestData.createGroupAccount();
            insert testAccount;
            Opportunity testOpp = Util02_TestData.createGrpAccOpportunity();
            testOpp.AccountId = testAccount.Id;
            insert testOpp;
            
            Quote quoteObj = new Quote (Name = QUOTE_NAME , OpportunityId = testOpp.id, Coverage_Options__c = COV_OPTIONS, vlocity_ins__EffectiveDate__c = Date.today(), Brand__c = BRAND, Pricebook2Id = customPB.Id);
            insert quoteObj;
            quoteObj.Coverage_Options__c = COV_OPTIONS_MOD;
            update quoteObj;
            
            List<QuoteLineItem> qliList = new List<QuoteLineItem>();
            QuoteLineItem qli1 = new QuoteLineItem(QuoteId = quoteObj.id , Quantity = 3.00 ,UnitPrice = 12 , PricebookEntryId = customPrice.id, Base_EE__c = 20.00, Base_EE_Child__c = 20.11, Base_EE_Family__c = 11.11, Base_EE_Spouse__c = 3.11,
                                                   Employer_Contribution_Percent__c = 10, Class_Selected__c = CLASS_SELECTED,Tech_MedicalBenefitLevel__c = BENEFIT_LEVEL, Product2Id = prod1.Id);
            qliList.add(qli1);
            insert qliList;
			
			vlocity_ins__Party__c partyObj = Util02_TestData.createPartyforAccount(testAccount.Id);
            Database.insert(partyObj);
            vlocity_ins__Application__c applicationObj = Util02_TestData.createApplicationRec(testAccount.Id, partyObj.Id);
            applicationObj.vlocity_ins__Type__c = System.Label.SG42_PaperApplication;
            Database.insert(applicationObj);
            applicationObj.vlocity_ins__Type__c = APP_TYPE;
            Database.update(applicationObj);
			
            Account acc = [select Id,Tech_Last_App_Created_Modified_Date__c,Tech_Last_Quote_Created_Modified_Date__c from Account where id=:testAccount.id];
            //checking the last modified date of application is populated on account
            System.assertNotEquals(NULL, acc.Tech_Last_App_Created_Modified_Date__c);
            //checking the last modified date of quote is populated on account
            System.assertNotEquals(NULL, acc.Tech_Last_Quote_Created_Modified_Date__c);
        }
    }
   
}