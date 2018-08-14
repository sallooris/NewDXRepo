/**********************************************************************
Class Name  :     VFCE05_AccountViewEditOverride_Test
Date Created:
Created By  :     Santosh
Description :     Test Class for VFCE05_AccountViewEditOverride which restricts entry of multiple
Reference Class : VFCE05_AccountViewEditOverride_Test
Change History  :
**********************************************************************/
@isTest
/* Test Class : VFCE05_AccountViewEditOverride*/

private class VFCE05_AccountViewEditOverride_Test
{
/* Method Name : enableToWorkUser_Method01
   Param 1     : 
   Return Type : Void
   Description : Test method for class VFCE04_LeadViewEditOverride which restricts entry of 
                 multiple spouse/domestic partner for Person Account.
*/
   private static testMethod void enableToWorkUser_Method01()
   { 
      List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
     User tstUser = Util02_TestData.insertUser(); 
     Profile txtProfile02 = [SELECT Id FROM Profile WHERE Name ='Representative' Limit 1];
     tstUser.profileID=txtProfile02.id;
     Account acc =Util02_TestData.insertAccount();  
     tstUser.ENABLED_TO_WORK__c= 'OH';  
     Postal_Code_County__c pCode = Util02_TestData.insertZipCode();   
     Database.insert(tstUser);
     System.runAs(tstUser)      {
       Test.startTest();
          Database.insert(pCode); 
          acc.Mobile_Phone__c='12345678';
          acc.ownerId=tstUser.id;
          acc.RecordTypeId=[Select id from RecordType where sObjectType = 'Account' and Name like '%Person%' ].id;
          pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];      
          acc.zip_code__c = pCode.Id;
          Database.Insert(acc);
          Account accList=[Select id,state__c from Account where id=:acc.id Limit 1];
          accList.state__c='IN';
          try{
          Database.update(accList);
          }catch(Exception e){}
          Account acc1=[Select id,ownerId,state__c,tech_businesstrack__c from Account where id=:acc.id Limit 1];
          VFCE05_AccountViewEditOverride aa=new VFCE05_AccountViewEditOverride(new ApexPages.StandardController(acc1));
          aa.redirectView();
          aa.redirectEdit();         
      Test.stopTest();    
        
   }
  }
  
  private static testMethod void enableToWorkUser_Method02()
   {
      List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
     User tstUser02 = Util02_TestData.insertUser();
     Profile txtProfile02 = [SELECT Id FROM Profile WHERE Name='System Administrator' Limit 1];
     tstUser02.profileID=txtProfile02.id;
     tstUser02.userName='XYZ@12345678.com';
     Database.Insert(tstUser02);
     
     Account ldObj=Util02_TestData.insertAccount();  
           
      System.runAs(tstUser02){
       Test.startTest();
          ldObj.RecordTypeId=[Select id from RecordType where sObjectType = 'Account' and Name like '%Person%' ].id;
          Database.Insert(ldObj);
          Account acc1=[Select id,ownerId,state__c,tech_businesstrack__c from Account where id=:ldObj.id Limit 1];
          VFCE05_AccountViewEditOverride aa=new VFCE05_AccountViewEditOverride(new ApexPages.StandardController(acc1));
          aa.redirectView();
          aa.redirectEdit();           
      Test.stopTest();    
        
   }
   
   }
   private static testMethod void enableToWorkUser_Method03()
   { 
      List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
     User tstUser = Util02_TestData.insertUser(); 
     Profile txtProfile02 = [SELECT Id FROM Profile WHERE Name ='Representative' Limit 1];
     tstUser.profileID=txtProfile02.id;
     Account acc =Util02_TestData.insertAccount();  
     tstUser.ENABLED_TO_WORK__c= 'OH';
     Database.insert(tstUser);
     acc.Mobile_Phone__c='12345678';
          acc.ownerId=tstUser.id;
          acc.RecordTypeId=[Select id from RecordType where sObjectType = 'Account' and Name like '%Person%' ].id;
          Database.Insert(acc);
          Account acc1=[Select id,ownerId,state__c,tech_businesstrack__c from Account where id=:acc.id Limit 1];
          User tstUser05 = Util02_TestData.insertUser();
          Profile txtProfile05 = [SELECT Id FROM Profile WHERE Name ='Representative' Limit 1];
          tstUser05.userName='alok222@22233.com';
          tstUser05.profileID=txtProfile05.id;
          tstUser05.ENABLED_TO_WORK__c= 'NM';
          Database.Insert(tstUser05);
     System.runAs(tstUser05)      {
       Test.startTest();
          VFCE05_AccountViewEditOverride aa=new VFCE05_AccountViewEditOverride(new ApexPages.StandardController(acc1));
          aa.redirectView();   
          aa.redirectEdit();       
      Test.stopTest();    
        
   }
  }
  private static testMethod void enableToWorkUser_Method04()
   { 
     List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
     User tstUser = Util02_TestData.insertUser(); 
     Profile txtProfile02 = [SELECT Id FROM Profile WHERE Name ='Standard User' Limit 1];
     tstUser.profileID=txtProfile02.id;
     Account acc =Util02_TestData.insertAccount();  
     tstUser.ENABLED_TO_WORK__c= 'OH';
     Database.insert(tstUser);
     acc.Mobile_Phone__c='12345678';
          acc.ownerId=tstUser.id;
          acc.RecordTypeId=[Select id from RecordType where sObjectType = 'Account' and Name like '%Person%' ].id;
         // acc.Tech_BusinessTrack__c='BROKER';
          Database.Insert(acc);
          Account acc1=[Select id,ownerId,state__c,tech_businesstrack__c from Account where id=:acc.id Limit 1];
          User tstUser05 = Util02_TestData.insertUser();
          Profile txtProfile05 = [SELECT Id FROM Profile WHERE Name ='Representative' Limit 1];
          tstUser05.userName='alok222@22233.com';
          tstUser05.profileID=txtProfile05.id;
          tstUser05.ENABLED_TO_WORK__c= 'NM';
          Database.Insert(tstUser05);
     System.runAs(tstUser05)      {
       Test.startTest();
          VFCE05_AccountViewEditOverride aa=new VFCE05_AccountViewEditOverride(new ApexPages.StandardController(acc1));
          aa.redirectView();   
          aa.redirectEdit();       
      Test.stopTest();    
        
   }
  }
    private static testMethod void enableToWorkUser_Method05()
   { 
      List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
     User tstUser = Util02_TestData.insertUser(); 
     Profile txtProfile02 = [SELECT Id FROM Profile WHERE Name ='Representative' Limit 1];
     tstUser.profileID=txtProfile02.id;
     Account acc =Util02_TestData.insertAccount();
     tstUser.ENABLED_TO_WORK__c= 'OH';
     Database.insert(tstUser);
     acc.Mobile_Phone__c='12345678';
          acc.ownerId=tstUser.id;
          acc.RecordTypeId=[Select id from RecordType where sObjectType = 'Account' and Name like '%Person%' ].id;
          Database.Insert(acc);
          Account acc1=[Select id,ownerId,state__c,tech_businesstrack__c from Account where id=:acc.id Limit 1];
      User tstUser05 = Util02_TestData.insertUser();
            Profile txtProfile05 = [SELECT Id FROM Profile WHERE Name ='Representative' Limit 1];
              tstUser05.userName='alok222@22233.com';
              tstUser05.profileID=txtProfile05.id;
              tstUser05.ENABLED_TO_WORK__c= 'NM';
              Database.Insert(tstUser05);
     System.runAs(tstUser05)      {
       Test.startTest();
          VFCE05_AccountViewEditOverride aa=new VFCE05_AccountViewEditOverride(new ApexPages.StandardController(acc1));
          aa.redirectView();   
          aa.redirectEdit();       
      Test.stopTest();    
        
   }
  }
    private static testMethod void enableToWorkUser_Method06()
   { 
      List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
     User tstUser = Util02_TestData.insertUser(); 
     Profile txtProfile02 = [SELECT Id FROM Profile WHERE Name ='Representative' Limit 1];
     tstUser.profileID=txtProfile02.id;
     Account acc =Util02_TestData.insertAccount();
     tstUser.ENABLED_TO_WORK__c= 'OH';
     Postal_Code_County__c pCode = Util02_TestData.insertZipCode();   
     Database.insert(tstUser);
     Database.insert(pCode);
     acc.Mobile_Phone__c='12345678';
          acc.ownerId=tstUser.id;
          acc.RecordTypeId=[Select id from RecordType where sObjectType = 'Account' and Name like '%Person%' ].id;
          pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];      
          acc.zip_code__c = pCode.Id;
          acc.ownerId = tstUser.id;
          Database.Insert(acc);
          acc.state__c='CA';
          acc.Billing_State__c='CA';
          database.update(acc);
          Account acc1=[Select id,ownerId,state__c,tech_businesstrack__c from Account where id=:acc.id Limit 1];
          User tstUser05 = Util02_TestData.insertUser();
            Profile txtProfile05 = [SELECT Id FROM Profile WHERE Name ='Representative' Limit 1];
              tstUser05.userName='alok222@22233.com';
              tstUser05.profileID=txtProfile05.id;
              tstUser05.ENABLED_TO_WORK__c= 'CA';
              Database.Insert(tstUser05);
     System.runAs(tstUser05)      {
       Test.startTest();
          VFCE05_AccountViewEditOverride aa=new VFCE05_AccountViewEditOverride(new ApexPages.StandardController(acc1));
          aa.redirectView();   
          aa.redirectEdit();       
      Test.stopTest();    
        
   }
   }
   private static testMethod void enableToWorkUser_Method07()
   { 
      List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
     User tstUser = Util02_TestData.insertUser(); 
     Profile txtProfile02 = [SELECT Id FROM Profile WHERE Name ='Representative' Limit 1];
     tstUser.profileID=txtProfile02.id;
     Account acc =Util02_TestData.insertAccount();
     tstUser.ENABLED_TO_WORK__c= 'OH';
     Postal_Code_County__c pCode = Util02_TestData.insertZipCode();   
     Database.insert(tstUser);
     Database.insert(pCode);
     acc.Mobile_Phone__c='12345678';
          acc.ownerId=tstUser.id;
          acc.RecordTypeId=[Select id from RecordType where sObjectType = 'Account' and Name like '%Person%' ].id;
          pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];      
          acc.zip_code__c = pCode.Id;
          acc.ownerId = tstUser.id;
          Database.Insert(acc);
          acc.state__c='CA';
          acc.Billing_State__c='CA';
          database.update(acc);
          Account acc1=[Select id,ownerId,state__c,tech_businesstrack__c from Account where id=:acc.id Limit 1];
          User tstUser05 = Util02_TestData.insertUser();
            Profile txtProfile05 = [SELECT Id FROM Profile WHERE Name ='Representative' Limit 1];
              tstUser05.userName='alok222@22233.com';
              tstUser05.profileID=txtProfile05.id;
              tstUser05.ENABLED_TO_WORK__c= 'HH';
              Database.Insert(tstUser05);
     System.runAs(tstUser05)      {
       Test.startTest();
          VFCE05_AccountViewEditOverride aa=new VFCE05_AccountViewEditOverride(new ApexPages.StandardController(acc1));
          aa.redirectView();   
          aa.redirectEdit();       
      Test.stopTest();    
        
   }
   }
  private static testMethod void enableToWorkUser_Method08()
   { 
      List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
     User tstUser = Util02_TestData.insertUser(); 
     User tstUser1 = Util02_TestData.insertUser(); 
     Profile txtProfile02 = [SELECT Id FROM Profile WHERE Name ='Representative' Limit 1];
     tstUser.profileID=txtProfile02.id;
     Account acc =Util02_TestData.insertAccount();
     Postal_Code_County__c pCode = Util02_TestData.insertZipCode();   
     Database.insert(tstUser);
     tstUser1.username='testtttt@testorg1.com.antem';
     tstUser1.Enabled_to_Work__c='';
     Database.insert(tstUser1);
     Database.insert(pCode);
     acc.Mobile_Phone__c='12345678';
          acc.RecordTypeId=[Select id from RecordType where sObjectType = 'Account' and Name like '%Person%' ].id;
          pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];      
          acc.zip_code__c = pCode.Id;
          Database.Insert(acc);
          acc.state__c='CA';
          acc.Billing_State__c='CA';
          database.update(acc);
          Account acc1=[Select id,ownerId,state__c,tech_businesstrack__c from Account where id=:acc.id Limit 1];
      System.runas(tstUser1){    
       Test.startTest();
          VFCE05_AccountViewEditOverride aa=new VFCE05_AccountViewEditOverride(new ApexPages.StandardController(acc1));
          aa.redirectView();   
          aa.redirectEdit();       
      Test.stopTest();    
      }  
   }
   private static testMethod void enableToWorkUser_Method09()
   {
      List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List; 
     User tstUser02 = Util02_TestData.insertUser();
     Profile txtProfile02 = [SELECT Id FROM Profile WHERE Name='Representative' Limit 1];
     tstUser02.profileID=txtProfile02.id;
     tstUser02.userName='XYZ@12345678.com';
     
     Database.Insert(tstUser02);
             Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
             Account acc=Util02_TestData.insertAccount();  
             Database.insert(pCode);
             pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];      
             acc.zip_code__c = pCode.Id;
             acc.State__c='OH';
             acc.Billing_State__c='OH';
             acc.ownerId =tstUser02.id; 
             acc.RecordTypeId=[Select id from RecordType where sObjectType = 'Account' and Name like '%Person%' ].id;
             Database.Insert(acc);
             Account acc1=[Select id,ownerId,state__c,tech_businesstrack__c from Account where id=:acc.id Limit 1];
             User tstUser05 = Util02_TestData.insertUser();
             Profile txtProfile05 = [SELECT Id FROM Profile WHERE Name ='Representative' Limit 1];
             tstUser05.userName='alok222@22233.com';
             tstUser05.profileID=txtProfile05.id;
             tstUser05.ENABLED_TO_WORK__c= '';
             Database.Insert(tstUser05);
             System.runAs(tstUser05){   
               Test.startTest();
             VFCE05_AccountViewEditOverride ab04=new VFCE05_AccountViewEditOverride(new ApexPages.StandardController(acc1));
             ab04.redirectView();
             ab04.redirectEdit();           
           Test.stopTest();    
        
         }
   
   }
   private static testMethod void enableToWorkUser_Method10()
   {
      List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List; 
     User tstUser02 = Util02_TestData.insertUser();
     Profile txtProfile02 = [SELECT Id FROM Profile WHERE Name='Representative' Limit 1];
     tstUser02.profileID=txtProfile02.id;
     tstUser02.userName='XYZ@12345678.com';
     tstUser02.enabled_to_work__c = 'OH';
     Database.Insert(tstUser02);
             Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
             Account acc=Util02_TestData.insertAccount();  
             Database.insert(pCode);
             pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];      
             acc.zip_code__c = pCode.Id;
             acc.State__c='OH';
             acc.Billing_State__c='OH';
             acc.RecordTypeId=[Select id from RecordType where sObjectType = 'Account' and Name like '%Person%' ].id;
             acc.ownerId =tstUser02.id; 
             Database.Insert(acc);
             Account acc1=[Select id,ownerId,state__c,tech_businesstrack__c from Account where id=:acc.id Limit 1];
             User tstUser05 = Util02_TestData.insertUser();
             Profile txtProfile05 = [SELECT Id FROM Profile WHERE Name ='Representative' Limit 1];
             tstUser05.userName='alok2224@22233.com';
             tstUser05.profileID=txtProfile05.id;
             tstUser05.ENABLED_TO_WORK__c= 'OH';
             Database.Insert(tstUser05);
             System.runAs(tstUser05){   
               Test.startTest();
             VFCE05_AccountViewEditOverride ab04=new VFCE05_AccountViewEditOverride(new ApexPages.StandardController(acc1));
             ab04.redirectView();
             ab04.redirectEdit();           
           Test.stopTest();    
        
         }
   
   }
   private static testMethod void enableToWorkUser_Method11()
   {
      List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List; 
     User tstUser02 = Util02_TestData.insertUser();
     Profile txtProfile02 = [SELECT Id FROM Profile WHERE Name='Representative' Limit 1];
     tstUser02.profileID=txtProfile02.id;
     tstUser02.userName='XYZ@12345678.com';
     tstUser02.enabled_to_work__c = 'OH';
     Database.Insert(tstUser02);
             Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
             Account acc=Util02_TestData.insertAccount();  
             Database.insert(pCode);
             pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];      
             acc.zip_code__c = pCode.Id;
             acc.State__c='OH';
             acc.Billing_State__c='OH';
             acc.RecordTypeId=[Select id from RecordType where sObjectType = 'Account' and Name like '%Person%' ].id;
             acc.ownerId =tstUser02.id; 
             Database.Insert(acc);
             User tstUser05 = Util02_TestData.insertUser();
             Profile txtProfile05 = [SELECT Id FROM Profile WHERE Name ='Representative' Limit 1];
             tstUser05.userName='alok2224@22233.com';
             tstUser05.profileID=txtProfile05.id;
             tstUser05.ENABLED_TO_WORK__c= '';
             Database.Insert(tstUser05);
             System.runAs(tstUser05){   
             Test.startTest();
             VFCE05_AccountViewEditOverride ab04=new VFCE05_AccountViewEditOverride(new ApexPages.StandardController(acc));
             ab04.redirectView();
             ab04.redirectEdit();           
           Test.stopTest();    
        
         }
   
   }
}