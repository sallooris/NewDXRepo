global with sharing class vlcCustomTypeAhead implements vlocity_ins.VlocityOpenInterface{

     public Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean success = true;

        try{
            if(methodName == 'getAccountsList') {
                getAccountsList(inputMap, outMap, options);
            }
            if(methodName == 'getGeneralAgencyList') {
                getGeneralAgencyList(inputMap, outMap, options);
            }
            if(methodName == 'getPaidAgencyList') {
                getPaidAgencyList(inputMap, outMap, options);
            }
            if(methodName == 'getBrokerList') {
                getBrokerList(inputMap, outMap, options);
            }
        }catch(Exception e){
            System.debug(' exception '+e);
            success = false;
            throw e;
        }
        return success;
     }


    @RemoteAction
    global static List<Account> getAccountsList(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        String searchName = (String) options.get('searchString');

        List<Map<String, String>> returnList = new List<Map<String,String>>();
        List<Account> accList = new List<Account>();

        if(searchName.length() > 1){
          List<List<Account>> accQueryList = search.query('FIND \''+ searchName +  '*\' IN NAME FIELDS RETURNING Account(Id, Name, Employer_EIN__c)');
          System.debug('The accList is: ' + accQueryList);

          accList = ((List<Account>)accQueryList[0]);
          if(accList != null && accList.size() > 0){
              for (Account a : accList){

                  Map<String,String> tempMap = new Map<String,String>();
                  tempMap.put('ExistingAccountId', a.Id);
                  tempMap.put('ExistingAccountName', (String)a.get('Name'));
                  tempMap.put('GroupETIN', (String)a.get('Employer_EIN__c'));
                  tempMap.put('AccountSearch', (String)a.get('Name'));
                  returnList.add(tempMap);
              }
          }
          System.debug('The accMap is: ' + returnList);
          outMap.put('OBDRresp', returnList);
        }

        System.debug('The accList is: ' + accList);
        //accList.sort();
        return accList;
    }


    @RemoteAction
    global static List<Account> getGeneralAgencyList(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        String searchName = (String) options.get('searchString');
        String searchETIN = '%'+searchName+'%';

        List<Map<String, String>> returnList = new List<Map<String,String>>();
        List<Account> accList = new List<Account>();
        Set<Account> accSet = new Set<Account>();

        if(searchName.length() > 1){
          List<List<Account>> accQueryList = search.query('FIND \''+ searchName +  '*\'  IN Name FIELDS RETURNING Account(Id, Name, AccountTypeAhead__c, BR_Encrypted_TIN__c, AgencyType__c WHERE AgencyType__c = \'General Agency\')');
          accSet.addAll(((List<Account>)accQueryList[0]));
          System.debug('The accList is: ' + accQueryList);

          List<Account> accFetchList = [SELECT Id, Name, AccountTypeAhead__c, BR_Encrypted_TIN__c, AgencyType__c FROM Account WHERE (BR_Encrypted_TIN__c LIKE :searchETIN AND AgencyType__c = 'General Agency')];
          accSet.addAll(accFetchList);
          System.debug('The accFetchList is: ' + accFetchList);

          //accList = ((List<SObject>)accQueryList[0]);
          accList.addAll(accSet);
          if(accList != null && accList.size() > 0){
              for (Account a : accList){

                  if((String)a.get('AgencyType__c') == 'General Agency'){
                    Map<String,String> tempMap = new Map<String,String>();
                    tempMap.put('GeneralAgencyId', a.Id);
                    tempMap.put('GeneralAgency', (String)a.get('Name'));
                    tempMap.put('GeneralAgencyTIN', (String)a.get('BR_Encrypted_TIN__c'));
                    tempMap.put('GeneralAgencySearch', (String)a.get('AccountTypeAhead__c'));
                    returnList.add(tempMap);
                  }
              }
          }
          System.debug('The accMap is: ' + returnList);
          outMap.put('OBDRresp', returnList);
        }

        //accList.sort();
        return accList;
    }

    @RemoteAction
    global static List<Account> getPaidAgencyList(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        String searchName = (String) options.get('searchString');
        String searchETIN = '%'+searchName+'%';

        List<Map<String, String>> returnList = new List<Map<String,String>>();
        List<Account> accList = new List<Account>();
        Set<Account> accSet = new Set<Account>();

        if(searchName.length() > 1){
          List<List<Account>> accQueryList = search.query('FIND \''+ searchName +  '*\' IN Name FIELDS RETURNING Account(Id, Name, AccountTypeAhead__c, BR_Encrypted_TIN__c, AgencyType__c WHERE AgencyType__c = \'Paid Agency\')');
          accSet.addAll(((List<Account>)accQueryList[0]));
          System.debug('The accList is: ' + accQueryList);

          List<Account> accFetchList = [SELECT Id, Name, AccountTypeAhead__c, BR_Encrypted_TIN__c, AgencyType__c FROM Account WHERE (BR_Encrypted_TIN__c LIKE :searchETIN AND AgencyType__c = 'Paid Agency')];
          accSet.addAll(accFetchList);
          System.debug('The accFetchList is: ' + accFetchList);

          //accList = ((List<SObject>)accQueryList[0]);
          accList.addAll(accSet);
          if(accList != null && accList.size() > 0){
              for (Account a : accList){

                  if((String)a.get('AgencyType__c') == 'Paid Agency'){
                    Map<String,String> tempMap = new Map<String,String>();
                    tempMap.put('PaidAgencyId', a.Id);
                    tempMap.put('PaidAgency', (String)a.get('Name'));
                    tempMap.put('PaidAgencyTIN', (String)a.get('BR_Encrypted_TIN__c'));
                    tempMap.put('PaidAgencySearch', (String)a.get('AccountTypeAhead__c'));
                    returnList.add(tempMap);
                  }

              }
          }
          System.debug('The accMap is: ' + returnList);
          outMap.put('OBDRresp', returnList);
        }

        //accList.sort();
        return accList;
    }

    @RemoteAction
    global static List<Contact> getBrokerList(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        String searchName = (String) options.get('searchString');
        String searchETIN = '%'+searchName+'%';

        List<Map<String, String>> returnList = new List<Map<String,String>>();
        List<Contact> cntList = new List<Contact>();
        Set<Contact> cntSet = new Set<Contact>();

        if(searchName.length() > 1){
          List<List<Contact>> cntQueryList = search.query('FIND \''+ searchName +  '*\' IN Name FIELDS RETURNING Contact(Id, Name, ContactTypeAhead__c, ETIN__c, AgencyType__c WHERE AgencyType__c = \'Brokerage\')');
          cntSet.addAll(((List<Contact>)cntQueryList[0]));
          System.debug('The cntList is: ' + cntQueryList);

          List<Contact> cntFetchList = [SELECT Id, Name, ContactTypeAhead__c, ETIN__c, AgencyType__c FROM Contact WHERE (ETIN__c LIKE :searchETIN AND AgencyType__c = 'Brokerage')];
          cntSet.addAll(cntFetchList);
          System.debug('The cntFetchList is: ' + cntFetchList);

          //cntList = ((List<SObject>)cntQueryList[0]);
          cntList.addAll(cntSet);
          if(cntList != null && cntList.size() > 0){
              for (Contact a : cntList){

                  if((String)a.get('AgencyType__c') == 'Brokerage'){
                    Map<String,String> tempMap = new Map<String,String>();
                    tempMap.put('BrokerId', a.Id);
                    tempMap.put('Broker', (String)a.get('Name'));
                    tempMap.put('BrokerTIN', (String)a.get('ETIN__c'));
                    tempMap.put('BrokerSearch', (String)a.get('ContactTypeAhead__c'));
                    returnList.add(tempMap);
                  }

              }
          }
          System.debug('The accMap is: ' + returnList);
          outMap.put('OBDRresp', returnList);
        }

        //cntList.sort();
        return cntList;
    }
}