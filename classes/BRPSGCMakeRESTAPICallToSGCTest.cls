@isTest
public class BRPSGCMakeRESTAPICallToSGCTest{
    public static vlocity_ins__Application__c  appl;
    public static Case caseObj;
     static testmethod void testBRPSGCMakeRESTAPICallToSGCApplicationStatus() {
       List<CS001_RecordTypeBusinessTrack__c> cs001List = BRPUtilTestMethods.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = BRPUtilTestMethods.createCS002Data();
        insert cs002List;
        BRPSGCIntegration__c bRPSGCIntegration = BRPUtilTestMethods.createBRPSGCIntegration();
        insert  bRPSGCIntegration;
        OAuthRESTAPIToken__c oAuthObj = BRPUtilTestMethods.CreateAuth();
        insert oAuthObj;        
        Account  accnt = BRPUtilTestMethods.CreateGroupAccount();
        insert accnt;
        //DS - SGFOA
        String accId = accnt.Id;
        vlocity_ins__Party__c party = BRPUtilTestMethods.CreateParty(accnt.Id);
        insert party;
        //accnt = [SELECT id FROM Account WHERE Name ='TestSmallGroup'];
        accnt = [SELECT id FROM Account WHERE Id = :accId];
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
        appl = BRPUtilTestMethods.GetApplicationObject(appl.Id);
        Test.startTest();  
        BRPSGCMakeRESTAPICallToSGC bRPSGCMakeRESTAPICallToSGC = new BRPSGCMakeRESTAPICallToSGC();    
        bRPSGCMakeRESTAPICallToSGC.CreateApplicationStatusCensusInSGC(appl.Account_Employer_EIN__c, appl.Id, 'XML', '123123123'); 
        Test.stopTest();                  
    }
    
    static testmethod void testBRPSGCMakeRESTAPICallToSGCApplicationCensus() {
       List<CS001_RecordTypeBusinessTrack__c> cs001List = BRPUtilTestMethods.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = BRPUtilTestMethods.createCS002Data();
        insert cs002List;
        BRPSGCIntegration__c bRPSGCIntegration = BRPUtilTestMethods.createBRPSGCIntegration();
        insert  bRPSGCIntegration;
        OAuthRESTAPIToken__c oAuthObj = BRPUtilTestMethods.CreateAuth();
        insert oAuthObj;        
        Account  accnt = BRPUtilTestMethods.CreateGroupAccount();
        insert accnt;
        //DS - SGFOA
        String accId = accnt.Id;
        vlocity_ins__Party__c party = BRPUtilTestMethods.CreateParty(accnt.Id);
        insert party;
        //accnt = [SELECT id FROM Account WHERE Name ='TestSmallGroup'];
        accnt = [SELECT id FROM Account WHERE Id = :accId];
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
        appl = BRPUtilTestMethods.GetApplicationObject(appl.Id);
        Test.startTest();  
        BRPSGCMakeRESTAPICallToSGC bRPSGCMakeRESTAPICallToSGC = new BRPSGCMakeRESTAPICallToSGC();    
        bRPSGCMakeRESTAPICallToSGC.CreateApplicationCensusInSGC(appl.Account_Employer_EIN__c, appl.Id, 'XML', '123123123', ''); 
        Test.stopTest();                  
    }      

    static testmethod void testBRPSGCMakeRESTAPICallToSGCCreateApplicationCensus() {
       List<CS001_RecordTypeBusinessTrack__c> cs001List = BRPUtilTestMethods.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = BRPUtilTestMethods.createCS002Data();
        insert cs002List;
        BRPSGCIntegration__c bRPSGCIntegration = BRPUtilTestMethods.createBRPSGCIntegration();
        insert  bRPSGCIntegration;
        OAuthRESTAPIToken__c oAuthObj = BRPUtilTestMethods.CreateAuth();
        insert oAuthObj;        
        Account  accnt = BRPUtilTestMethods.CreateGroupAccount();
        insert accnt;
        //DS - SGFOA
        String accId = accnt.Id;
        vlocity_ins__Party__c party = BRPUtilTestMethods.CreateParty(accnt.Id);
        insert party;
        //accnt = [SELECT id FROM Account WHERE Name ='TestSmallGroup'];
        accnt = [SELECT id FROM Account WHERE Id = :accId];
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
        appl = BRPUtilTestMethods.GetApplicationObject(appl.Id);
        Test.startTest();  
        BRPSGCMakeRESTAPICallToSGC bRPSGCMakeRESTAPICallToSGC = new BRPSGCMakeRESTAPICallToSGC();    
        bRPSGCMakeRESTAPICallToSGC.CreateApplicationCensusInSGC(appl.Account_Employer_EIN__c, appl.Id, 'XML', '123123123', 'TEST'); 
        Test.stopTest();                  
    }      
    
    static testmethod void testBRPSGCMakeRESTAPICallToSGCUpdateAppCensus() {
       List<CS001_RecordTypeBusinessTrack__c> cs001List = BRPUtilTestMethods.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = BRPUtilTestMethods.createCS002Data();
        insert cs002List;
        BRPSGCIntegration__c bRPSGCIntegration = BRPUtilTestMethods.createBRPSGCIntegration();
        insert  bRPSGCIntegration;
        OAuthRESTAPIToken__c oAuthObj = BRPUtilTestMethods.CreateAuth();
        insert oAuthObj;        
        Account  accnt = BRPUtilTestMethods.CreateGroupAccount();
        insert accnt;
        //DS - SGFOA
        String accId = accnt.Id;
        vlocity_ins__Party__c party = BRPUtilTestMethods.CreateParty(accnt.Id);
        insert party;
        //accnt = [SELECT id FROM Account WHERE Name ='TestSmallGroup'];
        accnt = [SELECT id FROM Account WHERE Id = :accId];
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
        appl = BRPUtilTestMethods.GetApplicationObject(appl.Id);
        
        String appId = appl.Id;
        caseObj = BRPUtilTestMethods.createCaseToSendToSGC(accId, appId);
        
        try
        {
        insert caseObj;
        }
        catch(DMLException d)
        {
            d.getMessage();
        }
        
        String caseId = caseObj.Id;
        
        Test.startTest();  
        BRPSGCMakeRESTAPICallToSGC bRPSGCMakeRESTAPICallToSGC = new BRPSGCMakeRESTAPICallToSGC();    
        bRPSGCMakeRESTAPICallToSGC.UpdateApplicationCensusInSGC(appl.Account_Employer_EIN__c, appl.Id, 'XML', '123123123', caseId); 
        Test.stopTest();                  
    }      

     static testmethod void testBRPSGCMakeRESTAPICallToSGCPayment() {
       List<CS001_RecordTypeBusinessTrack__c> cs001List = BRPUtilTestMethods.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = BRPUtilTestMethods.createCS002Data();
        insert cs002List;
        BRPSGCIntegration__c bRPSGCIntegration = BRPUtilTestMethods.createBRPSGCIntegration();
        insert  bRPSGCIntegration;
        OAuthRESTAPIToken__c oAuthObj = BRPUtilTestMethods.CreateAuth();
        insert oAuthObj;        
        Account  accnt = BRPUtilTestMethods.CreateGroupAccount();
        insert accnt;
        //DS - SGFOA
        String accId = accnt.Id;
        vlocity_ins__Party__c party = BRPUtilTestMethods.CreateParty(accnt.Id);
        insert party;
        //accnt = [SELECT id FROM Account WHERE Name ='TestSmallGroup'];
        accnt = [SELECT id FROM Account WHERE Id = :accId];
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
        appl = BRPUtilTestMethods.GetApplicationObject(appl.Id);
        Test.startTest();  
        BRPSGCMakeRESTAPICallToSGC bRPSGCMakeRESTAPICallToSGC = new BRPSGCMakeRESTAPICallToSGC(); 
        bRPSGCMakeRESTAPICallToSGC.CreatePaymentInSGC(appl.Account_Employer_EIN__c, appl.Id, 'XML', '123123123'); 
        Test.stopTest();                  
    }
             
    public static BRPSGCUploadDocumentHolder getBRPSGCUploadDocumentHolder(Attachment att)
    {
        BRPSGCUploadDocumentHolder brhld = new BRPSGCUploadDocumentHolder();        
        String appIdForSGC = appl.Id;
        appIdForSGC = appIdForSGC.substring(appIdForSGC.length()-9);        
        if((appl.Application_Number__c+'').length() > 5)
        appIdForSGC = appl.Application_Number__c+'ZZZ';
        brhld.AppIdForSGC = appIdForSGC;
        brhld.appId= appl.Id;
        brhld.fstatus = 'PENDING';
        brhld.uploadType = 'Automated';
        brhld.fileSendStatus= 'NOT SENT';
        brhld.EIN = appl.Account_Employer_EIN__c;
        brhld.grpName = appl.Account_Name__c;
        brhld.state = 'CO';//appl.Account_State__c;
        brhld.fname = att.Name;
        brhld.fileContent = att.Body;
        brhld.attachId= att.Id;
        brhld.documentType = 'SGAPP';
        brhld.formType = 'NEWENRL';
        brhld.fname = att.Name;
        brhld.fcategory = 'EmployerApplication';
        brhld.contentType = att.ContentType;
        brhld.fileSize = 2500; //att.BodyLength;
        return brhld;
    }
     public static BRPSGCUploadDocumentHolder getBRPSGCUploadDocumentHolderError(Attachment att)
    {
        BRPSGCUploadDocumentHolder brhld = new BRPSGCUploadDocumentHolder();        
        String appIdForSGC = appl.Id;
        appIdForSGC = appIdForSGC.substring(appIdForSGC.length()-9);        
        if((appl.Application_Number__c+'').length() > 5)
        appIdForSGC = appl.Application_Number__c+'ZZZ';
        brhld.AppIdForSGC = appIdForSGC;
        brhld.appId= appl.Id;
        brhld.fstatus = '';
        brhld.uploadType = '';
        brhld.fileSendStatus= 'NOT SENT';
        brhld.EIN = appl.Account_Employer_EIN__c;
        brhld.grpName = appl.Account_Name__c;
        brhld.state = appl.Account_State__c;
        brhld.fname = att.Name;
        brhld.fileContent = att.Body;
        brhld.attachId= att.Id;
        brhld.documentType = 'SGAPP';
        brhld.formType = 'NEWENRL';
        brhld.fname = att.Name;
        brhld.fcategory = 'EmployerApplication';
        brhld.contentType = att.ContentType;
        brhld.fileSize = att.BodyLength;
        return brhld;
    }
    }