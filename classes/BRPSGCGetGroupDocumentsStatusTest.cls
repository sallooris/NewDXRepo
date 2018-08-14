@isTest  // CM 09302016  Commenting Out Code
public with sharing class BRPSGCGetGroupDocumentsStatusTest 
{
  public static vlocity_ins__Application__c  appl;
    static testmethod void testGetDocListStatus() {
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
        appl.Member_Count__c=10;
        insert appl;
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new BRPMockHttpResponseGenerator());
        BRPSGCGetGroupDocumentsStatus BRPSGCGetGroupDocumentsStatus= new BRPSGCGetGroupDocumentsStatus();
        BRPSGCGetGroupDocumentsStatus.getApplicationDocStatusFromSGC(appl.Id);
        appl = BRPUtilTestMethods.getApplication(appl.Id);
        String statusDesc = appl.SGC_Application_Status__c;
        boolean status = false;
        if(statusDesc.contains('RECEIVED')) status = true;
        System.assertEquals(true,status);
        Test.stopTest();                             
    } 
    static testmethod void testGetDocListStatusError200() {
        List<CS001_RecordTypeBusinessTrack__c> cs001List = BRPUtilTestMethods.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = BRPUtilTestMethods.createCS002Data();
        insert cs002List;
        BRPSGCIntegration__c bRPSGCIntegration = BRPUtilTestMethods.createBRPSGCIntegration();
        bRPSGCIntegration.Get_Applications_Status__c= 'http://appstatuserror200';
        insert  bRPSGCIntegration; 
        Account  accnt = BRPUtilTestMethods.CreateGroupAccount();
        insert accnt;
        vlocity_ins__Party__c party = BRPUtilTestMethods.CreateParty(accnt.Id);
        insert party;
        // DC
//        accnt = [SELECT id FROM Account WHERE Name ='TestSmallGroup'];
        accnt = [SELECT id, name FROM Account WHERE Id =:accnt.Id ];
        Opportunity  opp = BRPUtilTestMethods.CreateOpportunity(accnt);   
        insert opp;     
        Quote  quote = BRPUtilTestMethods.CreateQuote(accnt,opp );
        insert quote;
        List<QuoteLineItem> qtList = BRPUtilTestMethods.CreateQuoteLineItem(quote);
        appl = BRPUtilTestMethods.createApplication(accnt.Id, quote.Id);
        appl.Member_Count__c=10;
        insert appl;
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new BRPMockHttpResponseGenerator());
        BRPSGCGetGroupDocumentsStatus BRPSGCGetGroupDocumentsStatus= new BRPSGCGetGroupDocumentsStatus();
        BRPSGCGetGroupDocumentsStatus.getApplicationDocStatusFromSGC(appl.Id);
        appl = BRPUtilTestMethods.getApplication(appl.Id);
        String statusDesc = appl.SGC_Application_Status__c;
        boolean status = false;
        if(statusDesc.contains('RECEIVED')) status = true;
        System.assertEquals(false,status);
        Test.stopTest();                            
    } 
    static testmethod void testGetDocListStatus400() {
        List<CS001_RecordTypeBusinessTrack__c> cs001List = BRPUtilTestMethods.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = BRPUtilTestMethods.createCS002Data();
        insert cs002List;
        BRPSGCIntegration__c bRPSGCIntegration = BRPUtilTestMethods.createBRPSGCIntegration();
        bRPSGCIntegration.Get_Applications_Status__c= 'http://appstatuserror400';
        insert  bRPSGCIntegration; 
        Account  accnt = BRPUtilTestMethods.CreateGroupAccount();
        insert accnt;
        vlocity_ins__Party__c party = BRPUtilTestMethods.CreateParty(accnt.Id);
        insert party;
		// DC
//        accnt = [SELECT id FROM Account WHERE Name ='TestSmallGroup'];
        accnt = [SELECT id,name FROM Account WHERE Id =:accnt.Id];
        Opportunity  opp = BRPUtilTestMethods.CreateOpportunity(accnt);   
        insert opp;     
        Quote  quote = BRPUtilTestMethods.CreateQuote(accnt,opp );
        insert quote;
        List<QuoteLineItem> qtList = BRPUtilTestMethods.CreateQuoteLineItem(quote);
        appl = BRPUtilTestMethods.createApplication(accnt.Id, quote.Id);
        appl.Member_Count__c=10;
        insert appl;
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new BRPMockHttpResponseGenerator());
        BRPSGCGetGroupDocumentsStatus BRPSGCGetGroupDocumentsStatus= new BRPSGCGetGroupDocumentsStatus();
        BRPSGCGetGroupDocumentsStatus.getApplicationDocStatusFromSGC(appl.Id);
        appl = BRPUtilTestMethods.getApplication(appl.Id);
        String statusDesc = appl.SGC_Application_Status__c;
        boolean status = false;
        if(statusDesc.contains('RECEIVED')) status = true;
        System.assertEquals(false,status);
        Test.stopTest();                            
    } 
    static testmethod void testGetDocListStatusException() {
        Test.startTest();   
        BRPSGCGetGroupDocumentsStatus BRPSGCGetGroupDocumentsStatus= new BRPSGCGetGroupDocumentsStatus();
        BRPSGCGetGroupDocumentsStatus.getApplicationDocStatusFromSGC(null);
        Test.stopTest();                            
    } 
}