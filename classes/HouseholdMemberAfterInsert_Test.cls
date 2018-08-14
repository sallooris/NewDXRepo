/**********************************************************************
Class Name  :  HouseholdMemberAfterInsert_Test
Date Created:
Created By  :  Santosh
Description :  Test Class for HouseholdMemberAfterInsert which restricts entry of multiple spouse/domestic 
               partner for Person Account.
Reference Class/Trigger : HouseholdMemberAfterInsert
Change History  :
**********************************************************************/
/*Test Class : HouseholdMemberAfterInsert */
@isTest
private class HouseholdMemberAfterInsert_Test
{
/* Method Name :restrictMultipleSpouceDPMethod01
   Param 1     :
   Return Type : Void
   Description : Test method for trigger HouseholdMemberAfterInsert which restricts entry of 
                 multiple spouse/domestic partner for Person Account.
*/
private static testMethod void restrictMultipleSpouceDPMethod01()
   {
      List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
      insert cs001List; 
      List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
      insert cs002List;
      Account testacc01=Util02_TestData.insertAccount();
      ID accRT =[select Id,Name from Recordtype where Name = 'Person Account' and SobjectType = 'Account'].Id;
      testacc01.recordtypeId = accRT ;
      Household_Member__c testHousehold01=Util02_TestData.insertHousehold();    
      Test.startTest();
      Database.insert(testacc01);
      testHousehold01.Household_ID__c=testacc01.id;
      testHousehold01.relationship_type__c='Domestic Partner';
      Database.insert(testHousehold01);     
      Household_Member__c testHousehold02=Util02_TestData.insertHousehold();
      testHousehold02.Household_ID__c=testacc01.id;
      testHousehold02.relationship_type__c='Domestic Partner';      
      Test.stopTest();
      System.assertEquals(testHousehold01.relationship_type__c,'Domestic Partner');
    
   }
}