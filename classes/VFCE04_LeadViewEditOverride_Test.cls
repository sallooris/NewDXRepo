/**********************************************************************
Class Name  :     VFCE04_LeadViewEditOverride_Test 
Date Created:
Created By  :     Santosh
Description :     Test Class for VFCE04_LeadViewEditOverride which restricts entry of multiple spouse/domestic 
                  partner for Person Account.
Reference Class : VFCE04_LeadViewEditOverride_Test
Change History  :
**********************************************************************/
/* Test Class : VFCE04_LeadViewEditOverride_Test*/
@isTest
private class VFCE04_LeadViewEditOverride_Test
{
/* Method Name : enableToWorkUser_Method01
   Param 1     : 
   Return Type : Void
   Description : Test method covers the business track and system admin profile functionality
*/
   private static testMethod void enableToWorkUser_Method01()
   { 
     List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
     List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
     insert cs002List;
     User tstUser = Util02_TestData.insertUser(); 
     Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
     Lead ldObj=Util02_TestData.insertLead(); 
     ID leadRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'LEAD'].Id;  
     tstUser.ENABLED_TO_WORK__c= 'OH';
     Database.insert(tstUser);
       Test.startTest();
          Database.insert(pCode); 
          insert cs001List;
          pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];      
          ldObj.zip_code__c = pCode.Id;
          ldObj.recordtypeId = leadRT ;
          ldObj.Mobile_Phone__c='12345678';
          Database.Insert(ldObj);
          Lead ld=[Select id,name,state__c,tech_businesstrack__c from Lead where id=:ldObj.id Limit 1];
      System.runAs(tstUser)      {
          VFCE04_LeadViewEditOverride aa=new VFCE04_LeadViewEditOverride(new ApexPages.StandardController(ld));
          aa.redirectView();
          aa.redirectEdit();
      Profile txtProfile02 = [SELECT Id FROM Profile WHERE Name ='Representative' Limit 1];
      User tstUser02 = Util02_TestData.insertUser();
      tstUser02.profileID=txtProfile02.id;
      tstUser02.userName='XYZ@12345678.com';
      Database.Insert(tstUser02);
      Lead ldObj02=Util02_TestData.insertLead();
      ldObj02.zip_code__c = pCode.Id;
      ldObj02.ownerID=tstUser02.id;
      ldObj02.recordtypeId = leadRT ;
      Database.Insert(ldObj02);
      aa.redirectView();
      aa.redirectEdit();             
      Test.stopTest();    
        
   }
  }
/* Method Name : enableToWorkUser_Method01
   Param 1     : 
   Return Type : Void
   Description : Test method covers the non system admin profile functionality
*/
   private static testMethod void enableToWorkUser_Method02()
   { 
     List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
     List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
      Database.Insert(cs001List);
      Database.insert(cs002List); 
      Profile txtProfile02 = [SELECT Id FROM Profile WHERE Name ='Representative' Limit 1];
      User tstUser02 = Util02_TestData.insertUser();
      tstUser02.profileID=txtProfile02.id;
      tstUser02.userName='XYZ@12345678.com';
       tstUser02.Enabled_to_work__c='OH';
      Database.Insert(tstUser02);
      Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
      pCode.Name='77777';
      Database.Insert(pCode);       
     System.runAs(tstUser02){   
         Test.startTest();
           Lead ldObj02=Util02_TestData.insertLead(); 
      ID leadRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'LEAD'].Id;
      ldObj02.firstName='AAAA';
      ldObj02.LastName='BBBB';
      ldObj02.TECH_BUSINESSTRACK__C='TELESALES';
      ldObj02.zip_code__c = pCode.Id;
      ldObj02.ownerID=tstUser02.id;
      ldObj02.recordtypeId = leadRT ;
      ldObj02.STATE__C='OH';   
      Database.Insert(ldObj02);
         Lead ld = [SELECT ID,OWNERID,STATE__C,TECH_BUSINESSTRACK__C FROM LEAD WHERE ID=:ldObj02.id limit 1];
          VFCE04_LeadViewEditOverride aa=new VFCE04_LeadViewEditOverride(new ApexPages.StandardController(ld));
              aa.redirectView();
              aa.redirectEdit();             
      Test.stopTest();    
        
     }
  }
private static testMethod void enableToWorkUser_Method03()
   { 
     List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
     List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
      Database.Insert(cs001List);
      Database.insert(cs002List); 
      Profile txtProfile02 = [SELECT Id FROM Profile WHERE Name ='Representative' Limit 1];
      User tstUser02 = Util02_TestData.insertUser();
      tstUser02.profileID=txtProfile02.id;
      tstUser02.userName='123XYZ@112.com';
      tstUser02.Enabled_to_work__c='OH';
      Database.Insert(tstUser02);
      User tstUser03 = Util02_TestData.insertUser();
      tstUser03.profileID=txtProfile02.id;
      tstUser03.userName='XYZ@12345678.com';
      tstUser03.Enabled_to_work__c='OH';
      Database.Insert(tstUser03); 
      Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
      pCode.Name='77777';
      Database.Insert(pCode);       
     System.runAs(tstUser02){   
       Test.startTest();
       Lead ldObj02=Util02_TestData.insertLead(); 
      ID leadRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'LEAD'].Id;
      ldObj02.firstName='AAAA';
      ldObj02.LastName='BBBB';
      ldObj02.TECH_BUSINESSTRACK__C='TELESALES';
      ldObj02.zip_code__c = pCode.Id;
      ldObj02.ownerID=tstUser03.id;
      ldObj02.recordtypeId = leadRT ;
      ldObj02.STATE__C='';   
      Database.Insert(ldObj02);
        // Lead ld = [SELECT ID,OWNERID,STATE__C,TECH_BUSINESSTRACK__C FROM LEAD WHERE ID=:ldObj02.id limit 1];
          VFCE04_LeadViewEditOverride aa=new VFCE04_LeadViewEditOverride(new ApexPages.StandardController(ldObj02));
              aa.redirectView();
              aa.redirectEdit();             
      Test.stopTest();    
        
     }
  }
private static testMethod void enableToWorkUser_Method04()
   { 
     List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
     List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
      Database.Insert(cs001List);
      Database.insert(cs002List); 
      Profile txtProfile02 = [SELECT Id FROM Profile WHERE Name ='Representative' Limit 1];
      User tstUser02 = Util02_TestData.insertUser();
      tstUser02.profileID=txtProfile02.id;
      tstUser02.userName='123XYZ@112.com';
      tstUser02.Enabled_to_work__c='OH';
      Database.Insert(tstUser02);
      User tstUser03 = Util02_TestData.insertUser();
      tstUser03.profileID=txtProfile02.id;
      tstUser03.userName='XYZ@12345678.com';
      tstUser03.Enabled_to_work__c='OH';
      Database.Insert(tstUser03); 
      Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
      pCode.Name='77777';
      Database.Insert(pCode);       
     System.runAs(tstUser02){   
       Test.startTest();
       Lead ldObj02=Util02_TestData.insertLead(); 
      ID leadRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'LEAD'].Id;
      ldObj02.firstName='AAAA';
      ldObj02.LastName='BBBB';
      ldObj02.TECH_BUSINESSTRACK__C='TELESALES';
      ldObj02.zip_code__c = pCode.Id;
      ldObj02.ownerID=tstUser03.id;
      ldObj02.recordtypeId = leadRT ;
      ldObj02.STATE__C='OH';   
      Database.Insert(ldObj02);
        // Lead ld = [SELECT ID,OWNERID,STATE__C,TECH_BUSINESSTRACK__C FROM LEAD WHERE ID=:ldObj02.id limit 1];
          VFCE04_LeadViewEditOverride aa=new VFCE04_LeadViewEditOverride(new ApexPages.StandardController(ldObj02));
              aa.redirectView();
              aa.redirectEdit();             
      Test.stopTest();    
        
     }
  }  
private static testMethod void enableToWorkUser_Method05()
   { 
     List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
     List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
      Database.Insert(cs001List);
      Database.insert(cs002List); 
      Profile txtProfile02 = [SELECT Id FROM Profile WHERE Name ='Representative' Limit 1];
      User tstUser02 = Util02_TestData.insertUser();
      tstUser02.profileID=txtProfile02.id;
      tstUser02.userName='123XYZ@112.com';
      tstUser02.Enabled_to_work__c='OH';
      Database.Insert(tstUser02);
      User tstUser03 = Util02_TestData.insertUser();
      tstUser03.profileID=txtProfile02.id;
      tstUser03.userName='XYZ@12345678.com';
      tstUser03.Enabled_to_work__c='OH';
      Database.Insert(tstUser03); 
      Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
      pCode.Name='77777';
      Database.Insert(pCode);       
     System.runAs(tstUser02){   
       Test.startTest();
       Lead ldObj02=Util02_TestData.insertLead(); 
      ID leadRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'LEAD'].Id;
      ldObj02.firstName='AAAA';
      ldObj02.LastName='BBBB';
      ldObj02.TECH_BUSINESSTRACK__C='TELESALES';
      ldObj02.zip_code__c = pCode.Id;
      ldObj02.ownerID=tstUser03.id;
      ldObj02.recordtypeId = leadRT ;
      ldObj02.STATE__C='NV';   
      Database.Insert(ldObj02);
        // Lead ld = [SELECT ID,OWNERID,STATE__C,TECH_BUSINESSTRACK__C FROM LEAD WHERE ID=:ldObj02.id limit 1];
          VFCE04_LeadViewEditOverride aa=new VFCE04_LeadViewEditOverride(new ApexPages.StandardController(ldObj02));
              aa.redirectView();
              aa.redirectEdit();             
      Test.stopTest();    
        
     }
  } 
private static testMethod void enableToWorkUser_Method06()
   { 
     List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
     List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
      Database.Insert(cs001List);
      Database.insert(cs002List); 
      Profile txtProfile02 = [SELECT Id FROM Profile WHERE Name ='Representative' Limit 1];
      User tstUser02 = Util02_TestData.insertUser();
      tstUser02.profileID=txtProfile02.id;
      tstUser02.userName='123XYZ@112.com';
      tstUser02.Enabled_to_work__c='';
      Database.Insert(tstUser02);
      User tstUser03 = Util02_TestData.insertUser();
      tstUser03.profileID=txtProfile02.id;
      tstUser03.userName='XYZ@12345678.com';
      tstUser03.Enabled_to_work__c='NV';
      Database.Insert(tstUser03); 
      Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
      pCode.Name='77777';
      Database.Insert(pCode);       
     System.runAs(tstUser02){   
       Test.startTest();
       Lead ldObj02=Util02_TestData.insertLead(); 
      ID leadRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'LEAD'].Id;
      ldObj02.firstName='AAAA';
      ldObj02.LastName='BBBB';
      ldObj02.TECH_BUSINESSTRACK__C='TELESALES';
      ldObj02.zip_code__c = pCode.Id;
      ldObj02.ownerID=tstUser03.id;
      ldObj02.recordtypeId = leadRT ;
      ldObj02.STATE__C='NV';   
      Database.Insert(ldObj02);
        // Lead ld = [SELECT ID,OWNERID,STATE__C,TECH_BUSINESSTRACK__C FROM LEAD WHERE ID=:ldObj02.id limit 1];
          VFCE04_LeadViewEditOverride aa=new VFCE04_LeadViewEditOverride(new ApexPages.StandardController(ldObj02));
              aa.redirectView();
              aa.redirectEdit();             
      Test.stopTest();    
        
     }
  }
private static testMethod void enableToWorkUser_Method07()
   {
     User tstUser03 = Util02_TestData.insertUser();
      Profile txtProfile03 = [SELECT Id FROM Profile WHERE Name ='System Administrator' Limit 1];
      tstUser03.userName='alok222@222.com';
      tstUser03.alias='isyst';
      tstUser03.profileID=txtProfile03.id;
      tstUser03.ENABLED_TO_WORK__c='';
      Database.Insert(tstUser03);
      User tstUser04 = Util02_TestData.insertUser();
      Profile txtProfile04 = [SELECT Id FROM Profile WHERE Name ='Business Administrator' Limit 1];
      tstUser04.userName='alok22233@22233.com';
      tstUser04.alias='isyst';
      tstUser04.profileID=txtProfile04.id;
      tstUser04.ENABLED_TO_WORK__c='';
      Database.Insert(tstUser04);
     Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
     List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data(); 
     List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
     pCode.name='888888';
     Database.insert(pCode); 
     insert cs001List; 
     insert cs002List;
     Group testGroup;  
     QueuesObject testQueue;  
     System.runAs(tstUser03){
           Test.startTest();   
              //pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];                  
             testGroup = new Group(Name='Test group', type='Queue');
             Database.insert(testGroup);                
             testQueue = new QueueSObject(QueueID =testGroup.id,SobjectType = 'Lead');
             Database.insert(testQueue);
             Test.stopTest();
     }
     System.runAs(tstUser04){   
             Lead ldObj=Util02_TestData.insertLead();  
             ID leadRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'LEAD'].Id;
             ldObj.recordtypeId = leadRT ;  
             ldObj.firstname = '987'; 
             ldObj.lastname = 'hello';     
             //ldObj.zip_code__c = pCode.Id;
             ldObj.TECH_BUSINESSTRACK__C='TELESALES';
             ldObj.status='Opportunity';
             ldObj.language__c='SP';
             ldObj.social_Security_number__c = '12345';
             ldObj.Mobile_Phone__c='12345678';
             ldObj.state__c='OH';
             ldObj.ownerID = testGroup.id ; 
             Database.insert(ldObj);
             VFCE04_LeadViewEditOverride ab=new VFCE04_LeadViewEditOverride(new ApexPages.StandardController(ldObj));
             ab.redirectView();
             ab.redirectEdit();  
         }
   
   } 
 private static testMethod void enableToWorkUser_Method08()
   {
     User tstUser03 = Util02_TestData.insertUser();
     Profile txtProfile03 = [SELECT Id FROM Profile WHERE Name ='System Administrator' Limit 1];
      tstUser03.userName='alok222@222.com';
      tstUser03.alias='isyst';
      tstUser03.profileID=txtProfile03.id;
      tstUser03.ENABLED_TO_WORK__c='OH';
      Database.Insert(tstUser03);
      User tstUser04 = Util02_TestData.insertUser();
      Profile txtProfile04 = [SELECT Id FROM Profile WHERE Name ='Business Administrator' Limit 1];
      tstUser04.userName='alok22233@22233.com';
      tstUser04.alias='isyst';
      tstUser04.profileID=txtProfile04.id;
      tstUser04.ENABLED_TO_WORK__c='OH';
      Database.Insert(tstUser04);
     Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
     List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data(); 
     List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
     pCode.name='888888';
     Database.insert(pCode); 
     insert cs001List; 
     insert cs002List;   
     Group testGroup ; 
     QueuesObject testQueue ;
     System.runAs(tstUser03){
           Test.startTest();   
              //pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];                  
             testGroup = new Group(Name='Test group', type='Queue');
             Database.insert(testGroup);                
             testQueue = new QueueSObject(QueueID =testGroup.id,SobjectType = 'Lead');
             Database.insert(testQueue);
             Test.stopTest();
     }
      System.runAs(tstUser04){  
             Lead ldObj=Util02_TestData.insertLead();  
             ID leadRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'LEAD'].Id;
             ldObj.recordtypeId = leadRT ;  
             ldObj.firstname = '987'; 
             ldObj.lastname = 'hello';     
             //ldObj.zip_code__c = pCode.Id;
             ldObj.TECH_BUSINESSTRACK__C='TELESALES';
             ldObj.status='Opportunity';
             ldObj.language__c='SP';
             ldObj.social_Security_number__c = '12345';
             ldObj.Mobile_Phone__c='12345678';
             ldObj.state__c='';
             ldObj.ownerID = testGroup.id ; 
             Database.insert(ldObj);
             VFCE04_LeadViewEditOverride ab=new VFCE04_LeadViewEditOverride(new ApexPages.StandardController(ldObj));
             ab.redirectView();
             ab.redirectEdit();   
         }
   
   } 
private static testMethod void enableToWorkUser_Method09()
   {
     User tstUser03 = Util02_TestData.insertUser();
     Profile txtProfile03 = [SELECT Id FROM Profile WHERE Name ='System Administrator' Limit 1];
      tstUser03.userName='alok222@222.com';
      tstUser03.alias='isyst';
      tstUser03.profileID=txtProfile03.id;
      tstUser03.ENABLED_TO_WORK__c='OH';
      Database.Insert(tstUser03);
      User tstUser04 = Util02_TestData.insertUser();
      Profile txtProfile04 = [SELECT Id FROM Profile WHERE Name ='Business Administrator' Limit 1];
      tstUser04.userName='alok22233@22233.com';
      tstUser04.alias='isyst';
      tstUser04.profileID=txtProfile04.id;
      tstUser04.ENABLED_TO_WORK__c='OH';
      Database.Insert(tstUser04);
     Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
     List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data(); 
     List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
     pCode.name='888888';
     Database.insert(pCode); 
     insert cs001List; 
     insert cs002List; 
     Group testGroup;  
     QueuesObject testQueue; 
     System.runAs(tstUser03){
           Test.startTest();   
              //pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];                  
             testGroup = new Group(Name='Test group', type='Queue');
             Database.insert(testGroup);                
             testQueue = new QueueSObject(QueueID =testGroup.id,SobjectType = 'Lead');
             Database.insert(testQueue);
             Test.stopTest();
     }
     System.runAs(tstUser04){
             Lead ldObj=Util02_TestData.insertLead();  
             ID leadRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'LEAD'].Id;
             ldObj.recordtypeId = leadRT ;  
             ldObj.firstname = '987'; 
             ldObj.lastname = 'hello';     
             //ldObj.zip_code__c = pCode.Id;
             ldObj.TECH_BUSINESSTRACK__C='TELESALES';
             ldObj.status='Opportunity';
             ldObj.language__c='SP';
             ldObj.social_Security_number__c = '12345';
             ldObj.Mobile_Phone__c='12345678';
             ldObj.state__c='OH';
             ldObj.ownerID = testGroup.id ; 
             Database.insert(ldObj);
             VFCE04_LeadViewEditOverride ab=new VFCE04_LeadViewEditOverride(new ApexPages.StandardController(ldObj));
             ab.redirectView();
             ab.redirectEdit(); 
         }
   
   }  
private static testMethod void enableToWorkUser_Method10()
   {
     User tstUser03 = Util02_TestData.insertUser();
     Profile txtProfile03 = [SELECT Id FROM Profile WHERE Name ='System Administrator' Limit 1];
      tstUser03.userName='alok222@222.com';
      tstUser03.alias='isyst';
      tstUser03.profileID=txtProfile03.id;
      tstUser03.ENABLED_TO_WORK__c='OH';
      Database.Insert(tstUser03);
      User tstUser04 = Util02_TestData.insertUser();
      Profile txtProfile04 = [SELECT Id FROM Profile WHERE Name ='Business Administrator' Limit 1];
      tstUser04.userName='alok22233@22233.com';
      tstUser04.alias='isyst';
      tstUser04.profileID=txtProfile04.id;
      tstUser04.ENABLED_TO_WORK__c='OH';
      Database.Insert(tstUser04);
     Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
     List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data(); 
     List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
     pCode.name='888888';
     Database.insert(pCode); 
     insert cs001List; 
     insert cs002List;  
     Group testGroup ;  
     QueuesObject testQueue ;
     System.runAs(tstUser03){
           Test.startTest();   
              //pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];                  
             testGroup = new Group(Name='Test group', type='Queue');
             Database.insert(testGroup);                
             testQueue = new QueueSObject(QueueID =testGroup.id,SobjectType = 'Lead');
             Database.insert(testQueue);
             Test.stopTest();
     }
     System.runAs(tstUser04){
             Lead ldObj=Util02_TestData.insertLead();  
             ID leadRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'LEAD'].Id;
             ldObj.recordtypeId = leadRT ;  
             ldObj.firstname = '987'; 
             ldObj.lastname = 'hello';     
             //ldObj.zip_code__c = pCode.Id;
             ldObj.TECH_BUSINESSTRACK__C='TELESALES';
             ldObj.status='Opportunity';
             ldObj.language__c='SP';
             ldObj.social_Security_number__c = '12345';
             ldObj.Mobile_Phone__c='12345678';
             ldObj.state__c='NV';
             ldObj.ownerID = testGroup.id ; 
             Database.insert(ldObj);
             VFCE04_LeadViewEditOverride ab=new VFCE04_LeadViewEditOverride(new ApexPages.StandardController(ldObj));
             ab.redirectView();
             ab.redirectEdit(); 
         }
   
   }  
private static testMethod void enableToWorkUser_Method11()
   {
     User tstUser03 = Util02_TestData.insertUser();
     Profile txtProfile03 = [SELECT Id FROM Profile WHERE Name ='System Administrator' Limit 1];
      tstUser03.userName='alok222@222.com';
      tstUser03.alias='isyst';
      tstUser03.profileID=txtProfile03.id;
      tstUser03.ENABLED_TO_WORK__c='OH';
      Database.Insert(tstUser03);
      User tstUser04 = Util02_TestData.insertUser();
      Profile txtProfile04 = [SELECT Id FROM Profile WHERE Name ='Business Administrator' Limit 1];
      tstUser04.userName='alok22233@22233.com';
      tstUser04.alias='isyst';
      tstUser04.profileID=txtProfile04.id;
      tstUser04.ENABLED_TO_WORK__c='OH';
      Database.Insert(tstUser04);
     Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
     List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data(); 
     List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
     pCode.name='888888';
     Database.insert(pCode); 
     insert cs001List; 
     insert cs002List;  
     Group testGroup;  
     QueuesObject testQueue ;
     System.runAs(tstUser03){
           Test.startTest();   
              //pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];                  
             testGroup = new Group(Name='Test group', type='Queue');
             Database.insert(testGroup);                
             testQueue = new QueueSObject(QueueID =testGroup.id,SobjectType = 'Lead');
             Database.insert(testQueue);
             Test.stopTest();
      }
      System.runAs(tstUser04){
             Lead ldObj=Util02_TestData.insertLead();  
             ID leadRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'LEAD'].Id;
             ldObj.recordtypeId = leadRT ;  
             ldObj.firstname = '987'; 
             ldObj.lastname = 'hello';     
             //ldObj.zip_code__c = pCode.Id;
             ldObj.TECH_BUSINESSTRACK__C='TELESALES';
             ldObj.status='Opportunity';
             ldObj.language__c='SP';
             ldObj.social_Security_number__c = '12345';
             ldObj.Mobile_Phone__c='12345678';
             ldObj.state__c='NV';
             ldObj.ownerID = testGroup.id ; 
             Database.insert(ldObj);
             VFCE04_LeadViewEditOverride ab=new VFCE04_LeadViewEditOverride(new ApexPages.StandardController(ldObj));
             ab.redirectView();
             ab.redirectEdit();    
         }
   
   }   
private static testMethod void enableToWorkUser_Method12()
   {
     User tstUser03 = Util02_TestData.insertUser();
     Profile txtProfile03 = [SELECT Id FROM Profile WHERE Name ='System Administrator' Limit 1];
      tstUser03.userName='alok222@222.com';
      tstUser03.alias='isyst';
      tstUser03.profileID=txtProfile03.id;
      tstUser03.ENABLED_TO_WORK__c='OH';
      Database.Insert(tstUser03);
      User tstUser04 = Util02_TestData.insertUser();
      Profile txtProfile04 = [SELECT Id FROM Profile WHERE Name ='Business Administrator' Limit 1];
      tstUser04.userName='alok22233@22233.com';
      tstUser04.alias='isyst';
      tstUser04.profileID=txtProfile04.id;
      tstUser04.ENABLED_TO_WORK__c='OH';
      Database.Insert(tstUser04);
     Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
     List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data(); 
     List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
     pCode.name='888888';
     Database.insert(pCode); 
     insert cs001List; 
     insert cs002List;  
     Group testGroup;  
     QueuesObject testQueue ;
     System.runAs(tstUser03){
           Test.startTest();   
              //pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];                  
             testGroup = new Group(Name='Test group', type='Queue');
             Database.insert(testGroup);                
             testQueue = new QueueSObject(QueueID =testGroup.id,SobjectType = 'Lead');
             Database.insert(testQueue);
             Test.stopTest();
      }
      System.runAs(tstUser04){
             Lead ldObj=Util02_TestData.insertLead();  
             ID leadRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'LEAD'].Id;
             ldObj.recordtypeId = leadRT ;  
             ldObj.firstname = '987'; 
             ldObj.lastname = 'hello';     
             //ldObj.zip_code__c = pCode.Id;
             ldObj.TECH_BUSINESSTRACK__C='TS';
             ldObj.status='Opportunity';
             ldObj.language__c='SP';
             ldObj.social_Security_number__c = '12345';
             ldObj.Mobile_Phone__c='12345678';
             ldObj.state__c='NV';
             ldObj.ownerID = testGroup.id ; 
             Database.insert(ldObj);
             VFCE04_LeadViewEditOverride ab=new VFCE04_LeadViewEditOverride(new ApexPages.StandardController(ldObj));
             ab.redirectView();
             ab.redirectEdit();    
         }
   
   }              
 }