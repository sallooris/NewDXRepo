@isTest   // CM 09302016 Commenting out Code 
public class BRPSGCUploadGroupQuoteDataTest{
//DS - -SGFOA
public static vlocity_ins__Application__c  appl;
public static Case caseObj;
    static testmethod void testsendQuoteToSMCRealLife() {
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
        //  DC
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
        appl = BRPUtilTestMethods.createApplicationToSendToSGC(accnt.Id, quote.Id);
        appl.Member_Count__c=10;
        appl.vlocity_ins__Status__c = 'Group Created';
        insert appl;
        
        //DS - -SGFOA
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
        Test.setMock(HttpCalloutMock.class, new BRPMockHttpResponseGenerator());
        
        BRPSGCUploadGroupQuoteData BRPSGCUploadGroupQuoteData1 = new BRPSGCUploadGroupQuoteData();
        BRPSGCUploadGroupQuoteData1.sendDataToSGC(appId, true, false, appl);
        BRPSGCUploadGroupQuoteData1.CreateApplicationCaseStatus(appId, false);
        BRPSGCUploadGroupQuoteData1.CreateApplicationCaseStatus(caseId, true);
        Test.stopTest();                             
    } 
    static testmethod void testsendCaseStatus() {
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
        //  DC
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
        appl = BRPUtilTestMethods.createApplicationToSendToSGC(accnt.Id, quote.Id);
        appl.Member_Count__c=10;
        insert appl;
        //DS - -SGFOA
        String appId = appl.Id;
        caseObj = BRPUtilTestMethods.createCaseToSendToSGC(accId, appId);
        caseObj.Underwriter_Notes__c = 'Some Text & % $ @ < >';
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
        Test.setMock(HttpCalloutMock.class, new BRPMockHttpResponseGenerator());
        
        BRPSGCUploadGroupQuoteData BRPSGCUploadGroupQuoteData1 = new BRPSGCUploadGroupQuoteData();
        BRPSGCUploadGroupQuoteData1.sendDataToSGC(caseId, false, true, null);
        Test.stopTest();                             
    } 
    static testmethod void testsendQuoteToSMCAlternative() {
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
        appl.WritingAgentETIN__c = null;
        appl.Paid_Agency_ETIN__c = null;
        appl.Parent_Agency_ETIN__c = null;
        appl.Member_Count__c=null;
        appl.Group_Coverage_Date__c = system.today();
        appl.SGC_Application_Status__c = 'SUCCESS';
        appl.vlocity_ins__Type__c='ELECTRONIC';
        appl.vlocity_ins__Status__c = 'Group Created';
        appl.Current_Status_Date__c = date.today();
        appl.Date_Application_Signed_Under_Review__c = date.today();
        appl.Num_of_Eligible_Full_Time_Employees__c = 10.0;       
        
        insert appl;        
        vlocity_ins__Application__c oldApp = appl;
        oldApp.vlocity_ins__Status__c = 'Group Returned';
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new BRPMockHttpResponseGenerator());
        BRPSGCUploadGroupQuoteData bRPSGCUploadGroupQuoteData = new BRPSGCUploadGroupQuoteData();
        bRPSGCUploadGroupQuoteData.sendDataToSGC(appl.Id, true, false, oldApp);
        Test.stopTest();                             
    } 
    static testmethod void testsendQuoteToSMCException() {
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
        vlocity_ins__Party__c party = BRPUtilTestMethods.CreateParty(accnt.Id);
        insert party;
//        accnt = [SELECT id FROM Account WHERE Name ='TestSmallGroup'];
        accnt = [SELECT id,name FROM Account WHERE Id =:accnt.Id];
        Opportunity  opp = BRPUtilTestMethods.CreateOpportunity(accnt);   
        insert opp;     
        Quote  quote = BRPUtilTestMethods.CreateQuote(accnt,opp );
        insert quote;
        List<QuoteLineItem> qtList = BRPUtilTestMethods.CreateQuoteLineItem(quote);
        appl = BRPUtilTestMethods.createApplication(accnt.Id, quote.Id);
        appl.WritingAgentETIN__c = null;
        appl.Paid_Agency_ETIN__c = null;
        appl.Parent_Agency_ETIN__c = null;
        appl.Member_Count__c=null;
        appl.Group_Coverage_Date__c = system.today();
        insert appl;
        Test.startTest();   
        BRPSGCUploadGroupQuoteData bRPSGCUploadGroupQuoteData = new BRPSGCUploadGroupQuoteData();
        bRPSGCUploadGroupQuoteData.sendDataToSGC(null, true, false, new vlocity_ins__Application__c());
        Test.stopTest();                             
    } 
}