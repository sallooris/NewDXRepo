@isTest
/************************************************************************************
Class Name   : SGA_AP38_SendEmailToTrueBlue_Test
Created Date : 8/24/2017
Created By   : IDC Offshore
Description  : This is the test class for SGA_AP38_SendEmailToTrueBlue class
*************************************************************************************/
private class SGA_AP38_SendEmailToTrueBlue_Test {
    private static final string TEST_NAME = 'Test';
    private static final string TEST_EMAIL = 'test@test.com';
    private static final string SHARE_TYPE = 'V';
    private static final string FILE_NAME = 'Test.jpg';
    /************************************************************************************
    Method Name : sendEmailToTrueBlueTeamTest
    Parameters  : None
    Return type : void
    Description : This is the testmethod for sendemail to true blue team
    *************************************************************************************/
    private testMethod static void sendEmailToTrueBlueTeamTest() {
        User testUser = Util02_TestData.createUser();
        Account testAcc = Util02_TestData.createGroupAccount();
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        Case testCase = Util02_TestData.createSGPEIMCase();
        vlocity_ins__Application__c testApplication = Util02_TestData.createApplicationForRelatedList('Application Created', NULL);
        System.runAs(testUser){
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.insert(testAcc);
            
            database.insert(testApplication);
            //Application_Document_Config__c record creation
            Application_Document_Config__c appConfig=Util02_TestData.createApplicationDocumentConfig();
            Database.insert(appConfig);
            //Application_Document_Checklist__c record creation
            Application_Document_Checklist__c docCheckList=Util02_TestData.createApplicationDocumentCheckList(appConfig.Id,testApplication.Id);
            docCheckList.Document_Name__c = System.Label.SG23_EmployerApplication;
            Insert docCheckList;
            Opportunity testOpp=Util02_TestData.createGrpAccOpportunity();
            List<Account_Stage__c> astage = Util02_TestData.insertAccountStages();
            Database.insert(astage);
            
            
            ID oppRT =[select Id,Name from Recordtype where Name = 'SG Quoting' and SobjectType = 'Opportunity'].Id;
            testOpp.accountid=testAcc.id;
            testOpp.recordtypeId = oppRT ;      
            AP08_RestrictMultipleOpenOpportunities.isFirstRunOPPBeforeInsert = true;
            Database.insert(testOpp);
            Quote quoteObj = Util02_TestData.createQuote();
            quoteObj.OpportunityId = testOpp.Id;
            Database.insert(quoteObj);
            List<QuoteDocument> qdocList = new List<QuoteDocument>();
            QuoteDocument qdoc = new QuoteDocument(quoteId=quoteObj.Id,Document=Blob.valueOf(TEST_NAME));
            qdocList.add(qdoc);
            QuoteDocument qdoc1 = new QuoteDocument(quoteId=quoteObj.Id,Document=Blob.valueOf(TEST_NAME));
            qdocList.add(qdoc1);
            Database.insert(qdocList);
            
            testCase.AccountId = testAcc.Id;
            testCase.Quote_Name__c = quoteObj.Id;
            database.insert(testCase);
            
            List<CaseComment> caseCommentList = new List<CaseComment>();
            CaseComment caseCommObj = new CaseComment();
            caseCommObj.CommentBody = TEST_NAME;
            caseCommObj.ParentId = testCase.Id;
            caseCommentList.add(caseCommObj);
            
            CaseComment caseCommObj1 = new CaseComment();
            caseCommObj1.CommentBody = TEST_NAME;
            caseCommObj1.ParentId = testCase.Id;
            caseCommentList.add(caseCommObj1);
            
            Database.Insert(caseCommentList);
            List<EmailMessage> emailMessageList = new List<EmailMessage>();
            EmailMessage emailMessageObj = new EmailMessage(ParentId=testCase.Id,FromAddress=TEST_EMAIL,Subject=TEST_NAME,
                                                            TextBody=TEST_NAME);
            emailMessageList.add(emailMessageObj);
            EmailMessage emailMessageObj1 = new EmailMessage(ParentId=testCase.Id,FromAddress=TEST_EMAIL,Subject=TEST_NAME,
                                                             TextBody=TEST_NAME);
            emailMessageList.add(emailMessageObj1);
            database.insert(emailMessageList);
            List<Attachment> attachmentList = new List<Attachment>();	
            Attachment att = new Attachment();
            att.Body = Blob.valueOf(TEST_NAME);
            att.ParentId = emailMessageObj.Id;
            att.Name = TEST_NAME;
            attachmentList.add(att);
            Attachment att1 = new Attachment();
            att1.Body = Blob.valueOf(TEST_NAME);
            att1.ParentId = emailMessageObj1.Id;
            att1.Name = TEST_NAME;
            attachmentList.add(att1);
            
            Attachment att2 = new Attachment();
            att2.Body = Blob.valueOf(TEST_NAME);
            att2.ParentId = testCase.Id;
            att2.Name = TEST_NAME;
            attachmentList.add(att2);
            
            Database.Insert(attachmentList);
            
            ContentVersion contentVersion = new ContentVersion(
                Title = TEST_NAME,PathOnClient = FILE_NAME,
                VersionData = Blob.valueOf(TEST_NAME),
                IsMajorVersion = true
            );
            insert contentVersion;    
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument where LatestPublishedVersionId=:contentVersion.Id];
            
            //create ContentDocumentLink  record 
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = testCase.id;
            cdl.ContentDocumentId = documents[0].Id;
            cdl.shareType = SHARE_TYPE;
            insert cdl;
            docCheckList.Case__c = testCase.Id;
            docCheckList.Tech_Content_Document_Id__c = documents[0].Id;
            update docCheckList;
            FeedItem feedItemObj = new FeedItem(ParentId=testCase.Id, Body=TEST_NAME);
            Database.insert(feedItemObj);
            FeedItem feedItemObj1 = new FeedItem(ParentId=testCase.Id, Body=TEST_NAME);
            Database.insert(feedItemObj1);
            Test.startTest();
            Case updateCase = [select id,BR_Category__c,BR_Sub_Category__c from Case Where Id = :testCase.Id];
            updateCase.BR_Category__c = System.Label.SG66_OtherDepartment;
            updateCase.BR_Sub_Category__c = System.Label.SG67_TrueBlue;
            Database.Update(updateCase);  
            Test.stopTest();
        }
        System.assertNotEquals(NULL, testAcc.Id);
        System.assertNotEquals(NULL, testCase.Id);
    }
}