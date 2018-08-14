@isTest
private class AP25_ExactTargetController_Test{
    static TestMethod void CreateAcconutswithTasks()
    {
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        User tstUser = Util02_TestData.insertUser(); 
        Profile txtProfile02 = [SELECT Id FROM Profile WHERE Name ='Representative' Limit 1];
        tstUser.profileID=txtProfile02.id;
        Database.insert(tstUser);
        Licensing__c lcnse = new Licensing__c();
        lcnse.License_Number__c = '12345';
        lcnse.Microsite_URL__c = 'http://testxml.in';
        lcnse.NPN__c = '6464';
        lcnse.Anthem_Producer_Number__c = '34543543';
        lcnse.OwnerId = tstUser.id;
        lcnse.state__c = 'CA';
        insert lcnse;
        List<sObject> ls = Test.loadData(CS004_TaskXmlGenerator__c.sObjectType, 'Test_CS004_TaskGenerationXMLData');
        List<sObject> ls1 = Test.loadData(CS005_SMCXMLGeneration__c.sObjectType, 'Test_CS005_GenerateXMLData');
        List<Task> testAccTasks=new List<Task>();
        List<Task> taskList = new List<Task>();
        id taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Send Fulfillment' AND SobjectType ='Task' LIMIT 1].Id;
        Account aa = Util02_TestData.insertAccount();
        id accRT= [SELECT Id FROM RecordType WHERE Name = 'Person Account' AND SobjectType ='Account' LIMIT 1].Id;
        aa.state__c='CA';
        aa.Billing_State__c='CA';
        aa.recordTypeId = accRT;
           insert aa;
            Task t = new Task();
            t.WhatID = aa.Id;
            t.ActivityDate = System.Today().addDays(1);
            t.Subject = 'Subject'+1;
            t.RecordTypeId = taskRecordTypeId;
            t.email_address__c ='Primary Email';
            t.residence_state__c = 'CA';
            t.Source_External_ID__c = t.id;
            insert t;
            AP22_GenerateTaskXml gtx = new AP22_GenerateTaskXml();
            gtx.insertXmlFields(t,tstUser.id,'insert');
            XML_Generator__c xg = [select id,xml_content__c from XML_Generator__c where tech_task_reference__c =:t.id];
            AP25_ExactTargetController extgt = new AP25_ExactTargetController();
            extgt.retrieveExactTragetData(xg);
            DOM.Document svcResp = new DOM.Document();
            String smcResp = '<?xml version="1.0" encoding="UTF-8"?><soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/08/addressing" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><env:Header xmlns:env="http://www.w3.org/2003/05/soap-envelope"><wsa:Action>CreateResponse</wsa:Action><wsa:MessageID>urn:uuid:3559edd2-ddeb-4691-9d65-b79bacbb90ac</wsa:MessageID><wsa:RelatesTo>urn:uuid:7eecba4e-cdcb-4baf-81de-7b9858a47952</wsa:RelatesTo><wsa:To>http://schemas.xmlsoap.org/ws/2004/08/addressing/role/anonymous</wsa:To><wsse:Security><wsu:Timestamp wsu:Id="Timestamp-88d43412-c9d6-4e9c-9d9e-1361e5dd4ec7"><wsu:Created>2015-10-27T07:19:12Z</wsu:Created><wsu:Expires>2015-10-27T07:24:12Z</wsu:Expires></wsu:Timestamp></wsse:Security></env:Header><soap:Body><CreateResponse xmlns="http://exacttarget.com/wsdl/partnerAPI"><Results xsi:type="TriggeredSendCreateResult" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><StatusCode>OK</StatusCode><StatusMessage>Queued</StatusMessage><OrdinalID>0</OrdinalID><NewID>0</NewID></Results><RequestID>9e866960-701b-4bb4-9764-3b19b6c6cc0d</RequestID><OverallStatus>OK</OverallStatus></CreateResponse></soap:Body></soap:Envelope>';
            svcResp.load(smcResp);
            extgt.parseResponse(svcResp);
            
            DOM.Document svcResp1 = new DOM.Document();
            String smcResp1 = '<?xml version="1.0" encoding="UTF-8"?><soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/08/addressing" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><env:Header xmlns:env="http://www.w3.org/2003/05/soap-envelope"><wsa:Action>CreateResponse</wsa:Action><wsa:MessageID>urn:uuid:3559edd2-ddeb-4691-9d65-b79bacbb90ac</wsa:MessageID><wsa:RelatesTo>urn:uuid:7eecba4e-cdcb-4baf-81de-7b9858a47952</wsa:RelatesTo><wsa:To>http://schemas.xmlsoap.org/ws/2004/08/addressing/role/anonymous</wsa:To><wsse:Security><wsu:Timestamp wsu:Id="Timestamp-88d43412-c9d6-4e9c-9d9e-1361e5dd4ec7"><wsu:Created>2015-10-27T07:19:12Z</wsu:Created><wsu:Expires>2015-10-27T07:24:12Z</wsu:Expires></wsu:Timestamp></wsse:Security></env:Header><soap:Body><CreateResponse xmlns="http://exacttarget.com/wsdl/partnerAPI"><Results xsi:type="TriggeredSendCreateResult" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><StatusCode>ERROR</StatusCode><StatusMessage>INVALID REQUEST</StatusMessage><OrdinalID>0</OrdinalID><NewID>0</NewID></Results><RequestID>9e866960-701b-4bb4-9764-3b19b6c6cc0d</RequestID><OverallStatus>OK</OverallStatus></CreateResponse></soap:Body></soap:Envelope>';
            svcResp1.load(smcResp1);
            extgt.parseResponse(svcResp1);
            
            DOM.Document faultSMCResp = new DOM.Document();
            String faultResp = '<?xml version="1.0" encoding="UTF-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/08/addressing" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><soap:Header><wsa:Action>http://schemas.xmlsoap.org/ws/2004/08/addressing/fault</wsa:Action><wsa:MessageID>urn:uuid:91d5b2bb-f909-4684-86e8-d5641fd96f70</wsa:MessageID><wsa:RelatesTo>urn:uuid:55291954-52fc-4e36-9b9e-908042c02d96</wsa:RelatesTo><wsa:To>http://schemas.xmlsoap.org/ws/2004/08/addressing/role/anonymous</wsa:To><wsse:Security><wsu:Timestamp wsu:Id="Timestamp-6aecd05b-fe8e-48a4-ad0b-d3756047a0a9"><wsu:Created>2015-10-28T12:40:05Z</wsu:Created><wsu:Expires>2015-10-28T12:45:05Z</wsu:Expires></wsu:Timestamp></wsse:Security></soap:Header><soap:Body><soap:Fault><faultcode>soap:Client</faultcode><faultstring>Authorization Failed</faultstring><faultactor>https://webservice.exacttarget.com/Service.asmx</faultactor><env:Detail xmlns:env="http://www.w3.org/2003/05/soap-envelope"><apifault xmlns="urn:fault.partner.exacttarget.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><Code>11</Code><Message>Authorization Failed</Message></apifault></env:Detail></soap:Fault></soap:Body></soap:Envelope>';
            faultSMCResp.load(faultResp);
            extgt.parseResponse(faultSMCResp);       
   }
}