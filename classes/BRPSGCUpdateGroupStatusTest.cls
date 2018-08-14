@isTest
public class BRPSGCUpdateGroupStatusTest {
    public static vlocity_ins__Application__c  appl;
    public static Case caseObj;
    
    static testMethod void testBRPSGCUpdateGroupStatus () 
    {
        List<CS001_RecordTypeBusinessTrack__c> cs001List = BRPUtilTestMethods.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = BRPUtilTestMethods.createCS002Data();
        insert cs002List;
       
        Account  accnt = BRPUtilTestMethods.CreateGroupAccount();
        insert accnt;
        
        String accId = accnt.Id;
        vlocity_ins__Party__c party = BRPUtilTestMethods.CreateParty(accnt.Id);
        insert party;
        
        accnt = [SELECT id FROM Account WHERE Id = :accId];
        
        Opportunity  opp = BRPUtilTestMethods.CreateOpportunity(accnt);   
        insert opp;
             
        Quote  quote = BRPUtilTestMethods.CreateQuote(accnt, opp);
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

        BRPSGCUpdateGroupStatusSupporting.GroupStatusRequest grpReq = new BRPSGCUpdateGroupStatusSupporting.GroupStatusRequest();
        grpReq.appId = appl.Application_Number__c;
        grpReq.ein = 'DS1234567';
        grpReq.caseStage = 'Group Created';
        
        String JsonMsg = JSON.serialize(grpReq);        

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

	    req.requestURI = '/services/apexrest/SGCGroupStatus';  //Request URL
	    req.httpMethod = 'POST';//HTTP Request Type
	    req.requestBody = Blob.valueof(JsonMsg);
	    RestContext.request = req;
	    RestContext.response= res;
	  
        BRPSGCUpdateGroupStatus.GroupStatusResponse results = BRPSGCUpdateGroupStatus.doPost();        
	    Test.stopTest();      
    }
    
    static testMethod void testBRPSGCUpdateGroupStatusNull () 
    {
        List<CS001_RecordTypeBusinessTrack__c> cs001List = BRPUtilTestMethods.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = BRPUtilTestMethods.createCS002Data();
        insert cs002List;
       
        Account  accnt = BRPUtilTestMethods.CreateGroupAccount();
        insert accnt;
        
        String accId = accnt.Id;
        vlocity_ins__Party__c party = BRPUtilTestMethods.CreateParty(accnt.Id);
        insert party;
        
        accnt = [SELECT id FROM Account WHERE Id = :accId];
        
        Opportunity  opp = BRPUtilTestMethods.CreateOpportunity(accnt);   
        insert opp;
             
        Quote  quote = BRPUtilTestMethods.CreateQuote(accnt, opp);
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

        BRPSGCUpdateGroupStatusSupporting.GroupStatusRequest grpReq = new BRPSGCUpdateGroupStatusSupporting.GroupStatusRequest();
        grpReq.appId = appl.Application_Number__c;
        grpReq.ein = '';
        grpReq.caseStage = 'Group Created';
        
        String JsonMsg = JSON.serialize(grpReq);        

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

	    req.requestURI = '/services/apexrest/SGCGroupStatus';  //Request URL
	    req.httpMethod = 'POST';//HTTP Request Type
	    req.requestBody = null; //Blob.valueof(JsonMsg);
	    RestContext.request = req;
	    RestContext.response= res;
	  
        BRPSGCUpdateGroupStatus.GroupStatusResponse results = BRPSGCUpdateGroupStatus.doPost();
        
	    Test.stopTest();      
    }    
}