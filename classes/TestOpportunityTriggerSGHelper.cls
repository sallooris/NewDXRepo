/*
* Name:       TestOpportunityTriggerSGHelper
* Purpose:    Test Class for OpportunityTriggerSGHelper
* Vlocity, 8/2016
*/
@isTest(SeeAllData = false)
public class TestOpportunityTriggerSGHelper {
    enum PortalType { CSPLiteUser, PowerPartner, PowerCustomerSuccess, CustomerSuccess, Partner }
    public static Account accCreatedbyPU;
    public Static Contact conCreatedbyPU;
    static testMethod void OpportunityTriggerSGHelpertest(){
        CS001_RecordTypeBusinessTrack__c rtAnthemOpps = new CS001_RecordTypeBusinessTrack__c();
        rtAnthemOpps.Name = 'Account_Anthem Opps';
        rtAnthemOpps.BusinessTrackName__c = 'ANTHEMOPPS'; 
        insert rtAnthemOpps;   
        
        CS001_RecordTypeBusinessTrack__c rtSGQuoting = new CS001_RecordTypeBusinessTrack__c();
        rtSGQuoting.Name = 'Opportunity_SG Quoting';
        rtSGQuoting.BusinessTrackName__c = 'SGQUOTING'; 
        insert rtSGQuoting; 
        User portalUser = getPortalUser(PortalType.Partner,null,true);
        Test.startTest();
        List<Opportunity> oppBrokeroppList = DataUtility.createoppBroker(100,accCreatedbyPU,conCreatedbyPU);
        insert oppBrokeroppList;
        List<Opportunity> paidagencyoppList = DataUtility.createoppPaidAgency(100,accCreatedbyPU,conCreatedbyPU);
        insert paidagencyoppList;
        List<Opportunity> generalagencyoppList = DataUtility.createoppGeneralAgency(100,accCreatedbyPU,conCreatedbyPU);
        insert generalagencyoppList;
        Test.stopTest();
        Account nAccount = new Account(name = 'TEST ACCOUNT',RecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Anthem Opps').getRecordTypeId());
        Database.insert(nAccount);
        Contact nContact = new Contact(AccountId = nAccount.id, lastname = 'lastname');
        Database.insert(nContact);
        oppBrokeroppList[0].Broker__c = nContact.Id;
        update oppBrokeroppList[0];
        paidagencyoppList[0].PaidAgency__c = nAccount.Id;
        update paidagencyoppList[0];
        generalagencyoppList[0].GeneralAgency__c = nAccount.Id;
        update generalagencyoppList[0];
    }
    
    public static User getPortalUser(PortalType portalType, User userWithRole, Boolean doInsert) {
        if(userWithRole == null) {   
            if(UserInfo.getUserRoleId() == null) {
                UserRole r = new UserRole(name = 'Manager');
                Database.insert(r);
                userWithRole = new User(alias = 'hasrole', email='userwithrole@roletest1.com', userroleid = r.id,
                                        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                                        localesidkey='en_US', profileid = UserInfo.getProfileId(), 
                                        timezonesidkey='America/Los_Angeles', username='userwithrole@testorg.com');
            } else {
                userWithRole = new User(Id = UserInfo.getUserId(), UserRoleId = UserInfo.getUserRoleId());
            }
            System.assert(userWithRole.userRoleId != null, 
                          'This test requires the target org to have at least one UserRole created. Please create a user role in this organization and try again.');
        }
        
        System.runAs(userWithRole) {
            accCreatedbyPU = new Account(name = 'TEST ACCOUNT',RecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Anthem Opps').getRecordTypeId());
            Database.insert(accCreatedbyPU);
            conCreatedbyPU = new Contact(AccountId = accCreatedbyPU.id, lastname = 'lastname');
            Database.insert(conCreatedbyPU);
        }
        Profile p = [SELECT Id FROM Profile WHERE Name='Anthem SG Broker'];
        String testemail = 'puser000@amamama.com';
        User pu = new User(profileId = p.id, username = testemail, email = testemail, 
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US', 
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles', 
                           alias='cspu', lastname='lastname', contactId = conCreatedbyPU.id);
        
        if(doInsert) {
            Database.insert(pu);
        }
        return pu;
    }
}