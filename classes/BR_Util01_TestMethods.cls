public class BR_Util01_TestMethods {

public static Account testAccount;
public static Case testCase;
public static Task testTask;
public static Call_Info__c callinfo;
public static CaseComment cc;
public static Brokerage_Broker__c testbrokerage;

    public static User CreateTestUser(){
        Profile txtProfile = [SELECT Id FROM Profile WHERE Name='System Administrator' Limit 1]; 
        User tstUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                           LocaleSidKey='en_US', ProfileId = txtProfile.Id, 
                                           TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg111.com');
    return tstUser;
    }
    public static Account CreateAgencyAccount(){
        List<RecordType> recList = [SELECT id FROM RECORDTYPE WHERE Name = 'Agency' AND sObjectType = 'Account'];
        testAccount = new Account(Name='Naga Agency');
        testAccount.RecordTypeId = recList[0].Id;
    return testAccount;
    }
    public static Account CreateBrokerAccount(){
        List<RecordType> recbList = [SELECT id FROM RECORDTYPE WHERE Name = 'Broker' AND sObjectType = 'Account'];
        testAccount = new Account(FirstName='Nagarjuna', LastName='Broker', BR_Tax_Identification_Number__c = '34567', BR_Encrypted_TIN__c = '76543', BR_National_Producer_Number__c = '345');
        testAccount.RecordTypeId = recbList[0].Id;
    return testAccount;
    }
    public static Brokerage_Broker__c CreateBrokerage(){
        testbrokerage = new Brokerage_Broker__c();
            testbrokerage.BR_Broker_Type__c = 'B';
            testbrokerage.BR_Contract_Type__c = 'INDIVIDUAL';
            testbrokerage.BR_State__c = 'CA';
            testbrokerage.BR_Parent_Encrypted_TIN__c = 'ASCSSSS1';
            testbrokerage.BR_Paid_Encrypted_TIN__c = 'ASCSSSS1';
            testbrokerage.BR_ASCS_Broker_Code__c = '234589';
            testbrokerage.BR_Start_Date__c = Date.valueOf('2010-08-01 00:00:00');   
    return testbrokerage;
    }
    public static Case CreateCase(){
        List<RecordType> caserecList = [SELECT id FROM RECORDTYPE WHERE Name = 'Broker Case' AND sObjectType = 'Case'];
        testCase = new Case(Origin='Phone', Status = 'New', Priority = 'Normal', BR_State__c ='CA', BR_Department__c='Sales Support',
                           BR_Line_of_Business__c='Individual', BR_Category__c='Billing', BR_Sub_Category__c='PTD',
                           BR_Product_Type__c='Medical', Subject='Test Case trigger', Description='Test Case trigger Desc');
        testCase.RecordTypeId = caserecList[0].Id;
    return testCase;
    }
    public static Task CreateTask(){
        List<RecordType> taskrecList = [SELECT id FROM RECORDTYPE WHERE sObjectType = 'Task' AND Name like '%BR%'];
        testTask = new Task(Status = 'In Progress', BR_Activity_Type__c = 'Inbound', BR_Routed_To__c = 'Claims', 
                            ActivityDate= Date.valueOf('2015-08-10 12:00:00'), Priority = 'Normal');
        testTask.RecordTypeId = taskrecList[0].Id;
    return testTask;
    }
    public static Call_Info__c CreateCallInfo()
    {
        callinfo = new Call_Info__c(BR_Call_Id__c = 'NAGA12345', BR_Duration__c = '1Hr', BR_Phone_Number__c = '9985432126', BR_Start_Date__c = System.Today());
        return callinfo;
    }
    public static CaseComment CreateCaseComment()
    {
        cc = new CaseComment(CommentBody = 'NagaCase');
        return cc;
    }
    public static List<CS001_RecordTypeBusinessTrack__c> createBusinessTrack(){
        CS001_RecordTypeBusinessTrack__c cs001 = new CS001_RecordTypeBusinessTrack__c ();
            cs001.name = 'Account_Agency';
            cs001.BusinessTrackName__c = 'BROKER';
        CS001_RecordTypeBusinessTrack__c cs002 = new CS001_RecordTypeBusinessTrack__c ();
            cs002.name = 'Account_Broker';
            cs002.BusinessTrackName__c = 'BROKER';
        CS001_RecordTypeBusinessTrack__c cs003 = new CS001_RecordTypeBusinessTrack__c ();
            cs003.name = 'Task_BR-Inbound/Outbound Call';
            cs003.BusinessTrackName__c = 'BROKER';
        CS001_RecordTypeBusinessTrack__c cs004 = new CS001_RecordTypeBusinessTrack__c ();
            cs004.name = 'Task_BR-Schedule Followup';
            cs004.BusinessTrackName__c = 'BROKER';
        CS001_RecordTypeBusinessTrack__c cs005 = new CS001_RecordTypeBusinessTrack__c ();
            cs005.name = 'Task_BR-Send Fulfillment';
            cs005.BusinessTrackName__c = 'BROKER'; 
        CS001_RecordTypeBusinessTrack__c cs006 = new CS001_RecordTypeBusinessTrack__c ();
            cs006.name = 'Task_Broker Genesys Call';
            cs006.BusinessTrackName__c = 'BROKER'; 
        List<CS001_RecordTypeBusinessTrack__c> cs001List = new List<CS001_RecordTypeBusinessTrack__c>();
        cs001List.add(cs001);
        cs001List.add(cs002);
        cs001List.add(cs003);
        cs001List.add(cs004);
        cs001List.add(cs005);
        cs001List.add(cs006);
    return cs001List;
    }
    
    public static ASCSServiceInfo createASCSTestData(){
        ASCSServiceInfo ascsInfo = new ASCSServiceInfo();
        List<Account> accList = new List<Account>();
        List<License_Appointment__c> licenseList= new List<License_Appointment__c>();
        List<Certification__c> certiList = new List<Certification__c>();
        List<License_Appointment__c> conList = new List<License_Appointment__c>();
        List<Brokerage_Broker__c> relationList = new List<Brokerage_Broker__c>();
        
        Account acc = new Account();
            acc.FirstName = 'Test';
            acc.LastName = '<![CDATA[ASCSAccounttest1]]>';
            acc.BR_Encrypted_TIN__c = 'ASCSSSS1';
            acc.PersonEmail = '<![CDATA[abctest@test.com]]>';
            acc.Work_Phone__c = '<![CDATA[789654321]]>';
            acc.Billing_Street__c = '<![CDATA[lane 1]]>';
            acc.Billing_City__c = '<![CDATA[Texas]]>';
            acc.Billing_State__c = 'CA';
            acc.Billing_PostalCode__c = '<![CDATA[38975]]>';
            acc.BillingCountry = 'New york';
        accList.add(acc);
        
        License_Appointment__c license = null;
        //License 1
        license = new License_Appointment__c();
            license.BR_Type__c = 'Appointment';
            license.BR_Start_Date__c = Date.valueOf('2010-08-06 00:00:00');
            license.BR_End_Date__c = Date.valueOf('2017-01-31 00:00:00');
            license.BR_State__c = 'CA';
            license.BR_Encrypt_ID__c = 'ASCSSSS1';
        licenseList.add(license);
        //License 2
        license = new License_Appointment__c();
            license.BR_Type__c = 'License';
            license.BR_Start_Date__c = Date.valueOf('2003-11-06 00:00:00');
            license.BR_End_Date__c = Date.valueOf('2017-05-31 00:00:00');
            license.BR_State__c = 'CO';
            license.BR_Encrypt_ID__c = 'ASCSSSS1';
        licenseList.add(license);
        
        Certification__c certification = new Certification__c();
            certification.BR_State__c = 'CA';
            certification.BR_Certificate_Effective_Date__c = Date.valueOf('2003-11-06 00:00:00');
            certification.BR_Certificate_End_Date__c = Date.valueOf('2017-05-31 00:00:00');
        certiList.add(certification);
        
        Brokerage_Broker__c brokerage = null;
        //Brokerage 1
        brokerage = new Brokerage_Broker__c();
            brokerage.BR_Broker_Type__c = 'B';
            brokerage.BR_Contract_Type__c = 'INDIVIDUAL';
            brokerage.BR_State__c = 'CA';
            brokerage.BR_Parent_Encrypted_TIN__c = 'ASCSSSS1';
            brokerage.BR_Paid_Encrypted_TIN__c = 'ASCSSSS1';
            brokerage.BR_Start_Date__c = Date.valueOf('2010-08-01 00:00:00');
        relationList.add(brokerage);
        
        License_Appointment__c contract = null;
        //License 1
        contract = new License_Appointment__c();
            contract.BR_Type__c = 'Contract';
            contract.BR_Start_Date__c = Date.valueOf('2010-08-06 00:00:00');
            contract.BR_State__c = 'CA';
            contract.BR_Encrypt_ID__c = 'ASCSSSS1';
        conList.add(contract);
        ascsInfo.accList = accList;
        ascsInfo.lAList = licenseList;
        ascsInfo.relationList = relationList;
        ascsInfo.conList = conList;
        ascsInfo.certiList = certiList;
        System.debug('UtilASCS:::::'+ascsInfo);
    return ascsInfo;    
    }
    
}