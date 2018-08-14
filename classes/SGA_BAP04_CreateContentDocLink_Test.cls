@isTest
private class SGA_BAP04_CreateContentDocLink_Test {
	private static final string TEST_VAL = 'Test';
    private static final string FILE_NAME = 'Test.jpeg';
    private static final string VERSION_DATA = 'Test Data';
    private static final string SCHEDULE_TIME = '0 0 23 * * ?';
    private static final string CRON_JOB_NAME = 'Test Update';
    /************************************************************************************
    Method Name : createPaperApplication
    Parameters  : None
    Return type : void
    Description : This is the testmethod for paper application creation
    *************************************************************************************/
    private testMethod static void createPaperApplication() {
        User testUser = Util02_TestData.createUser();
        List<Application_Document_Config__c> testConfigList = Util02_TestData.createDocumentConfigList();
        //Business Custom Setting insertion
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        //Account record creation
        Account testAccount = Util02_TestData.createGroupAccount();
        System.runAs(testUser){
            Test.startTest();
            Database.insert(cs001List);
            Database.insert(testConfigList);
            Database.insert(testAccount);
            vlocity_ins__Party__c partyObj = Util02_TestData.createPartyforAccount(testAccount.Id);
            Database.insert(partyObj);
            vlocity_ins__Application__c applicationObj = Util02_TestData.createApplicationRec(testAccount.Id, partyObj.Id);
            applicationObj.vlocity_ins__Type__c = System.Label.SG42_PaperApplication;
            Database.insert(applicationObj);
            ContentVersion contentVersion_1 = new ContentVersion(Title = TEST_VAL,
                                                                 PathOnClient = FILE_NAME,
                                                                 VersionData = Blob.valueOf(VERSION_DATA),
                                                                 IsMajorVersion = true);
            insert contentVersion_1;
            ContentVersion cv = [select Id,ContentDOcumentId from ContentVersion where Id=:contentVersion_1.Id];

            List<Application_Document_CheckList__c> adcList = [select id,Tech_CDL_Created__c,Tech_Content_Document_Id__c from 
                                                              Application_Document_CheckList__c where application__c =:applicationObj.Id];
            for(Application_Document_CheckList__c adcObj : adcList){
                adcObj.Tech_Content_Document_Id__c = cv.ContentDocumentId;
            }
            update adcList;
			Database.executeBatch(new SGA_BAP04_CreateContentDocLink());               
        }
    }
    
    /************************************************************************************
    Method Name : TestSchedulableClass
    Parameters  : None
    Return type : void
    Description : This is the testmethod for schedule job
    *************************************************************************************/
    static TestMethod void TestSchedulableClass()
    {
        Test.StartTest();
        SGA_SCAP04_CreateCDLSchedule sh = new SGA_SCAP04_CreateCDLSchedule();
        String schedule = SCHEDULE_TIME;
        system.schedule(CRON_JOB_NAME, schedule, sh );
        Test.StopTest();
    }
}