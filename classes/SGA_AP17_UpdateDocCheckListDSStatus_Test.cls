/**************************************************************************************
Class Name :   SGA_AP17_UpdateDocCheckListDSStatus_Test
Date Created : 23-June-2017
Created By   : IDC Offshore
Description  : 1. This class is the test class for SGA_AP17_UpdateDocCheckListDSStatus	  
Change History : 
***************************************************************************************/
@isTest
private class SGA_AP17_UpdateDocCheckListDSStatus_Test {
    /**************************************************************************************
Method Name  : SGA_AP17_UpdateDocCheckListDSStatus_Test
Date Created : 23-June-2017
Created By   : IDC Offshore
Description  : 1. This method is used test the docusign details are populating or not	  
Change History : 
***************************************************************************************/
    private testMethod static void updateDocumentCheckListOnDSCreation(){
        User testUser = Util02_TestData.createUser();
        System.runAs(testUser){
            //Custom setting data creation
            List<SGA_CS01_DocNameSubjectValue__c> docNameSubjValueList = Util02_TestData.createDocusignSubjectValues();
            Database.Insert(docNameSubjValueList);
            
            //creation of application document config object records
            List<Application_Document_Config__c> appDocConfigList = Util02_TestData.createDocumentConfigList();
            insert appDocConfigList;
            //Account record creation
            Account testAccount = Util02_TestData.createGroupAccountForRelatedList();
            //Application record creation
            vlocity_ins__Application__c testApplication = Util02_TestData.createApplicationForRelatedList(SG01_Constants.STATUSINENROLLMENTCOMPLETED, System.today() +5);
            //Business Custom Setting insertion
            List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
            //Record Type Assignment Custom Setting insertion
            List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.Insert(testAccount);
            Database.insert(testApplication);
            //creating document checklist records
            List<Application_Document_CheckList__c> docCheckList = new List<Application_Document_CheckList__c>();
            Application_Document_CheckList__c adc1 = new Application_Document_CheckList__c();
            adc1.Application__c = testApplication.Id;
            adc1.Document_Name__c = System.Label.SG25_Initial_Payment;
            adc1.Required__c = true;
            adc1.Status__c = System.Label.SG11_Not_Submitted;
            adc1.Application_Document_Config__c = appDocConfigList[3].Id;
            docCheckList.add(adc1);
            
            Application_Document_CheckList__c adc2 = new Application_Document_CheckList__c();
            adc2.Application__c = testApplication.Id;
            adc2.Document_Name__c = System.Label.SG32_Voided_Cheque;
            adc2.Required__c = true;
            adc2.Status__c = System.Label.SG11_Not_Submitted;
            adc2.Application_Document_Config__c = appDocConfigList[4].Id;
            docCheckList.add(adc2);
            
            Insert docCheckList;
            //creation of docusign records
            dsfs__DocuSign_Status__c docusignStatus = new dsfs__DocuSign_Status__c();
            docusignStatus.Application__c = testApplication.Id;
            docusignStatus.dsfs__Subject__c = System.Label.SG24_SG_Electronic_Debit_Form;
            docusignStatus.dsfs__Envelope_Status__c = System.Label.SG11_Not_Submitted;
            
            Insert docusignStatus;
            //creation of attachments for docusign records
            Attachment attach1 = new Attachment();
            attach1.Name = System.Label.SG26_Intial_Payment_Form_Name;
            attach1.Body = Blob.valueOf(System.Label.SG26_Intial_Payment_Form_Name);
            attach1.ParentId = docusignStatus.Id;
            Insert attach1;
             
            Attachment attach2 = new Attachment();
            attach2.Name = System.Label.SG32_Voided_Cheque;
            attach2.Body = Blob.valueOf(System.Label.SG32_Voided_Cheque);
            attach2.ParentId = docusignStatus.Id;
            Insert attach2;
            Test.startTest();
            docusignStatus.dsfs__Envelope_Status__c = System.Label.SG34_DocusignCompleted;
            update docusignStatus;
            Test.stopTest();
            System.assertEquals(System.Label.SG34_DocusignCompleted, docusignStatus.dsfs__Envelope_Status__c);
        }
    }
}