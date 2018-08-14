@isTest
private class LeadAfterUpdate_Test {
/*
Method Name : testLeadActivityOwnerChange
Return type : void
Description : This method is used to check the activity owner is getting changed or not after lead owner change
*/

private static testMethod void testLeadActivityOwnerChange()
  { 
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        User testUser01=Util02_TestData.insertUser();
        Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
        Lead ldObj=Util02_TestData.insertLead();
        Test.startTest();
        Database.insert(testUser01);
        Database.insert(pCode);
        pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];      
        ldObj.zip_code__c = pCode.Id;
        Database.insert(ldObj);
        ldObj.ownerId = testUser01.id;
        Database.Update(ldObj);
        Test.stopTest();
}
/*
Method Name : testAccountActivityOwnerChange
Return type : void
Description : This method is used to check the activity owner is getting changed or not after account owner change
*/
private static testMethod void testAccountActivityOwnerChange()
  { 
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        User testUser01=Util02_TestData.insertUser();
        User testUser02=Util02_TestData.insertUser();
        Account testAcc = Util02_TestData.insertAccount();
        id taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Send Fulfillment' AND SobjectType ='Task' LIMIT 1].Id;
        Database.insert(testUser01);
        testAcc.ownerId = testUser01.id;
        Database.insert(testAcc);
        testUser02.username = 'bhasakrb123@ggggg.com';
        Database.insert(testUser02);
        Test.startTest();
        Update testAcc;
        testAcc.ownerId = testUser02.id;
        Update testAcc;+
        Test.stopTest();
        
}

/*
Method Name : testLeadCallIDKeys
Return type : void
Description : This method is used to check if a new record on the Call ID Keys
*/
private static testMethod void testLeadCallIDKeys()
  {
  Call_ID_Keys__c testKeys = new Call_ID_Keys__c ();
  testKeys.Call_ID__c = '11111111';
  testKeys.SFID__c = '99999999';
  insert testKeys;
  
  }

}