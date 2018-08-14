/**********************************************************************
Class Name   : BAP02_SMCXMLToExactTarget_Test
Date Created : 028-Oct-2015
Created By   : Bhaskar
Description  : Test class
Referenced/Used in : BAP02_SMCXMLToExactTarget
**********************************************************************/
@isTest
Public Class BAP02_SMCXMLToExactTarget_Test
{
    
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
        Test.StartTest();
        BAP02_SMCXMLToExactTarget b = new BAP02_SMCXMLToExactTarget();
        b.str_SOQL += ' LIMIT 200';
        Database.ExecuteBatch(b, 1);
        Test.StopTest();
    }
    static TestMethod void TestSchedulableClass()
    {
        Test.StartTest();
        SCAP02_SMCXMLToExactTarget sh = new SCAP02_SMCXMLToExactTarget();
        String schedule = '0 5 * * * ?';
        system.schedule('Exact Target', schedule, sh );
        Test.StopTest();
    }
}