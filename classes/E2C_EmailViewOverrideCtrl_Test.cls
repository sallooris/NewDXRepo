@isTest
private class E2C_EmailViewOverrideCtrl_Test {
    
    // setup data to be used across test methods
    static void testSetupData() {
        User u = E2C_Util_TestDataFactory.createUserList(1, null, true)[0];

        List<CS001_RecordTypeBusinessTrack__c> busTrack = BR_Util01_TestMethods.createBusinessTrack();
        insert busTrack;

        Account acct = new Account(Name = 'Test Account');
        insert acct;

        //create contact
        Contact cont = new Contact(AccountId = acct.Id, LastName ='Test Contact', Fax ='1231231234', Email='contact@test.com');
        insert cont;

        System.runAs(u) {
            Case caseRec = E2C_Util_TestDataFactory.createCaseList(1, true)[0];
        }


    }

    // Test for reply() method
    static testmethod void testforward() {
        testSetupData();
        Case caseRec = [SELECT Id, Contact.Id, BR_Tech_Case_RoutingAddress__c from Case where Origin = 'Email' Limit 1];
        User u = [SELECT Id from User where Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
        System.runAs (u) {
            E2C_Util_TestDataFactory.createEmailMessageList(caseRec, 1, true);   
        }
        List<EmailMessage> emList = null;
        E2C_EmailViewOverrideCtrl ctrl = null;
        PageReference pageRef = Page.E2C_EmailViewOverride;
        PageReference pgRef = null;   

        Test.setCurrentPage(pageRef);

        Test.startTest();
            emList = [SELECT Id, FromAddress, Parent.BR_Tech_Case_RoutingAddress__c, ParentId, Parent.ContactId from EmailMessage Where ParentId = :caseRec.Id ORDER BY Subject DESC];
            ctrl = new E2C_EmailViewOverrideCtrl(new ApexPages.StandardController(emList[0]));
            System.currentPageReference().getParameters().put('emailId', emList[0].Id);
            System.currentPageReference().getParameters().put('emailFrom', emList[0].FromAddress);

            pgRef = ctrl.forward();
        Test.stopTest();
            System.assert(ctrl.redirectURL.contains('EmailAuthor'));
            System.assert(ctrl.redirectURL.contains('p3_lkid=' + ((String) caseRec.Id).left(15)));
            System.assert(ctrl.redirectURL.contains('email_id=' + emList[0].Id));
            System.assert(ctrl.redirectURL.contains('forward=1'));
    }

    // Test for reply() method
    static testmethod void testReply() {
        testSetupData();
        Case caseRec = [SELECT Id, Contact.Id, BR_Tech_Case_RoutingAddress__c from Case where Origin = 'Email' Limit 1];
        User u = [SELECT Id from User where Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];

        System.runAs (u) {
            List<EmailMessage> em = E2C_Util_TestDataFactory.createEmailMessageList(caseRec, 1, true);   
        }
        List<EmailMessage> emList = null;
        E2C_EmailViewOverrideCtrl ctrl = null;
        PageReference pageRef = Page.E2C_EmailViewOverride;
        PageReference pgRef = null;   

        Test.setCurrentPage(pageRef);

        Test.startTest();
            emList = [SELECT Id, FromAddress, Parent.BR_Tech_Case_RoutingAddress__c, ParentId, Parent.ContactId from EmailMessage Where ParentId = :caseRec.Id ORDER BY Subject DESC];
            ctrl = new E2C_EmailViewOverrideCtrl(new ApexPages.StandardController(emList[0]));
            System.currentPageReference().getParameters().put('emailId', emList[0].Id);
            System.currentPageReference().getParameters().put('emailFrom', emList[0].FromAddress);

            pgRef = ctrl.reply();
        Test.stopTest();
            System.assert(ctrl.redirectURL.contains('EmailAuthor'));
            System.assert(ctrl.redirectURL.contains('p3_lkid=' + ((String) caseRec.Id).left(15)));
            System.assert(ctrl.redirectURL.contains('email_id=' + emList[0].Id));
            System.assert(ctrl.redirectURL.contains('replyToAll=0'));
    }

    // Test for reply() method
    static testmethod void testReplyWithContact() {
        testSetupData();
        User u = [SELECT Id from User where Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
        List<Contact> cont = [Select Id, Email from Contact where Fax ='1231231234'];
        // Daryl - Shield changes - 9/17
        String emailid = 'contact@test.com';
 //       List<List<sObject>> results  = [FIND :emailid IN EMAIL FIELDS RETURNING Contact (Id, Email) limit 1];
  //      List<Contact> cont = (List<Contact>)results[0];
        Case caseRec = E2C_Util_TestDataFactory.createCaseList(1, false)[0];

        System.runAs (u) {  
            caseRec.ContactId = cont[0].Id;
            caseRec.SuppliedEmail = cont[0].Email;
            caseRec.Description = 'Test Case Description';
            caseRec.Subject = 'Test Case Subject';
            caseRec.BR_Tech_Case_RoutingAddress__c = 'testroutingaddress@test.com';
            insert caseRec;

            List<EmailMessage> em = E2C_Util_TestDataFactory.createEmailMessageList(caseRec, 1, false);
            em[0].FromAddress = cont[0].Email;
            insert em;
        }
        List<EmailMessage> emList = null;
        E2C_EmailViewOverrideCtrl ctrl = null;
        PageReference pageRef = Page.E2C_EmailViewOverride;
        PageReference pgRef = null;   

        Test.setCurrentPage(pageRef);

        Test.startTest();
            emList = [SELECT Id, FromAddress, Parent.BR_Tech_Case_RoutingAddress__c, ParentId, Parent.ContactId from EmailMessage Where ParentId = :caseRec.Id ORDER BY Subject DESC];
            ctrl = new E2C_EmailViewOverrideCtrl(new ApexPages.StandardController(emList[0]));
            System.currentPageReference().getParameters().put('emailId', emList[0].Id);
            System.currentPageReference().getParameters().put('emailFrom', emList[0].FromAddress);
            pgRef = ctrl.reply();
        Test.stopTest();
            System.assert(ctrl.redirectURL.contains('EmailAuthor'));
            System.assert(ctrl.redirectURL.contains('p3_lkid=' + ((String) caseRec.Id).left(15)));
            System.assert(ctrl.redirectURL.contains('email_id=' + emList[0].Id));
            System.assert(ctrl.redirectURL.contains('replyToAll=0'));
    }

    // Test for replyToAll method
    static testmethod void testReplyToAll() {
        testSetupData();
        Case caseRec = [SELECT Id, Contact.Id, BR_Tech_Case_RoutingAddress__c, Parent.ContactId from Case where Origin = 'Email' Limit 1];
        User u = [SELECT Id from User where Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
        System.runAs (u) {
            E2C_Util_TestDataFactory.createEmailMessageList(caseRec, 1, true);   
        }
        List<EmailMessage> emList = null;
        E2C_EmailViewOverrideCtrl ctrl = null;
        PageReference pageRef = Page.E2C_EmailViewOverride;
        PageReference pgRef = null;   

        Test.setCurrentPage(pageRef);

        Test.startTest();
            emList = [SELECT Id, FromAddress, Parent.BR_Tech_Case_RoutingAddress__c, ParentId, Parent.ContactId, ToAddress from EmailMessage Where ParentId = :caseRec.Id ORDER BY Subject DESC];
            ctrl = new E2C_EmailViewOverrideCtrl(new ApexPages.StandardController(emList[0]));

            System.currentPageReference().getParameters().put('emailId', emList[0].Id);
            System.currentPageReference().getParameters().put('emailFrom', emList[0].FromAddress);
            System.currentPageReference().getParameters().put('emailCC', 'testcc@address.com');
            System.currentPageReference().getParameters().put('emailTo', emList[0].ToAddress);

            pgRef = ctrl.replyToAll();
        Test.stopTest();
            System.assert(ctrl.redirectURL.contains('EmailAuthor'));
            System.assert(ctrl.redirectURL.contains('p3_lkid=' + ((String) caseRec.Id).left(15)));
            System.assert(ctrl.redirectURL.contains('email_id=' + emList[0].Id));
            System.assert(ctrl.redirectURL.contains('replyToAll=1')); 
            System.assert(ctrl.redirectURL.contains('p4='));
    }
    
    // Test for replyToAll method for email with multiple To addresses
    static testmethod void testReplyToAll2() {
        testSetupData();
        Case caseRec = [SELECT Id, Contact.Id, BR_Tech_Case_RoutingAddress__c, Parent.ContactId from Case where Origin = 'Email' Limit 1];
        User u = [SELECT Id from User where Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
        System.runAs (u) {
            E2C_Util_TestDataFactory.createEmailMessageList(caseRec, 1, true);   
        }
        List<EmailMessage> emList = null;
        E2C_EmailViewOverrideCtrl ctrl = null;
        PageReference pageRef = Page.E2C_EmailViewOverride;
        PageReference pgRef = null;   

        Test.setCurrentPage(pageRef);

        Test.startTest();
            emList = [SELECT Id, FromAddress, Parent.BR_Tech_Case_RoutingAddress__c, ParentId, ToAddress, Parent.ContactId from EmailMessage Where ParentId = :caseRec.Id];

            ctrl = new E2C_EmailViewOverrideCtrl(new ApexPages.StandardController(emList[0]));
            System.currentPageReference().getParameters().put('emailId', emList[0].Id);
            System.currentPageReference().getParameters().put('emailFrom', emList[0].FromAddress);
            System.currentPageReference().getParameters().put('emailCC', 'testcc@address.com');
            System.currentPageReference().getParameters().put('emailTo', emList[0].ToAddress + ';testToAddr@atest.com' + ';' + emList[0].FromAddress + ';' + emList[0].Parent.BR_Tech_Case_RoutingAddress__c);

            pgRef = ctrl.replyToAll();
        Test.stopTest();
            System.assert(ctrl.redirectURL.contains('EmailAuthor'));
            System.assert(ctrl.redirectURL.contains('p3_lkid=' + ((String) caseRec.Id).left(15)));
            System.assert(ctrl.redirectURL.contains('email_id=' + emList[0].Id));
            System.assert(ctrl.redirectURL.contains('replyToAll=1')); 
            System.assert(ctrl.redirectURL.contains('p4='));
    }

    // Test for replyToAll method for email with multiple To CC Addresses 
    static testmethod void testReplyToAll3() {
        testSetupData();
        Case caseRec = [SELECT Id, Contact.Id, BR_Tech_Case_RoutingAddress__c, Parent.ContactId from Case where Origin = 'Email' Limit 1];
        User u = [SELECT Id from User where Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
        System.runAs (u) {
            E2C_Util_TestDataFactory.createEmailMessageList(caseRec, 1, true);   
        }
        List<EmailMessage> emList = null;
        E2C_EmailViewOverrideCtrl ctrl = null;
        PageReference pageRef = Page.E2C_EmailViewOverride;
        PageReference pgRef = null;   

        Test.setCurrentPage(pageRef);

        Test.startTest();
            emList = [SELECT Id, FromAddress, Parent.BR_Tech_Case_RoutingAddress__c, ParentId, Parent.ContactId, ToAddress from EmailMessage Where ParentId = :caseRec.Id];
            ctrl = new E2C_EmailViewOverrideCtrl(new ApexPages.StandardController(emList[0]));
            System.currentPageReference().getParameters().put('emailId', emList[0].Id);
            System.currentPageReference().getParameters().put('emailFrom', emList[0].FromAddress);
            System.currentPageReference().getParameters().put('emailCC', 'testcc@address.com;testCCAddr2@atest.com' + ';' + emList[0].FromAddress + ';' + emList[0].Parent.BR_Tech_Case_RoutingAddress__c);

            pgRef = ctrl.replyToAll();
        Test.stopTest();
            System.assert(ctrl.redirectURL.contains('EmailAuthor'));
            System.assert(ctrl.redirectURL.contains('p3_lkid=' + ((String) caseRec.Id).left(15)));
            System.assert(ctrl.redirectURL.contains('email_id=' + emList[0].Id));
            System.assert(ctrl.redirectURL.contains('replyToAll=1')); 
            System.assert(ctrl.redirectURL.contains('p4='));
    }
    
}