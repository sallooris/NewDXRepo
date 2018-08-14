@isTest
/**********************************************************************************
Class Name :   SGA_AP51_UpdateRatingArea_Test
Date Created : 09/26/2017 (mm/dd/yyyy)
Created By   : IDC Offshore
Description  : 1. This class is the test class for SGA_AP51_UpdateRatingArea
*************************************************************************************/
private class SGA_AP51_UpdateRatingArea_Test {
    /************************************************************************************
Method Name : getRatingAreaTest
Parameters  : None
Return type : void
Description : This is positive testmethod for getRatingArea Method
*************************************************************************************/
    private static testMethod void getRatingAreaTest() {   
        User testUser = Util02_TestData.createUser();
        Account testAcc = Util02_TestData.createGroupAccount();
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        Geographical_Info__c geo =Util02_TestData.createGeoRecord();
        System.runAs(testUser){
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.insert(geo);
            testAcc.Company_Zip__c ='12766';
            testAcc.Company_State__c ='NY';
            Database.insert(testAcc);
            Account acc = new Account();
            Test.startTest();
            // check created account with rating area populated
            acc= [Select Id,Rating_Area__c from Account Where Id =: testAcc.Id limit 1];
            Test.stopTest();   
            System.assertEquals('3', acc.Rating_Area__c);
        }
        
    }
    /************************************************************************************
Method Name : getRatingAreaNegTest
Parameters  : None
Return type : void
Description : This is Negative testmethod for getRatingArea Method
*************************************************************************************/
    private static testMethod void getRatingAreaNegTest() {   
        User testUser = Util02_TestData.createUser();
        Account testAcc = Util02_TestData.createGroupAccount();
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        Geographical_Info__c geo =Util02_TestData.createGeoRecord();
        geo.RatingArea__c =3;
        System.runAs(testUser){
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.insert(geo);
            testAcc.Company_Zip__c ='12766';
            testAcc.Company_State__c ='NY';
            Database.insert(testAcc);
            Account acc = new Account();
            Test.startTest();
            // check created account with rating area populated
            acc= [Select Id,Rating_Area__c from Account Where Id =: testAcc.Id limit 1];
            Test.stopTest();   
            System.assertNotEquals('1', acc.Rating_Area__c);
        }
    }
/************************************************************************************
Method Name : getRatingAreaCountyTest
Parameters  : None
Return type : void
Description : This is Positive testmethod for getRatingAreaCountyTest Method
*************************************************************************************/
   private static testMethod void getRatingAreaCountyTest() {   
        User testUser = Util02_TestData.createUser();
        Account testAcc = Util02_TestData.createGroupAccount();
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        Geographical_Info__c geo =Util02_TestData.createGeoRecord();
        System.runAs(testUser){
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.insert(geo);
            testAcc.Company_Zip__c ='12766';
            testAcc.Company_State__c ='NY';
            testAcc.County__c='COLUMBIA';
            Database.insert(testAcc);
            Account acc = new Account();
            Test.startTest();
            // check created account with rating area populated
            acc= [Select Id,Rating_Area__c from Account Where Id =: testAcc.Id limit 1];
            Test.stopTest();   
            System.assertEquals('3', acc.Rating_Area__c);
        }
    }
    
    /************************************************************************************
Method Name : getRatingAreaBulk
Parameters  : None
Return type : void
Description : This is Bulk testmethod for getRatingArea Method
*************************************************************************************/
    private static testMethod void getRatingAreaBulk() {   
        User testUser = Util02_TestData.createUser();
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        Geographical_Info__c geo =Util02_TestData.createGeoRecord();
        List<Account> accList= new List<Account>();
        System.runAs(testUser){
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.insert(geo);
            for(integer i=0;i<200;i++){
                Account testAcc = Util02_TestData.createGroupAccount();
                testAcc.Name='test'+i;
                testAcc.Company_Zip__c ='12766';
                testAcc.Company_State__c ='NY';
                accList.add(testAcc);
            }
            Database.insert(accList);
            List<Account> accListInserted = new   List<Account>();
            Test.startTest();
            // check created account with rating area populated
            accListInserted = [Select Id,Rating_Area__c from Account Where Company_Zip__c =: '12766'];
            Test.stopTest();   
            System.assertEquals('3', accListInserted[0].Rating_Area__c);
        }
    }
}