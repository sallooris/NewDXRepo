@isTest
private class VFCE06_PostChatSurvey_Test{
    private static testMethod void postChatSurveyTest1(){
        Test.startTest();
            List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
            insert cs001List;
            Account acc =Util02_TestData.insertAccount();
            acc.RecordTypeId=[Select id from RecordType where sObjectType = 'Account' and Name like '%Person%' ].id;
            insert acc;
            LiveChatVisitor visitor = new LiveChatVisitor();
            insert visitor;
            //create a Live Chat Transcript
            LiveChatTranscript trans = new LiveChatTranscript(
                                                            LiveChatVisitorId = visitor.Id,
                                                            accountId = acc.Id,
                                                            Body = 'Hello',
                                                            chatKey = 'd8078583-f509-4665-8002-5725cff6f7a3'
                                                            );
            insert trans;
            Live_Agent_Chat_Survey__c lacs = new Live_Agent_Chat_Survey__c();
            lacs.Please_rate_your_operator__c = 'Good';
            System.debug('chatterkey>>>>>'+trans.chatKey);
            lacs.chatKey__c = trans.chatKey;
            VFCE06_PostChatSurvey.chatterKey = trans.chatKey;
            VFCE06_PostChatSurvey aa=new VFCE06_PostChatSurvey(new ApexPages.StandardController(lacs));
            aa.submit();
        Test.stopTest();
    }
    private static testMethod void postChatSurveyTest2(){
        Test.startTest();
            List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
            insert cs001List;
            Account acc =Util02_TestData.insertAccount();
            acc.RecordTypeId=[Select id from RecordType where sObjectType = 'Account' and Name like '%Person%' ].id;
            insert acc;
            LiveChatVisitor visitor = new LiveChatVisitor();
            insert visitor;
            //create a Live Chat Transcript
            LiveChatTranscript trans = new LiveChatTranscript(
                                                            LiveChatVisitorId = visitor.Id,
                                                            accountId = acc.Id,
                                                            Body = 'Hello',
                                                            chatKey = 'd8078583-f509-4665-8002-5725cff6f7a2'
                                                            );
            insert trans;
            System.debug('chatterkey>>>>>'+trans.chatKey);
            Live_Agent_Chat_Survey__c lacs = new Live_Agent_Chat_Survey__c();
            lacs.Please_rate_your_operator__c = 'Good';
            lacs.chatKey__c = trans.chatKey;
            AP20_AttachSurveyToChatScript.isBeforeIsertFirstRun = true;
            insert lacs;
        Test.stopTest();
    }
    private static testMethod void postChatSurveyTest3(){
        Test.startTest();
            List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
            insert cs001List;
            Account acc =Util02_TestData.insertAccount();
            acc.RecordTypeId=[Select id from RecordType where sObjectType = 'Account' and Name like '%Person%' ].id;
            insert acc;
            Test.setCurrentPageReference(new PageReference('Page.VFCE07_PostChatSurveyAgent'));
            System.currentPageReference().getParameters().put('cid', acc.id);
            LiveChatVisitor visitor = new LiveChatVisitor();
            insert visitor;
            //create a Live Chat Transcript
            LiveChatTranscript trans = new LiveChatTranscript(
                                                            LiveChatVisitorId = visitor.Id,
                                                            accountId = acc.Id,
                                                            Body = 'Hello',
                                                            chatKey = 'd8078583-f509-4665-8002-5725cff6f7a4'
                                                            );
            insert trans;
            System.debug('chatterkey>>>>>'+trans.chatKey);
            Live_Agent_Chat_Survey__c lacs = new Live_Agent_Chat_Survey__c();
            lacs.What_type_of_help_was_needed__c = ' Medicaid';
            lacs.Sales_Channel__c = 'Online';
            lacs.Contact_with_Anthem_within_last_90_days__c = 'No';
            lacs.Chat_Outcome__c = 'Sale';
            VFCE07_PostChatSurveyAgent aa=new VFCE07_PostChatSurveyAgent(new ApexPages.StandardController(lacs));
            aa.submit();
            
        Test.stopTest();
    }
    private static testMethod void postChatSurveyTest4(){
        Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
        Lead ldObj=Util02_TestData.insertLead();
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List;
        ID leadRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'Lead'].Id;
        ldObj.recordtypeId = leadRT;    
        Test.startTest();
            Database.insert(pCode); 
            pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];      
            ldObj.zip_code__c = pCode.Id;
            Database.insert(ldObj);
            Test.setCurrentPageReference(new PageReference('Page.VFCE07_PostChatSurveyAgent'));
            System.currentPageReference().getParameters().put('cid', ldObj.id);
            LiveChatVisitor visitor = new LiveChatVisitor();
            insert visitor;
            //create a Live Chat Transcript
            LiveChatTranscript trans = new LiveChatTranscript(
                                                            LiveChatVisitorId = visitor.Id,
                                                            LeadId = ldObj.Id,
                                                            Body = 'Hello',
                                                            chatKey = 'd8078583-f509-4665-8002-5725cff6f7a5'
                                                            );
            insert trans;
            System.debug('chatterkey>>>>>'+trans.chatKey);
            Live_Agent_Chat_Survey__c lacs = new Live_Agent_Chat_Survey__c();
            lacs.What_type_of_help_was_needed__c = ' Medicaid';
            lacs.Sales_Channel__c = 'Online';
            lacs.Contact_with_Anthem_within_last_90_days__c = 'No';
            lacs.Chat_Outcome__c = 'Sale';
            VFCE07_PostChatSurveyAgent aa=new VFCE07_PostChatSurveyAgent(new ApexPages.StandardController(lacs));
            aa.submit();
        Test.stopTest();
    }
    private static testMethod void postChatSurveyTest5(){
        Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
        Lead ldObj=Util02_TestData.insertLead();
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List;
        ID leadRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'Lead'].Id;
        ldObj.recordtypeId = leadRT;    
        Test.startTest();
            Database.insert(pCode); 
            pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];      
            ldObj.zip_code__c = pCode.Id;
            Database.insert(ldObj);
            Test.setCurrentPageReference(new PageReference('Page.VFCE07_PostChatSurveyAgent'));
            System.currentPageReference().getParameters().put('id', ldObj.id);
            LiveChatVisitor visitor = new LiveChatVisitor();
            insert visitor;
            //create a Live Chat Transcript
            LiveChatTranscript trans = new LiveChatTranscript(
                                                            LiveChatVisitorId = visitor.Id,
                                                            LeadId = ldObj.Id,
                                                            Body = 'Hello',
                                                            chatKey = 'd8078583-f509-4665-8002-5725cff6f7a6'
                                                            );
            insert trans;
            System.debug('chatterkey>>>>>'+trans.chatKey);
            Live_Agent_Chat_Survey__c lacs = new Live_Agent_Chat_Survey__c();
            lacs.What_type_of_help_was_needed__c = ' Medicaid';
            lacs.Sales_Channel__c = 'Online';
            lacs.Contact_with_Anthem_within_last_90_days__c = 'No';
            lacs.Chat_Outcome__c = 'Sale';
            VFCE07_PostChatSurveyAgent aa=new VFCE07_PostChatSurveyAgent(new ApexPages.StandardController(lacs));
            aa.submit();
        Test.stopTest();
    }
    
}