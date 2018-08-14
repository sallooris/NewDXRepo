/*************************************************************************
Class Name   : TaskBeforeUpdate_Test
Date Created : 11-June-2015
Created By   : Bhaskar
Description  : This class is test class for TaskBeforeUpdate class
****************************************************************************/
/*    Test Class : - TaskBeforeUpdate Trigger */
@isTest
public class TaskBeforeUpdate_Test{

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
        pp.brand__c ='ABC';
        pp.SMC_Customer_Key__c ='ABCD';
        pp.SMC_Brand__c = 'ABCBC';
        pp.SMC_Language__c='ES';
        insert pp;
        Postcard_Proposal__c pp1 = new Postcard_Proposal__c();
        pp1.Name = 'CAPC-030';
        pp1.kit_name__c = 'Deadline Passed';
        pp1.language__c = 'EN';
        pp1.state__c = 'CA';
        pp1.SMC_Customer_Key__c ='ABCD';
        pp1.brand__c ='ABC';
        pp1.SMC_Brand__c = 'ABC';
        pp1.SMC_Language__c='EN';
        insert pp1;
        Task t = new Task();
        t.ActivityDate = System.Today();
        t.Subject = 'Subject';
        t.RecordTypeId = taskRecordTypeId;
        t.language__c='EN';
        t.communication_type__c ='Deadline Passed';
        t.email_address__c = 'Primary Email';
        t.whatId = a.id;
        testAccountTasks.add(t);
        insert testAccountTasks;
        AP07_PopulateKitIDOnTask.populateKitIds(testAccountTasks,'insert');
        List<Task> updateTasks = new List<Task>();
        for(Task tt:testAccountTasks){
            tt.communication_type__c ='Follow-up Reminder';
            tt.language__c='SP';
            tt.email_address__c ='';
            tt.postal_address__c = 'Mailing Address';
            updateTasks.add(tt);
        }
        update updateTasks;
        AP07_PopulateKitIDOnTask.populateKitIds(updateTasks,'update');
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
        Postcard_Proposal__c pp = new Postcard_Proposal__c();
        pp.Name = 'CAPS-030';
        pp.kit_name__c = 'Deadline Passed';
        pp.language__c = 'SP';
        pp.state__c = 'CA';
        pp.brand__c ='ABC';
        pp.SMC_Brand__c = 'ABC';
        pp.SMC_Language__c='ES';
        pp.SMC_Customer_Key__c ='ABCD';
        insert pp;
        Postcard_Proposal__c pp1 = new Postcard_Proposal__c();
        pp1.Name = 'CAPC-030';
        pp1.kit_name__c = 'Deadline Passed';
        pp1.language__c = 'EN';
        pp1.state__c = 'CA';
        pp1.SMC_Customer_Key__c ='ABCD';
        pp1.brand__c ='ABC';
        pp1.SMC_Brand__c = 'ABC';
        pp1.SMC_Language__c='EN';
        insert pp1;
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
        AP07_PopulateKitIDOnTask.populateKitIds(testLeadTasks,'insert');
        List<Task> updateTasks = new List<Task>();
        for(Task t:testLeadTasks){
            t.communication_type__c ='Deadline Passed';
            updateTasks.add(t);
        }
        update updateTasks;
        AP07_PopulateKitIDOnTask.populateKitIds(updateTasks,'update');
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
        pp.brand__c ='ABC';
        pp.SMC_Customer_Key__c ='ABCD';
        pp.SMC_Brand__c = 'ABCBC';
        pp.SMC_Language__c='ES';
        insert pp;
        Postcard_Proposal__c pp1 = new Postcard_Proposal__c();
        pp1.Name = 'CAPC-030';
        pp1.kit_name__c = 'Deadline Passed';
        pp1.language__c = 'EN';
        pp1.state__c = 'CA';
        pp1.SMC_Customer_Key__c ='ABCD';
        pp1.brand__c ='ABC';
        pp1.SMC_Brand__c = 'ABC';
        pp1.SMC_Language__c='EN';
        insert pp1;
        Task t = new Task();
        t.ActivityDate = System.Today();
        t.Subject = 'Subject';
        t.RecordTypeId = taskRecordTypeId;
        t.language__c='EN';
        t.communication_type__c ='Deadline Passed';
        t.email_address__c = 'Primary Email';
        t.whatId = a.id;
        testAccountTasks.add(t);
        insert testAccountTasks;
        AP07_PopulateKitIDOnTask.populateKitIds(testAccountTasks,'insert');
        List<Task> updateTasks = new List<Task>();
        for(Task tt:testAccountTasks){
            tt.language__c='SP';
            tt.email_address__c ='Primary Email';
            tt.postal_address__c = '';
            updateTasks.add(tt);
        }
        update updateTasks;
        AP07_PopulateKitIDOnTask.populateKitIds(updateTasks,'update');
}
private static testMethod void testMarketingCampaignPopulation()
{
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        List<Campaign> listCampaign = new List<Campaign>();
        User tstUser = Util02_TestData.insertUser(); 
        List<Task> testAccountTasks=new List<Task>(); 
        List<Task> testLeadTasks=new List<Task>();
        id LeadRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'TS MASTER' AND SobjectType ='Lead' LIMIT 1].Id;
        id campRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'TS MASTER' AND SobjectType ='Campaign' LIMIT 1].Id;
        id accRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Person Account' AND SobjectType ='Account' LIMIT 1].Id;
        id taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Inbound/Outbound Call Activity' AND SobjectType ='Task' LIMIT 1].Id;
        Account a = Util02_TestData.insertAccount();
        Campaign c = new Campaign();
        c.name = '101A';
        c.recordTypeId = campRecordTypeId;
        c.description = 'test123';
        listCampaign.add(c);
        Campaign c1 = new Campaign();
        c1.name = '101X';
        c1.recordTypeId = campRecordTypeId;
        c1.description = 'test';
        listCampaign.add(c1);
        Campaign c2 = new Campaign();
        c2.name = '101G';
        c2.recordTypeId = campRecordTypeId;
        c2.description = 'testGGGG';
        listCampaign.add(c2);
        insert listCampaign;
        a.state__c = 'CA';
        a.recordTypeId = accRecordTypeId ;
        a.Language__c = 'SP';
        a.Marketing_Event__c=c2.id;
        insert a;
        for(Integer i=0;i< 5;i++){
            Task t = new Task();
            t.ActivityDate = System.Today()+i;
            t.Subject = 'Subject'+i;
            t.RecordTypeId = taskRecordTypeId;
            t.marketing_id__c='101A';
            t.whatId = a.id;
            testAccountTasks.add(t);
        }
        for(Integer i=5;i< 10;i++){
            Task t = new Task();
            t.ActivityDate = System.Today()+i;
            t.Subject = 'Subject'+i;
            t.RecordTypeId = taskRecordTypeId;
            t.marketing_id__c ='101X';
            t.whatId = a.id;
            testAccountTasks.add(t);
        }
        insert testAccountTasks;
        List<Task> updateTasks = new List<Task>();
        for(Task t:testAccountTasks){
            t.marketing_id__c ='101G';
            updateTasks.add(t);
        }
        update updateTasks; 
        update listCampaign; 
}
private static testMethod void testMarketingCampaignPopulation1()
{
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        List<Campaign> listCampaign = new List<Campaign>();
        User tstUser = Util02_TestData.insertUser(); 
        List<Task> testAccountTasks=new List<Task>(); 
        List<Task> testLeadTasks=new List<Task>();
        id LeadRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'TS MASTER' AND SobjectType ='Lead' LIMIT 1].Id;
        id campRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'TS MASTER' AND SobjectType ='Campaign' LIMIT 1].Id;
        id accRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Person Account' AND SobjectType ='Account' LIMIT 1].Id;
        id taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Inbound/Outbound Call Activity' AND SobjectType ='Task' LIMIT 1].Id;
        Account a = Util02_TestData.insertAccount();
        Campaign c = new Campaign();
        c.name = '101A';
        c.recordTypeId = campRecordTypeId ;
        c.description = 'test123';
        listCampaign.add(c);
        Campaign c1 = new Campaign();
        c1.name = '101X';
        c1.recordTypeId = campRecordTypeId ;
        c1.description = 'test';
        listCampaign.add(c1);
        insert listCampaign;
        a.state__c = 'CA';
        a.recordTypeId = accRecordTypeId ;
        a.Language__c = 'SP';
        a.Marketing_Event__c=c1.id;
        insert a;
        Task t = new Task();
        t.ActivityDate = System.Today();
        t.Subject = 'Subject';
        t.RecordTypeId = taskRecordTypeId;
        t.marketing_id__c='101A';
        t.whatId = a.id;
        insert t;  
        a.Marketing_Event__c=c1.id;
        a.recordTypeId = accRecordTypeId ;
        update a;
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
        List<Account> accList = new List<Account>(); 
        List<Account> accListupdateBack = new List<Account>();
        List<Task> taskList = new List<Task>();
        id accRT= [SELECT Id FROM RecordType WHERE Name = 'Person Account' AND SobjectType ='Account' LIMIT 1].Id;
        accList = Util02_TestData.createAccounts();
        for(Account a : accList){
            if(a.FirstName == 'Nagarjuna1'){
                a.suppress__c = true ;
                a.recordTypeId = accRT;
            }
            else if(a.FirstName == 'Nagarjuna2'){
                a.suppressed_email__c = True;
                a.recordTypeId = accRT;
            }
            else if(a.FirstName == 'Nagarjuna3'){
                a.suppressed_mail__c = true;
                a.recordTypeId = accRT;
            }
            else if(a.FirstName == 'Nagarjuna4'){
                a.suppress__c= false ;
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
            t.email_address__c='Primary Email';
            taskList.add(t);
            i++;
        }
        try{
            insert taskList;
        List<Task> updateTasks = new List<Task>();
        for(Task t:taskList){
            t.postal_address__c='Mailing Address';
            updateTasks.add(t);
        }
        update updateTasks;
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
        id taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Send Fulfillment' AND SobjectType ='Task' LIMIT 1].Id;
        Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
        insert pCode;
        pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];
        System.assertEquals(pCode.Name, '50002');
        List<Lead> leadList = new List<Lead>();
        ID leadRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'LEAD'].Id;
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
             List<Task> updateTasks = new List<Task>();
        for(Task t:testLeadTasks){
            t.postal_address__c='Mailing Address';
            updateTasks.add(t);
        }
        update updateTasks;
        }catch(Exception e){  
        }
}
private static testMethod void testAccphones()
{
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
        ID accRT =[select Id,Name from Recordtype where Name = 'Person Account' and SobjectType = 'Account'].Id;
        accList = Util02_TestData.createAccounts();
        for(Account a : accList){
           if(a.FirstName == 'Nagarjuna2'){
                a.phone = '';
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
        List<Task> updateTasks = new List<Task>();
        for(Task t:taskList){
            t.Phone_Number__c='Home Phone';
            updateTasks.add(t);
        }
        update updateTasks;
        }
        catch(Exception e){
        }
}
private static testmethod void testleadphone(){
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        List<Task> testLeadTasks=new List<Task>(); 
        List<Lead> leadListupdateBack = new List<Lead>();
        List<Task> taskList = new List<Task>();
        id taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Schedule Followup' AND SobjectType ='Task' LIMIT 1].Id;
        Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
        insert pCode;
        ID leadRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'LEAD'].Id;
        pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];
        System.assertEquals(pCode.Name, '50002');
        List<Lead> leadList = new List<Lead>();
        for(integer j=0;j<4;j++){
            Lead testLead = null;
            if(j==0){
                testLead = Util02_TestData.insertLead(); 
                testLead.zip_code__c = pCode.Id;
                testLead.phone = '';
                testLead.work_phone__c='1234';
                testLead.mobile_phone__c='2345';
                testLead.recordTypeId = leadRT;
            }else if(j==1){
                testLead = Util02_TestData.insertLead(); 
                testLead.zip_code__c = pCode.Id;
                testLead.phone = '543543';
                testLead.work_phone__c='';
                testLead.mobile_phone__c='2345';
                testLead.recordTypeId = leadRT;
            }else if(j==2){
                testLead = Util02_TestData.insertLead(); 
                testLead.zip_code__c = pCode.Id;
               testLead.phone = '543543';
                testLead.work_phone__c='2345';
                testLead.mobile_phone__c='';
                testLead.recordTypeId = leadRT;
            }else if(j==3){
                testLead = Util02_TestData.insertLead(); 
                testLead.zip_code__c = pCode.Id;
                testLead.phone = '';
                testLead.work_phone__c='';
                testLead.mobile_phone__c='';
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
            t.Phone_Number__c='Mobile Phone';
            testLeadTasks.add(t);
            i++;
            
        }try{
             insert testLeadTasks;
             List<Task> updateTasks = new List<Task>();
        for(Task t:testLeadTasks){
            t.Phone_Number__c='Home Phone';
            
            updateTasks.add(t);
        }
        update updateTasks;
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
 //       System.runAs(tstUser){
        insert aa;
        Task t = new Task();
        t.WhatID = aa.Id;
        t.ActivityDate = System.Today().addDays(1);
        t.Subject = 'Subject'+1;
        t.RecordTypeId = taskRecordTypeId;
        t.email_address__c ='Primary Email';
        t.residence_state__c = 'CA';
        insert t;
            try{
                AP18_RestrictResidenceStateChange.isTaskBeforeUpdateFirstRun =true;
                t.residence_state__c ='AB';
                Database.update(t);
            }catch(Exception e){ 
            }
 //       }
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
//        System.runAs(tstUser){
        insert aa;
        Task t = new Task();
        t.WhatID = aa.Id;
        t.ActivityDate = System.Today().addDays(1);
        t.Subject = 'Subject'+1;
        t.RecordTypeId = taskRecordTypeId;
        t.email_address__c ='Primary Email';
        t.residence_state__c = 'CA';
            taskList.add(t);
           
           AP21_PopulateDueDate.isBeforeInsertFirstRun=true;
          
            insert t;
            t.Desired_Effective_Date__c=system.today();
            update t;
  //      }
   } 
   private static testmethod void testXMLGeneration(){
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        User tstUser = Util02_TestData.insertUser(); 
        Profile txtProfile02 = [SELECT Id FROM Profile WHERE Name ='Representative' Limit 1];
        tstUser.profileID=txtProfile02.id;
        Database.insert(tstUser);
        Licensing__c lcnse = new Licensing__c();
        lcnse.License_Number__c = '12345';
        lcnse.Microsite_URL__c = 'http://testxml.in';
        lcnse.NPN__c = '6464';
        lcnse.Anthem_Producer_Number__c = '34543543';
        lcnse.OwnerId = tstUser.id;
        lcnse.state__c = 'CA';
        insert lcnse;
        List<sObject> ls = Test.loadData(CS004_TaskXmlGenerator__c.sObjectType, 'Test_CS004_TaskGenerationXMLData');
        List<sObject> ls1 = Test.loadData(CS005_SMCXMLGeneration__c.sObjectType, 'Test_CS005_GenerateXMLData');
        List<Task> testAccTasks=new List<Task>();
        List<Task> taskList = new List<Task>();
        id taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Send Fulfillment' AND SobjectType ='Task' LIMIT 1].Id;
        Account aa = Util02_TestData.insertAccount();
        id accRT= [SELECT Id FROM RecordType WHERE Name = 'Person Account' AND SobjectType ='Account' LIMIT 1].Id;
        aa.state__c='CA';
        aa.Billing_State__c='CA';
        aa.recordTypeId = accRT;
 //       System.runAs(tstUser){
        insert aa;
        Task t = new Task();
        t.WhatID = aa.Id;
        t.ActivityDate = System.Today().addDays(1);
        t.Subject = 'Subject'+1;
        t.RecordTypeId = taskRecordTypeId;
        t.email_address__c ='Primary Email';
        t.residence_state__c = 'CA';
        insert t;
        AP22_GenerateTaskXml gtx = new AP22_GenerateTaskXml();
        gtx.insertXmlFields(t,tstUser.id,'insert');
//        }
    }
private static testmethod void testXMLGeneration1(){
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        User tstUser = Util02_TestData.insertUser(); 
        Profile txtProfile02 = [SELECT Id FROM Profile WHERE Name ='Representative' Limit 1];
        tstUser.profileID=txtProfile02.id;
        Database.insert(tstUser);
        Licensing__c lcnse = new Licensing__c();
        lcnse.License_Number__c = '12345';
        lcnse.Microsite_URL__c = 'http://testxml.in';
        lcnse.NPN__c = '6464';
        lcnse.Anthem_Producer_Number__c = '34543543';
        lcnse.OwnerId = tstUser.id;
        lcnse.state__c = 'CA';
        insert lcnse;
        List<sObject> ls = Test.loadData(CS004_TaskXmlGenerator__c.sObjectType, 'Test_CS004_TaskGenerationXMLData');
        List<sObject> ls1 = Test.loadData(CS005_SMCXMLGeneration__c.sObjectType, 'Test_CS005_GenerateXMLData');
        List<Task> testAccTasks=new List<Task>();
        List<Task> taskList = new List<Task>();
        id taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Send Fulfillment' AND SobjectType ='Task' LIMIT 1].Id;
        Account aa = Util02_TestData.insertAccount();
        id accRT= [SELECT Id FROM RecordType WHERE Name = 'Person Account' AND SobjectType ='Account' LIMIT 1].Id;
        aa.state__c='CA';
        aa.Billing_State__c='CA';
        aa.recordTypeId = accRT;
 //       System.runAs(tstUser){
        insert aa;
        Task t = new Task();
        t.WhatID = aa.Id;
        t.ActivityDate = System.Today().addDays(1);
        t.Subject = 'SubjectBhaskarXML'+1;
        t.RecordTypeId = taskRecordTypeId;
        t.email_address__c ='Secondary Email';
        t.residence_state__c = 'CA';
        test.starttest();
        insert t;
        Task t1 = [select ID,Source_External_ID__c from task where subject='SubjectBhaskarXML1'];
        String taskId = t1.id;
        t1.Source_External_ID__c = taskId.substring(0,15);
        AP22_GenerateTaskXml.isXmlGeneratorAfterUpdate = true;
        update t1;
        test.stoptest();
        AP22_GenerateTaskXml gtx = new AP22_GenerateTaskXml();
        gtx.insertXmlFields(t,tstUser.id,'update');
//        }
    }
private static testmethod void testXMLGeneration2(){
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        User tstUser = Util02_TestData.insertUser(); 
        Profile txtProfile02 = [SELECT Id FROM Profile WHERE Name ='Representative' Limit 1];
        tstUser.profileID=txtProfile02.id;
        Database.insert(tstUser);
        Licensing__c lcnse = new Licensing__c();
        lcnse.License_Number__c = '12345';
        lcnse.Microsite_URL__c = 'http://testxml.in';
        lcnse.NPN__c = '6464';
        lcnse.Anthem_Producer_Number__c = '34543543';
        lcnse.OwnerId = tstUser.id;
        lcnse.state__c = 'CA';
        insert lcnse;
        List<sObject> ls = Test.loadData(CS004_TaskXmlGenerator__c.sObjectType, 'Test_CS004_TaskGenerationXMLData');
        List<sObject> ls1 = Test.loadData(CS005_SMCXMLGeneration__c.sObjectType, 'Test_CS005_GenerateXMLData');
        List<Task> testAccTasks=new List<Task>();
        List<Task> taskList = new List<Task>();
        id taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Send Fulfillment' AND SobjectType ='Task' LIMIT 1].Id;
        Account aa = Util02_TestData.insertAccount();
        id accRT= [SELECT Id FROM RecordType WHERE Name = 'Person Account' AND SobjectType ='Account' LIMIT 1].Id;
        aa.state__c='CA';
        aa.Billing_State__c='CA';
        aa.recordTypeId = accRT;
//        System.runAs(tstUser){
        insert aa;
        Task t = new Task();
        t.WhatID = aa.Id;
        t.ActivityDate = System.Today().addDays(1);
        t.Subject = 'Subject'+1;
        t.RecordTypeId = taskRecordTypeId;
        t.email_address__c ='Primary Email';
        t.residence_state__c = 'CA';
        t.Source_External_ID__c = t.id;
        insert t;
        delete t;
//        }
    }
    private static testmethod void testXMLGeneration3(){
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
        insert pCode;
        User tstUser = Util02_TestData.insertUser(); 
        Profile txtProfile02 = [SELECT Id FROM Profile WHERE Name ='Representative' Limit 1];
        tstUser.profileID=txtProfile02.id;
        Database.insert(tstUser);
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
        Licensing__c lcnse = new Licensing__c();
        lcnse.License_Number__c = '12345';
        lcnse.Microsite_URL__c = 'http://testxml.in';
        lcnse.NPN__c = '6464';
        lcnse.Anthem_Producer_Number__c = '34543543';
        lcnse.OwnerId = tstUser.id;
        lcnse.state__c = 'CA';
        insert lcnse;
        List<sObject> ls = Test.loadData(CS004_TaskXmlGenerator__c.sObjectType, 'Test_CS004_TaskGenerationXMLData');
        List<sObject> ls1 = Test.loadData(CS005_SMCXMLGeneration__c.sObjectType, 'Test_CS005_GenerateXMLData');
        Task t = new Task();
        t.ActivityDate = System.Today()+1;
        t.Subject = 'Subject'+1;
        t.RecordTypeId = taskRecordTypeId;
        t.language__c='EN';
        t.communication_type__c ='Deadline Passed';
        t.email_address__c = 'Primary Email';
        t.whoId = testLead.id;
        insert t;
        AP22_GenerateTaskXml gtx = new AP22_GenerateTaskXml();
        gtx.insertLeadXmlFields(t,tstUser.id,'insert');
    }
private static testmethod void testXMLGeneration4(){
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
        insert pCode;
        User tstUser = Util02_TestData.insertUser(); 
        Profile txtProfile02 = [SELECT Id FROM Profile WHERE Name ='Representative' Limit 1];
        tstUser.profileID=txtProfile02.id;
        Database.insert(tstUser);
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
        Licensing__c lcnse = new Licensing__c();
        lcnse.License_Number__c = '12345';
        lcnse.Microsite_URL__c = 'http://testxml.in';
        lcnse.NPN__c = '6464';
        lcnse.Anthem_Producer_Number__c = '34543543';
        lcnse.OwnerId = tstUser.id;
        lcnse.state__c = 'CA';
        insert lcnse;
        List<sObject> ls = Test.loadData(CS004_TaskXmlGenerator__c.sObjectType, 'Test_CS004_TaskGenerationXMLData');
        List<sObject> ls1 = Test.loadData(CS005_SMCXMLGeneration__c.sObjectType, 'Test_CS005_GenerateXMLData');
        Task t = new Task();
        t.ActivityDate = System.Today()+1;
        t.Subject = 'SubjectBhaskarXML1';
        t.RecordTypeId = taskRecordTypeId;
        t.language__c='EN';
        t.communication_type__c ='Deadline Passed';
        t.email_address__c = 'Secondary Email';
        t.whoId = testLead.id;
        Test.startTest();
        insert t;
        Task t1 = [select ID,Source_External_ID__c from task where subject='SubjectBhaskarXML1'];
        String taskId = t1.id;
        t1.Source_External_ID__c = taskId.substring(0,15);
        AP22_GenerateTaskXml.isXmlGeneratorAfterUpdate = true;
        update t1;
        test.stoptest();
        AP22_GenerateTaskXml gtx = new AP22_GenerateTaskXml();
        gtx.insertLeadXmlFields(t,tstUser.id,'update');
        
    }
private static testmethod void testXMLGeneration5(){
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
        insert pCode;
        User tstUser = Util02_TestData.insertUser(); 
        Profile txtProfile02 = [SELECT Id FROM Profile WHERE Name ='Representative' Limit 1];
        tstUser.profileID=txtProfile02.id;
        Database.insert(tstUser);
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
        Licensing__c lcnse = new Licensing__c();
        lcnse.License_Number__c = '12345';
        lcnse.Microsite_URL__c = 'http://testxml.in';
        lcnse.NPN__c = '6464';
        lcnse.Anthem_Producer_Number__c = '34543543';
        lcnse.OwnerId = tstUser.id;
        lcnse.state__c = 'CA';
        insert lcnse;
        List<sObject> ls = Test.loadData(CS004_TaskXmlGenerator__c.sObjectType, 'Test_CS004_TaskGenerationXMLData');
        List<sObject> ls1 = Test.loadData(CS005_SMCXMLGeneration__c.sObjectType, 'Test_CS005_GenerateXMLData');
        Task t = new Task();
        t.ActivityDate = System.Today()+1;
        t.Subject = 'Subject'+1;
        t.RecordTypeId = taskRecordTypeId;
        t.language__c='EN';
        t.communication_type__c ='Deadline Passed';
        t.email_address__c = 'Secondary Email';
        t.whoId = testLead.id;
        t.Source_External_ID__c = t.id;
        Test.startTest();
        insert t;
        delete t;
        Test.stopTest();
    }
}