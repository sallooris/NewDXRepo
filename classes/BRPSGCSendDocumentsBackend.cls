public with sharing class BRPSGCSendDocumentsBackend
{

    public void SendDocumentToSGC(String AppId, String FileName)
    {
        vlocity_ins__Application__c applObjRet = GetApplicationObject(AppId);
        
        System.debug('INTEGRATION TESTING******************************Application Status :'+ applObjRet.vlocity_ins__Status__c);
        System.debug('INTEGRATION TESTING******************************applObjRet  :'+ applObjRet );
        String applStat = applObjRet.SGC_Application_Status__c;
 //       if(applObjRet.vlocity_ins__Status__c == 'Application Signed, Pending Supporting Documents'){
 //         if(applStat.containsIgnoreCase('SUCCESS')) {            
            if(FileName.containsIgnoreCase('Application')){
                if(applObjRet.Employer_Application__c != 'Submitted'){
                 SendSignedDocumentToSGC(applObjRet);
                }
                if(applObjRet.Quote__c != 'Submitted') {
                    SendQuotePDFToSGC(applObjRet);
                }                       
             }
             else if(FileName.containsIgnoreCase('Payment')) {
                SendPaymentForm(applObjRet);
                }                       
             else if(FileName.containsIgnoreCase('Void') || FileName.containsIgnoreCase('Check')) {
                SendVoidedCheck(applObjRet);
                }  
             else if(FileName.containsIgnoreCase('HRA')) {
                SendHRAForm(applObjRet);
                }                               
    }
       public Boolean SendHRAForm(vlocity_ins__Application__c applObjRet){
        BRPSGCMakeRESTAPICallToSGC bRPSGCMakeRESTAPICallToSGC = new BRPSGCMakeRESTAPICallToSGC();
        BRPSGCUploadDocumentHolder brhld = GetDocumentHolder(applObjRet,'HRA');
        System.debug('INTEGRATION TESTING******************************MAKING REST API SendHRAForm ');
        if(brhld.fname != null){
            System.debug('INTEGRATION TESTING******************************SendHRAForm BEFORE CALL:'+ brhld );
            bRPSGCMakeRESTAPICallToSGC.UploadDocumentToSGC(brhld);
            } else{
                System.debug('INTEGRATION TESTING******************************FILE NOT FOUND' );
                }
        return true;
   } 
    public Boolean SendPaymentForm(vlocity_ins__Application__c applObjRet){
        BRPSGCMakeRESTAPICallToSGC bRPSGCMakeRESTAPICallToSGC = new BRPSGCMakeRESTAPICallToSGC();
        BRPSGCUploadDocumentHolder brhld = GetDocumentHolder(applObjRet,'EFT');
        System.debug('INTEGRATION TESTING******************************MAKING REST API SendPaymentForm');
        if(brhld.fname != null){
            System.debug('INTEGRATION TESTING******************************SendPaymentFormBEFORE CALL:'+ brhld );
            bRPSGCMakeRESTAPICallToSGC.UploadDocumentToSGC(brhld);
            } else{
                System.debug('INTEGRATION TESTING******************************FILE NOT FOUND' );
                }
        return true;
   }
     public Boolean SendVoidedCheck(vlocity_ins__Application__c applObjRet){
        BRPSGCMakeRESTAPICallToSGC bRPSGCMakeRESTAPICallToSGC = new BRPSGCMakeRESTAPICallToSGC();
        BRPSGCUploadDocumentHolder brhld = GetDocumentHolder(applObjRet,'VoidedCheck');
        System.debug('INTEGRATION TESTING******************************MAKING REST API SendPaymentForm - VoidedCheck');
        if(brhld.fname != null){
            System.debug('INTEGRATION TESTING******************************SendPaymentFormBEFORE CALL:'+ brhld );
            bRPSGCMakeRESTAPICallToSGC.UploadDocumentToSGC(brhld);
            } else{
                System.debug('INTEGRATION TESTING******************************FILE NOT FOUND' );
                }
        return true;
   }
     public Boolean SendSignedDocumentToSGC(vlocity_ins__Application__c applObjRet){
        BRPSGCMakeRESTAPICallToSGC bRPSGCMakeRESTAPICallToSGC = new BRPSGCMakeRESTAPICallToSGC();
        BRPSGCUploadDocumentHolder brhld = GetDocumentHolder(applObjRet,'EmployerApplication');
        System.debug('INTEGRATION TESTING******************************MAKING REST API SendSignedDocumentToSGC ');
        if(brhld.fname != null){
            System.debug('INTEGRATION TESTING******************************SendSignedDocumentToSGC BEFORE CALL:'+ brhld );
            bRPSGCMakeRESTAPICallToSGC.UploadDocumentToSGC(brhld);
            } else{
                System.debug('INTEGRATION TESTING******************************FILE NOT FOUND' );
                }
        return true;
   }
    public Boolean SendQuotePDFToSGC(vlocity_ins__Application__c applObjRet){
        BRPSGCMakeRESTAPICallToSGC bRPSGCMakeRESTAPICallToSGC = new BRPSGCMakeRESTAPICallToSGC();
        BRPSGCUploadDocumentHolder brhld = GetDocumentHolder(applObjRet,'Quote');
        System.debug('INTEGRATION TESTING******************************MAKING REST API: CALL:SendQuotePDFToSGC ');
        if(brhld.fname != null){
            System.debug('INTEGRATION TESTING******************************CALL:SendQuotePDFToSGC BEFORE CALL:'+ brhld );
            bRPSGCMakeRESTAPICallToSGC.UploadDocumentToSGC(brhld);
            } else{
                System.debug('INTEGRATION TESTING******************************FILE NOT FOUND' );
                }
        return true;
   }
 
        
   public BRPSGCUploadDocumentHolder GetDocumentHolder(vlocity_ins__Application__c applObj,String attachmentName)
    {         
        BRPSGCUploadDocumentHolder brhld = new BRPSGCUploadDocumentHolder();        
        String appIdForSGC = applObj.Id;
        appIdForSGC = appIdForSGC.substring(appIdForSGC.length()-9);        
        if((applObj.Application_Number__c+'').length() > 5)
        appIdForSGC = applObj.Application_Number__c+'ZZZ';
        brhld.AppIdForSGC = appIdForSGC;
        brhld.appId= applObj.Id;
        brhld.fstatus = 'PENDING';
        brhld.uploadType = 'Automated';
        brhld.fileSendStatus= 'NOT SENT';
        String ein = applObj.EIN__c;  
                if(ein == null) ein = applObj.Account_Employer_EIN__c;                        
        brhld.EIN = ein;
        brhld.grpName = applObj.Account_Name__c;
        brhld.state = applObj.Account_State__c;
      
        if(attachmentName == 'EmployerApplication'){
            List <Attachment> attList=   [Select Id, Body, BodyLength, ContentType,Description,Name,ParentId,OwnerId From Attachment where ParentId=:applObj.Id];
            System.debug('INTEGRATION TESTING******************************Attachment Found :'+attList);
            for(  Attachment att :  attList){     
                 System.debug('INTEGRATION TESTING******************************Attachment Name :'+att.Name);
                if(att.Name.containsIgnoreCase('Application')){
                    System.debug('INTEGRATION TESTING******************************STARTED ASSIGNING FILE FOR EMPLOYER APPLICATION');
                    brhld.fname = att.Name;
                    brhld.fileContent = att.Body;
                    brhld.attachId= att.Id;
                    brhld.documentType = 'SGAPP';
                    brhld.formType = 'NEWENRL';
                    brhld.fname = att.Name;
                   brhld.fcategory = 'EmployerApplication';
                    brhld.contentType = att.ContentType;
                    brhld.fileSize = att.BodyLength;
                    System.debug('Attachement  Body myFile:'+ att.Body);
                     delete att; 
                   }    
               }
              } else if(attachmentName == 'EFT'){
            List <Attachment> attList=   [Select Id, Body, BodyLength, ContentType,Description,Name,ParentId,OwnerId From Attachment where ParentId=:applObj.Id];
            System.debug('INTEGRATION TESTING******************************Attachment Found :'+attList);
            for(  Attachment att :  attList){     
                 System.debug('INTEGRATION TESTING******************************Attachment Name :'+att.Name);
                if(att.Name.containsIgnoreCase('Payment')){
                    System.debug('INTEGRATION TESTING******************************STARTED ASSIGNING FILE FOR EMPLOYER APPLICATION');
                    brhld.fname = att.Name;
                    brhld.fileContent = att.Body;
                    brhld.attachId= att.Id;
                    brhld.documentType = 'FPHI';
                    brhld.formType = 'INTPAY';
                    brhld.fname = att.Name;
                    brhld.fcategory = 'EFT';
                    brhld.contentType = att.ContentType;
                    brhld.fileSize = att.BodyLength;
                    System.debug('Attachement  Body myFile:'+ att.Body);
                    delete att;
                   }    
               }
              }
        else if(attachmentName == 'HRA'){
            List <Attachment> attList=   [Select Id, Body, BodyLength, ContentType,Description,Name,ParentId,OwnerId From Attachment where ParentId=:applObj.Id];
            System.debug('INTEGRATION TESTING******************************Attachment Found :'+attList);
            for(  Attachment att :  attList){     
                 System.debug('INTEGRATION TESTING******************************Attachment Name :'+att.Name);
                if(att.Name.containsIgnoreCase('HRA')){
                    System.debug('INTEGRATION TESTING******************************STARTED ASSIGNING FILE FOR EMPLOYER APPLICATION');
                    brhld.fname = att.Name;
                    brhld.fileContent = att.Body;
                    brhld.attachId= att.Id;
                    brhld.documentType = 'SGAPP';
                    brhld.formType = 'HRA';
                    brhld.fname = att.Name;
                    brhld.fcategory = 'HRA';
                    brhld.contentType = att.ContentType;
                    brhld.fileSize = att.BodyLength;
                    System.debug('Attachement  Body myFile:'+ att.Body);
                    delete att;
                   }    
               }
              }
         else if(attachmentName == 'VoidedCheck'){
            List <Attachment> attList=   [Select Id, Body, BodyLength, ContentType,Description,Name,ParentId,OwnerId From Attachment where ParentId=:applObj.Id];
            System.debug('INTEGRATION TESTING******************************Attachment Found :'+attList);
            for(  Attachment att :  attList){     
                 System.debug('INTEGRATION TESTING******************************Attachment Name :'+att.Name);
                if(att.Name.containsIgnoreCase('Check') || att.Name.containsIgnoreCase('Void')){
                    System.debug('INTEGRATION TESTING******************************STARTED ASSIGNING FILE FOR VOIDED CHECK');
                    brhld.fname = att.Name;
                    brhld.fileContent = att.Body;
                    brhld.attachId= att.Id;
                    brhld.documentType = 'FPHI';
                    brhld.formType = 'VOID';
                    brhld.fname = att.Name;
                    brhld.fcategory = 'VoidedCheck';
                    brhld.contentType = att.ContentType;
                    brhld.fileSize = att.BodyLength;
                    System.debug('Attachement  Body myFile:'+ att.Body);
                    delete att;
                   }    
               }
              }
        else if(attachmentName == 'Quote'){
                String quoteId = GetQuoteIdFromJSON(applObj.vlocity_ins__JSONData__c);
                System.debug('******************************Quote Id :'+ quoteId);
                BRPSendQuotePDFToSGC bRPSendQuotePDFToSGC = new BRPSendQuotePDFToSGC();
                boolean status = bRPSendQuotePDFToSGC.GenerateQuotePDF(quoteId);    
                 System.debug('INTEGRATION TESTING******************************Quote Attachment Created :'+status );

                if(status) 
                {        
                    String attaName = 'Quote For Enrollment - '+quoteId + '.pdf';     
                    List <Attachment> attList=   [Select Id, Body, BodyLength, ContentType,Description,Name,ParentId,OwnerId From Attachment where 
                        ParentId=:quoteId and Name = :attaName];
                    for(  Attachment att :  attList){     
                        System.debug('INTEGRATION TESTING******************************Attachment Name:'+att.Name);
                        if(att.Name.contains('Quote')){
                        System.debug('INTEGRATION TESTING******************************STARTED ASSIGNING FILE FOR QUOTE');
 
                            brhld.fname = att.Name;
                            brhld.fileContent = att.Body;
                            brhld.attachId= att.Id;
                            brhld.documentType = 'SGAPP';
                            brhld.formType = 'QUOTE';
                            brhld.fname = att.Name;
                            brhld.fcategory = 'Quote';
                            if(att.ContentType == null) brhld.contentType = 'application/pdf';
                            else brhld.contentType = att.ContentType;
                            brhld.fileSize = att.BodyLength;
                          }    
                       }
                 }
            }  
                
        return brhld;
        }
                    
    public vlocity_ins__Application__c GetApplicationObject(String applicationId)
    {
        vlocity_ins__Application__c applObj = [SELECT 
            Application_Number__c,
            Account_Name__c,
            Account_State__c,
            vlocity_ins__PrimaryPartyId__c,
            Account_Employer_EIN__c,
            vlocity_ins__JSONData__c, 
            Employer_Application__c,
            Quote__c,
            vlocity_ins__Status__c,
            vlocity_ins__Type__c, 
            SGC_Application_Status__c,
            Payment_Form__c,
            HRA__c,
            EIN__c, 
            Id,
            Name
            FROM vlocity_ins__Application__c  
        WHERE Id =:applicationId LIMIT 1];
    return applObj;
    }

  
   public String GetQuoteIdFromJSON(String jSON){
        String quoteId = jSON.substringBetween('"DRId_Quote":"','","');
        return quoteId;
   }
}