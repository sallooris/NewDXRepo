@isTest
public class BRPSGCSendDocumentsBackendTest{
    public static vlocity_ins__Application__c  appl;
    public static BRPSGCUploadDocumentController controller;

   static testmethod void testSendDocBackend() {
       List<CS001_RecordTypeBusinessTrack__c> cs001List = BRPUtilTestMethods.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = BRPUtilTestMethods.createCS002Data();
        insert cs002List;
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
        //DC
        //accnt = [SELECT id FROM Account WHERE Name ='TestSmallGroup'];
        accnt = [SELECT name, id FROM Account WHERE Id = :accId];
        Opportunity  opp = BRPUtilTestMethods.CreateOpportunity(accnt);   
        insert opp;     
        Quote  quote = BRPUtilTestMethods.CreateQuote(accnt,opp );
        insert quote;
        List<QuoteLineItem> qtList = BRPUtilTestMethods.CreateQuoteLineItem(quote);
        appl = BRPUtilTestMethods.createApplication(accnt.Id, quote.Id);
        appl.vlocity_ins__Status__c= 'Application Signed, Pending Supporting Documents';
        appl.Payment_Form__c = 'Not Submitted';
        appl.HRA__c = 'Not Submitted';
        insert appl;
        Attachment attachmentPDF1 = BRPUtilTestMethods.createAttachment(appl.Id, 'Employer Application','EmployerApplication.pdf');
        Attachment attachmentPDF2 = BRPUtilTestMethods.createAttachment(appl.Id, 'HRA','HRA.pdf');
        Attachment attachmentPDF3 = BRPUtilTestMethods.createAttachment(appl.Id, 'Payment','EFT.pdf');        
        Test.startTest();   
        insert attachmentPDF1;
        insert attachmentPDF2;
        insert attachmentPDF3;
        Test.stopTest();             
    }

 
    }