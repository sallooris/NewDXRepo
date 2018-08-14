@isTest
public with sharing class AccountBeforeUpdate_Test{

/*
Method Name : testAccountOwnerChange
Return type : void
Description : This method is used to check the user is able to change the ownership based on the enabled work
*/

private static testMethod void testAccountOwnerChange()
  { 
       List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
       insert cs001List; 
       List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
       insert cs002List;
       User testUser01=Util02_TestData.insertUser();
       Profile txtProfile02 = [SELECT Id FROM Profile WHERE Name ='Representative' Limit 1];
       testUser01.profileID=txtProfile02.id;
       testUser01.enabled_to_work__c='AP;NV;DF';
       Database.insert(testUser01);
       User testUser02=Util02_TestData.insertUser();
       testUser02.username = 'bhasakrb123@ggggg.com';
       testUser02.profileID=txtProfile02.id;
       testUser02.enabled_to_work__c='AP;NV;DF';
       Database.insert(testUser02); 
       Account testAcc = Util02_TestData.insertAccount();
       testAcc.date_of_birth__c=System.today();
       testAcc.customer_score__c ='1';
       testAcc.state__c='NV';
       testAcc.Billing_State__c='NV';
       testAcc.ownerid=testUser01.id;
       ID accRT =[select Id,Name from Recordtype where Name = 'Person Account' and SobjectType = 'Account'].Id;
       testAcc.recordtypeId = accRT ;
       Database.Insert(testAcc);   
          
       Test.startTest();
         //System.runas(testUser02){           
           AP12_RestrictOwnerChangeStateBase.accFirstRun = true;
           AP12_RestrictOwnerChangeStateBase restrictAccount = new AP12_RestrictOwnerChangeStateBase();                          
           //Account acc1= [SELECT ownerId,id,tech_businesstrack__c from Account where id=:testAcc.id limit 1];
           testAcc.ownerId = testUser02.id;
           Database.Update(testAcc);           
         //}
       Test.stopTest();
} 

/*
Method Name : testAccountCustomerScoreChange
Return type : void
Description : This method is used to check the the IF condition(same customer score & different zip code or DOB) in AccountBeforeUpdate Trigger
*/
public static testMethod void testAccountCustomerScoreChange()
  { 
  
       List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
       insert cs001List; 
       List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
       insert cs002List;
       User testUser01=Util02_TestData.insertUser();
       testUser01.enabled_to_work__c='AP;NF;DF';
       Database.Insert(testUser01);
          
       Test.startTest();
           System.runas (testUser01){
           
           Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
           Database.insert(pCode);
           Postal_Code_County__c pCode1 = Util02_TestData.insertZipCode();    
           pCode1.Name='500081';
           Database.insert(pCode1);
           Account testAcc = Util02_TestData.insertAccount();
           testAcc.Zip_Code__c=pCode.id;
           testAcc.date_of_birth__c=System.today();
           testAcc.customer_score__c ='1';
           testAcc.ownerid=testUser01.id;
           ID accRT =[select Id,Name from Recordtype where Name = 'Person Account' and SobjectType = 'Account'].Id;
           testAcc.recordtypeId = accRT ;
           Database.Insert(testAcc);
           Util01_RetrieveZipCodeScore.isFirstRunAccUpdate=true;
               
           Account acc1= [SELECT ownerId,id,tech_businesstrack__c,customer_score__c,date_of_birth__c,Zip_Code__c from Account where id=:testAcc.id limit 1];                
           //acc1.Zip_Code__c=pCode.id; 
           acc1.Zip_Code__c=pCode1.id; 
           //acc1.ownerid=testUser01.id;      
           Database.Update(acc1);
          }
        Test.stopTest();         
}

/*
Method Name : testAccountCustomerScoreChange
Return type : void
Description : This method is used to check the the ELSE IF condition(customer score not null & different) in AccountBeforeUpdate Trigger
*/

private static testMethod void testAccountCustomerScoreChange2()
  { 
       List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
       insert cs001List; 
       List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
       insert cs002List;
       User testUser01=Util02_TestData.insertUser();
       testUser01.enabled_to_work__c='AP;NF;DF';
       Database.Insert(testUser01);
          
       Test.startTest();
           System.runas (testUser01){
           
           Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
           Database.insert(pCode);
           Postal_Code_County__c pCode1 = Util02_TestData.insertZipCode();    
           pCode1.Name='500081';
           Database.insert(pCode1);
           Account testAcc = Util02_TestData.insertAccount();
           testAcc.Zip_Code__c=pCode.id;
           testAcc.date_of_birth__c=System.today();
           testAcc.customer_score__c ='1';
           testAcc.ownerid=testUser01.id;
           ID accRT =[select Id,Name from Recordtype where Name = 'Person Account' and SobjectType = 'Account'].Id;
           testAcc.recordtypeId = accRT ;
           Database.Insert(testAcc);
           Util01_RetrieveZipCodeScore.isFirstRunAccUpdate=true;
               
           Account acc1= [SELECT ownerId,id,tech_businesstrack__c,customer_score__c,date_of_birth__c,Zip_Code__c from Account where id=:testAcc.id limit 1];                
           //acc1.Zip_Code__c=pCode.id; 
           acc1.customer_score__c='2'; 
          //acc1.ownerid=testUser01.id;      
           Database.Update(acc1);
          }
        Test.stopTest();         

}
/*
Method Name : testAccountCustomerScoreChange
Return type : void
Description : This method is used to check the the ELSE IF condition(customer score null & different) in AccountBeforeUpdate Trigger
*/
private static testMethod void testAccountCustomerScoreChange3()
  { 
       List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
       insert cs001List; 
       List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
       insert cs002List;
       User testUser01=Util02_TestData.insertUser();
       testUser01.enabled_to_work__c='AP;NF;DF';
       Database.Insert(testUser01);
          
       Test.startTest();
           System.runas (testUser01){
           
           Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
           Database.insert(pCode);
           Postal_Code_County__c pCode1 = Util02_TestData.insertZipCode();    
           pCode1.Name='500081';
           Database.insert(pCode1);
           Account testAcc = Util02_TestData.insertAccount();
           testAcc.Zip_Code__c=pCode.id;
           testAcc.date_of_birth__c=System.today();
           testAcc.customer_score__c ='1';
           testAcc.ownerid=testUser01.id;
           ID accRT =[select Id,Name from Recordtype where Name = 'Person Account' and SobjectType = 'Account'].Id;
           testAcc.recordtypeId = accRT ;
           Database.Insert(testAcc);
           Util01_RetrieveZipCodeScore.isFirstRunAccUpdate=true;
               
           Account acc1= [SELECT ownerId,id,tech_businesstrack__c,customer_score__c,date_of_birth__c,Zip_Code__c from Account where id=:testAcc.id limit 1];                
           //acc1.Zip_Code__c=pCode.id; 
           acc1.customer_score__c=''; 
           //acc1.ownerid=testUser01.id;      
           Database.Update(acc1);
          }
        Test.stopTest(); 

}

private static testMethod void testAccountMarketingEvent()
  { 
       List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
       insert cs001List; 
       List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
       insert cs002List;
       User testUser01=Util02_TestData.insertUser();
       testUser01.enabled_to_work__c='AP;NF;DF';
       User testUser02=Util02_TestData.insertUser();
       Account testAcc = Util02_TestData.insertAccount();
       testAcc.customer_score__c ='1';
       testAcc.state__c='NV';
       ID accRT =[select Id,Name from Recordtype where Name = 'Person Account' and SobjectType = 'Account'].Id;
       testAcc.recordtypeId = accRT ;
       //testAcc.Tech_Businesstrack__c='TELESALES';
       testAcc.date_of_birth__c=System.today();
       Database.insert(testUser01);
       //testAcc.ownerId = testUser01.id;
       Database.insert(testAcc);
       testUser02.username = 'bhasakrb123@ggggg.com';
       Database.insert(testUser02);
       Test.startTest();
       try{
           testAcc.Marketing_Event__c='1003';
           
           Update testAcc;
       }catch(Exception e){
        
       }
       Test.stopTest();

  } 
}