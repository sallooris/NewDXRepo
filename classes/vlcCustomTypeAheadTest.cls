/****************************************************************************
Class Name  :  vlcCustomTypeAheadTest
Created By  :  Vlocity
Description : Test class for vlcCustomTypeAhead
****************************************************************************/

@isTest(seeAllData = true)
public class vlcCustomTypeAheadTest{
    public testmethod static void vlcCustomTypeAheadMethod(){

      Map<String,Object> inputMap = new Map<String,Object>();
      Map<String,Object> outMap = new Map<String,Object>();
      Map<String,Object> options = new Map<String,Object>();

      test.startTest();
      vlcCustomTypeAhead vss = new vlcCustomTypeAhead();


      /* Account Test */
      Id RecordType_Id = [Select Id from RecordType where sObjectType = 'Account' AND Name = 'Agency'].Id;
      Account test_account = new Account(Name='General Account', Employer_EIN__c='123456789', RecordTypeId = RecordType_Id);
      insert test_account;

      Id [] fixedAccountSearchResults= new Id[1];
      fixedAccountSearchResults[0] = test_account.Id;
      test.setFixedSearchResults(fixedAccountSearchResults);

      options.put('searchString', 'General');
      Boolean validateAccountsList = vss.invokeMethod('getAccountsList', inputMap, outMap, options);
      System.assertEquals(validateAccountsList, true);

      /* General Agency Test */
      Account test_generalagency = new Account(Name='General Account', BR_Encrypted_TIN__c='123456789', RecordTypeId = RecordType_Id, AgencyType__c='General Agency');
      insert test_generalagency;

      Id [] fixedGeneralAgencySearchResults= new Id[1];
      fixedGeneralAgencySearchResults[0] = test_generalagency.Id;
      test.setFixedSearchResults(fixedGeneralAgencySearchResults);

      Boolean validateGeneralAgencyList = vss.invokeMethod('getGeneralAgencyList', inputMap, outMap, options);
      System.assertEquals(validateGeneralAgencyList, true);

      /* Paid Agency Test */
      Account test_paidagency = new Account(Name='General Account', BR_Encrypted_TIN__c='123456789', RecordTypeId = RecordType_Id, AgencyType__c='Paid Agency');
      insert test_paidagency;

      Id [] fixedPaidAgencySearchResults= new Id[1];
      fixedPaidAgencySearchResults[0] = test_paidagency.Id;
      test.setFixedSearchResults(fixedPaidAgencySearchResults);

      Boolean validatePaidAgencyList = vss.invokeMethod('getPaidAgencyList', inputMap, outMap, options);
      System.assertEquals(validatePaidAgencyList, true);

      /* Contact Test */
      Contact test_contact = new Contact(FirstName='George', LastName='Harrison', Email='george@email.com', ETIN__c='123456789', AgencyType__c='Brokerage');
      insert test_contact;

      Id [] fixedContactSearchResults= new Id[1];
      fixedContactSearchResults[0] = test_contact.Id;
      test.setFixedSearchResults(fixedContactSearchResults);

      options.put('searchString', 'George');
      Boolean validateBrokerList = vss.invokeMethod('getBrokerList', inputMap, outMap, options);
      System.assertEquals(validateBrokerList, true);

      test.stopTest();
    }
}