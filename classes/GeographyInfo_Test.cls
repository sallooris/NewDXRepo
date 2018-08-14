/****************************************************************************
Class Name  :  GeographyInfo_Test
Created By  :  Vlocity
Description : Test class for GeographyInfo
****************************************************************************/

@isTest
Private class GeographyInfo_Test{ 
   
    Private static testMethod void GeographyInfoTestMethod()
    { 
      User tstUser = Util02_TestData.insertUser();
        System.runAs(tstUser)
        {  
            
          Geographical_Info__c GInfo = new Geographical_Info__c(Name='EBC',Area__c='120',County__c='SCHENECTADY',RatingArea__c=1,Zip_Code__c='100',State__c='NY');
          insert GInfo ;
          GeographyInfo.getCounty('100');
         }
    } 
 }