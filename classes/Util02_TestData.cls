public class Util02_TestData {
    
    public static Lead testLead;
    public static Opportunity testOpp;
    public static Account testAccount;
    public static List<Account> testAccList = new List<Account>();
    public static List<Task> testTaskList = new List<Task>();
    public static List<Lead> testLeadList = new List<Lead>();
    public static Postal_Code_County__c testZipCode ;
    public static Postal_Code_County__c testZipCode1 ;
    public static Zip_DOB_Score__c testZipCodeScore ;
    public static Boolean runContactsUpdate = false;
    public static Account insertAccount(){
        testAccount = new Account(firstname='test first name',lastname='test Last Name', Date_of_Birth__c=Date.ValueOf('1985-07-01'));
        testAccount.RecordTypeId=[Select id from RecordType where sObjectType = 'Account' and Name like '%Person%' ].id;
        return testAccount;
    }
    public static Lead insertLead(){
        testLead = new Lead(firstname='TestF1',lastname='TestF2', Date_of_Birth__c=Date.ValueOf('1985-07-01'));
        return testLead;
    }
    public static Postal_Code_County__c insertZipCode(){
        testZipCode = new Postal_Code_County__c(Name='50002', City__c='Hyderabad', Country__c='INDIA', County__c='MDGDA', State__c='TS');
        return testZipCode ;
    }
    public static Postal_Code_County__c insertZipCode1(){
        testZipCode1 = new Postal_Code_County__c(Name='50001', City__c='Hyderabad', Country__c='INDIA', County__c='MDGDA', State__c='TS');
        return testZipCode1 ;
    }
    public static Zip_DOB_Score__c insertZipDOBScore(){
        testZipCodeScore = new Zip_DOB_Score__c(Zip_Code__c='50002', Score__c=1, Start_Date__c=Date.ValueOf('1980-07-01'), End_Date__c=Date.ValueOf('1990-07-01'));
        return testZipCodeScore ;
    }
    
    public static Household_Member__c insertHousehold(){
        
        Household_Member__c hm = new Household_Member__c(First_Name__c='first',last_name__c='household',Household_ID__c=testAccount.id,date_of_birth__c=system.today(),relationship_type__c='Primary');
        
        return hm;
        
    }
    public static Opportunity insertOpportunity(){
        testOpp = new Opportunity( Name = 'My Test Opp',Open_Enrollment__c='OE2015',
                                  StageName = 'Opportunity',
                                  CloseDate = System.today().addDays(4));
        //insert  testOpp
        return testOpp;
    }
    public static Account_Stage__c insertAccountStage(){
        Account_Stage__c testAccStage=new Account_Stage__c (Name='Opportunity',Oppty_Stage__c='Opportunity');
        return testAccStage;
    }
    public static List<Account_Stage__c> insertAccountStages(){
        Account_Stage__c testAccStage=new Account_Stage__c (Name='Opportunity',Oppty_Stage__c='Opportunity');
        Account_Stage__c testAccStage1=new Account_Stage__c (Name='Application Started',Oppty_Stage__c='Application Started');
        Account_Stage__c testAccStage2=new Account_Stage__c (Name='Application Submitted',Oppty_Stage__c='Application Submitted');
        Account_Stage__c testAccStage3=new Account_Stage__c (Name='Customer Enrolled',Oppty_Stage__c='Sold');
        Account_Stage__c testAccStage4=new Account_Stage__c (Name='Exhausted',Oppty_Stage__c='Lost');
        List<Account_Stage__c> acstages = new List<Account_Stage__c>();
        acstages.add(testAccStage);
        acstages.add(testAccStage1);
        acstages.add(testAccStage2);
        acstages.add(testAccStage3);
        acstages.add(testAccStage4);
        return acstages;
    }
    public static User insertUser(){
        Profile txtProfile = [SELECT Id FROM Profile WHERE Name='System Administrator' Limit 1]; 
        User tstUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = txtProfile.Id,enabled_to_work__c ='CA', 
                                TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg111.com');
        return tstUser;
    }
    
    public static List<Account> createAccounts(){
        
        for(Integer i=0; i<5; i++)
        {
            Account a = new Account();
            a.FirstName = 'Nagarjuna'+i;
            a.LastName = 'Kaipu'+i;
            a.Date_of_Birth__c = Date.ValueOf('1985-07-01');
            testAccList.add(a);
        }
        return testAccList;
    }
    
    
    public static List<Task> createTasks(){
        
        for(Integer i=2; i<=6; i++)
        {
            Task t = new Task();
            t.ActivityDate = System.Today()+i;
            t.Subject = 'Subject'+i;
            testTaskList.add(t);
        }
        return testTaskList;
    }
    public static List<Task> createOutboundTasks(){
        
        for(Integer i=0; i<=11; i++)
        {
            Task t = new Task();
            t.ActivityDate = System.Today()+i;
            t.Subject = 'Subject'+i;
            testTaskList.add(t);
        }
        return testTaskList;
    }
    
    public static LIst<Lead> createBulkLeads(){ 
        
        for (Integer j=0;j<=200;j++){
            
            Lead ld=new Lead();              
            ld.firstname='Anthem'+j;
            ld.lastname='Santosh'+j; 
            ld.Date_of_Birth__c=Date.ValueOf('1985-07-01');
        }
        return testLeadList;
    }
    public static List<CS001_RecordTypeBusinessTrack__c> createCS001Data(){
        CS001_RecordTypeBusinessTrack__c cs001 = new CS001_RecordTypeBusinessTrack__c ();
        cs001.name = 'Account_Person Account';
        cs001.BusinessTrackName__c = System.label.Telesales;
        CS001_RecordTypeBusinessTrack__c cs002 = new CS001_RecordTypeBusinessTrack__c ();
        cs002.name = 'Lead_TS MASTER';
        cs002.BusinessTrackName__c = System.label.Telesales;
        CS001_RecordTypeBusinessTrack__c cs003 = new CS001_RecordTypeBusinessTrack__c ();
        cs003.name = 'Opportunity_TS MASTER';
        cs003.BusinessTrackName__c = System.label.Telesales;
        CS001_RecordTypeBusinessTrack__c cs004 = new CS001_RecordTypeBusinessTrack__c ();
        cs004.name = 'Task_Send Fulfillment';
        cs004.BusinessTrackName__c = System.label.Telesales;
        CS001_RecordTypeBusinessTrack__c cs005 = new CS001_RecordTypeBusinessTrack__c ();
        cs005.name = 'Task_Schedule Followup';
        cs005.BusinessTrackName__c = System.label.Telesales;
        CS001_RecordTypeBusinessTrack__c cs006 = new CS001_RecordTypeBusinessTrack__c ();
        cs006.name = 'Task_Inbound/Outbound Call Activity';
        cs006.BusinessTrackName__c = System.label.Telesales;
        CS001_RecordTypeBusinessTrack__c cs007 = new CS001_RecordTypeBusinessTrack__c ();
        cs007.name = 'Opportunity_Closed Won/Lost';
        cs007.BusinessTrackName__c = System.label.Telesales;
        CS001_RecordTypeBusinessTrack__c cs008 = new CS001_RecordTypeBusinessTrack__c ();
        cs008.name = 'Campaign_TS MASTER';
        cs008.BusinessTrackName__c = System.label.Telesales;
        CS001_RecordTypeBusinessTrack__c cs009 = new CS001_RecordTypeBusinessTrack__c ();
        cs009.name = 'Account_Business Account';
        cs009.BusinessTrackName__c = System.label.Telesales;
        CS001_RecordTypeBusinessTrack__c cs010 = new CS001_RecordTypeBusinessTrack__c ();
        cs010.name = 'Account_Group';
        cs010.BusinessTrackName__c = 'SGQUOTING';
        CS001_RecordTypeBusinessTrack__c cs011 = new CS001_RecordTypeBusinessTrack__c ();
        cs011.name = 'Account_Agency';
        cs011.BusinessTrackName__c = 'BROKER';
        CS001_RecordTypeBusinessTrack__c cs012 = new CS001_RecordTypeBusinessTrack__c ();
        cs012.name = 'Opportunity_SG Quoting';
        cs012.BusinessTrackName__c = 'SGQUOTING';
        CS001_RecordTypeBusinessTrack__c cs013 = new CS001_RecordTypeBusinessTrack__c ();
        cs013.name = 'Task_SGA-Case Installation';
        cs013.BusinessTrackName__c = 'SGQUOTING';
        CS001_RecordTypeBusinessTrack__c cs014 = new CS001_RecordTypeBusinessTrack__c ();
        cs014.name = 'Task_SGA Task';
        cs014.BusinessTrackName__c = 'SGQUOTING';
        CS001_RecordTypeBusinessTrack__c cs015 = new CS001_RecordTypeBusinessTrack__c ();
        cs015.name = 'Account_Agency/Brokerage';
        cs015.BusinessTrackName__c = 'SGQUOTING';
        
        List<CS001_RecordTypeBusinessTrack__c> cs001List = new List<CS001_RecordTypeBusinessTrack__c>();
        cs001List.add(cs001);
        cs001List.add(cs002);
        cs001List.add(cs003);
        cs001List.add(cs004);
        cs001List.add(cs005);
        cs001List.add(cs006);
        cs001List.add(cs007);
        cs001List.add(cs008);
        cs001List.add(cs009);
        cs001List.add(cs010);
        cs001List.add(cs011);
        cs001List.add(cs012);
        cs001List.add(cs013);
        cs001List.add(cs014);
        cs001List.add(cs015);
        return cs001List;
    }
    public static List<CS002_RTypeAssignOnLeadConvert__c> createCS002Data(){
        ID accRT =[select Id,Name from Recordtype where Name = 'Person Account' and SobjectType = 'Account'].Id;   
        ID oppRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'Opportunity'].Id;  
        ID accOppsRT =[select Id,Name from Recordtype where Name = 'Anthem Opps' and SobjectType = 'Account'].Id;   
        ID oppOppsRT =[select Id,Name from Recordtype where Name = 'Anthem Opps' and SobjectType = 'Opportunity'].Id;  
        Id grpRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group').getRecordTypeId();
        CS002_RTypeAssignOnLeadConvert__c cs001 = new CS002_RTypeAssignOnLeadConvert__c ();
        cs001.name = 'Account_TELESALES';
        cs001.RecordTypeID__c = accRT;
        CS002_RTypeAssignOnLeadConvert__c cs002 = new CS002_RTypeAssignOnLeadConvert__c ();
        cs002.name = 'Opportunity_TELESALES';
        cs002.RecordTypeID__c = oppRT;
        CS002_RTypeAssignOnLeadConvert__c cs003 = new CS002_RTypeAssignOnLeadConvert__c ();
        cs003.name = 'Account_ANTHEMOPPS';
        cs003.RecordTypeID__c = accOppsRT;
        CS002_RTypeAssignOnLeadConvert__c cs004 = new CS002_RTypeAssignOnLeadConvert__c ();
        cs004.name = 'Opportunity_ANTHEMOPPS';
        cs004.RecordTypeID__c = oppOppsRT;
        CS002_RTypeAssignOnLeadConvert__c cs005 = new CS002_RTypeAssignOnLeadConvert__c ();
        cs005.name = 'Account_SGQUOTING';
        cs005.RecordTypeID__c = grpRecordTypeId;
        List<CS002_RTypeAssignOnLeadConvert__c> cs001List = new List<CS002_RTypeAssignOnLeadConvert__c>();
        cs001List.add(cs001);
        cs001List.add(cs002);
        cs001List.add(cs003);
        cs001List.add(cs004);
        cs001List.add(cs005);
        return cs001List;
    }
    
    
    /*********** Added by nmishra@vlocity.com ***********/
    
    
    public static Account createAccount(String name) {
        Account account         = new Account();
        account.Name            = name;
        return account;
    }
    
    public static Contact createContact(String firstName, String lastName, String emailId, Id accountId) {
        Id recordTypeId = [SELECT Id, Description,DeveloperName,IsActive,Name,SobjectType 
                           FROM RecordType 
                           WHERE SobjectType = 'Contact' 
                           AND DeveloperName = 'Anthem_Opps'].Id;
        Contact contact     = new Contact();
        contact.FirstName   = firstName;
        contact.LastName    = lastName;
        contact.Email       = emailId;
        contact.AccountId   = accountId;
        
        return contact;
    }
    
    public static User createUser(Id contactId, String fName, String lName, String email, String userName) {
        Id profileId = [SELECT Id,Name,UserType 
                        FROM Profile 
                        WHERE Name = 'Anthem SG Broker' 
                        LIMIT 1].Id;
        User dummyUser = [SELECT TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, LanguageLocaleKey
                          FROM User 
                          LIMIT 1];
        User broker                 = new User();
        broker.ContactId            = contactId;
        broker.FirstName            = fName;
        broker.LastName             = lName;
        broker.Email                = email;
        broker.Username             = userName;
        broker.ProfileId            = profileId;
        broker.Alias                = lName.substring(0,4);
        broker.CommunityNickname    = lName.substring(0,4);
        broker.TimeZoneSidKey       =dummyUser.TimeZoneSidKey;
        broker.LocaleSidKey         =dummyUser.LocaleSidKey;
        broker.EmailEncodingKey     =dummyUser.EmailEncodingKey;
        broker.LanguageLocaleKey    =dummyUser.LanguageLocaleKey;
        return broker;
        
    }
    
    public static Opportunity createOpportunity(Id broker, Id paidAgency, Id generalAgency) {
        Opportunity opp = new Opportunity();
        opp.Name = 'My Test Opp';
        opp.StageName = 'Opportunity';
        opp.CloseDate = System.today().addDays(4);
        opp.Broker__c = broker;
        opp.GeneralAgency__c = generalAgency;
        opp.PaidAgency__c = paidAgency;
        
        return opp;
        
    }
    
    public static vlocity_ins__Application__c createApplication() {
        vlocity_ins__Application__c testApplication = new vlocity_ins__Application__c(name='Test Application',
                                                                                      Date_Enrollment_Complete__c = System.now()+2);
        return testApplication;
    }
    
    public static Quote createQuote() {
        Quote testQuote = new Quote(Name='Test Quote',Coverage_Options__c = 'Medical,Dental,Vision',
                                   vlocity_ins__EffectiveDate__c = Date.today(), Brand__c = 'EBC');
        
        return testQuote;
    }
    
    public static Account createGroupAccount(){
        Id grpRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group').getRecordTypeId();
        Account testGrpAccount = new Account(recordtypeId=grpRecordTypeId,Name='Test Account',Group_Number__c = '12345',Company_State__c = 'NY',
                                          Group_Number_2__c='54321',Employer_EIN__c = '345234123',Tech_Businesstrack__c='SGQUOTING',
                                          BillingCity='Houston',BillingStreet='2 Avenue Road',BillingState='NY',BillingPostalCode='56839', BR_Encrypted_TIN__c = '9999');
        return testGrpAccount;
    }
    
     public static Account createBrokerAgentAccount(){
        Id grpRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Agency/Brokerage').getRecordTypeId();
        Account testGrpAccount = new Account(recordtypeId=grpRecordTypeId,Name='Test Account1');
        return testGrpAccount;
    }
    
    public static Account createBrokerAgentAccountData(){
        Id grpRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Agency/Brokerage').getRecordTypeId();
        Account testGrpAccount = new Account(recordtypeId=grpRecordTypeId,Name='Test Account1', Type = 'Prospect', Employer_EIN__c = '000000000');
        return testGrpAccount;
    }
    
    public static Account pepareForUpdate(Account acc,Id PartyId){
        acc.vlocity_ins__PartyId__c=PartyId;
        return acc;
    }
    
    public static Opportunity createGrpAccOpportunity(){
        Opportunity testGrpOpp = new Opportunity( Name = 'My Test Opp',Open_Enrollment__c='OE2015',
                                              StageName = 'Opportunity',
                                              CloseDate = System.today().addDays(4),recordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SG Quoting').getRecordTypeId());
        return testGrpOpp;
    }
    
    public static User createUser(){
        Profile txtProfile = [SELECT Id FROM Profile WHERE Name='System Administrator' Limit 1]; 
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        User tstUser = new User(Alias = 'standt1', Email='standarduser@testorg1.com', UserRoleId = portalRole.Id, 
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = txtProfile.Id,enabled_to_work__c ='CA', 
                                TimeZoneSidKey='America/Los_Angeles', UserName='standardUSER989999@testOrg.com');
        insert tstUser;
        return tstUser;
    }
    
    public static User createByPassUser(){
        Profile txtProfile = [SELECT Id FROM Profile WHERE Name='System Administrator' Limit 1]; 
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        User tstUser = new User(Alias = 'standt1', Email='standarduser@testorg1.com', UserRoleId = portalRole.Id, 
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = txtProfile.Id,enabled_to_work__c ='CA', 
                                TimeZoneSidKey='America/Los_Angeles', UserName='standardUSER98999912@testOrg.com',BypassVR__c = true);
        insert tstUser;
        return tstUser;
    }    
     public static vlocity_ins__Party__c createPartyforAccount(Id AccountId) {
        vlocity_ins__Party__c party = new vlocity_ins__Party__c(
                                Name='Test123',
                                vlocity_ins__AccountId__c = AccountId,
                                vlocity_ins__IsPersonAccount__c = false,
                                vlocity_ins__PartyEntityId__c = AccountId,
                                vlocity_ins__PartyEntityType__c = 'Account'
                                );
        return party;
    }
    
    
    public static vlocity_ins__ApplicationPartyRelationship__c createApplicationPartyRelationship(Id AppId,Id PartyId){
      vlocity_ins__ApplicationPartyRelationship__c appPartyRel = new vlocity_ins__ApplicationPartyRelationship__c(
                                vlocity_ins__ApplicationId__c = AppId,
                                vlocity_ins__PartyId__c = PartyId
                                );
      return appPartyRel;

    }
    
    public static vlocity_ins__OmniScriptInstance__c  createOmniScriptInstance(Account acc,String objectLabel,Id omniSriptId,String Status){
      vlocity_ins__OmniScriptInstance__c  omniScriptInstance = new vlocity_ins__OmniScriptInstance__c (
                    vlocity_ins__ObjectId__c = acc.Id,
                    vlocity_ins__ObjectLabel__c = objectLabel,
                    vlocity_ins__ObjectName__c = acc.Name,
                    vlocity_ins__OmniScriptId__c = omniSriptId,
                    vlocity_ins__ResumeLink__c = 'Test Link',
                    vlocity_ins__LastSaved__c = System.now(),
                    vlocity_ins__Status__c = Status );
      return omniScriptInstance;

    }
    
    public static vlocity_ins__OmniScript__c  createOmniScript(String Type,String SubType) {
      
      vlocity_ins__OmniScript__c  omniScript = new vlocity_ins__OmniScript__c (
                    vlocity_ins__IsActive__c = True,
                    vlocity_ins__SubType__c = SubType,
                    vlocity_ins__Type__c = Type,
                    vlocity_ins__Version__c = 1.0 
                 );
      return omniScript;
    }
    
    public static Account createGroupAccountForRelatedList(){
        Account testAccount = Util02_TestData.createGroupAccount();
                testAccount.Group_Number__c='123456';
                testAccount.Group_Number_2__c='12345611';
                testAccount.Sic='test1233';
                testAccount.Employer_EIN__c='EIN123456';
        return testAccount;
    }
    
    public static vlocity_ins__Application__c createApplicationForRelatedList(String status,Date GroupCoverageDate) {
        vlocity_ins__Application__c testApplication = Util02_TestData.createApplication();
                      testApplication.Group_Coverage_Date__c = GroupCoverageDate;
                      testApplication.Member_Count__c = 15;
                      testApplication.WritingAgentETIN__c ='ETIN12344';
                      testApplication.vlocity_ins__Status__c=status;
        return testApplication;
    }
    public static Application_Document_Checklist__c createApplicationDocumentCheckList(Id configId,Id appId)
    {
        Application_Document_Checklist__c adc=new Application_Document_Checklist__c();
        adc.Document_Name__c='Member Application';
        adc.File_Name__c='Test1.docx';
        adc.Required__c=true;
        adc.Status__c='Submitted';
        adc.Application_Document_Config__c=configId;
        adc.Application__c=appId; 
        return adc;
        
    }
    
    public static List<Application_Document_Checklist__c> createAppDocumentCheckList(Id configId,Id appId)
    {
        List<Application_Document_Checklist__c> adcList = new List<Application_Document_Checklist__c>();
        Application_Document_Checklist__c adc = new Application_Document_Checklist__c();
        adc.Document_Name__c='Quote Proposal';
        adc.File_Name__c='Test1.docx';
        adc.File_Size__c = '12345';
        adc.Required__c=true;
        adc.Status__c='Not Submitted';
        
        Application_Document_Checklist__c adc1 = new Application_Document_Checklist__c();
        adc1.Document_Name__c='NYS 45';
        adc1.File_Name__c='Test2.docx';
        adc1.Required__c=true;
        adc1.Status__c='Not Submitted';
        
        Application_Document_Checklist__c adc2 = new Application_Document_Checklist__c();
        adc2.Document_Name__c='Tax Documents';
        adc2.File_Name__c='Test2.docx';
        adc2.Required__c=true;
        adc2.Status__c='Not Submitted';
        
        adcList.add(adc);
        adcList.add(adc1);
        adcList.add(adc2);
        return adcList;
        
    }
    
    public static Application_Document_Config__c createApplicationDocumentConfig()
    {
        Application_Document_Config__c adc=new Application_Document_Config__c();
        adc.Description__c='Test';
        adc.Document_Name__c='Test.txt';
        adc.Required__c=true;
        adc.State__c='CA';
        
        return adc;
    }
    
    public static vlocity_ins__Application__c createApplicationRec(String accountId, String partyId) {
        System.debug(':::accountId::::'+accountId);
        vlocity_ins__Application__c testApplication = new vlocity_ins__Application__c(name='Test Application', vlocity_ins__AccountId__c = accountId,
                                                                                      vlocity_ins__PrimaryPartyId__c = partyId, Date_Enrollment_Complete__c = System.now()+2);
        return testApplication;
    }
    
    public static List<Application_Document_Config__c> createDocumentConfigList()
    {
        List<Application_Document_Config__c> configList = new List<Application_Document_Config__c>();
        configList.add(new Application_Document_Config__c(Document_Name__c = 'Employer Application', Required__c = true, State__c = 'NY'));
        configList.add(new Application_Document_Config__c(Document_Name__c = 'NYS 45', Required__c = false, State__c = 'NY'));
        configList.add(new Application_Document_Config__c(Document_Name__c = 'Tax Documents', Required__c = false, State__c = 'NY'));
        configList.add(new Application_Document_Config__c(Document_Name__c = 'Initial Payment', Required__c = true, State__c = 'NY'));
        configList.add(new Application_Document_Config__c(Document_Name__c = 'Voided Check', Required__c = true, State__c = 'NY'));
        configList.add(new Application_Document_Config__c(Document_Name__c = 'HSA', Required__c = true, State__c = 'NY'));
        return configList;
    }
    
    public static List<Broker_Date_Settings__c> createBrokerDatesCustomSettings(){
        Broker_Date_Settings__c brokerCS001 = new Broker_Date_Settings__c ();
        brokerCS001.Name = 'NY';
        brokerCS001.Broker_Date_Span__c = 93;
        brokerCS001.Broker_Skip_Days__c = -30;
        brokerCS001.EffectiveDate_Start_Year__c = 2017;
        brokerCS001.Internal_users_days_span__c = 150;
        brokerCS001.Internal_Users_Past_Days_Span__c = -720;
        List<Broker_Date_Settings__c> brokerCS001List = new List<Broker_Date_Settings__c>();
        brokerCS001List.add(brokerCS001);
        
        return brokerCS001List;
    }
    
    public static List<Product2> createProductsForSGA(){
        List<Product2> pList = new List<Product2>();
        Product2 prod1 = new Product2(Name = 'Testing Product', Family = 'Best Practices', IsActive = true, vlocity_ins__Type__c = 'Vision');
        Product2 prod2 = new Product2(Name = 'Testing Product', Family = 'Best Practices', IsActive = true, vlocity_ins__Type__c = 'Dental');
        Product2 prod3 = new Product2(Name = 'Testing Product', Family = 'Best Practices', IsActive = true, vlocity_ins__Type__c = 'Medical');
        
        pList.add(prod1);
        pList.add(prod2);
        pList.add(prod3);
        
        return pList;
    }
    
     public static Product2 createProduct(){
       Product2 prod = new Product2(Name = 'Testing Product', Family = 'Best Practices', IsActive = true, vlocity_ins__Type__c = 'Vision');
       return prod;
    }
    
    public static Pricebook2 createPricebook2SGA(){
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        return customPB;
    }
    
    public static PricebookEntry createPricebookEntrySGA(Id prd2Id,Id price2Id,Boolean isStandard){
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = price2Id, Product2Id = prd2Id,
            UnitPrice = 12000, IsActive = true,
            UseStandardPrice = isStandard);
        return customPrice;
    }
    
    public static Quote createQuoteSGA(Id oppId,Date dt,Id priceBook2Id, String brand){
        Quote qt = new Quote (Name = 'quotetest' , OpportunityId = oppId, Coverage_Options__c = 'Medical,Dental,Vision', vlocity_ins__EffectiveDate__c = dt, Brand__c = brand, Pricebook2Id = priceBook2Id);
        return qt;
    }
    
    public static List<SGA_CS01_DocNameSubjectValue__c> createDocusignSubjectValues(){
        
        List<SGA_CS01_DocNameSubjectValue__c> docNameSubjValueList = new List<SGA_CS01_DocNameSubjectValue__c>();
        SGA_CS01_DocNameSubjectValue__c cs1 = new SGA_CS01_DocNameSubjectValue__c();
        cs1.Name = System.Label.SG25_Initial_Payment;
        cs1.DocuSignStatus_Subject__c = System.Label.SG24_SG_Electronic_Debit_Form;
        docNameSubjValueList.add(cs1);
        
        SGA_CS01_DocNameSubjectValue__c cs2 = new SGA_CS01_DocNameSubjectValue__c();
        cs2.Name = System.Label.SG32_Voided_Cheque;
        cs2.DocuSignStatus_Subject__c = System.Label.SG24_SG_Electronic_Debit_Form;
        docNameSubjValueList.add(cs2);
        
        SGA_CS01_DocNameSubjectValue__c cs3 = new SGA_CS01_DocNameSubjectValue__c();
        cs3.Name = System.Label.SG23_EmployerApplication;
        cs3.DocuSignStatus_Subject__c = 'Employer Application EBC,Employer Application EBCBS';
        docNameSubjValueList.add(cs3);
        
        SGA_CS01_DocNameSubjectValue__c cs4 = new SGA_CS01_DocNameSubjectValue__c();
        cs4.Name = System.Label.SG27_HRA;
        cs4.DocuSignStatus_Subject__c = System.Label.SG28_HRA_Form;
        docNameSubjValueList.add(cs4);
        
        return docNameSubjValueList;
    }
    
    /* Create case Installation case */
    public static Case createSGInstallationCase()
    {
        ID caseRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Small Group Case Installation').getRecordTypeId();      
        case testCase = new Case();
        testCase.RecordTypeId = caseRT;
        testCase.status = 'Assigned';
        testCase.Stage__c = 'Group Submitted, Under Review';
        testCase.Origin = 'Origin';
        testCase.Priority = 'Normal';
        testCase.BR_State__c = 'NY';
        testCase.Paperwork_Received__c = System.Today();
        
        return testCase;
    }
    
    /* Create case Installation case */
    public static Case createSGPEIMCase()
    {
        ID caseRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Small Group Pre-Enrollment Inquiry').getRecordTypeId();      
        case testCase = new Case();
        testCase.RecordTypeId = caseRT;
        testCase.status = 'Assigned';
        testCase.Stage__c = 'Group Submitted, Under Review';
        testCase.Origin = 'Origin';
        testCase.Priority = 'Normal';
        testCase.BR_State__c = 'NY';
        testCase.Paperwork_Received__c = System.Today();
        
        return testCase;
    }
    
    /* Create CaseComment*/
    public static CaseComment createCaseComment ()
    {
        CaseComment testCaseComment = new CaseComment();
        testCaseComment.CommentBody = 'Test Case Comment';
        
        return testCaseComment;
    }
    
    public static Case insertSGACase(ID accId,Id appId){
        case testCase = new Case();
        testCase.AccountId = accId;
        testCase.Application_Name__c = appId;
        ID caseRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Small Group Case Installation').getRecordTypeId();      
        testCase.RecordTypeId = caseRT;
        testCase.status = 'New';
        testCase.Stage__c = 'Scrub Completed';
        testCase.Origin = 'SALES';
        testCase.Priority = 'Normal';
        testCase.BR_State__c = 'NY';
        testCase.Paperwork_Received__c = System.Today();
        return testCase;
    }
    
    public static Application_Document_Config__c createApplicationDocumentConfigNY()
    {
        Application_Document_Config__c adc=new Application_Document_Config__c();
        adc.Description__c='Test';
        adc.Document_Name__c='Test.txt';
        adc.Required__c=true;
        adc.State__c='NY';
        
        return adc;
    }
    
    public static AccountTeamMember createAccountTeamMember()
    {
        AccountTeamMember atm = new AccountTeamMember();
        atm.TeamMemberRole  ='Broker';
        return atm;
    }
    
    public static List<SGA_State_Product_Taglines__c> createStateSpecificDetails(){
        List<SGA_State_Product_Taglines__c> pTagLineList = new List<SGA_State_Product_Taglines__c>();
        SGA_State_Product_Taglines__c nyStateDetails = new SGA_State_Product_Taglines__c();
        nyStateDetails.Name = 'NY';
        nyStateDetails.Brand_Name__c = 'BlueShild BlueCross';
        nyStateDetails.Configurable_Paragraph__c = 'Test';
        nyStateDetails.Product_Tag_Line__c = 'Test';
        nyStateDetails.Sales_Support_Email__c = 'testny@anthem.com';
        
        SGA_State_Product_Taglines__c caStateDetails = new SGA_State_Product_Taglines__c();
        caStateDetails.Name = 'CA';
        caStateDetails.Brand_Name__c = 'Anthem';
        caStateDetails.Configurable_Paragraph__c = 'Test';
        caStateDetails.Product_Tag_Line__c = 'Test';
        caStateDetails.Sales_Support_Email__c = 'testca@anthem.com';
        
        SGA_State_Product_Taglines__c coStateDetails = new SGA_State_Product_Taglines__c();
        coStateDetails.Name = 'CO';
        coStateDetails.Brand_Name__c = 'Anthem';
        coStateDetails.Configurable_Paragraph__c = 'Test';
        coStateDetails.Product_Tag_Line__c = 'Test';
        coStateDetails.Sales_Support_Email__c = 'testco@anthem.com';
        
        SGA_State_Product_Taglines__c meStateDetails = new SGA_State_Product_Taglines__c();
        meStateDetails.Name = 'ME';
        meStateDetails.Brand_Name__c = 'Anthem';
        meStateDetails.Configurable_Paragraph__c = 'Test';
        meStateDetails.Product_Tag_Line__c = 'Test';
        meStateDetails.Sales_Support_Email__c = 'testme@anthem.com';
        
        pTagLineList.add(nyStateDetails);
        pTagLineList.add(caStateDetails);
        pTagLineList.add(coStateDetails);
        pTagLineList.add(meStateDetails);
        return pTagLineList;
    }
    public static Note createNote(Id parentId)
    {
        Note nt = new Note();
        nt.Title = 'Test Note123';
        nt.Body = 'Testing Note.';
        nt.ParentId =parentId;
        return nt;
    }
    
    public static Geographical_Info__c createGeoRecord(){
        Geographical_Info__c geo = new Geographical_Info__c(State__c='NY' ,Name = 'EBCBS' ,Zip_Code__c = '12766' , County__c='COLUMBIA', RatingArea__c =3);
        return geo;
    }
    
    public static User_Sales_Rep_Code__c  createSalesRepCode(){
        User_Sales_Rep_Code__c usrp = new User_Sales_Rep_Code__c();
        usrp.Sales_Rep_Code__c = 'usd';
        usrp.State__c = 'NY';
        return usrp;
    }
}