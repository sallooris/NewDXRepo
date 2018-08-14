@isTest
global class BRPMockHttpResponseGenerator implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {

        HttpResponse res = new HttpResponse();
        if(req.getEndpoint().equals('http://createdocument')){        
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"uploadDocumentResponse":{"sgcTransId":"57d218015629e72c1395b826"}');
        res.setStatusCode(200);
        }
        else if(req.getEndpoint().equals('http://accesstoken')){        
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{  "token_type": "BearerToken",  "issued_at": "1473300402605",  "client_id": "iiNOHAYyGNPP2ysLg15Lflf9eoNmgsOj",  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkIyODZkaGtCRDFvcWQ0VFBYMTlzS015dlpXayIsImtpZCI6IkIyODZkaGtCRDFvcWQ0VFBYMTlzS015dlpXayJ9.eyJjbGllbnRfaWQiOiJlMGI5MDFjNTBjMGY0NGNjODcwNmFhZDVhOGEwY2YwNCIsInNjb3BlIjoicHVibGljIiwiaXNzIjoiaHR0cHM6Ly92YTEwbjUwODUwLnVzLmFkLndlbGxwb2ludC5jb20vc2VjdXJlYXV0aDMiLCJhdWQiOiJodHRwczovL3ZhMTBuNTA4NTAudXMuYWQud2VsbHBvaW50LmNvbS9zZWN1cmVhdXRoMyIsImV4cCI6MTQ3MzMwMTMwMiwibmJmIjoxNDczMzAwNDAwfQ.YeGhSygrj7fKVYjHTIaiHgsOCbG-d2Ej-X6INvVB-QhbDjiy_qdTlD2HX_w_YHvb_J9fwiwOj8mb1EDabDuXhfF5qykHSbGIk8OnVMxoZJPGug7tqRD_HKnNm13CUdGEY9SX-pR2eHqoBMOgxKizIfBhZACkZSu8uiGaSVoC6Aek1V8Gk4H0hUJM7SmRHiThMW2yhAIS71Y4mP6GSDYrgUJgu3HSuMX6DSzpupg8Uorh2qNza6FFVz7QBMgyXIuask0swcTvGc7vLqRMvtdTopldrJyQZRod395zOOh1ugtY-jhtm0F-U7InfI9bMJJCZ_7hDe9wNVc-82n_36HTuw",  "application_name": "salesforcebrokerportal_app",  "scope": "",  "expires_in": "899",  "status": "approved"}');
        res.setStatusCode(200);
        }
        else if(req.getEndpoint().equals('http://createApplication')){        
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"uploadDocumentResponse":{"sgcTransId":"57d218015629e72c1395b826"}');
        res.setStatusCode(200);
        }
        else if(req.getEndpoint().equals('http://docmenterror')){        
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"uploadDocumentResponse":{"sgcTransId":"57d218015629e72c1395b826"}');
        res.setStatusCode(400);
        }
        else if(req.getEndpoint().equals('http://applicatiomerror')){        
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"uploadDocumentResponse":{"sgcTransId":"57d218015629e72c1395b826"}');
        res.setStatusCode(400);
        }
        else if(req.getEndpoint().equals('http://applicationstatus')){        
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"documentStatusResponse":{"sgcDocStatus":"RECEIVED"}}');
        res.setStatusCode(200);
        }
         else if(req.getEndpoint().equals('http://appstatuserror200')){        
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"type":"E","code":"1003","message":"No documents have been uploaded for this EIN and App ID","detail":"No documents have been uploaded for this EIN and App ID "}');
        res.setStatusCode(200);
        }       
         else if(req.getEndpoint().equals('http://appstatuserror400')){        
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"type":"E","code":"1003","message":"No documents have been uploaded for this EIN and App ID","detail":"No documents have been uploaded for this EIN and App ID "}');
        res.setStatusCode(400);
        }       
          else if(req.getEndpoint().equals('http://getdocstatus')){        
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"documentListResponse":{"uploadedList":[{"fileName":"Census Form_sample  V3.5.xlsb","fileType":"application/vnd.ms-excel.sheet.binary.macroEnabled.12","docType":"SMAPP","formType":"MBRSPRDSHT","uploadType":"Manual","receiveDate":"2016-09-08 14:32:22","docStatus":"PROCESSING"},{"fileName":"Employee_App_SAMPLE.pdf","fileType":"application/pdf","docType":"SMAPP","formType":"MBRAPPPDF","uploadType":"Manual","receiveDate":"2016-09-08 14:38:09","docStatus":"RECEIVED"},{"fileName":"Employee_App_SAMPLE.pdf","fileType":"application/pdf","docType":"SGAPP","formType":"NYS45","uploadType":"Manual","receiveDate":"2016-09-08 14:39:34","docStatus":"RECEIVED"},{"fileName":"Tax_docs_SAMPLE.pdf","fileType":"application/pdf","docType":"SGAPP","formType":"FORM941","uploadType":"Manual","receiveDate":"2016-09-08 14:40:13","docStatus":"RECEIVED"},{"fileName":"Payment_Form_SAMPLE.pdf","fileType":"application/pdf","docType":"SGAPP","formType":"PAYROLL","uploadType":"Manual","receiveDate":"2016-09-08 14:40:59","docStatus":"RECEIVED"},{"fileName":"Payroll_SAMPLE.pdf","fileType":"application/pdf","docType":"SGAPP","formType":"PAYROLL","uploadType":"Manual","receiveDate":"2016-09-08 14:41:38","docStatus":"RECEIVED"},{"fileName":"Tax_docs_SAMPLE.pdf","fileType":"application/pdf","docType":"SGAPP","formType":"TAXDOCS","uploadType":"Manual","receiveDate":"2016-09-08 14:42:16","docStatus":"RECEIVED"},{"fileName":"Tax_docs_SAMPLE.pdf","fileType":"application/pdf","docType":"FPHI","formType":"VOID","uploadType":"Manual","receiveDate":"2016-09-08 14:43:10","docStatus":"RECEIVED"},{"fileName":"Employee_App_SAMPLE.pdf","fileType":"application/pdf","docType":"SGAPP","formType":"HRA","uploadType":"Manual","receiveDate":"2016-09-08 14:44:01","docStatus":"RECEIVED"},{"fileName":"Payroll_SAMPLE.pdf","fileType":"application/pdf","docType":"FPHI","formType":"INTPAY","uploadType":"Manual","receiveDate":"2016-09-08 14:44:28","docStatus":"RECEIVED"},{"fileName":"SF-184.doc","fileType":"application/msword","docType":"SGAPP","formType":"MISC","uploadType":"Manual","receiveDate":"2016-09-08 14:45:13","docStatus":"RECEIVED"},{"fileName":"table_export.xls","fileType":"application/vnd.ms-excel","docType":"SGAPP","formType":"MISC","uploadType":"Manual","receiveDate":"2016-09-12 18:55:04","docStatus":"RECEIVED"},{"fileName":"Quote For Enrollment - 0Q0550000005o7KCAQ.pdf","fileType":"application/pdf","docType":"SGAPP","formType":"QUOTE","uploadType":"Automated","receiveDate":"2016-09-12 19:03:00","docStatus":"RECEIVED"},{"fileName":"Employer Signed Application.pdf","fileType":"application/pdf","docType":"SGAPP","formType":"NEWENRL","uploadType":"Automated","receiveDate":"2016-09-12 19:03:01","docStatus":"UPLOADED"}],"requiredList":[[{"docType":"SGAPP","formType":"QUOTE","description":"Quote"}],[{"docType":"SGAPP","formType":"NYS45","description":"NY S45"}],[{"docType":"SMAPP","formType":"MBRAPPPDF","description":"Employee App PDF (Signed)"},{"docType":"SMAPP","formType":"MBRSPRDSHT","description":"Census Tool Spreadsheet"}],[{"docType":"SGAPP","formType":"NEWENRL","description":"Employer Application (Data)"}]],"optionalList":[{"docType":"SGAPP","formType":"PAYROLL","description":"Payroll Forms"},{"docType":"SGAPP","formType":"FORM941","description":"Form 941"},{"docType":"SGAPP","formType":"TAXDOCS","description":"Tax Docs"},{"docType":"FPHI","formType":"INTPAY","description":"Payment Form"},{"docType":"FPHI","formType":"VOID","description":"Voided Check"},{"docType":"SGAPP","formType":"MISC","description":"Other"}]}}');
        res.setStatusCode(200);
        }          
         else if(req.getEndpoint().equals('http://getdcstatusError')){        
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"type":"E","code":"1003","message":"No documents have been uploaded for this EIN and App ID","detail":"No documents have been uploaded for this EIN and App ID "}');
        res.setStatusCode(200);
        }        
         else if(req.getEndpoint().equals('http://getdstatusError400')){        
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"exceptions": {"exceptions": {"exception":[ {"type": "system", "code": "1001", "message": "invalid Acc Id", "detail": "Account not found"}]}} }');
        res.setStatusCode(400);
        }     
        return res;
    }
}