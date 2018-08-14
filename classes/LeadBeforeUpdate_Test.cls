/****************************************************************************
Class Name  :  LeadBeforeUpdate_Test
Date Created:  29-June-2015
Created By  :  Bhaskar
Description :  1. Test Class for Lead before update trigger. 
Change History :    
****************************************************************************/
@isTest
public class LeadBeforeUpdate_Test{
    /*
    Method Name : testLeadOwnerChange
    Return type : void
    Description : This method is used to check the user is able to change the ownership based on the enabled work
    */
    private static testMethod void testLeadOwnerChange()
    { 
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        List<Lead> lsslist=new List<Lead>();
        List<Lead> lsslist2=new List<Lead>();
        User testUser01=Util02_TestData.insertUser();
        testUser01.enabled_to_work__c='AP;NF;DF';
        User testUser02=Util02_TestData.insertUser();
        testUser02.username = 'bhasakrb123@gggggqq.com';
        Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
        Lead ldObj=Util02_TestData.insertLead();
        Database.insert(testUser01);
        Database.insert(pCode);
        ID leadRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'LEAD'].Id;
        ldObj.recordtypeId = leadRT;       
        pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];      
        ldObj.zip_code__c = pCode.Id;
        ldObj.customer_score__c='1';
        ldObj.date_of_birth__c=System.today();
        ldObj.state__c = 'NV';
        ldObj.ownerId=testUser01.id;
        Database.insert(ldObj);
        testUser02.enabled_to_work__c='';
        Database.insert(testUser02);
        AP12_RestrictOwnerChangeStateBase.leadFirstRun = true;
        try{
            ldObj.ownerId = testUser02.id;
            Database.update(ldObj);
            AP12_RestrictOwnerChangeStateBase obj2=new AP12_RestrictOwnerChangeStateBase();           
        }catch(Exception e){
        }
    }
    /*
    Method Name : testLeadCustomerScoreChange
    Return type : void
    Description : 
    */
    private static testMethod void testLeadCustomerScoreChange()
    { 
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        List<Lead> lsslist=new List<Lead>();
        List<Lead> lsslist2=new List<Lead>();
        User testUser01=Util02_TestData.insertUser();
        testUser01.enabled_to_work__c='AP;NF;DF';
        User testUser02=Util02_TestData.insertUser();
        testUser02.username = 'bhasakrb123@gggggqq.com';
        Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
        Lead ldObj=Util02_TestData.insertLead();
        Database.insert(testUser01);
        Database.insert(pCode);
        pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];
        ID leadRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'LEAD'].Id;
        ldObj.recordtypeId = leadRT;      
        ldObj.zip_code__c = pCode.Id;
        ldObj.customer_score__c='1';
        ldObj.date_of_birth__c = System.today();
        ldObj.state__c = 'NV';
        ldObj.ownerId=testUser01.id;
        Database.insert(ldObj);
        testUser02.enabled_to_work__c='';
        Database.insert(testUser02);
        Postal_Code_County__c pCode1 = Util02_TestData.insertZipCode();
        pCode1.name='5000081';
        Database.Insert(pCode1);
        Util01_RetrieveZipCodeScore.isFirstRunLeadUpdate=true;
        try{
            ldObj.Zip_Code__c=pCode1.id;
            ldObj.customer_score__c = '1';
            Database.update(ldObj);
        }catch(Exception e){
        }
    }
    /*
    Method Name : testLeadCustomerScoreChange1
    Return type : void
    Description : 
    */
    private static testMethod void testLeadCustomerScoreChange1()
    { 
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        List<Lead> lsslist=new List<Lead>();
        List<Lead> lsslist2=new List<Lead>();
        User testUser01=Util02_TestData.insertUser();
        testUser01.enabled_to_work__c='AP;NF;DF';
        User testUser02=Util02_TestData.insertUser();
        testUser02.username = 'bhasakrb123@gggggqq.com';
        Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
        Lead ldObj=Util02_TestData.insertLead();
        Database.insert(testUser01);
        Database.insert(pCode);
        pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];   
        ID leadRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'LEAD'].Id;
        ldObj.recordtypeId = leadRT;   
        ldObj.zip_code__c = pCode.Id;
        ldObj.customer_score__c='1';
        ldObj.date_of_birth__c = System.today();
        ldObj.date_of_birth__c=System.today();
        ldObj.state__c = 'NV';
        ldObj.ownerId=testUser01.id;
        Database.insert(ldObj);
        testUser02.enabled_to_work__c='';
        Database.insert(testUser02);
        Util01_RetrieveZipCodeScore.isFirstRunLeadUpdate=true;
        try{
            ldObj.customer_score__c='2';
            Database.update(ldObj);
        }catch(Exception e){
        }
    }
    /*
    Method Name : testLeadCustomerScoreChange2
    Return type : void
    Description : 
    */
    private static testMethod void testLeadCustomerScoreChange2()
    { 
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        List<Lead> lsslist=new List<Lead>();
        List<Lead> lsslist2=new List<Lead>();
        User testUser01=Util02_TestData.insertUser();
        testUser01.enabled_to_work__c='AP;NF;DF';
        Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
        Lead ldObj=Util02_TestData.insertLead();
        Database.insert(testUser01);
        Database.insert(pCode);
        pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];   
        ID leadRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'LEAD'].Id;
        ldObj.recordtypeId = leadRT;   
        ldObj.zip_code__c = pCode.Id;
        ldObj.customer_score__c='';
        ldObj.date_of_birth__c=System.today();
        ldObj.state__c = 'NV';
        ldObj.ownerId=testUser01.id;
        Database.insert(ldObj);
    }
    /*
    Method Name : testLeadMarketingEvent
    Return type : void
    Description : 
    */
    private static testMethod void testLeadMarketingEvent()
    { 
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        User testUser01=Util02_TestData.insertUser();
        testUser01.enabled_to_work__c='AP;NF;DF';
        User testUser02=Util02_TestData.insertUser();
        Lead testLead = Util02_TestData.insertLead();
        testLead.customer_score__c ='1';
        testLead.Marketing_Event__c=NULL;
        testLead.state__c='NV';
        testLead.date_of_birth__c=System.today();
        Database.insert(testUser01);
        testUser02.username = 'bhasakrb123@ggggg.com';
        Database.insert(testUser02);
        Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
        Database.insert(pCode);
        pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];  
        ID leadRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'LEAD'].Id;
        testLead.recordtypeId = leadRT;    
        testLead.zip_code__c = pCode.Id;
        Database.insert(testLead);
        Test.startTest();
        try{
            testLead.Marketing_Event__c='1003';
            Update testLead;
        }catch(Exception e){
        }
        Test.stopTest();
    }
    /*
    Method Name : testLeadOwnerChange1
    Return type : void
    Description : 
    */
    private static testMethod void testLeadOwnerChange1()
    { 
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        List<Lead> lsslist=new List<Lead>();
        List<Lead> lsslist2=new List<Lead>();
        User testUser01=Util02_TestData.insertUser();
        testUser01.enabled_to_work__c='AP;NF;DF';
        User testUser02=Util02_TestData.insertUser();
        testUser02.username = 'bhasakrb123@au.com';
        Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
        Lead ldObj=Util02_TestData.insertLead();
        Database.insert(testUser01);
        Database.insert(pCode);
        ID leadRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'LEAD'].Id;
        ldObj.recordtypeId = leadRT;       
        pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];      
        ldObj.zip_code__c = pCode.Id;
        ldObj.customer_score__c='1';
        ldObj.date_of_birth__c=System.today();
        ldObj.state__c = 'NV';
        ldObj.ownerId=testUser01.id;
        Database.insert(ldObj);
        testUser02.enabled_to_work__c='AP;NF;DF';
        Database.insert(testUser02);
        try{
            AP13_UpdateAcitivityOwner.isLeadAfterUpdate = true;
            ldObj.ownerId = testUser02.id;           
            AP13_UpdateAcitivityOwner activityOwner = new AP13_UpdateAcitivityOwner();
            Database.update(ldObj); 
        }catch(Exception e){
        }
    }
}