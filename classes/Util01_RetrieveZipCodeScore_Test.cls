@isTest
public class Util01_RetrieveZipCodeScore_Test
{
    static testmethod void testcustomerScoreAutoPopulate()
    {
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        Zip_DOB_Score__c ZipScore= Util02_TestData.insertZipDOBScore();
        insert ZipScore;
        
        ZipScore = [select Id, Zip_Code__c from Zip_DOB_Score__c where Id = :ZipScore.Id];
        System.assertEquals(ZipScore.Zip_Code__c, '50002');
        
        Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
        insert pCode;
        
        pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];
        System.assertEquals(pCode.Name, '50002');
        
        Lead testLead = Util02_TestData.insertLead(); 
        ID leadRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'LEAD'].Id;
        testLead.recordtypeId = leadRT ;
        testLead.zip_code__c = pCode.Id;
        insert testLead;
        
        testLead = [select Id, FirstName, Tech_ZipCode__c, State__c, County__c, Country, City, PostalCode, Customer_Score__c from Lead where Id = :testLead.Id AND Tech_Businesstrack__c='TELESALES'];
        System.assertEquals(testLead.FirstName, 'TestF1');
        System.assertEquals(testLead.Tech_ZipCode__c, '50002');
//        System.assertEquals(testLead.State__c, 'TS');
//        System.assertEquals(testLead.County__c, 'MDGDA');
//        System.assertEquals(testLead.Country, 'INDIA');
//        System.assertEquals(testLead.City, 'Hyderabad');
//        System.assertEquals(testLead.PostalCode, '50002');
//        System.assertEquals(testLead.Customer_Score__c, '1');
        
        Account testAccount = Util02_TestData.insertAccount(); 
        ID accRT =[select Id,Name from Recordtype where Name = 'Person Account' and SobjectType = 'Account'].Id;
        testAccount.recordtypeId = accRT ; 
        insert testAccount;
        testAccount.zip_code__c = pCode.Id;
        update testAccount;
            
        testAccount = [select Id, FirstName, Tech_ZipCode__c, State__c, County__c, BillingCountry, Billing_City__c, Billing_PostalCode__c, Customer_Score__c from Account where Id = :testAccount.Id AND Tech_Businesstrack__c='TELESALES'];
        system.debug('testAccount==>'+testAccount);
        System.assertEquals(testAccount.FirstName, 'test first name');
        
        System.assertEquals(testAccount.Tech_ZipCode__c, '50002');
//        System.assertEquals(testAccount.State__c, 'TS');
//        System.assertEquals(testAccount.County__c, 'MDGDA');
 //       System.assertEquals(testAccount.BillingCountry, 'INDIA');
 //       System.assertEquals(testAccount.Billing_City__c, 'Hyderabad');
 //       System.assertEquals(testAccount.Billing_PostalCode__c, '50002');
 //       System.assertEquals(testAccount.Customer_Score__c, NULL);
        
        
         
    }
}