@isTest(SeeAllData = false)
public class Test_VlocityApplicationTrigger {
    public static Account testAccount1;
    public static Account testAccount2;
    public static Account testAccount3;
    public static Contact testContact1;
    public static Contact testContact2;
    public static Contact testContact3;
    public static Opportunity testOpportunity1;
    public static Opportunity testOpportunity2;
    public static Opportunity testOpportunity3;
    public static Opportunity testOpportunity4;
    public static Opportunity testOpportunity5;
    public static User broker1;
    public static User broker2;
    public static User broker3;
    public static vlocity_ins__Party__c testParty1;
    public static vlocity_ins__Party__c testParty2;
    public static vlocity_ins__Party__c testParty3;
    public static UserRole role;
    public static user u;
    public static Integer tempCount = 1;
    public static void createRecords() {
         UserRole customrole = [select id,name from UserRole where name='System Admin (IT & Support)' limit 1];
        profile p = [select id,name from profile where name='System Administrator' limit 1];
        
         u = new User(
     ProfileId = p.Id,
     LastName = 'last',
     Email = 'puser000@amamama.com',
     Username = 'puser000@amamama'+tempCount+'.com' +UserInfo.getOrganizationId(),
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US',
     UserRoleId = customrole.Id
     
    );
    tempCount++;
     insert u;
       
        
       
    }
    
    public static void createUserRecords() {
    
     CS001_RecordTypeBusinessTrack__c rtAnthemOpps = new CS001_RecordTypeBusinessTrack__c();
        rtAnthemOpps.Name = 'Account_Agency/Brokerage';
        rtAnthemOpps.BusinessTrackName__c = 'SGQUOTING'; 
        insert rtAnthemOpps;

        CS001_RecordTypeBusinessTrack__c rtSGQuoting = new CS001_RecordTypeBusinessTrack__c();
        rtSGQuoting.Name = 'Opportunity_SG Quoting';
        rtSGQuoting.BusinessTrackName__c = 'SGQUOTING'; 
        insert rtSGQuoting;

        Party_Roles__c partyRoles = new Party_Roles__c();
        partyRoles.Name = 'Role1';
        partyRoles.Source_Roles__c = 'Agency;Brokerage';
        partyRoles.Target_Roles__c = 'Agency;Paid Agency;General Agency';
        insert partyRoles; 

        testAccount1 = Util02_TestData.createAccount('Test Agency 1'); 
        testAccount1.RecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Agency/Brokerage').getRecordTypeId();
        testAccount2 = Util02_TestData.createAccount('Test Agency 2');
        testAccount2.RecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Agency/Brokerage').getRecordTypeId();
        testAccount3 = Util02_TestData.createAccount('Test Agency 3');
        testAccount3.RecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Agency/Brokerage').getRecordTypeId();
        insert testAccount1;
        insert testAccount2;
        insert testAccount3;
        
        testAccount1.ownerId = u.Id;
        testAccount2.ownerId = u.Id;
        testAccount3.ownerId = u.Id;
        
        update testAccount1;
        update testAccount2;
        update testAccount3;

        testContact1 = Util02_TestData.createContact('Jon', 'Snow', 'jon222@snow.com', testAccount1.Id);
        testContact2 = Util02_TestData.createContact('Arya', 'Stark', 'arya222@stark.com', testAccount2.Id);
        testContact3 = Util02_TestData.createContact('Stanis', 'Baratheon', 'stanis222@baratheon.com', testAccount3.Id);

        insert testContact1;
        insert testContact2;
        insert testContact3;

        List<Opportunity> opportunityList = new List<Opportunity>();

        testOpportunity1 = Util02_TestData.createOpportunity(testContact3.Id, testAccount2.Id, testAccount1.Id);
        testOpportunity1.RecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SG Quoting').getRecordTypeId();
        opportunityList.add(testOpportunity1);

        testOpportunity2 = Util02_TestData.createOpportunity(null, testAccount2.Id, testAccount1.Id);
        testOpportunity2.RecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SG Quoting').getRecordTypeId();
        opportunityList.add(testOpportunity2);

        testOpportunity3 = Util02_TestData.createOpportunity(testContact2.Id, testAccount1.Id, testAccount3.Id);
        testOpportunity3.RecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SG Quoting').getRecordTypeId();
        opportunityList.add(testOpportunity3);

        testOpportunity4 = Util02_TestData.createOpportunity(testContact3.Id, testAccount3.Id, testAccount2.Id);
        testOpportunity4.RecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SG Quoting').getRecordTypeId();
        opportunityList.add(testOpportunity4);

        testOpportunity5 = Util02_TestData.createOpportunity(testContact1.Id, testAccount2.Id, testAccount2.Id);
        testOpportunity5.RecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SG Quoting').getRecordTypeId();
        opportunityList.add(testOpportunity5);

        insert opportunityList;
        update opportunityList;
        testParty1 = new vlocity_ins__Party__c();
        testParty1.Name = testAccount1.Name;
        testParty1.vlocity_ins__AccountId__c = testAccount1.Id;
        testParty1.vlocity_ins__PartyEntityId__c = testAccount1.Id;
        testParty1.vlocity_ins__PartyEntityType__c = 'Account';

        testParty2 = new vlocity_ins__Party__c();
        testParty2.Name = testAccount2.Name;
        testParty2.vlocity_ins__AccountId__c = testAccount2.Id;
        testParty2.vlocity_ins__PartyEntityId__c = testAccount2.Id;
        testParty2.vlocity_ins__PartyEntityType__c = 'Account';

        testParty3 = new vlocity_ins__Party__c();
        testParty3.Name = testAccount3.Name;
        testParty3.vlocity_ins__AccountId__c = testAccount3.Id;
        testParty3.vlocity_ins__PartyEntityId__c = testAccount3.Id;
        testParty3.vlocity_ins__PartyEntityType__c = 'Account';

        insert testParty1;
        insert testParty2;
        insert testParty3;
     
        broker1 = Util02_TestData.createUser(testContact1.Id, testContact1.FirstName, testContact1.LastName, testContact1.Email, testContact1.Email);
        insert broker1;

        broker2 = Util02_TestData.createUser(testContact2.Id, testContact2.FirstName, testContact2.LastName, testContact2.Email, testContact2.Email);
        insert broker2;

        broker3 = Util02_TestData.createUser(testContact3.Id, testContact3.FirstName, testContact3.LastName, testContact3.Email, testContact3.Email);
        insert broker3;
    }
    
    
    static testMethod void unitTest1() {
        createRecords();
        List<vlocity_ins__Application__c> applicationList = new List<vlocity_ins__Application__c>();
        Test.startTest();
        system.runAs(u){
            createUserRecords();
           
            vlocity_ins__Application__c application = new vlocity_ins__Application__c();
            application.Name = 'Test Application';
            application.SGC_Application_Status__c = 'SUCCESS';
            application.vlocity_ins__PrimaryPartyId__c = testParty1.Id;
            application.Writing_Broker_Email_ID__c = 'test@abc.com';
            application.Opportunity_Id__c = testOpportunity1.Id;
            applicationList.add(application);

            vlocity_ins__Application__c application1 = new vlocity_ins__Application__c();
            application1.Name = 'Test Application';
            application.SGC_Application_Status__c = 'SUCCESS';
            application1.vlocity_ins__PrimaryPartyId__c = testParty1.Id;
            application1.Writing_Broker_Email_ID__c = 'test@abc.com';
            application1.Opportunity_Id__c = testOpportunity2.Id;
            applicationList.add(application1);

            vlocity_ins__Application__c application2 = new vlocity_ins__Application__c();
            application2.Name = 'Test Application';
            application.SGC_Application_Status__c = 'SUCCESS';
            application2.vlocity_ins__PrimaryPartyId__c = testParty1.Id;
            application2.Writing_Broker_Email_ID__c = 'test@abc.com';
            application2.Opportunity_Id__c = testOpportunity3.Id;
            applicationList.add(application2);

            vlocity_ins__Application__c application3 = new vlocity_ins__Application__c();
            application3.Name = 'Test Application';
            application3.vlocity_ins__PrimaryPartyId__c = testParty1.Id;
            application3.Writing_Broker_Email_ID__c = 'test@abc.com';
            application3.Opportunity_Id__c = testOpportunity4.Id;
            applicationList.add(application3);

            vlocity_ins__Application__c application4 = new vlocity_ins__Application__c();
            application4.Name = 'Test Application';
            application.SGC_Application_Status__c = 'SUCCESS';
            application4.vlocity_ins__PrimaryPartyId__c = testParty1.Id;
            application4.Writing_Broker_Email_ID__c = 'test@abc.com';
            application4.Opportunity_Id__c = testOpportunity5.Id;
            applicationList.add(application4);

            insert applicationList;
            update applicationList;
            Set<Id> applicationIdSet = new Set<Id>();

            for(vlocity_ins__Application__c tmpApp : applicationList) {
                applicationIdSet.add(tmpApp.Id);
            }

            List<vlocity_ins__Application__Share> appShareList = [SELECT Id, ParentId FROM vlocity_ins__Application__Share WHERE RowCause = 'Manual' AND ParentId IN: applicationIdSet];
        }
            //System.assertEquals(24, appShareList.size());
        Test.stopTest();

    }

    static testMethod void unitTest2() {
        createRecords();

        Test.startTest();
        system.runAs(u){
            createUserRecords();
            vlocity_ins__Application__c application = new vlocity_ins__Application__c();
            application.Name = 'Test Application';
            application.SGC_Application_Status__c = 'SUCCESS';
            application.vlocity_ins__PrimaryPartyId__c = testParty1.Id;
            application.Writing_Broker_Email_ID__c = 'test@abc.com';
            //application.Opportunity_Id__c = testOpportunity1.Id;

            insert application;
            application.Opportunity_Id__c = testOpportunity1.Id;
            update application;
            testOpportunity1 = [SELECT Id, GeneralAgency__c FROM Opportunity WHERE Id =: testOpportunity1.Id];
            testOpportunity1.GeneralAgency__c = null;
            testOpportunity1.AccountId = testAccount3.Id;
            testOpportunity1.Broker__c = null;

 //           update testOpportunity1;

            List<vlocity_ins__Application__Share> appShareList = [SELECT Id, ParentId FROM vlocity_ins__Application__Share WHERE RowCause = 'Manual' AND ParentId =: application.Id];

            //System.assertEquals(4, appShareList.size());
            }
        Test.stopTest();


    }

    static testMethod void testException1() {
        
        Test.startTest();
            ApplicationSharingHelper appShHelper = new ApplicationSharingHelper();
            try {
                appShHelper.getAccountIdToGroupRoleIds(null); 
            } catch(NullPointerException exptn) {
                return;
            }
            System.assert(false, 'NullPointerException');
        Test.stopTest();
    }

}