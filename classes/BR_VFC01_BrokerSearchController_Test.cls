/*************************************************************
Class Name   : BR_VFC01_BrokerSearchController_Test 
Date Created : 10-July-2015
Created By   : Nagarjuna Kaipu
Description  : This class is used for testing broker search page
Change History :
1. Modified by Kishore Jonnadula
*************************************************************/

@isTest
public class BR_VFC01_BrokerSearchController_Test {
    public static testmethod void testBrokerSearchController(){

        List<CS001_RecordTypeBusinessTrack__c> cs001List = BR_Util01_TestMethods.createBusinessTrack();
        insert cs001List; 
        User testUser=BR_Util01_TestMethods.CreateTestUser();
        insert(testUser);
        Account a = BR_Util01_TestMethods.CreateAgencyAccount();
        a.BR_Tax_Identification_Number__c = '12349876';
        a.BR_Encrypted_TIN__c = '4321';
        insert a;
        Account b = BR_Util01_TestMethods.CreateBrokerAccount();
        insert b;
        System.debug('brokerId:::'+b.Id);
        Brokerage_Broker__c testbrokerage = BR_Util01_TestMethods.CreateBrokerage();
        testbrokerage.BR_Broker__c = b.Id;
        insert testbrokerage;
        System.runAs(testUser){
            Test.startTest();
              try{
                  Test.setCurrentPageReference(new PageReference('Page.VFP08_BrokerSearch'));
                    BR_VFC01_BrokerSearchController searchCon = new BR_VFC01_BrokerSearchController();
                   
                    searchCon.ClearFields();
                    
                    searchCon.AgencyCode = '234589';
                    searchCon.SearchBroker();
                    System.assert(searchCon.wrapAccountList.size() > 0);
                  
                    searchCon.ClearFields();
                   	searchCon.AgencyName = 'Naga Agency';
                    searchCon.SearchBroker();
                    System.assert(searchCon.wrapAccountList.size() > 0);
                    
                   searchCon.ClearFields();
                    searchCon.AgencyTIN = '12349876';
                    searchCon.SearchBroker();
                    System.assert(searchCon.wrapAccountList.size() > 0);
               
                    searchCon.ClearFields();
                    searchCon.AgencyETIN = '4321';
                    searchCon.SearchBroker();
                    System.assert(searchCon.wrapAccountList.size() > 0);
                  
                    searchCon.ClearFields();
                    searchCon.BrokerTIN = '34567';
                    searchCon.SearchBroker();
                    System.assert(searchCon.wrapAccountList.size() > 0);
                  	
                    searchCon.ClearFields();
                    searchCon.BrokerETIN = '76543';
                    searchCon.SearchBroker();
                    System.assert(searchCon.wrapAccountList.size() > 0);
                  
                    searchCon.ClearFields();
                    searchCon.BrokerNPN = '345';
                    searchCon.SearchBroker();
                    System.assert(searchCon.wrapAccountList.size() > 0);
                   
                    searchCon.ClearFields();
                    searchCon.BrokerName = 'Broker Nagarjuna';
                    searchCon.SearchBroker();
                    System.assert(searchCon.wrapAccountList.size() > 0);
                  
              }catch(Exception ex){
                  System.debug('Exception::::'+ex.getMessage()); 
              }
            Test.stopTest();
      }
    }
    //Test Method for wrapBrokerResults method in BR_VFC01_BrokerSearchController 
    public static testmethod void testBrokerSearchController_method2(){

        List<CS001_RecordTypeBusinessTrack__c> cs001List = BR_Util01_TestMethods.createBusinessTrack();
        insert cs001List; 
        User testUser=BR_Util01_TestMethods.CreateTestUser();
        insert(testUser);
        Account a = BR_Util01_TestMethods.CreateAgencyAccount();
        a.BR_Tax_Identification_Number__c = '12349876';
        a.BR_Encrypted_TIN__c = '4321';
        insert a;
        System.runAs(testUser){
            Test.startTest();
              try{
                  Test.setCurrentPageReference(new PageReference('Page.VFP08_BrokerSearch'));
                    BR_VFC01_BrokerSearchController searchCon = new BR_VFC01_BrokerSearchController();
                List<Account> accList = [SELECT ID, NAME, BR_Encrypted_TIN__c, BR_TAX_IDENTIFICATION_NUMBER__c, RecordType.Name FROM ACCOUNT
                                         WHERE ID =: a.Id];
                 searchCon.wrapBrokerResults(accList);
                 System.assert(searchCon.wrapAccountList.size() > 0);
              }catch(Exception ex){
                  System.debug('Exception::::'+ex.getMessage());
              }
            Test.stopTest();
      }
    }
    //Test Method for wrapAccount inner class in BR_VFC01_BrokerSearchController 
    public static testmethod void testBrokerSearchController_method3(){

        List<CS001_RecordTypeBusinessTrack__c> cs001List = BR_Util01_TestMethods.createBusinessTrack();
        insert cs001List; 
        User testUser=BR_Util01_TestMethods.CreateTestUser();
        insert(testUser);
        Account a = BR_Util01_TestMethods.CreateAgencyAccount();
        a.BR_Tax_Identification_Number__c = '12349876';
        a.BR_Encrypted_TIN__c = '4321';
        insert a;
        String brokerType = null;
        System.runAs(testUser){
            Test.startTest();
              try{
                  Test.setCurrentPageReference(new PageReference('Page.VFP08_BrokerSearch'));
                    Account acc1 = [SELECT ID, NAME, BR_Encrypted_TIN__c, BR_TAX_IDENTIFICATION_NUMBER__c, RecordType.Name FROM ACCOUNT
                                         WHERE ID =: a.Id];
					BR_VFC01_BrokerSearchController.wrapAccount innerClass = new BR_VFC01_BrokerSearchController.wrapAccount(acc1, brokerType);
                    innerClass.acc = acc1;
                 System.assertEquals('Naga Agency', innerClass.acc.Name);
              }catch(Exception ex){
                  System.debug('Exception::::'+ex.getMessage());
              }
            Test.stopTest();
      }
    }
    
    public static testmethod void testBrokerSearchController_method4(){
    	List<CS001_RecordTypeBusinessTrack__c> cs001List = BR_Util01_TestMethods.createBusinessTrack();
        insert cs001List; 
        User testUser=BR_Util01_TestMethods.CreateTestUser();
        insert(testUser);
        
        ASCSServiceInfo ascstestInfo = new ASCSServiceInfo();
        ascstestInfo = BR_Util01_TestMethods.createASCSTestData();
        ascstestInfo.brokerType = 'Agent';
        BR_VFC01_BrokerSearchController controller = new BR_VFC01_BrokerSearchController();
        controller.brokerData = ascstestInfo;
        
        System.runAs(testUser){
            Test.startTest();
              try{
                  controller.wrapBrokerResults(ascstestInfo.accList);
                  controller.wrapAccountList[0].selected=true;
                  System.assert(controller.wrapAccountList.size() > 0);
                  PageReference pageRef = controller.createSelectedData();
                  System.assert(pageRef.getRedirect());
              }catch(Exception ex){
                  System.debug('Exception::::'+ex.getMessage());
              }
            Test.stopTest();
      }
    }
}