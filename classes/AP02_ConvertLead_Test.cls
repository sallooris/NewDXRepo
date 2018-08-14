/***********************************************************************************
Class Name  :  AP02_Convert_Lead_Test
Date Created:
Created By  :  Aman/Santosh
Description :  Test Class for Lead Conversion 
Change History :   
**************************************************************************************/
/*    Test Class : Lead Conversion */
@isTest
private class AP02_ConvertLead_Test
{
/*
Method Name : testcon_lead_method
Param 1 : Accepts set of accountIds
Return type : void
Description : This method is used to get the opportunities of the account and update the opportunity stage with account customer stage 
*/
private static testMethod void testcon_lead_method()
{
    Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
    Lead ldObj=Util02_TestData.insertLead();
    List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
    insert cs001List;
    ID leadRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'Lead'].Id;
    ldObj.recordtypeId = leadRT;      
    Test.startTest();
    Database.insert(pCode); 
    pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];      
    ldObj.zip_code__c = pCode.Id;
    Database.insert(ldObj);
    pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id Limit 1];   
    ldObj.Zip_Code__c=pCode.Id;
    Database.Update(ldObj);
    User testUser01=Util02_TestData.insertUser();
    Database.Insert(testUser01);
    AP02_ConvertLead.con_lead_method(ldObj.Id,testUser01.Id); 
    Test.stopTest();
} 
}