/****************************************************
 * Class Name : SFDCCustomObject_test
 * Created date : Aug-13-2015
 * Created by : Pointel
 * Purpose : To test SFDCCustomObject class.
 ****************************************************/
@isTest(SeeAllData=true) 
public class SFDCCustomObject_test {
public static TestMethod void  test()
    {
        SFDCCustomObject obj=new SFDCCustomObject();
        string id= obj.createRecord('BR_Call_Id__c=0000000000000000^BR_Start_Date__c=2015-08-19 16:37:11^BR_Phone_Number__c=0123456789^Status=Completed^Subject= 8/19/2015 4:37:11 PM');//Details to create record : Positive scenario
        obj.createRecord('Date_time_of_call__c=2015-08-19 16:37:11');//postivie scenario for date time
        obj.createRecord('BR_End_Date__c=2015-08-19');//postivie scenario for date time
        obj.createRecord('BR_End_Date__c=');//Partial detial to create record : Negative scenario
        obj.createRecord('');//Empty detial to create record : Negative scenario
        List<string> temp=id.split('\\,');
        obj.updateRecord('BR_Duration__c=0Hr 2 mins 24secs', temp[0]);//Details to update record : Positive scenario
        obj.updateRecord('BR_Duration__c=', temp[0]);//Partial detial to update record : Negative scenario
        obj.updateRecord('BR_End_Date__c=2015-08-19 16:37:11', temp[0]);//postivie scenario for date time
        obj.updateRecord('BR_End_Date__c=2015-08-19', temp[0]);//postivie scenario for date time
        obj.updateRecord('', '');//Empty detial to update record : Negative scenario
    }
}