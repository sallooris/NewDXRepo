@isTest(SeeAllData = false)
public class Test_VlocityPartyRelationshipTrigger{

    public static Account testAccount1;
    public static Account testAccount2;
    public static Account testAccount3;
    public static Contact testContact1;
    public static Contact testContact2;
    public static Contact testContact3;
    public static User broker1;
    public static User broker2;
    public static User broker3;
    public static vlocity_ins__Party__c testParty1;
    public static vlocity_ins__Party__c testParty2;
    public static vlocity_ins__Party__c testParty3;
    public static String orgId = UserInfo.getOrganizationId();
    
    public static void createRecords() {

        CS001_RecordTypeBusinessTrack__c rtAnthemOpps = new CS001_RecordTypeBusinessTrack__c();
        rtAnthemOpps.Name = 'Account_Agency/Brokerage';
        rtAnthemOpps.BusinessTrackName__c = 'SGQUOTING'; 
        insert rtAnthemOpps;

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

        testContact1 = Util02_TestData.createContact('Jon', 'Snow', 'jont'+orgId+'@snow.com', testAccount1.Id);
        testContact2 = Util02_TestData.createContact('Arya', 'Stark', 'aryat'+orgId+'@stark.com', testAccount2.Id);
        testContact3 = Util02_TestData.createContact('Stanis', 'Baratheon', 'stanist'+orgId+'@baratheon.com', testAccount3.Id);

        insert testContact1;
        insert testContact2;
        insert testContact3;

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
    }

    public static void createUserRecords() {
        broker1 = Util02_TestData.createUser(testContact1.Id, testContact1.FirstName, testContact1.LastName, testContact1.Email, testContact1.Email);
        //broker1.AccountId = testAccount1.Id;
        insert broker1;

        broker2 = Util02_TestData.createUser(testContact2.Id, testContact2.FirstName, testContact2.LastName, testContact2.Email, testContact2.Email);
        //broker2.AccountId = testAccount2.Id;
        insert broker2;

        broker3 = Util02_TestData.createUser(testContact3.Id, testContact3.FirstName, testContact3.LastName, testContact3.Email, testContact3.Email);
        //broker3.AccountId = testAccount3.Id;
        insert broker3;
    }

    static testMethod void unitTest1() {
        createRecords();
        createUserRecords();      
        List<vlocity_ins__PartyRelationship__c> partyRelationshipList = new List<vlocity_ins__PartyRelationship__c>();
        vlocity_ins__PartyRelationship__c partyRelationship = new vlocity_ins__PartyRelationship__c();
        partyRelationship.vlocity_ins__SourcePartyId__c = testParty1.Id;
        partyRelationship.vlocity_ins__TargetPartyId__c = testParty2.Id;
        partyRelationship.vlocity_ins__PrimaryRole__c = 'Agency';
        partyRelationship.vlocity_ins__TargetRole__c = 'Agency';
        partyRelationship.vlocity_ins__IsActive__c = true;
        partyRelationshipList.add(partyRelationship);
        //insert partyRelationship;

        vlocity_ins__PartyRelationship__c partyRelationship1 = new vlocity_ins__PartyRelationship__c();
        partyRelationship1.vlocity_ins__SourcePartyId__c = testParty1.Id;
        partyRelationship1.vlocity_ins__TargetPartyId__c = testParty3.Id;
        partyRelationship1.vlocity_ins__PrimaryRole__c = 'Brokerage';
        partyRelationship1.vlocity_ins__TargetRole__c = 'Paid Agency';
        partyRelationship1.vlocity_ins__IsActive__c = true;
        partyRelationshipList.add(partyRelationship1);

        vlocity_ins__PartyRelationship__c partyRelationship2 = new vlocity_ins__PartyRelationship__c();
        partyRelationship2.vlocity_ins__SourcePartyId__c = testParty2.Id;
        partyRelationship2.vlocity_ins__TargetPartyId__c = testParty3.Id;
        partyRelationship2.vlocity_ins__PrimaryRole__c = 'Brokerage';
        partyRelationship2.vlocity_ins__TargetRole__c = 'General Agency';
        partyRelationship2.vlocity_ins__IsActive__c = true;
        partyRelationshipList.add(partyRelationship2);

        Test.startTest();
        insert partyRelationshipList;

        List<AccountShare> accShareList = [SELECT Id, AccountId, RowCause, UserOrGroupId FROM AccountShare WHERE RowCause = 'Manual'];
        System.assertEquals(6, accShareList.size());
        Test.stopTest();
    }

    static testMethod void unitTest2() {
        createRecords();
        createUserRecords();

        Test.startTest();
            vlocity_ins__PartyRelationship__c partyRelationship = new vlocity_ins__PartyRelationship__c();
            partyRelationship.vlocity_ins__SourcePartyId__c = testParty1.Id;
            partyRelationship.vlocity_ins__TargetPartyId__c = testParty2.Id;
            partyRelationship.vlocity_ins__PrimaryRole__c = 'Agency';
            partyRelationship.vlocity_ins__TargetRole__c = 'Agency';
            partyRelationship.vlocity_ins__IsActive__c = true;
            insert partyRelationship;



            partyRelationship = [SELECT vlocity_ins__IsActive__c FROM vlocity_ins__PartyRelationship__c WHERE Id =: partyRelationship.Id];
            partyRelationship.vlocity_ins__IsActive__c = false;
            update partyRelationship;

            List<AccountShare> accShareList = [SELECT Id, AccountId, RowCause, UserOrGroupId FROM AccountShare WHERE RowCause = 'Manual'];
            System.assertEquals(0, accShareList.size());
        Test.stopTest();
    }


    static testMethod void unitTest3() {
        createRecords();
        createUserRecords();

        Test.startTest();
            vlocity_ins__PartyRelationship__c partyRelationship = new vlocity_ins__PartyRelationship__c();
            partyRelationship.vlocity_ins__SourcePartyId__c = testParty1.Id;
            partyRelationship.vlocity_ins__TargetPartyId__c = testParty2.Id;
            partyRelationship.vlocity_ins__PrimaryRole__c = 'Agency';
            partyRelationship.vlocity_ins__TargetRole__c = 'Agency';
            partyRelationship.vlocity_ins__IsActive__c = true;
            insert partyRelationship;

            partyRelationship = [SELECT vlocity_ins__SourcePartyId__c FROM vlocity_ins__PartyRelationship__c WHERE Id =: partyRelationship.Id];
            partyRelationship.vlocity_ins__SourcePartyId__c = testParty3.Id;
            update partyRelationship;

            List<AccountShare> accShareList = [SELECT Id, AccountId, RowCause, UserOrGroupId FROM AccountShare WHERE RowCause = 'Manual'];
            System.assertEquals(2, accShareList.size());
        Test.stopTest();
    }

    static testMethod void unitTest4() {
        createRecords();
        createUserRecords();

        Test.startTest();
            vlocity_ins__PartyRelationship__c partyRelationship = new vlocity_ins__PartyRelationship__c();
            partyRelationship.vlocity_ins__SourcePartyId__c = testParty1.Id;
            partyRelationship.vlocity_ins__TargetPartyId__c = testParty2.Id;
            partyRelationship.vlocity_ins__PrimaryRole__c = 'Agency';
            partyRelationship.vlocity_ins__TargetRole__c = 'Agency';
            partyRelationship.vlocity_ins__IsActive__c = true;
            insert partyRelationship;

            partyRelationship = [SELECT vlocity_ins__SourcePartyId__c, vlocity_ins__IsActive__c FROM vlocity_ins__PartyRelationship__c WHERE Id =: partyRelationship.Id];
            partyRelationship.vlocity_ins__SourcePartyId__c = testParty3.Id;
            partyRelationship.vlocity_ins__IsActive__c = false;
            update partyRelationship;

            List<AccountShare> accShareList = [SELECT Id, AccountId, RowCause, UserOrGroupId FROM AccountShare WHERE RowCause = 'Manual'];
            System.assertEquals(0, accShareList.size());
        Test.stopTest();
    }

    static testMethod void unitTest5() {
        createRecords();
        createUserRecords();

        Test.startTest();
            vlocity_ins__PartyRelationship__c partyRelationship = new vlocity_ins__PartyRelationship__c();
            partyRelationship.vlocity_ins__SourcePartyId__c = testParty1.Id;
            partyRelationship.vlocity_ins__TargetPartyId__c = testParty2.Id;
            partyRelationship.vlocity_ins__PrimaryRole__c = 'Agency';
            partyRelationship.vlocity_ins__TargetRole__c = 'Agency';
            partyRelationship.vlocity_ins__IsActive__c = false;
            insert partyRelationship;

            partyRelationship = [SELECT vlocity_ins__SourcePartyId__c, vlocity_ins__IsActive__c FROM vlocity_ins__PartyRelationship__c WHERE Id =: partyRelationship.Id];
            //partyRelationship.vlocity_ins__SourcePartyId__c = testParty3.Id;
            partyRelationship.vlocity_ins__IsActive__c = true;
            update partyRelationship;



            List<AccountShare> accShareList = [SELECT Id, AccountId, RowCause, UserOrGroupId FROM AccountShare WHERE RowCause = 'Manual'];
            System.assertEquals(2, accShareList.size());
        Test.stopTest();
    }

    static testMethod void unitTest6() {
        createRecords();
        createUserRecords();

        Test.startTest();
            vlocity_ins__PartyRelationship__c partyRelationship = new vlocity_ins__PartyRelationship__c();
            partyRelationship.vlocity_ins__SourcePartyId__c = testParty1.Id;
            partyRelationship.vlocity_ins__TargetPartyId__c = testParty2.Id;
            partyRelationship.vlocity_ins__PrimaryRole__c = 'Agency';
            partyRelationship.vlocity_ins__TargetRole__c = 'Agency';
            partyRelationship.vlocity_ins__IsActive__c = true;
            insert partyRelationship;

            partyRelationship = [SELECT vlocity_ins__SourcePartyId__c, vlocity_ins__IsActive__c FROM vlocity_ins__PartyRelationship__c WHERE Id =: partyRelationship.Id];
            //partyRelationship.vlocity_ins__SourcePartyId__c = testParty3.Id;
            partyRelationship.vlocity_ins__IsActive__c = true;
            partyRelationship.vlocity_ins__PrimaryRole__c = 'Brokerage';
            partyRelationship.vlocity_ins__TargetRole__c = 'Paid Agency';
            update partyRelationship;

            List<AccountShare> accShareList = [SELECT Id, AccountId, RowCause, UserOrGroupId FROM AccountShare WHERE RowCause = 'Manual'];
            System.assertEquals(2, accShareList.size());
        Test.stopTest();
    }

    static testMethod void unitTest7() {
        createRecords();
        createUserRecords();

        Test.startTest();
            vlocity_ins__PartyRelationship__c partyRelationship = new vlocity_ins__PartyRelationship__c();
            partyRelationship.vlocity_ins__SourcePartyId__c = testParty1.Id;
            partyRelationship.vlocity_ins__TargetPartyId__c = testParty2.Id;
            partyRelationship.vlocity_ins__PrimaryRole__c = 'Agency';
            partyRelationship.vlocity_ins__TargetRole__c = 'Agency';
            partyRelationship.vlocity_ins__IsActive__c = true;
            insert partyRelationship;

            partyRelationship = [SELECT vlocity_ins__SourcePartyId__c, vlocity_ins__IsActive__c FROM vlocity_ins__PartyRelationship__c WHERE Id =: partyRelationship.Id];
            delete partyRelationship;

            List<AccountShare> accShareList = [SELECT Id, AccountId, RowCause, UserOrGroupId FROM AccountShare WHERE RowCause = 'Manual'];
            System.assertEquals(0, accShareList.size());
        Test.stopTest();
    }

}