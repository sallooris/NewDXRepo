/**
* JIRA - SFOA-497: Start the Enrollment Process - Build a process to trigger the REST API Client when Application gets submitted
* BRPSGCListOfDocumentsAndStatus Class is used to get the list of documents needed for enrollment from SGC
* @Date: 7/15/2016
* @Author: Daryl Coutinho
* 
*/

public with sharing class BRPSGCListOfDocumentStatusFromSGC{

    
    public vlocity_ins__Application__c getDocListStatusFromSGC(String AppId)
    {
        System.debug('inside getDocStatus - app Id = '+AppId);
        String respMsg = '';
        //String json1 = '{\"documentListResponse\":{\"uploadedList\":[{\"fileName\":\"Test_kris_1.pdf\",\"fileType\":\"application/pdf\",\"docType\":\"SGAPP\",\"formType\":\"NEWENRL\",\"uploadType\":\"TestuploadType\",\"receiveDate\":\"2016-08-10 18:46:44\",\"docStatus\":\"received\"},{\"fileName\":\"Test_kris_2.pdf\",\"fileType\":\"application/pdf\",\"docType\":\"SGAPP\",\"formType\":\"HRA\",\"uploadType\":\"TestuploadType\",\"receiveDate\":\"2016-08-12 18:47:22\",\"docStatus\":\"received\"}],\"requiredList\":[[{\"docType\":\"SGAPP\",\"formType\":\"PAYROLL\",\"description\":\"EmployerApplication\"}],[{\"docType\":\"SGAPP\",\"formType\":\"QUOTE\",\"description\":\"Quote\"}],[{\"docType\":\"SGAPP\",\"formType\":\"NYS45\",\"description\":\"NYS45\"}],[{\"docType\":\"SMAPP\",\"formType\":\"MBRAPPPDF\",\"description\":\"EmployeeAppPDF\"},{\"docType\":\"SMAPP\",\"formType\":\"MBRSPRDSHT\",\"description\":\"CensusToolSpreadsheet\"}]],\"optionalList\":[{\"docType\":\"SMAPP\",\"formType\":\"PAYROLL\",\"description\":\"PayrollForms\"},{\"docType\":\"SGAPP\",\"formType\":\"FORM941\",\"description\":\"Form941\"},{\"docType\":\"SGAPP\",\"formType\":\"TAXDOCS\",\"description\":\"TaxDocs\"},{\"docType\":\"SGAPP\",\"formType\":\"HRA\",\"description\":\"HRA\"},{\"docType\":\"FPHI\",\"formType\":\"INTPAY\",\"description\":\"PaymentForm\"},{\"docType\":\"FPHI\",\"formType\":\"VOID\",\"description\":\"VoidedCheck\"},{\"docType\":\"MISC\",\"formType\":\"SGAPP\",\"description\":\"Other\"}]}}';
        String json1 = '{"documentListResponse":{"uploadedList":[{"fileName":"Test_kris_1.pdf","fileType":"application/pdf","docType":"SGAPP","formType":"NEWENRL","uploadType":"TestuploadType","receiveDate":"2016-08-12 18:46:44","docStatus":"ERROR"},{"fileName":"Test_kris_2.pdf","fileType":"application/pdf","docType":"SGAPP","formType":"NEWENRL","uploadType":"TestuploadType","receiveDate":"2016-08-15 18:47:22","docStatus":"ERROR"},{"fileName":"Test_kris_3.pdf","fileType":"application/pdf","docType":"SGAPP","formType":"NEWENRL","uploadType":"TestuploadType","receiveDate":"2016-08-10 18:46:44","docStatus":"received"},{"fileName":"Test_kris_4.pdf","fileType":"application/pdf","docType":"SGAPP","formType":"HRA","uploadType":"TestuploadType","receiveDate":"2016-07-12 18:47:22","docStatus":"received"},{"fileName":"Test_kris_5.pdf","fileType":"application/pdf","docType":"SGAPP","formType":"HRA","uploadType":"TestuploadType","receiveDate":"2016-07-13 18:46:44","docStatus":"ERROR"},{"fileName":"Test_kris_6.pdf","fileType":"application/pdf","docType":"SGAPP","formType":"HRA","uploadType":"TestuploadType","receiveDate":"2016-07-06 18:47:22","docStatus":"received"}],"requiredList":[[{"docType":"SGAPP","formType":"NEWENRL","description":"EmployerApplication"}],[{"docType":"SGAPP","formType":"QUOTE","description":"Quote"}],[{"docType":"SGAPP","formType":"NYS45","description":"NYS45"}],[{"docType":"SMAPP","formType":"MBRAPPPDF","description":"EmployeeAppPDF"},{"docType":"SMAPP","formType":"MBRSPRDSHT","description":"CensusToolSpreadsheet"}]],"optionalList":[{"docType":"SMAPP","formType":"PAYROLL","description":"PayrollForms"},{"docType":"SGAPP","formType":"FORM941","description":"Form941"},{"docType":"SGAPP","formType":"TAXDOCS","description":"TaxDocs"},{"docType":"SGAPP","formType":"HRA","description":"HRA"},{"docType":"FPHI","formType":"INTPAY","description":"PaymentForm"},{"docType":"FPHI","formType":"VOID","description":"VoidedCheck"},{"docType":"MISC","formType":"SGAPP","description":"Other"}]}}';      
        String errresp = '{"exceptions": {"exceptions": {"exception":[ {"type": "system", "code": "1001", "message": "invalid Acc Id", "detail": "Account not found"}]}} }';

        String sgcErrRespMsg = '';
        vlocity_ins__Application__c vloApp;
        BRPSGCMakeRESTAPICallToSGC bRPSGCMakeRESTAPICallToSGC = new BRPSGCMakeRESTAPICallToSGC();
        try
        {
            // retrieve application data
            vloApp = getApplicationObject(AppId);
            String ein = vloApp.Account_Employer_EIN__c;
            String appIdForSGC = AppId;
            appIdForSGC = appIdForSGC.substring(appIdForSGC.length()-9);        
            if((vloApp.Application_Number__c+'').length() > 5)
                appIdForSGC = vloApp.Application_Number__c+'ZZZ';  
            String OauthId = BRPOauthForSGC.GetOauthToken();            
            HttpRequest httpReq = BRPOauthForSGC.GetHttpReqForApplicationDocumentStatus(OauthId,ein, appIdForSGC);
            System.debug('INTEGRATION getDocStatus******************************PARAMS:HttpReqMsg - '+ httpReq );
            System.debug('INTEGRATION getDocStatus******************************PARAMS:appId - '+ vloApp.Id);
            System.debug('INTEGRATION getDocStatus******************************PARAMS:EIN - '+ vloApp.Account_Employer_EIN__c);
            System.debug('INTEGRATION getDocStatus******************************Application_Number__c- '+ vloApp.Application_Number__c);            
            Http ht = new Http();
            HttpResponse  response = ht.send(httpReq);
            system.debug('after send respcode- '+response.getStatusCode());
            system.debug('after send respbody- '+response.getBody());
            String isError;
            String statusMsg ='\n****************'+DateTime.now()+'RESULTS OF GET DOC STATUS FROM SGC*************';
            if(response.getStatusCode() == 200)
            {
                isError = (response.getBody()).substringBetween('{"type":"','","code"'); 
                if(isError != null && isError == 'E') 
                {
                    statusMsg=  '\n EXCEPTION IN GETTING APPLICATION STATUS: Message - '+(response.getBody()).substringBetween('"message":"','","detail"')+', Details - '+(response.getBody()).substringBetween('","detail":"','"}');
                } else{
                BRPSGCDocListRespContainer uplist = BRPSGCDocListRespContainer.parse(response.getBody());                
                String censusUpd = 'N';
                String empAppPDFUpd = 'N';
                String form941Upd = 'N';
                String nys45Upd = 'N';
                String payrollUpd = 'N';
                String hraUpd = 'N';
                String taxDocUpd = 'N';
                String payFormUpd = 'N';
                String voidChkUpd = 'N';
                String emplyrAppUpd = 'N';
                String errFileList = '';
                system.debug('un sorted list = '+uplist.documentListResponse.uploadedList);
                uplist.documentListResponse.uploadedList.sort();
                system.debug('sorted list = '+uplist.documentListResponse.uploadedList);
                for(BRPSGCDocListRespContainer.uploadedList ul : uplist.documentListResponse.uploadedList)
                {
                    System.debug(' BRPSGCDocumentListResponse - '+ul.fileName);
                    String docType = ul.docType;
                    String formtyp = ul.formType;
                    String docstat = ul.docStatus;
                    String fileName = ul.fileName;                    
                    statusMsg= statusMsg+ '\n DOC STATUS IN BACKEND**' + docType + ' : '+formtyp+ ' : '+fileName+ ' : STATUS - '+ docstat;
                    if (docstat == 'RECEIVED')
                    {
                            docstat = 'Received';
                        //  parse to get the doc type
                        if (docType == 'SMAPP' && formtyp == 'MBRSPRDSHT')
                        {
                            if (censusUpd == 'N')
                            {
                                vloApp.Census_Form__c = docstat;    //  Census Tool Spreadsheet
                                censusUpd = 'Y';
                            }
                        }
                        else if ((docType == 'SMAPP') && (formtyp == 'MBRAPPPDF'))
                        {
                            System.debug('found member app');
                            if (empAppPDFUpd == 'N')
                            {
                                vloApp.Employee_App_PDF__c = docstat;    // Employee App PDF
                                empAppPDFUpd = 'Y';
                            }
                        }
                        else if (docType == 'SGAPP' && formtyp == 'FORM941')
                        {
                            if (form941Upd == 'N')
                            {
                                vloApp.Form_941__c = docstat;   //  Form 941
                                form941Upd = 'Y';
                            }
                        }
                        else if (docType == 'SGAPP' && formtyp == 'NYS45')
                        {
                            if (nys45Upd == 'N')
                            {
                                vloApp.Form_NYS_45__c = docstat;    //  NYS 45
                                nys45Upd = 'Y';
                            }
                        }
                        else if (docType == 'SGAPP' && formtyp == 'PAYROLL')
                        {
                            if(payrollUpd == 'N')
                            {
                                vloApp.Payroll_Document__c = docstat;   //  Current Payroll
                                payrollUpd = 'Y';
                            }
                        }
                        else if (docType == 'SGAPP' && formtyp == 'HRA')
                        {
                            if (hraUpd == 'N')
                            {
                                vloApp.HRA__c = docstat;    //  HRA
                                hraUpd = 'Y';
                            }
                        }
                        else if (docType == 'SGAPP' && formtyp == 'TAXDOCS')
                        {
                            if (taxDocUpd == 'N')
                            {
                                vloApp.Quarterly_Tax_Filing__c = docstat;   //  Quarterly Tax filing
                                taxDocUpd = 'Y';
                            }
                        }
                        else if (docType == 'FPHI' && formtyp == 'INTPAY')
                        {
                            if (payFormUpd == 'N')
                            {   
                                vloApp.Payment_Form__c = docstat;   //  Payroll Forms
                                payFormUpd = 'Y';
                            }
                        }
                        else if (docType == 'FPHI' && formtyp == 'VOID')
                        {
                            if (voidChkUpd == 'N')
                            {
                                vloApp.Voided_Check__c = docstat;   //  Voided Check
                                voidChkUpd = 'Y';
                            }
                        }
                        else if (docType == 'SGAPP' && formtyp == 'NEWENRL')
                        {
                            if (emplyrAppUpd == 'N')
                            {
                                vloApp.Employer_Application__c = docstat;   //  Employer Application
                                emplyrAppUpd = 'Y';
                            }
                        }
                        //  parse to get the doc type
                    }
                }
                //  update the Application record
                
                system.debug('statusMsg= '+statusMsg);
                vloApp.SGC_Document_Status__c = vloApp.SGC_Document_Status__c + statusMsg;
                system.debug('After updating the Application'); 
                }
            } else
            {
                statusMsg=  '\n EXCEPTION IN GETTING DOCUMENT STATUS FROM BACKEND: Message - '+(response.getBody()).substringBetween('"message":"','","detail"')+', Details - '+(response.getBody()).substringBetween('","detail":"','"}');
                system.debug('sgcErrRespMsg = '+sgcErrRespMsg);
            }
            System.debug('INTEGRATION TESTING ******************************HTTP statusMsg- '+ statusMsg);
            System.debug('INTEGRATION TESTING  ******************************HTTP RESPONSE - '+ response.getBody());
            System.debug('INTEGRATION TESTING  ******************************SGC_Application_Status__c  - '+ vloApp.SGC_Document_Status__c);
            update vloApp;
 
        }
        catch(Exception e)
        {
            System.Debug('Error occured in Method:getDocListStatus: '+e.getMessage());
        }
         return vloApp;   
    } 
       public vlocity_ins__Application__c getApplicationObject (String appId){
            return [SELECT 
            Application_Number__c,
            Account_Employer_EIN__c,
            Census_Form__c,
            Employer_Application__c,
            Employee_App_PDF__c,
            Quote__c,
            Form_941__c,
            Form_NYS_45__c,
            HRA__c,
            Payroll_Document__c,
            Payment_Form__c,
            Quarterly_Tax_Filing__c,
            Voided_Check__c,
            SGC_Document_Status__c,
            Id,
            Name,
            OwnerId FROM vlocity_ins__Application__c  
            WHERE Id =:AppId LIMIT 1];
    }  
}