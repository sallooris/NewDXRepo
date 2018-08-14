/*************************************************************************
Class Name   : TaskBeforeInsert_Test
Date Created : 11-June-2015
Created By   : Bhaskar
Description  : This class is test class for TaskBeforeInsert class
****************************************************************************/
/*    Test Class : - TaskBeforeInsert Trigger */
@isTest
public class TaskBeforeInsert_Test{
private static testMethod void testPoulateKitIds()
{
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        User tstUser = Util02_TestData.insertUser(); 
        List<Task> testAccountTasks=new List<Task>(); 
        id taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Send Fulfillment' AND SobjectType ='Task' LIMIT 1].Id;
        Account a = Util02_TestData.insertAccount();
        ID accRT =[select Id,Name from Recordtype where Name = 'Person Account' and SobjectType = 'Account'].Id;
        a.recordtypeId = accRT ;    
        a.state__c = 'CA';
        a.Language__c = 'SP';
        insert a;
        Postcard_Proposal__c pp = new Postcard_Proposal__c();
        pp.Name = 'CAPS-030';
        pp.kit_name__c = 'Deadline Passed';
        pp.language__c = 'SP';
        pp.state__c = 'CA';
        pp.SMC_Brand__c='ABCBC';
        pp.SMC_Language__c='ES';
        insert pp;
        Postcard_Proposal__c pp1 = new Postcard_Proposal__c();
        pp1.Name = 'CAPC-030';
        pp1.kit_name__c = 'Deadline Passed';
        pp1.language__c = 'EN';
        pp1.state__c = 'CA';
        pp.SMC_Brand__c='ABCBC';
        pp.SMC_Language__c='EN';
        insert pp1;
        for(Integer i=0;i< 50;i++){
            Task t = new Task();
            t.ActivityDate = System.Today()+i;
            t.Subject = 'Subject'+i;
            t.RecordTypeId = taskRecordTypeId;
            t.language__c='SP';
            t.communication_type__c ='Deadline Passed';
            t.email_address__c = 'Primary Email';
            t.whatId = a.id;
            testAccountTasks.add(t);
        }
        for(Integer i=50;i< 100;i++){
            Task t = new Task();
            t.ActivityDate = System.Today()+i;
            t.Subject = 'Subject'+i;
            t.RecordTypeId = taskRecordTypeId;
            t.language__c='EN';
            t.communication_type__c ='Thanks for Contacting Me';
            t.Postal_Address__c = 'Mailing Address';
            t.whatId = a.id;
            testAccountTasks.add(t);
        }
        insert testAccountTasks;
        
    
}
private static testMethod void testPopulateKitCodes1(){
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
        insert pCode;
        id taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Send Fulfillment' AND SobjectType ='Task' LIMIT 1].Id;
        pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];
        List<Task> testLeadTasks=new List<Task>(); 
        Lead testLead = Util02_TestData.insertLead(); 
        ID leadRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'LEAD'].Id;
        testLead.recordtypeId = leadRT ;
        testLead.zip_code__c = pCode.Id;
        testLead.state__c = 'CA';
        testLead.Language__c = 'SP';
        insert testLead;
        for(Integer i=0;i< 5;i++){
            Task t = new Task();
            t.ActivityDate = System.Today()+i;
            t.Subject = 'Subject'+i;
            t.RecordTypeId = taskRecordTypeId;
            t.language__c='SP';
            t.communication_type__c ='Deadline Passed';
            t.email_address__c = 'Primary Email';
            t.whoId = testLead.id;
            testLeadTasks.add(t);
        }
        for(Integer i=5;i< 10;i++){
            Task t = new Task();
            t.ActivityDate = System.Today()+i;
            t.Subject = 'Subject'+i;
            t.RecordTypeId = taskRecordTypeId;
            t.language__c='EN';
            t.communication_type__c ='Thanks for Contacting Me';
            t.postal_address__c = 'Mailing Address';
            t.whoId = testLead.id;
            testLeadTasks.add(t);
        }
        insert testLeadTasks;
}
private static testMethod void testPoulateKitIds2()
{
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        User tstUser = Util02_TestData.insertUser(); 
        List<Task> testAccountTasks=new List<Task>(); 
        id taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Send Fulfillment' AND SobjectType ='Task' LIMIT 1].Id;
        Account a = Util02_TestData.insertAccount();
        ID accRT =[select Id,Name from Recordtype where Name = 'Person Account' and SobjectType = 'Account'].Id;
        a.recordtypeId = accRT ;    
        a.state__c = 'CA';
        a.Language__c = 'SP';
        insert a;
        Postcard_Proposal__c pp = new Postcard_Proposal__c();
        pp.Name = 'CAPS-030';
        pp.kit_name__c = 'Deadline Passed';
        pp.language__c = 'SP';
        pp.state__c = 'CA';
        pp.SMC_Brand__c='ABCBC';
        pp.SMC_Language__c='ES';
        insert pp;
        Postcard_Proposal__c pp1 = new Postcard_Proposal__c();
        pp1.Name = 'CAPC-030';
        pp1.kit_name__c = 'Deadline Passed';
        pp1.language__c = 'EN';
        pp1.state__c = 'CA';
        pp.SMC_Brand__c='ABCBC';
        pp.SMC_Language__c='EN';
        pp.SMC_Customer_Key__c='ABCBCBC';
        insert pp1;
        Task t = new Task();
        t.ActivityDate = System.Today()+1;
        t.Subject = 'Subject'+1;
        t.RecordTypeId = taskRecordTypeId;
        t.language__c='EN';
        t.communication_type__c ='Deadline Passed';
        t.email_address__c = 'Primary Email';
        t.whatId = a.id;
        insert t; 
}
private static testMethod void testMarketingCampaignPopulation()
{
     Test.startTest();
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        List<Campaign> listCampaign = new List<Campaign>();
        User tstUser = Util02_TestData.insertUser(); 
        List<Task> testAccountTasks=new List<Task>(); 
        List<Task> testLeadTasks=new List<Task>(); 
        id taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Inbound/Outbound Call Activity' AND SobjectType ='Task' LIMIT 1].Id;
        Account a = Util02_TestData.insertAccount();
        id accRT= [SELECT Id FROM RecordType WHERE Name = 'Person Account' AND SobjectType ='Account' LIMIT 1].Id;
        id campaignRT= [SELECT Id FROM RecordType WHERE Name = 'TS MASTER' AND SobjectType ='Campaign' LIMIT 1].Id;
        Campaign c = new Campaign();
        c.name = '101A';
        c.recordtypeid = campaignRT;
        c.description = 'test123';
        listCampaign.add(c);
        Campaign c1 = new Campaign();
        c1.name = '101X';
        c1.recordtypeid = campaignRT;
        c1.description = 'test';
        listCampaign.add(c1);
        insert listCampaign;
        a.state__c = 'CA';
        a.Language__c = 'SP';
        a.Marketing_Event__c=c.id;
        a.recordtypeid = accRT;
        insert a;
        Test.stopTest();
}
private static testMethod void testSupression()
     {
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        User tstUser = Util02_TestData.insertUser(); 
        List<Task> testAccountTasks=new List<Task>(); 
        id taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Send Fulfillment' AND SobjectType ='Task' LIMIT 1].Id;
        List<Account> accList = Util02_TestData.createAccounts();
        List<Account> accListupdateBack = new List<Account>();
        id accRT= [SELECT Id FROM RecordType WHERE Name = 'Person Account' AND SobjectType ='Account' LIMIT 1].Id;
        List<Task> taskList = new List<Task>();
        for(Integer i = 0 ; i < accList.size(); i++){
            if(i==0){
                accList[i].Suppress__c = true ;
                accList[i].recordTypeId=accRT;
            }
            else if(i==1){
                accList[i].suppressed_email__c = True;
                accList[i].recordTypeId=accRT;
            }
            else if(i==2){
                accList[i].suppressed_mail__c = true;      
                accList[i].recordTypeId=accRT;
            }
        }
        insert accList;
        Integer i = 1;
        for(Account a: accList)
        {
            Task t = new Task();
            t.WhatID = a.Id;
            t.ActivityDate = System.Today().addDays(i);
            t.Subject = 'Subject'+i;
            t.RecordTypeId = taskRecordTypeId;
            t.email_address__c='Primary Email';
            taskList.add(t);
            i++;
        }
        try{
            insert taskList;
        }
        catch(Exception e){
        }
}
private static testmethod void testSuppression1(){
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        List<Task> testLeadTasks=new List<Task>(); 
        List<Lead> leadListupdateBack = new List<Lead>();
        List<Task> taskList = new List<Task>();
        id leadRT= [SELECT Id FROM RecordType WHERE Name = 'TS MASTER' AND SobjectType ='Lead' LIMIT 1].Id;
        id taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Send Fulfillment' AND SobjectType ='Task' LIMIT 1].Id;
        Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
        insert pCode;
        pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];
        System.assertEquals(pCode.Name, '50002');
        List<Lead> leadList = new List<Lead>();
        for(integer j=0;j<4;j++){
            Lead testLead = null;
            if(j==0){
                testLead = Util02_TestData.insertLead(); 
                testLead.zip_code__c = pCode.Id;
                testLead.suppress__c= true ;
                testLead.recordTypeId = leadRT;
            }else if(j==1){
                testLead = Util02_TestData.insertLead(); 
                testLead.zip_code__c = pCode.Id;
                testLead.suppressed_mail__c=true;
                testLead.recordTypeId = leadRT;
            }else if(j==2){
                testLead = Util02_TestData.insertLead(); 
                testLead.zip_code__c = pCode.Id;
                testLead.suppressed_email__c=true;
                testLead.recordTypeId = leadRT;
            }else if(j==3){
                testLead = Util02_TestData.insertLead(); 
                testLead.zip_code__c = pCode.Id;
                testLead.suppress__c= false ;
                testLead.recordTypeId = leadRT;
            }
            leadList.add(testLead);
        }
        insert leadList;
        Integer i=1;
        for(Lead a: leadList)
        {
            Task t = new Task();
            t.WhoID = a.Id;
            t.ActivityDate = System.Today().addDays(i);
            t.Subject = 'Subject'+i;
            t.RecordTypeId = taskRecordTypeId;
            t.email_address__c='Primary Email';
            testLeadTasks.add(t);
            i++; 
        }try{
             insert testLeadTasks;
        }catch(Exception e){
            
        }
}
private static testMethod void testAccountPhones(){
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        User tstUser = Util02_TestData.insertUser(); 
        List<Task> testAccountTasks=new List<Task>(); 
        id taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Schedule Followup' AND SobjectType ='Task' LIMIT 1].Id;
        List<Account> accList = new List<Account>(); 
        List<Account> accListupdateBack = new List<Account>();
        List<Task> taskList = new List<Task>();
        id accRT= [SELECT Id FROM RecordType WHERE Name = 'Person Account' AND SobjectType ='Account' LIMIT 1].Id;
        accList = Util02_TestData.createAccounts();
        for(Account a : accList){
            if(a.FirstName == 'Nagarjuna2'){
                a.phone = '';
                a.Suppressed_Phone__c = true;
                a.Consent_Days__c = System.today() - 1;
                a.work_phone__c='1234';
                a.mobile_phone__c='2345';
                a.recordTypeId = accRT;
            }else if(a.FirstName == 'Nagarjuna3'){
                a.phone = '543543';
                a.work_phone__c='';
                a.mobile_phone__c='2345';
                a.recordTypeId = accRT;
            }else if(a.FirstName == 'Nagarjuna4'){
                a.phone = '543543';
                a.work_phone__c='2345';
                a.mobile_phone__c='';
                a.recordTypeId = accRT;
            }
            accListupdateBack.add(a);   
        }
        insert accListupdateBack;
        Integer i = 1;
        for(Account a: accListupdateBack)
        {
            Task t = new Task();
            t.WhatID = a.Id;
            t.ActivityDate = System.Today().addDays(i);
            t.Subject = 'Subject'+i;
            t.RecordTypeId = taskRecordTypeId;
            t.Phone_Number__c='Mobile Phone';
            taskList.add(t);
            i++;
        }
        try{
            insert taskList;
        }
        catch(Exception e){
        }
    }
private static testmethod void testLeadPhones(){
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        List<Task> testLeadTasks=new List<Task>(); 
        List<Lead> leadListupdateBack = new List<Lead>();
        List<Task> taskList = new List<Task>();
        id taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Send Fulfillment' AND SobjectType ='Task' LIMIT 1].Id;
        Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
        insert pCode;
        id leadRT= [SELECT Id FROM RecordType WHERE Name = 'TS MASTER' AND SobjectType ='Lead' LIMIT 1].Id;
        pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];
        System.assertEquals(pCode.Name, '50002');
        List<Lead> leadList = new List<Lead>();
        for(integer j=0;j<4;j++){
            Lead testLead = null;
            if(j==0){
                testLead = Util02_TestData.insertLead(); 
                testLead.zip_code__c = pCode.Id;
                testLead.phone='';
                testLead.Mobile_Phone__c = '1234';
                testLead.Work_Phone__c = '1234333';
                testLead.recordTypeId = leadRT;
            }else if(j==1){
                testLead = Util02_TestData.insertLead(); 
                testLead.zip_code__c = pCode.Id;
                testLead.phone='3423423';
                testLead.Mobile_Phone__c = '';
                testLead.Work_Phone__c = '1234333';
                testLead.recordTypeId = leadRT;
            }else if(j==2){
                testLead = Util02_TestData.insertLead(); 
                testLead.zip_code__c = pCode.Id;
                testLead.phone='324234';
                testLead.Mobile_Phone__c = '1234';
                testLead.Work_Phone__c = '';
                testLead.recordTypeId = leadRT;
            }else if(j==3){
                testLead = Util02_TestData.insertLead(); 
                testLead.zip_code__c = pCode.Id;
                testLead.phone='';
                testLead.Mobile_Phone__c = '';
                testLead.Work_Phone__c = '';
                testLead.recordTypeId = leadRT;
            }
            leadList.add(testLead);
        }
        insert leadList;
        Integer i=1;
        for(Lead a: leadList)
        {
            Task t = new Task();
            t.WhoID = a.Id;
            t.ActivityDate = System.Today().addDays(i);
            t.Subject = 'Subject'+i;
            t.RecordTypeId = taskRecordTypeId;
            t.Phone_Number__c='Work Phone';
            testLeadTasks.add(t);
            i++;
        }try{
             insert testLeadTasks;
        }catch(Exception e){
        }
}
private static testmethod void testLeadPhones1(){
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        List<Task> testLeadTasks=new List<Task>(); 
        List<Lead> leadListupdateBack = new List<Lead>();
        List<Task> taskList = new List<Task>();
        id taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Send Fulfillment' AND SobjectType ='Task' LIMIT 1].Id;
        Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
        insert pCode;
        pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];
        System.assertEquals(pCode.Name, '50002');
        Lead ld = Util02_TestData.insertLead();
        id leadRT= [SELECT Id FROM RecordType WHERE Name = 'TS MASTER' AND SobjectType ='Lead' LIMIT 1].Id;
        ld.zip_code__c = pCode.id;
        ld.consent_days__c = System.today() - 1 ;
        ld.Suppressed_Phone__c = true;
        ld.Suppressed_HomePhone__c = true;
        ld.recordTypeId = leadRT;
        insert ld;
        Task t = new Task();
        t.WhoID = ld.Id;
        t.ActivityDate = System.Today().addDays(1);
        t.Subject = 'Subject'+1;
        t.RecordTypeId = taskRecordTypeId;
        t.email_address__c ='Primary Email';
        testLeadTasks.add(t);
        try{
             insert testLeadTasks;
        }catch(Exception e){
        }
}
private static testmethod void testLeadPhones2(){
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        List<Task> testLeadTasks=new List<Task>(); 
        List<Lead> leadListupdateBack = new List<Lead>();
        List<Task> taskList = new List<Task>();
        id taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Send Fulfillment' AND SobjectType ='Task' LIMIT 1].Id;
        Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
        insert pCode;
        pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];
        System.assertEquals(pCode.Name, '50002');
        Lead ld = Util02_TestData.insertLead();
        id leadRT= [SELECT Id FROM RecordType WHERE Name = 'TS MASTER' AND SobjectType ='Lead' LIMIT 1].Id;
        ld.zip_code__c = pCode.id;
        ld.Suppress__c = true;
        ld.recordTypeId = leadRT;
        insert ld;
        Task t = new Task();
        t.WhoID = ld.Id;
        t.ActivityDate = System.Today().addDays(1);
        t.Subject = 'Subject'+1;
        t.RecordTypeId = taskRecordTypeId;
        t.email_address__c ='Primary Email';
        testLeadTasks.add(t);
        try{
             insert testLeadTasks;
        }catch(Exception e){
        }
    }
private static testmethod void testLeadPhones3(){
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        List<Task> testLeadTasks=new List<Task>(); 
        List<Lead> leadListupdateBack = new List<Lead>();
        List<Task> taskList = new List<Task>();
        id taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Send Fulfillment' AND SobjectType ='Task' LIMIT 1].Id;
        Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
        insert pCode;
        pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];
        System.assertEquals(pCode.Name, '50002');
        Lead ld = Util02_TestData.insertLead();
        id leadRT= [SELECT Id FROM RecordType WHERE Name = 'TS MASTER' AND SobjectType ='Lead' LIMIT 1].Id;
        ld.zip_code__c = pCode.id;
        ld.recordTypeId = leadRT;
        ld.Suppressed_Email__c = true;
        insert ld;
        Task t = new Task();
        t.WhoID = ld.Id;
        t.ActivityDate = System.Today().addDays(1);
        t.Subject = 'Subject'+1;
        t.RecordTypeId = taskRecordTypeId;
        t.email_address__c ='Primary Email';
        testLeadTasks.add(t);
        try{
             insert testLeadTasks;
        }catch(Exception e){ 
        }
}
private static testmethod void testLeadPhones4(){
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        List<Task> testLeadTasks=new List<Task>(); 
        List<Lead> leadListupdateBack = new List<Lead>();
        List<Task> taskList = new List<Task>();
        id taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Send Fulfillment' AND SobjectType ='Task' LIMIT 1].Id;
        Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
        insert pCode;
        pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];
        System.assertEquals(pCode.Name, '50002');
        Lead ld = Util02_TestData.insertLead();
        id leadRT= [SELECT Id FROM RecordType WHERE Name = 'TS MASTER' AND SobjectType ='Lead' LIMIT 1].Id;
        ld.zip_code__c = pCode.id;
        ld.recordTypeId = leadRT;
        ld.Suppressed_Mail__c = true;
        insert ld;
        Task t = new Task();
        t.WhoID = ld.Id;
        t.ActivityDate = System.Today().addDays(1);
        t.Subject = 'Subject'+1;
        t.RecordTypeId = taskRecordTypeId;
        t.email_address__c ='Primary Email';
        testLeadTasks.add(t);
        try{
             insert testLeadTasks;
        }catch(Exception e){  
        }
}
private static testmethod void testAccPhones4(){
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        List<Task> testAccTasks=new List<Task>(); 
        List<Task> taskList = new List<Task>();
        id taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Send Fulfillment' AND SobjectType ='Task' LIMIT 1].Id;
        Account aa = Util02_TestData.insertAccount();
        id accRT= [SELECT Id FROM RecordType WHERE Name = 'Person Account' AND SobjectType ='Account' LIMIT 1].Id;
        aa.Suppress__c = true;
        aa.recordTypeId = accRT;
        insert aa;
        Task t = new Task();
        t.WhatID = aa.Id;
        t.ActivityDate = System.Today().addDays(1);
        t.Subject = 'Subject'+1;
        t.RecordTypeId = taskRecordTypeId;
        t.email_address__c ='Primary Email';
        testAccTasks.add(t);
        try{
             insert testAccTasks;
        }catch(Exception e){
            
        }
}
private static testmethod void testAccTaskResidenceState(){
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        User tstUser = Util02_TestData.insertUser(); 
        Profile txtProfile02 = [SELECT Id FROM Profile WHERE Name ='Representative' Limit 1];
        tstUser.profileID=txtProfile02.id;
        Database.insert(tstUser);
        List<Task> testAccTasks=new List<Task>(); 
        List<Task> taskList = new List<Task>();
        id taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Send Fulfillment' AND SobjectType ='Task' LIMIT 1].Id;
        Account aa = Util02_TestData.insertAccount();
        id accRT= [SELECT Id FROM RecordType WHERE Name = 'Person Account' AND SobjectType ='Account' LIMIT 1].Id;
        aa.state__c='CA';
        aa.Billing_State__c='CA';
        aa.recordTypeId = accRT;
        insert aa;
//        System.runAs(tstUser){
            Task t = new Task();
            t.WhatID = aa.Id;
            t.ActivityDate = System.Today().addDays(1);
            t.Subject = 'Subject'+1;
            t.RecordTypeId = taskRecordTypeId;
            t.email_address__c ='Primary Email';
            t.residence_state__c = 'AB';
            testAccTasks.add(t);
            try{
                 insert testAccTasks;
            }catch(Exception e){    
            }
       // }
}
private static testmethod void testLeadTaskResidenceState(){
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        List<Task> testLeadTasks=new List<Task>(); 
        List<Lead> leadListupdateBack = new List<Lead>();
        List<Task> taskList = new List<Task>();
        User tstUser = Util02_TestData.insertUser(); 
        Profile txtProfile02 = [SELECT Id FROM Profile WHERE Name ='Representative' Limit 1];
        tstUser.profileID=txtProfile02.id;
        Database.insert(tstUser);
        id taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Send Fulfillment' AND SobjectType ='Task' LIMIT 1].Id;
        Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
        insert pCode;
        pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];
        System.assertEquals(pCode.Name, '50002');
        Lead ld = Util02_TestData.insertLead();
        id leadRT= [SELECT Id FROM RecordType WHERE Name = 'TS MASTER' AND SobjectType ='Lead' LIMIT 1].Id;
        ld.zip_code__c = pCode.id;
        ld.State='CA';
        ld.State__c='CA';
        ld.recordTypeId = leadRT;
        insert ld;
   //     System.runAs(tstUser){
            Task t = new Task();
            t.WhoID = ld.Id;
            t.ActivityDate = System.Today().addDays(1);
            t.Subject = 'Subject'+1;
            t.RecordTypeId = taskRecordTypeId;
            t.email_address__c ='Primary Email';
            t.residence_state__c = 'AB';
            testLeadTasks.add(t);
            try{
                 insert testLeadTasks;
            }catch(Exception e){ 
            }
      //  }
}
private static testmethod void testHomePageDueDate(){
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        User tstUser = Util02_TestData.insertUser(); 
        Profile txtProfile02 = [SELECT Id FROM Profile WHERE Name ='Representative' Limit 1];
        tstUser.profileID=txtProfile02.id;
        Database.insert(tstUser);
        List<Task> testAccTasks=new List<Task>(); 
        List<Task> taskList = new List<Task>();
        id taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Send Fulfillment' AND SobjectType ='Task' LIMIT 1].Id;
        Account aa = Util02_TestData.insertAccount();
        id accRT= [SELECT Id FROM RecordType WHERE Name = 'Person Account' AND SobjectType ='Account' LIMIT 1].Id;
        aa.state__c='CA';
        aa.Billing_State__c='CA';
        aa.recordTypeId = accRT;
  //      System.runAs(tstUser){
        insert aa;
        Task t = new Task();
        t.WhatID = aa.Id;
        t.ActivityDate = System.Today().addDays(1);
        t.Subject = 'Subject'+1;
        t.RecordTypeId = taskRecordTypeId;
        t.email_address__c ='Primary Email';
 //       t.residence_state__c = 'CA';
        t.Desired_Effective_Date__c=system.today();           
        AP21_PopulateDueDate.isBeforeInsertFirstRun=true;
        insert t;
            
     //   }
   } 
}