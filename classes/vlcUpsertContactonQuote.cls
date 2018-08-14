global with sharing class vlcUpsertContactonQuote implements vlocity_ins.VlocityOpenInterface{

     public Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean success = true;

        try{
            if(methodName == 'upsertContactOnQuote') {
                upsertContactOnQuote(inputMap, outMap, options);
            }
        }catch(Exception e){
            System.debug(' exception '+e);
            success = false;
            throw e;
        }
        return success;
     }


    @RemoteAction
    global static Boolean upsertContactOnQuote(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {

        Map<String,Object> quotePreparedFor = (Map<String,Object>)inputMap.get('QuotePreparedFor');
        String contactEmail = (String) quotePreparedFor.get('qEmail');
        String contactName = (String) quotePreparedFor.get('qContactName');
        String contactTitle = (String) quotePreparedFor.get('qContactTitle');
        String contactPhone = (String) quotePreparedFor.get('qPhone');
        String contactFax = (String) quotePreparedFor.get('qContactFax');

        Map<String,Object> CategorySelection = (Map<String,Object>)inputMap.get('CategorySelection');
        String AccountId = (String) CategorySelection.get('Object_Id');

        Map<String,Object> accountQuotedFor = (Map<String,Object>)inputMap.get('Step');
        String AccountGroupETIN = (String) accountQuotedFor.get('ETINFormula');

        Map<String,Object> quotePreparedCompanyFor = (Map<String,Object>)quotePreparedFor.get('quote_name_blk');
        String AccountName = (String) quotePreparedCompanyFor.get('qGroupName');
        Map<String,Object> quotePreparedCompanyAddressFor = (Map<String,Object>)quotePreparedCompanyFor.get('Address_blk');

        String QuoteId = (String) inputMap.get('DRId_Quote');

        Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        List<List<Contact>> contactResults = [FIND :contactEmail IN Email FIELDS RETURNING Contact (Id, FirstName, LastName, Name WHERE RecordTypeId = :recordTypeId)];
        List<Account> accountResults = [SELECT Id, Name From Account WHERE Id = :AccountId];
        List<Quote> quoteResults = [SELECT Id, Name From Quote WHERE Id = :QuoteId];


        if(contactResults[0].size() > 0 && quoteResults.size() > 0 && accountResults.size() > 0){
            Contact contactPerson = contactResults[0][0];
            Account accountDetail = accountResults[0];
            Quote quoteDetail = quoteResults[0];

            contactPerson.LastName = contactName;
            contactPerson.Title = contactTitle;
            contactPerson.Fax = contactFax;
            contactPerson.Phone = contactPhone;
            contactPerson.AccountID = accountResults[0].id;
            System.debug('The contactPerson is: ' + contactPerson);
            update contactPerson;

            quoteDetail.ContactID = contactResults[0][0].id;
            update quoteDetail;
        }
        else if(quoteResults.size() > 0 && accountResults.size() > 0){
          Contact contactPerson = new Contact();
          Account accountDetail = accountResults[0];
          Quote quoteDetail = quoteResults[0];

          contactPerson.Email = contactEmail;
          contactPerson.LastName = contactName;
          contactPerson.Title = contactTitle;
          contactPerson.Fax = contactFax;
          contactPerson.Phone = contactPhone;
          contactPerson.AccountID = accountResults[0].id;
          contactPerson.RecordTypeId = recordTypeId;
          System.debug('The contactPerson is: ' + contactPerson);
          insert contactPerson;

          quoteDetail.ContactID = contactPerson.id;
          update quoteDetail;
        }
        else{
            System.debug('The quoteResults is: 0');
        }

        System.debug('The AccountId is: ' + AccountId);
        System.debug('The QuoteId is: ' + QuoteId);

        System.debug('The quoteResults is: ' + quoteResults);

        return true;
    }
}