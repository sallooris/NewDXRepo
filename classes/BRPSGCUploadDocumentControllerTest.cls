@isTest  // CM 09302016  Commenting Out Code
public class BRPSGCUploadDocumentControllerTest{ 
    public static vlocity_ins__Application__c  appl;
    public static BRPSGCUploadDocumentController controller;

    static testmethod void testDocUpload() {
       List<CS001_RecordTypeBusinessTrack__c> cs001List = BRPUtilTestMethods.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = BRPUtilTestMethods.createCS002Data();
        insert cs002List;        
        BRPSGCIntegration__c bRPSGCIntegration = BRPUtilTestMethods.createBRPSGCIntegration();
        insert  bRPSGCIntegration; 
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
        List<QuoteLineItem> qtList = BRPUtilTestMethods.CreateQuoteLineItem(quote);
        appl = BRPUtilTestMethods.createApplication(accnt.Id, quote.Id);
        insert appl;
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new BRPMockHttpResponseGenerator());
        Test.setCurrentPageReference(new PageReference('Page.BRP SGC Upload Document'));
        String applId = appl.Id;
        System.currentPageReference().getParameters().put('ApplicationId', applId);                    
        ApexPages.StandardController sc = new ApexPages.standardController(appl);
        controller = new BRPSGCUploadDocumentController (sc);           
        testDocUploadToSGC(); 
        Test.stopTest();             
    }

    static testmethod void testDocUploadErrorTest() {
       List<CS001_RecordTypeBusinessTrack__c> cs001List = BRPUtilTestMethods.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = BRPUtilTestMethods.createCS002Data();
        insert cs002List;
        BRPSGCIntegration__c bRPSGCIntegration = BRPUtilTestMethods.createBRPSGCIntegration();
        insert  bRPSGCIntegration; 
        Account  accnt = BRPUtilTestMethods.CreateGroupAccount();
        insert accnt;
        vlocity_ins__Party__c party = BRPUtilTestMethods.CreateParty(accnt.Id);
        insert party;
        // DC
        //accnt = [SELECT id FROM Account WHERE Name ='TestSmallGroup'];
        accnt = [SELECT id,name FROM Account WHERE Id =:accnt.Id];
        Opportunity  opp = BRPUtilTestMethods.CreateOpportunity(accnt);   
        insert opp;     
        Quote  quote = BRPUtilTestMethods.CreateQuote(accnt,opp );
        insert quote;
        List<QuoteLineItem> qtList = BRPUtilTestMethods.CreateQuoteLineItem(quote);
        appl = BRPUtilTestMethods.createApplication(accnt.Id, quote.Id);
        insert appl;
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new BRPMockHttpResponseGenerator());
        Test.setCurrentPageReference(new PageReference('Page.BRP SGC Upload Document'));
        String applId = appl.Id;
        System.currentPageReference().getParameters().put('ApplicationId', applId);                    
        ApexPages.StandardController sc = new ApexPages.standardController(appl);
        controller = new BRPSGCUploadDocumentController (sc);           
        System.currentPageReference().getParameters().put('hasError', 'true');      
        System.currentPageReference().getParameters().put('errorMessage', 'errorMessage');      
       testDocUploadWithError();   
        Test.stopTest();             
    }

    static void testDocUploadToSGC() {        
 
        for(BRPSGCUploadDocumentHolder bRPSGCUploadDocumentHolder:controller.fileHolder){
            String myString = 'StringToBlob';
            Blob myBlob = Blob.valueof(myString);        
            bRPSGCUploadDocumentHolder.fileContent = myBlob;   
            bRPSGCUploadDocumentHolder.fname = 'AK.XLS';
            bRPSGCUploadDocumentHolder.contentType = 'PDF';  
            bRPSGCUploadDocumentHolder.fstatus = 'Submitted';   
            bRPSGCUploadDocumentHolder.fileSize = 123;           
            }
            controller.SaveDoc();       
      }
   static void testDocUploadToSGCStatusNull() {        
 
        for(BRPSGCUploadDocumentHolder bRPSGCUploadDocumentHolder:controller.fileHolder){
            String myString = 'StringToBlob';
            Blob myBlob = Blob.valueof(myString);        
            bRPSGCUploadDocumentHolder.fileContent = myBlob;   
            bRPSGCUploadDocumentHolder.fname = 'AK.XLS';
            bRPSGCUploadDocumentHolder.contentType = 'PDF';  
            bRPSGCUploadDocumentHolder.fstatus = null;   
            bRPSGCUploadDocumentHolder.fileSize = 123;           
            }
            controller.SaveDoc();       
            // 
      }   
    static void testDocUploadWithError() {                
        controller.SaveDoc();       
    }
        static void testDocUploadToSGCCensus() {        
 
        for(BRPSGCUploadDocumentHolder bRPSGCUploadDocumentHolder:controller.fileHolder){
            if(bRPSGCUploadDocumentHolder.fcategory == 'Census Tool Spreadsheet')
            {
                String myString = 'StringToBlob';
                Blob myBlob = Blob.valueof(myString);        
                bRPSGCUploadDocumentHolder.fileContent = myBlob;   
                bRPSGCUploadDocumentHolder.fname = 'AK.PDF';
                bRPSGCUploadDocumentHolder.contentType = 'PDF';  
                bRPSGCUploadDocumentHolder.fstatus = 'Submitted';   
                bRPSGCUploadDocumentHolder.fileSize = 123;           
                }
            }
            controller.SaveDoc();       
            // 
       }
    }