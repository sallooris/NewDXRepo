@isTest
public class BRPSendQuotePDFToSGCTest{
    public static vlocity_ins__Application__c  appl;


    static testmethod void testGenerateQuotePDF() {
       List<CS001_RecordTypeBusinessTrack__c> cs001List = BRPUtilTestMethods.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = BRPUtilTestMethods.createCS002Data();
        insert cs002List;
         SmallGroupSIC__c sic = BRPUtilTestMethods.CreateSIC();
         insert sic;       
       Test.setMock(HttpCalloutMock.class, new BRPMockHttpResponseGenerator());     
        BRPSGCIntegration__c bRPSGCIntegration = BRPUtilTestMethods.createBRPSGCIntegration();
        insert  bRPSGCIntegration;
        OAuthRESTAPIToken__c oAuthObj = BRPUtilTestMethods.CreateAuth();
        insert oAuthObj;       
        Account  accnt = BRPUtilTestMethods.CreateGroupAccount();
        insert accnt;
        //	DC
        String accId = accnt.Id;
        // DC
        vlocity_ins__Party__c party = BRPUtilTestMethods.CreateParty(accnt.Id);
        insert party;
        // DC
//        accnt = [SELECT id FROM Account WHERE Name ='TestSmallGroup'];
		accnt = [SELECT name, id FROM Account WHERE Id = :accId];        
        Opportunity  opp = BRPUtilTestMethods.CreateOpportunity(accnt);   
        insert opp;     
        Quote  quote = BRPUtilTestMethods.CreateQuote(accnt,opp );
        insert quote;
        List<QuoteLineItem> qtList = BRPUtilTestMethods.CreateQuoteLineItemForPDF(quote);

        BRPSendQuotePDFToSGC  bRPSendQuotePDFToSGC  = new BRPSendQuotePDFToSGC  ();
        Test.startTest();    
        boolean status = bRPSendQuotePDFToSGC.GenerateQuotePDF(quote.Id);
        System.assertEquals(status,true);
        Test.stopTest();                  
    } 
        static testmethod void testGenerateQuotePDFFail() {       
        BRPSendQuotePDFToSGC  bRPSendQuotePDFToSGC  = new BRPSendQuotePDFToSGC  ();
        Test.startTest();    
        boolean status = bRPSendQuotePDFToSGC.GenerateQuotePDF(null);
        System.assertEquals(status,false);
        Test.stopTest();                  
    } 
    }