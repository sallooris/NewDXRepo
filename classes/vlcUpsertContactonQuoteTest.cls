/****************************************************************************
Class Name  :  vlcUpsertContactonQuoteTest
Created By  :  Vlocity
Description : Test class for vlcUpsertContactonQuote
****************************************************************************/

@isTest(seeAllData = true)
public class vlcUpsertContactonQuoteTest{
    public testmethod static void vlcUpsertContactonQuoteMethod(){

      Map<String,Object> inputMap = new Map<String,Object>();
      Map<String,Object> outMap = new Map<String,Object>();
      Map<String,Object> options = new Map<String,Object>();

      test.startTest();
      vlcUpsertContactonQuote vss = new vlcUpsertContactonQuote();

      Map<String,Object> quotePreparedFor = new Map<String,Object>();
      quotePreparedFor.put('qEmail', 'test@email.com');
      quotePreparedFor.put('qContactName', 'Test');
      quotePreparedFor.put('qContactTitle', 'Broker');
      quotePreparedFor.put('qPhone', '3123123120');
      quotePreparedFor.put('qContactFax', '2122122120');
      inputMap.put('QuotePreparedFor', quotePreparedFor);

      Id RecordType_AccountId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Agency').getRecordTypeId();
      Account test_account = new Account(Name='Test Account', BR_Encrypted_TIN__c='123456789', RecordTypeId = RecordType_AccountId);
      insert test_account;

      Map<String,Object> CategorySelection = new Map<String,Object>();
      CategorySelection.put('Object_Id', test_account.Id);
      inputMap.put('CategorySelection', CategorySelection);

      Map<String,Object> accountQuotedFor = new Map<String,Object>();
      accountQuotedFor.put('ETINFormula', test_account.BR_Encrypted_TIN__c);
      inputMap.put('Step', accountQuotedFor);

      Map<String,Object> quotePreparedCompanyFor = new Map<String,Object>();
      quotePreparedCompanyFor.put('qGroupName', test_account.Name);
      quotePreparedFor.put('quote_name_blk', quotePreparedCompanyFor);

      Map<String,Object> quotePreparedCompanyAddressFor = new Map<String,Object>();
      quotePreparedCompanyAddressFor.put('Address_blk', '');

      Id RecordType_ContactId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
      Contact test_contact = new Contact(FirstName='George', LastName='Harrison', Email='george@email.com', RecordTypeId=RecordType_ContactId);
      insert test_contact;

      Opportunity test_opportunity = new Opportunity(Name='Test Opportunity', StageName='Closed/Lost', CloseDate=Date.Today());
      insert test_opportunity;

      Quote test_quote = new Quote(Name='Test Quote', OpportunityId=test_opportunity.Id);
      insert test_quote;

      inputMap.put('DRId_Quote', test_quote.Id);
      System.debug('The Test contactPerson is: ' + inputMap);

      Boolean validateInsertContactonQuote = vss.invokeMethod('upsertContactOnQuote', inputMap, outMap, options);
      System.assertEquals(validateInsertContactonQuote, true);

      Id [] fixedContactSearchResults= new Id[1];
      fixedContactSearchResults[0] = test_contact.Id;
      test.setFixedSearchResults(fixedContactSearchResults);

      quotePreparedFor.put('qEmail', 'test@email.com');
      inputMap.put('QuotePreparedFor', quotePreparedFor);
      System.debug('The Test contactPerson is: ' + inputMap);

      Boolean validateUpdateContactonQuote = vss.invokeMethod('upsertContactOnQuote', inputMap, outMap, options);
      System.assertEquals(validateUpdateContactonQuote, true);

      test.stopTest();
    }
}