public with sharing class TestResources {
    
    
    public static map<String,map<String,RecordType>> mRecordType;
    
    static{
        mRecordType = new map<String,map<String,RecordType>>();
        Map<String, RecordType> mRecordTypeByDevName;
        for(RecordType eachRecordType : [SELECT Id
                                            ,DeveloperName
                                            ,SObjectType
                                     FROM RecordType
                                     WHERE IsActive = true]){
             if(mRecordType.containsKey(eachRecordType.SObjectType)){
                 mRecordType.get(eachRecordType.SObjectType).put(eachRecordType.DeveloperName,eachRecordType);
             }
             else{
                 mRecordTypeByDevName = new map<String,RecordType>();
                 mRecordTypeByDevName.put(eachRecordType.DeveloperName,eachRecordType);
                 mRecordType.put(eachRecordType.SObjectType,mRecordTypeByDevName);      
             }
         }
                                     
    }    
    
    //Create customSettings for unit test
    public static void createCustomSettings(){
        createCS001_RecordTypeBusinessTrack();
    }
    
    public static list<SObject> createCS001_RecordTypeBusinessTrack(){
    
        list<SObject>lRecordTypeBusinessTrack = test.loadData(CS001_RecordTypeBusinessTrack__c.SObjectType,'Test_CS001RecordTypeBusinessTrack');
        return lRecordTypeBusinessTrack;
    }
    
   
    
    private static User DummyUser {
        get {
            if (DummyUser==null) {
                DummyUser = [select id, TimeZoneSidKey, LocaleSidKey, 
                    EmailEncodingKey, ProfileId, LanguageLocaleKey
                    from User limit 1];
            }
            return DummyUser ;
        } set ;
    }
    
    private static Account acc {
        get {
            if (acc==null) {
                Id accAntOppsRecTypeId = [SELECT Id, Name FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Anthem_Opps'].Id;
                acc = new Account(Name='Account Test', RecordTypeId = accAntOppsRecTypeId);
                insert acc;
            }
            
            return acc ;
            
        } set ;
    }    
    
    private static Profile systemAdminProfile{
        get{
            if (systemAdminProfile==null){
                systemAdminProfile = [Select id from Profile Where Name=: 'System Administrator' limit 1];
            }
            return systemAdminProfile;
        } set;
    }
    
    public static Profile brokerProfile{
        get{
            if (brokerProfile==null){
                brokerProfile = AnthemOppsProfiles.brokerProfile;
            }
            return brokerProfile;
        } set;
    }    
        
    private static Profile salesRepProfile {
        get{
            if (salesRepProfile==null){
                salesRepProfile = AnthemOppsProfiles.salesRepProfile;
            }
            return salesRepProfile;
        } set; 
    } 
    
    private static Profile salesManagerProfile {
        get{
            if (salesManagerProfile==null){
                salesManagerProfile = AnthemOppsProfiles.salesManagerProfile;
            }
            return salesManagerProfile;
        } set; 
    }
    
    private static Profile leadControllerProfile {
        get{
            if (leadControllerProfile==null){
                leadControllerProfile = AnthemOppsProfiles.salesAdminProfile;
            }
            return leadControllerProfile;
        } set; 
    } 
     
    
    private static User salesManager {
        get{
            if (salesManager==null){
                profile portalUser = [select id from Profile where Name Like '%Portal User%' Limit 1];
                salesManager = TestResources.createTestUser('ManagerName','ManagerLastName','manager@anthem.com','manager@anthem.com',portalUser .Id);
                salesManager.contactID = createContact('ManagerLastName').id;
                insert salesManager;
            }
            return salesManager;
        } set; 
    }           
    
    public static User getCurrentUser(){
        return [ select Id from User where Id = :UserInfo.getUserId() ];
    }

    public static User createTestUser(String firstName,String lastName,String email,String userName,Id profileId) {
        return new User(
            FirstName = firstName,
            LastName = lastName,
            Email = email,
            Username = userName,
            ProfileId = profileId,
            Alias = lastName.substring(0,5),
            CommunityNickname = lastName.substring(0,5),
            TimeZoneSidKey=DummyUser.TimeZoneSidKey,
            LocaleSidKey=DummyUser.LocaleSidKey,
            EmailEncodingKey=DummyUser.EmailEncodingKey,
            LanguageLocaleKey=DummyUser.LanguageLocaleKey,
            Regional_Brand__c ='Brand',
            User_State__c='Minnesota'
        );
    }

    public static User LeadController (String firstName,String lastName,String email,String userName){
        User leadCon = TestResources.createTestUser(firstName,lastName,email,userName,leadControllerProfile.Id);
        return leadCon;
    }
    
    public static User SalesRep (String firstName,String lastName,String email,String userName){
         profile portalUserProfile = [select id from Profile where Name Like '%Portal User%' Limit 1];
        User salesRep = TestResources.createTestUser(firstName,lastName,email,userName,portalUserProfile.Id);
        salesRep.contactID = createContact(lastName).id;
        salesRep.Sales_Manager__c = salesManager.id;
        return salesRep;
    }
    
    public static User broker (String firstName,String lastName,String email,String userName, ID salesRepID){
        profile portalUserProfile = [select id from Profile where Name Like '%Portal User%' Limit 1];
        User broker = TestResources.createTestUser(firstName,lastName,email,userName,portalUserProfile.Id);
        broker.contactID = createContact(lastName).id;
        broker.Sales_Rep__c = salesRepID;
        return broker;
    } 
    
    public static User admin (String firstName,String lastName,String email,String userName){
        User admin = TestResources.createTestUser(firstName,lastName,email,userName,systemAdminProfile.Id);
        return admin;
    }       
    
    public static Contact createContact(String lastName){
        Id conAntOppsRecTypeId = [SELECT Id, Name FROM RecordType WHERE sObjectType = 'Contact' AND DeveloperName = 'Anthem_Opps'].Id;
        Contact cont= new Contact(LastName = lastName, AccountId = acc.id, RecordTypeId = conAntOppsRecTypeId);
        insert cont;
        return cont;
    }
    
    public static State__c createState(Id ownerID){
        return new State__c(Name = 'Minnesota', OwnerID = ownerID);
    }
    
    public static State__c createState(Id ownerID, String stateName){
        return new State__c(Name = stateName, OwnerID = ownerID);
    }    
    
    public static Zip_City_County__c createZipCityCounty(Id stateID){
        return new Zip_City_County__c(Name='55404', City__c='Minneapolis', State__c=stateID, County__c='Hennepin', Territory__c='Hennepin');
    }
    
    public static User_by_Zip_City_County__c createUserByZipCityCounty(Id userID, Id ZipCodeID){
        return new User_by_Zip_City_County__c(Zip_Code__c=ZipCodeID, User__c = userID);
    }
    
    public static Assignment_Rule__c createAssignmentRule(Id stateId, Id leadControllerID){
        Id assignmentRuleRecId = [SELECT Id FROM RecordType WHERE sObjectType = 'Assignment_Rule__c' AND DeveloperName = 'Geographical_Record_Type'].Id;
        return new Assignment_Rule__c(Name ='Minnesota' , State__c= stateId, Lead_Controller__c=leadControllerID, OwnerID =leadControllerID,RecordTypeId = assignmentRuleRecId);
    }   
    
    public static void createProfilesCustomSetting(){
        
        List<Profiles__c> profilesList = new List<Profiles__c> ();
        
        Profiles__c admin = new Profiles__c();
        admin.Name = 'Admin';
        admin.Profile_Name__c = 'Anthem Opps Admin';
        profilesList.add(admin);
        
        Profiles__c broker = new Profiles__c();
        broker.Name = 'Broker';
        broker.Profile_Name__c ='Anthem Opps Brokers';
        profilesList.add(broker);
        
        Profiles__c salesAdmin = new Profiles__c();
        salesAdmin.Name = 'Sales Admin';
        salesAdmin.Profile_Name__c = 'Anthem Opps Sales Admin';
        profilesList.add(salesAdmin);
                
        Profiles__c readOnly = new Profiles__c();
        readOnly.Name = 'Read Only';
        readOnly.Profile_Name__c = 'Anthem Opps Read Only';
        profilesList.add(readOnly);
                
        Profiles__c salesManagerProf = new Profiles__c();
        salesManagerProf.Name = 'Sales Manager';
        salesManagerProf.Profile_Name__c = 'Anthem Opps Sales Manager';
        profilesList.add(salesManagerProf);
                
        Profiles__c salesRep = new Profiles__c();
        salesRep.Name = 'Sales Rep';
        salesRep.Profile_Name__c = 'Anthem Opps Sales Rep';
        profilesList.add(salesRep);
            
        insert profilesList;
    }
    
    public static void createRTypeBTrackCustomSettings(){
        CS001_RecordTypeBusinessTrack__c rTypeBTrackOpp = new CS001_RecordTypeBusinessTrack__c();
        rTypeBTrackOpp.Name = 'Opportunity_Anthem Opps';
        rTypeBTrackOpp.BusinessTrackName__c = 'ANTHEMOPPS';
        insert rTypeBTrackOpp;
        
        CS001_RecordTypeBusinessTrack__c rTypeBTrackAcc = new CS001_RecordTypeBusinessTrack__c();
        rTypeBTrackAcc.Name = 'Account_Anthem Opps';
        rTypeBTrackAcc.BusinessTrackName__c = 'ANTHEMOPPS';
        insert rTypeBTrackAcc;
        
        CS001_RecordTypeBusinessTrack__c rTypeBTrackCon = new CS001_RecordTypeBusinessTrack__c();
        rTypeBTrackCon.Name = 'Contact_Anthem Opps';
        rTypeBTrackCon.BusinessTrackName__c = 'ANTHEMOPPS';
        insert rTypeBTrackCon;
    }
    
}