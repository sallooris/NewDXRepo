/**********************************************************************
Class Name  :  AP03_RestrictMultipleSpouseDP_Test 
Date Created:
Created By  :  Amanjot
Description :  Test Class for AP03_RestrictMultipleSpouseDP which restricts entry of multiple spouse/domestic 
partner for Person Account.
Reference Class :AP03_RestrictMultipleSpouseDP_Test
Change History  :
**********************************************************************/
@isTest
/*Test Class : AP03HouseholdMember_Test */
private class AP03_RestrictMultipleSpouseDP_Test
{
/* Method Name :testrestrictMultipleSpouceDP
Param 1     :
Return Type : Void
Description : Test method for class AP03_RestrictMultipleSpouseDP which restricts entry of 
multiple spouse/domestic partner for Person Account.
*/
private static testMethod void testrestrictMultipleSpouceDP()
{
    MAP<ID,Integer> householdMap=new MAP<ID,Integer>();
    Account testacc01=Util02_TestData.insertAccount();
    List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
    insert cs001List; 
    List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
    insert cs002List;
    ID accRT =[select Id,Name from Recordtype where Name = 'Person Account' and SobjectType = 'Account'].Id;
    testacc01.recordtypeId = accRT ;  
    Household_Member__c testHousehold01=Util02_TestData.insertHousehold();
    List<Household_Member__c> householdlist=new List<Household_Member__c>();
    AP03_RestrictMultipleSpouseDP obj=new AP03_RestrictMultipleSpouseDP();     
    Test.startTest();
        Database.insert(testacc01);
        testHousehold01.Household_ID__c=testacc01.id;
        testHousehold01.relationship_type__c='Domestic Partner';
        Database.insert(testHousehold01);  
        householdlist.add(testHousehold01) ;
        obj.restrictMultipleSpouceDP(householdlist);
        householdlist.clear();
        Household_Member__c testHousehold02=Util02_TestData.insertHousehold();
        testHousehold02.Household_ID__c=testacc01.id;
        testHousehold02.relationship_type__c='Domestic Partner';
        householdlist.add(testHousehold02) ;
        obj.restrictMultipleSpouceDP(householdlist);
        Integer i=0;
        for (Household_Member__c hh : [Select id,relationship_type__c,household_id__c from household_member__c where household_id__c =: testacc01.id]){
            householdMap.put(hh.household_id__c,i+1);   
        }
    Test.stopTest();
    System.assertEquals(testHousehold01.relationship_type__c,'Domestic Partner');
}
}