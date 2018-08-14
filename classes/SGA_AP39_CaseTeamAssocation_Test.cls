/*******************************************************************************************
* Class Name  : SGA_AP39_CaseTeamAssocation_Test
* Created By  : IDC Offshore
* CreatedDate : 08/23/2017 (mm/dd/yyyy)
* Description : This test class for SGA_AP39_CaseTeamAssocation
********************************************************************************************/
@isTest
private class SGA_AP39_CaseTeamAssocation_Test {
    private testMethod static void associateCaseToBrokerOrAgencyTest1(){
        User testUser = Util02_TestData.createUser();
        //Account record creation
        Account testAccount1 = Util02_TestData.createGroupAccountForRelatedList();
        Account testAccount3 = Util02_TestData.createGroupAccountForRelatedList();
        Account testAccount4 = Util02_TestData.createBrokerAgentAccount();

        //Application record creation
        Contact con1= Util02_TestData.createContact('TestCon1','Lname','test@Test.com', NULL);
        User BrokerUser= Util02_TestData.createUser(NULL, 'TestBroker','Lname', 'testBroker@test.com', 'testBorker@test.com');
        vlocity_ins__Application__c testApplication = Util02_TestData.createApplicationForRelatedList('Group Created', System.today() +5);
        //Business Custom Setting insertion
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        //Record Type Assignment Custom Setting insertion
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        System.runAs(testUser){
            Test.startTest();
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.Insert(testAccount1);
            Database.Insert(testAccount3);
            Database.Insert(testAccount4);
            System.debug('testAccount4'+testAccount4.RecordTypeID);
            con1.AccountID = testAccount4.Id;
            Database.insert(con1);
            BrokerUser.contactId = con1.Id;
            Database.insert(BrokerUser);
            Database.insert(testApplication);
            Case testCase = Util02_TestData.insertSGACase(testAccount1.Id,testApplication.Id);
            testCase.Stage__c = 'Group Submitted, Under Review';
            testCase.RecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.SG50_CaseInstallationRecType).getRecordTypeId();
            testCase.Broker_Writing_Agent_1__c = testAccount4.Id;
            System.debug('Broker_Writing_Agent_1__c'+testCase.Broker_Writing_Agent_1__c);
            Insert testCase; 
            testCase.Broker_Writing_Agent_2__c = testAccount4.Id;
            testCase.General_Agency__c = testAccount4.Id;
            testCase.Paid_Agency__c = testAccount4.Id;
            testCase.Delegate_Contact_of_Broker_or_Agency__c = con1.Id;
            update testCase;
            Test.stopTest();
            System.assertEquals(testCase.Broker_Writing_Agent_1__c,testAccount4.Id);
        }
    }
   /* private testMethod static void bulkTest(){
        User testUser = Util02_TestData.createUser();
        //Account record creation
        Account testAccount1 = Util02_TestData.createGroupAccountForRelatedList();
        Account testAccount3 = Util02_TestData.createGroupAccountForRelatedList();
        Account testAccount4 = Util02_TestData.createBrokerAgentAccount();

        //Application record creation
        Contact con1= Util02_TestData.createContact('TestCon1','Lname','test@Test.com', NULL);
        User BrokerUser= Util02_TestData.createUser(NULL, 'TestBroker','Lname', 'testBroker@test.com', 'testBorker@test.com');
        vlocity_ins__Application__c testApplication = Util02_TestData.createApplicationForRelatedList('Group Created', System.today() +5);
        //Business Custom Setting insertion
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        //Record Type Assignment Custom Setting insertion
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        SGA_InternalUser_Email__c csInternalUser= new SGA_InternalUser_Email__c(Name='NY',Value__c = true);

        System.runAs(testUser){
            Test.startTest();
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.Insert(testAccount1);
            Database.Insert(testAccount3);
            Database.Insert(testAccount4);
            con1.AccountID = testAccount1.Id;
            Database.insert(con1);
            BrokerUser.contactId = con1.Id;
            Database.insert(BrokerUser);
            Database.insert(testApplication);
            Database.insert(csInternalUser);
            List<Case> caseList = New List<Case>();
            for(integer i=0; i<200; i++){
                Case testCase = Util02_TestData.insertSGACase(testAccount3.Id,testApplication.Id);
                testCase.Stage__c = 'Group Submitted, Under Review';
                testCase.BR_State__c='NY';
                testCase.RecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.SG50_CaseInstallationRecType).getRecordTypeId();
                testCase.Broker_Writing_Agent_1__c = testAccount4.Id;
                caseList.add(testCase);
            }
            Database.Insert(caseList);
             
            for(case testCase : caseList){
                testCase.Broker_Writing_Agent_2__c = testAccount4.Id;
                testCase.General_Agency__c = testAccount4.Id;
                testCase.Paid_Agency__c = testAccount4.Id;
                testCase.Delegate_Contact_of_Broker_or_Agency__c = con1.Id;
            }
            Database.update(caseList);
            Test.stopTest();
            System.assertEquals(caseList[0].Broker_Writing_Agent_1__c,testAccount4.Id);
        }
    }*/
}