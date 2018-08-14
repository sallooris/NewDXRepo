public with sharing class BRPSGCUploadDocumentController 
{
    public List<BRPSGCUploadDocumentHolder> fileHolder{get;set;}
    public List<selectOption> optionList{get;set;}
    public vlocity_ins__Application__c appl{get;set;}
    public String   applicationId{get;set;}

    public BRPSGCUploadDocumentController(ApexPages.StandardController controller)
    {
        String errorInd= Apexpages.currentpage().getparameters().get('hasError');
        if(errorInd =='true'){
        String errormessage = Apexpages.currentpage().getparameters().get('errorMessage');
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,errormessage);
        ApexPages.addMessage(myMsg);
        }
        applicationId = Apexpages.currentPage().getParameters().get('ApplicationId');
        optionList = New List<selectOption>();
        optionList.add(New selectOption('',''));
        optionList.add(New selectOption('Submitted','Submitted'));
        optionList.add(New selectOption('Not Submitted','Not Submitted'));
        optionList.add(New selectOption('Resubmitted','Resubmitted')); 
        optionList.add(New selectOption('Received','Received'));
        optionList.add(New selectOption('Need Updated Document','Need Updated Document'));
        optionList.add(New selectOption('Items are Missing on Form','Items are Missing on Form'));
        fileHolder = new List<BRPSGCUploadDocumentHolder>();
        appl = [SELECT 
            Application_Number__c,
            EIN__c, 
            Account_Employer_EIN__c,
            Account_Name__c,
            Account_State__c,
            Paid_Agency_ETIN__c,
            Parent_Agency_ETIN__c,
            WritingAgentETIN__c,
            Census_Form__c,
            Employer_Application__c,
            Employee_App_PDF__c,
            Quote__c,
            Form_941__c,
            Form_NYS_45__c,
            HRA__c,
            Payroll_Document__c,
            SGC_Application_Status__c,
            SGC_Document_Status__c,
            Payment_Form__c,
            Quarterly_Tax_Filing__c,
            Voided_Check__c,
            vlocity_ins__Status__c,
            vlocity_ins__Type__c, 
            Id,
            Name,
            vlocity_ins__PrimaryPartyId__c,
            OwnerId FROM vlocity_ins__Application__c  
        WHERE Id =:applicationId LIMIT 1];
        constructFileHolderList(appl); 
     }    
    private void constructFileHolderList(vlocity_ins__Application__c appl)
    {
        if(appl != null)
        {   
            setFieldToHolder('Census Tool Spreadsheet', appl.Census_Form__c);
            setFieldToHolder('Employee App PDF', appl.Employee_App_PDF__c);
            setFieldToHolder('NYS 45', appl.Form_NYS_45__c);
            setFieldToHolder('Form 941', appl.Form_941__c);
            setFieldToHolder('Current Payroll', appl.Payroll_Document__c);
            setFieldToHolder('Quarterly Tax filing', appl.Quarterly_Tax_Filing__c);
            setFieldToHolder('Voided Check', appl.Voided_Check__c);
            setFieldToHolder('HRA', appl.HRA__c);
            setFieldToHolder('Payroll Forms', appl.Payroll_Document__c);
            setFieldToHolder('Payment Form', appl.Payment_Form__c);
            setFieldToHolder('Other/Waivers', '');
        }
    }    
    private void setFieldToHolder(String fcategory, String fstatus)
    {
        BRPSGCUploadDocumentHolder BRPSGCUploadDocumentHolder = new BRPSGCUploadDocumentHolder();
        BRPSGCUploadDocumentHolder.fcategory = fcategory;
        if(fstatus == null) 
        BRPSGCUploadDocumentHolder.fstatus = 'Not Submitted';
        else
        BRPSGCUploadDocumentHolder.fstatus = fstatus;
        if((fcategory == 'Employer Application' ||  fcategory == 'Census Tool Spreadsheet' ||  fcategory == 'NYS 45') && (fstatus == 'Not Submitted'))        
        BRPSGCUploadDocumentHolder.required = true;
        else 
        BRPSGCUploadDocumentHolder.required = false;        
        if((fcategory == 'Census Tool Spreadsheet' || fcategory == 'Employee App PDF') && (fstatus != 'Not Submitted'))  
        resetCensorEmpApp();    
        fileHolder.add(BRPSGCUploadDocumentHolder); 
    }
    private void resetCensorEmpApp(){
        for(BRPSGCUploadDocumentHolder brhld : fileHolder)
        {
            if(brhld.fcategory == 'Census Tool Spreadsheet' || brhld.fcategory == 'Employee App PDF') brhld.required = false;
        }
    }    
 /*   private boolean IsRequiredDocumentMissing() {
        boolean reqDoc = false;  
        boolean otherDocsMissing = false;  
        boolean censDoc = false;
        boolean empApp =  false;    
        for(BRPSGCUploadDocumentHolder brhld : fileHolder)
        {
            if( brhld.fcategory == 'NYS 45' && brhld.fstatus == 'Not Submitted' && brhld.fname == 'Not Submitted') otherDocsMissing = true;               
            if(brhld.fcategory == 'Census Tool Spreadsheet' && brhld.fstatus == 'Not Submitted' && brhld.fname == 'Not Submitted') censDoc = true;        
            if(brhld.fcategory == 'Employee App PDF' && brhld.fstatus == 'Not Submitted' && brhld.fname == null) empApp = true;
        } 
        if((censDoc || empApp) && otherDocsMissing)  
            reqDoc= true;       
        return reqDoc;       
    }*/
    private PageReference ReturnPageReference(String errorMsg){
        PageReference pageRef = new PageReference('/apex/BRPSGCUploadDocument?applicationId=' + applicationId);
        pageRef.setRedirect(true);
        if(errorMsg != null){
            pageRef.getParameters().put('hasError','true');
            pageRef.getParameters().put('errorMessage',errorMsg);
        }     
        return pageRef;
    }
    public PageReference SaveDoc() 
    {        
        String errMsg = null;  
        system.debug('App Status: '+appl.vlocity_ins__Status__c);
        String OauthId = BRPOauthForSGC.GetOauthToken();
        if(appl.vlocity_ins__Status__c != 'Enrollment Expired' && appl.vlocity_ins__Status__c != 'Enrollment Complete')
        {
            try{
                String docType = '';
                String formType = '';   
                String applStat = appl.SGC_Application_Status__c;
                system.debug('SGC App Status: '+applStat );
                 if (applStat == null) applStat ='NOT SENT';
                if(!applStat.containsIgnoreCase('SUCCESS')) {
 //                  update appl;
                     if (errMsg == null)
                        errMsg = System.Label.BRPDocUploadAppNotSentError;
                        else 
                            errMsg = errMsg +'</br>'+System.Label.BRPDocUploadAppNotSentError;
                } else{            
                boolean filesize = false;
                for(BRPSGCUploadDocumentHolder brhld : fileHolder)
                {      
                    system.debug('BRPSGCUploadDocumentHolder : '+brhld);
                    if(brhld.fileContent != null)
                    {
                         if(brhld.fileSize > 10485760){                         
                         if (!filesize) {
                             if (errMsg == null)
                                 errMsg = System.Label.BRPDocUploadFileSize + '</br>** Document Name: '+brhld.fcategory + ', File Name - '+brhld.fname; 
                                 else errMsg = errMsg + '</br> </br> '+ System.Label.BRPDocUploadFileSize + '</br>** Document Name: '+brhld.fcategory + ', File Name - '+brhld.fname; 
                             filesize = true;
                             } else errMsg =  errMsg + '</br>** Document Name: '+brhld.fcategory + ', File Name - '+brhld.fname; 
                             
                         continue;
                         }                       
                        JSONGenerator gen = JSON.createGenerator(true);
                        system.debug('preparing json start');
                        gen.writeStartObject();
                        gen.writeStringField('groupName', appl.Account_Name__c);
                        gen.writeStringField('state', appl.Account_State__c);
                        gen.writeStringField('lob', 'SG');          
                        gen.writeStringField('fileName', brhld.fname);
                        gen.writeStringField('fileType', brhld.contentType);
                        if (brhld.fcategory == 'Census Tool Spreadsheet'){
                            docType = 'SMAPP';
                            formType = 'MBRSPRDSHT';
                            if(!brhld.fname.containsIgnoreCase('XLS')) {
                                errMsg = System.Label.BRPDocUploadCensorXLSReq;
                                continue;
                            }
                                
                        }else if (brhld.fcategory == 'Employee App PDF'){
                            docType = 'SMAPP';
                            formType = 'MBRAPPPDF';
                        }else if (brhld.fcategory == 'Form 941'){
                            docType = 'SGAPP';
                            formType = 'FORM941';
                        }else if (brhld.fcategory == 'NYS 45') {
                            docType = 'SGAPP';
                            formType = 'NYS45';
                        }else if (brhld.fcategory == 'Current Payroll'){
                            docType = 'SGAPP';
                            formType = 'PAYROLL';
                        }else if (brhld.fcategory == 'HRA'){
                            docType = 'SGAPP';
                            formType = 'HRA';
                        }else if (brhld.fcategory == 'Quarterly Tax filing'){
                            docType = 'SGAPP';
                            formType = 'TAXDOCS';
                        }else if (brhld.fcategory == 'Payment Form'){
                            docType = 'FPHI';
                            formType = 'INTPAY';
                        }else if (brhld.fcategory == 'Payroll Forms'){
                            docType = 'FPHI';
                            formType = 'INTPAY';
                        }else if (brhld.fcategory == 'Voided Check'){
                            docType = 'FPHI';
                            formType = 'VOID';
                        }else if (brhld.fcategory == 'Other/Waivers'){
                            docType = 'SGAPP';
                            formType = 'MISC';
                        }     
                        brhld.formType  = formType ;                                                    
                        gen.writeStringField('docType', docType);
                        gen.writeStringField('formType', formType);
                        gen.writeStringField('fileSize', String.valueOf(brhld.fileSize));
                        gen.writeStringField('uploadType', 'Manual');
                        gen.writeStringField('userId', UserInfo.getUserName());
                        gen.writeStringField('fileData', EncodingUtil.base64Encode(brhld.fileContent));
                        gen.writeEndObject();
                        system.debug('preparing json end');
                        String jsonString = gen.getAsString();
                        system.debug('request json = '+jsonString);
                        gen = null;                        
                        MakeRESTAPICall(OauthId, brhld,jsonString);                       
                    }
                }
               updateStatusAfterCall();
              }
            }catch(Exception e){
                System.debug('Exception****'+e);
                errMsg = System.Label.BRPDocUploadSGCError;
            } 
        } else errMsg = System.Label.BRPDocUploadStatus;            
//        if(IsRequiredDocumentMissing())  if (errMsg == null)  errMsg  = System.Label.BRPDocUploadSGCReqDocument;
//        else errMsg  = errMsg + System.Label.BRPDocUploadSGCReqDocument;        
        return ReturnPageReference(errMsg);
    }
    

    public void MakeRESTAPICall(String OauthId, BRPSGCUploadDocumentHolder brhld, String jsonString){        
                    
        System.debug('INTEGRATION MakeRESTAPICall******************************PARAMS:reqMsg - '+ jsonString);
        System.debug('INTEGRATION MakeRESTAPICall ******************************PARAMS:appId - '+ appl.Id);
        System.debug('INTEGRATION MakeRESTAPICall******************************PARAMS:fcategory - '+ brhld.fcategory);
        System.debug('INTEGRATION MakeRESTAPICall******************************PARAMS:EIN - '+ appl.Account_Employer_EIN__c);
        System.debug('INTEGRATION MakeRESTAPICall******************************Application_Number__c- '+ appl.Application_Number__c);
        String appIdForSGC = appl.Id;
        
        appIdForSGC = appIdForSGC.substring(appIdForSGC.length()-9);        
        if((appl.Application_Number__c+'').length() > 5)
            appIdForSGC = appl.Application_Number__c+'ZZZ';
        String ein = appl.EIN__c;        
        if(ein == null)
               ein = appl.Account_Employer_EIN__c;                              
        HttpRequest req = BRPOauthForSGC.GetHttpReqForUploadDocument(OauthId, ein,  appIdForSGC); 
        req.setBody(jsonString);
        try{
            Http ht = new Http();
            HttpResponse response = ht.send(req);
            System.debug('INTEGRATION TESTING ******************************HTTP RESPONSE - '+ response.toString());
            boolean status = false;
            String statusMsg = null;
    
            if((response.getStatusCode() == 200)){           
                status = true;
                    statusMsg =  '\n'+DateTime.now()+':DOC UPLOAD - SUCCESS - DOCUMENT TYPE: '+ brhld.formType +', FILE NAME: '+ brhld.fname+', SGC Trans Id - '+(response.getBody()).substringBetween('"sgcTransId":"','"}}');
                } else  {
                    statusMsg=  '\n'+DateTime.now()+':DOC UPLOAD - FAILED - DOCUMENT TYPE: '+ brhld.formType +', FILE NAME: '+ brhld.fname+', EXCEPTION: Message - '+(response.getBody()).substringBetween('"message":"','","detail"')+', Details - '+(response.getBody()).substringBetween('","detail"','"}}');
                    }
            System.debug('INTEGRATION TESTING ******************************HTTP RESPONSE - '+ statusMsg);
            System.debug('INTEGRATION TESTING ******************************HTTP RESPONSE - '+ response.getBody());
            brhld.curStatus = status;
            brhld.errMsg = statusMsg;
            }catch(Exception e){
                System.debug('INTEGRATION TESTING EXCEPTION ******************************HTTP RESPONSE - '+ e);
            }                    
    }    
    
     public void updateStatusAfterCall(){
      vlocity_ins__Application__c   application = [SELECT 
           Census_Form__c,
            Employer_Application__c,
            Employee_App_PDF__c,
            Quote__c,
            Form_941__c,
            Form_NYS_45__c,
            HRA__c,
            Payroll_Document__c,
            SGC_Application_Status__c,
            SGC_Document_Status__c,
            Payment_Form__c,
            Quarterly_Tax_Filing__c,
            Voided_Check__c,
            Id
            FROM vlocity_ins__Application__c  
        WHERE Id =:applicationId LIMIT 1];       
               for(BRPSGCUploadDocumentHolder brhld : fileHolder)
                {
                    if(brhld.fileContent != null)
                    {
                    brhld.fileContent = null;
                    String status = ' ';
                    if(brhld.curStatus){
                        if(brhld.fstatus == 'Not Submitted') 
                            status = 'Submitted';
                                else status = 'Resubmitted';
                        if(brhld.fcategory == 'Census Tool Spreadsheet')
                        application.Census_Form__c = status ;
                            else if(brhld.fcategory == 'Employee App PDF')
                                application.Employee_App_PDF__c = status ;    
                                else if(brhld.fcategory == 'NYS 45')
                                    application.Form_NYS_45__c = status ;    
                                    else if(brhld.fcategory == 'Form 941')
                                        application.Form_941__c = status ;
                                        else if(brhld.fcategory == 'Current Payroll')
                                            application.Payroll_Document__c = status ;
                                            else if(brhld.fcategory == 'HRA')
                                                application.HRA__c = status ;
                                                 else if(brhld.fcategory == 'Quarterly Tax filing')
                                                    application.Quarterly_Tax_Filing__c = status ;
                                                    else if(brhld.fcategory == 'Payroll Forms')
                                                        application.Payroll_Document__c = status ;
                                                    else if(brhld.fcategory == 'Payment Form')
                                                        application.Payment_Form__c = status ;
                                                        else if(brhld.fcategory == 'Voided Check')
                                                            application .Voided_Check__c = status ;
                    } 
                    if(application.SGC_Document_Status__c != null)
                        application.SGC_Document_Status__c = application.SGC_Document_Status__c +brhld.errMsg;
                            else application.SGC_Document_Status__c = brhld.errMsg; 
            
                    
                }
           }
           update application;
    }
}