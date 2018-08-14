/**********************************************************************************
Class Name :   SGA_AP06_FileUploadController
Date Created : 29-March-2017
Created By   : IDC Offshore
Description  : 1. This class is used in SGA_VF04_FileUpload page
2. This class is used to fetch the documents list and upload files in content version Object.
Change History : 
*************************************************************************************/
public without sharing class SGA_AP06_FileUploadController {
    public Static Final String B_CONSTANT = 'B';
    public Static Final String SHARE_V_CONSTANT = 'V';
    private static Final String VISIBILITY_ALL_CONSTANT = 'AllUsers';
    public Static Final String MISSINGINFO_CONSTANT = 'Missing Information';
    public vlocity_ins__Application__c applicationObj{get;set;}
    public List<WrapFileUploadHolder> wrapFileUploadHolderList{get;set;}
    public Boolean saveBtndisable{get;set;}
    public String confirmMessage{get;set;}
    public List<String> docCheckIdsList{get;set;}
    private set<Id> fileIdSet{get;set;}
    public String applicationId {get;set;}
    public Static Final String APPLICATIONID_CONSTANT = 'ApplicationId';
    public Static Final String METHOD_LOADAPP = 'loadApplicationandDocuments';
    /****************************************************************************************************
    Method Name : SGA_AP06_FileUploadController
    Description : This constructor is used to retrieve application record based on the Id.
    ******************************************************************************************************/
    public SGA_AP06_FileUploadController(ApexPages.StandardController controller){
        applicationId = SG01_Constants.BLANK;
        try{
            applicationId = Apexpages.currentPage().getParameters().get(APPLICATIONID_CONSTANT);
        }catch(Exception ex){
            UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_AP06_FILEUPLOAD, SG01_Constants.CLS_SGA_AP06_FILEUPLOAD, SG01_Constants.BLANK, Logginglevel.ERROR);
        }
    }
    /****************************************************************************************************
    Method Name : SGA_AP06_FileUploadController
    Description : This constructor is used to retrieve application record based on the Id.
    ******************************************************************************************************/
    public void loadApplicationandDocuments(){
        confirmMessage = null;
        saveBtndisable = false;
        try{
            applicationObj = new vlocity_ins__Application__c();
            if(String.isNotBlank(applicationId)){
                String whereClause = SG01_Constants.SPACE+SG01_Constants.WHERE_CLAUSE+SG01_Constants.ID
                    +SG01_Constants.EQUALS_SLASH+String.escapeSingleQuotes(applicationId)+SG01_Constants.BACK_SLASH;
                Map<ID,vlocity_ins__Application__c> applicationMap = SGA_Util03_ApplicationDataAccessHelper.fetchApplicationMap(SG01_Constants.SGA_AP06_APPLICATIONOBJQUERY, whereClause, SG01_Constants.BLANK, SG01_Constants.LIMIT_1);  
                if(!applicationMap.isEmpty()){
                    applicationObj = applicationMap.get(applicationId);
                }
                documentsNeedtoUpload(Label.SG09_Confirm_Msg1);
                saveBtndisable = disableSaveBtn(applicationObj.vlocity_ins__Status__c);
            }
        }catch(Exception ex){
            UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_AP06_FILEUPLOAD, METHOD_LOADAPP, SG01_Constants.BLANK, Logginglevel.ERROR);
        }
    }
    
    /****************************************************************************************************
    Method Name : disableSaveBtn
    Parameters  : String
    Return type : Boolean
    Description : This method is used to disable the upload documents button.
    ******************************************************************************************************/
    private Boolean disableSaveBtn(String status){
        Boolean btnDisableFlag = false;
        if(Label.SG06_Enrollment_Complete.equals(status) || Label.SG08_Enrollment_Expired.equals(status) || Label.SG07_Enrollment_Denied.equals(status))
        {
            btnDisableFlag = true;
        }else{
            btnDisableFlag = false;
        }
        return btnDisableFlag;
    }
    
    /****************************************************************************************************
    Method Name : documentsNeedtoUpload
    Parameters  : String
    Return type : List<WrapFileUploadHolder>
    Description : This method is used to retrieve the list documents need to upload.
    ******************************************************************************************************/
    public void documentsNeedtoUpload(String confirmMsg)
    {
        Integer requiredDocCount = 0;
        Integer uploadedReqCount = 0;
        try{
            docCheckIdsList = new List<String>();
            wrapFileUploadHolderList = new List<WrapFileUploadHolder>();
            Map<ID,Application_Document_Checklist__c> documentMap = new Map<ID,Application_Document_Checklist__c>();
            String whereClause = SG01_Constants.SPACE+SG01_Constants.WHERE_CLAUSE+SG01_Constants.APPLICATIONID
                +SG01_Constants.EQUALS_SLASH+String.escapeSingleQuotes(applicationId)+SG01_Constants.BACK_SLASH;
            documentMap = SGA_Util04_DCDataAccessHelper.fetchDocumentChecklistMap(SG01_Constants.SGA_AP06_DCCHECKLISTQUERY, whereClause, SG01_Constants.BLANK, SG01_Constants.LIMIT_100);  
            if(!documentMap.isEmpty()){
                Application_Document_Checklist__c dcObj = null;
                for(String key : documentMap.keySet()){
                    docCheckIdsList.add(key);
                    dcObj = new Application_Document_Checklist__c();
                    dcObj = documentMap.get(key);
                    if(dcObj.Required__c){ requiredDocCount = requiredDocCount + 1; }
                    if(dcObj.Required__c && dcObj.File_Name__c != null){ uploadedReqCount = uploadedReqCount+1; }
                    wrapFileUploadHolderList.add(new WrapFileUploadHolder(dcObj));
                }
                confirmMessage = requiredDocCount == uploadedReqCount?confirmMsg : null;
            }
        }catch(Exception ex){ UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_AP06_FILEUPLOAD, SG01_Constants.SGA_AP06_DOCUMENTNEEDTOUPLOAD, SG01_Constants.BLANK, Logginglevel.ERROR); }
    }
    
    /****************************************************************************************************
    Method Name : saveFiles
    Parameters  : None
    Return type : PageReference
    Description : This method is used to update document checklist records and upload files into content
    version object and insert records in contentdocumentLink object.
    ******************************************************************************************************/
    public PageReference saveFiles(){
        List<ContentVersion> filesList = null;
        Map<String, String> documentLinkIdMap = null;
        Set<Id> fileIds = new Set<Id>();
        List<ContentVersion> updateCVList = new List<ContentVersion>();
        try{
            documentLinkIdMap = new Map<String, String>();
            filesList = new List<ContentVersion>();
            if(!wrapFileUploadHolderList.isEmpty()){
                documentLinkIdMap = retrieveExistingDocs(docCheckIdsList);
                filesList = prepareContentVersionList(wrapFileUploadHolderList);
                List<ContentVersion> contentVersionList = new List<ContentVersion>();
                if(!filesList.isEmpty()){ 
                    contentVersionList = SGA_Util05_FilesDataAccessHelper.dmlContentVersionlist(filesList, SG01_Constants.INSERT_OPERATION);
                }
                if(!contentVersionList.isEmpty()){
                    for(ContentVersion cv : contentVersionList){
                        fileIds.add(cv.Id); 
                    } 
                }
                updateCVList = [SELECT Id, title, ContentDocumentId FROM ContentVersion WHERE Id IN : fileIds LIMIT 100];
                List<Application_Document_Checklist__c> docCheckList = prepareDocumentCheckList(updateCVList, wrapFileUploadHolderList);
                if(!docCheckList.isEmpty()){
                    List<Application_Document_Checklist__c> documentCheckList = SGA_Util04_DCDataAccessHelper.dmlDocChecklist(docCheckList, SG01_Constants.UPDATE_OPERATION);  
                    //Insert ContentDocumentLink to map uploaded files to Records
                    insertContentDocumentLink(documentCheckList, documentLinkIdMap);
                }
                documentsNeedtoUpload(Label.SG10_Confirm_Msg2);
            } // End - wrapFileUploadHolderList if condition
        }catch(Exception ex){
            UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_AP06_FILEUPLOAD, SG01_Constants.SGA_AP06_SAVEFILES, SG01_Constants.BLANK, Logginglevel.ERROR);
        }
        return null;
    }
    
    /****************************************************************************************************
    Method Name : saveFiles
    Parameters  : List<String>
    Return type : Map<String, String>
    Description : This method is used to retrieve existing content document Id based on the document
    checklist record Id's.
    ******************************************************************************************************/
    private Map<String, String> retrieveExistingDocs(List<String> dcIdsList){
        Map<String, String> docCheckIdMap = new Map<String, String>();
        if(!dcIdsList.isEmpty()){
            for(ContentDocumentLink cdLink : [SELECT ContentDocumentId,Id,IsDeleted,LinkedEntityId,ShareType,SystemModstamp,Visibility, ContentDocument.Title FROM ContentDocumentLink WHERE LinkedEntityId IN: docCheckIdsList LIMIT 100]){
                if(cdLink != null){
                    docCheckIdMap.put(cdLink.ContentDocumentId, cdLink.Id);
                }
            } 
        }
        return docCheckIdMap;
    }
    
    /****************************************************************************************************
    Method Name : prepareContentVersionList
    Parameters  : List<WrapFileUploadHolder>, Map<String, String>
    Return type : List<ContentVersion>
    Description : This method is used to prepare the contentversion records list.
    ******************************************************************************************************/
    private List<ContentVersion> prepareContentVersionList(List<WrapFileUploadHolder> wrapperFileList){
        List<ContentVersion> contentVersionList = new List<ContentVersion>();
        ContentVersion cv = null;
        for(WrapFileUploadHolder wrapObj : wrapperFileList){
            if(String.isNotBlank(wrapObj.fileName) && wrapObj.fileContent != null){
                cv = new ContentVersion();
                cv.versionData = wrapObj.fileContent;
                cv.title = wrapObj.fileName;
                cv.PathOnClient = wrapObj.fileName;
                if(String.isNotBlank(wrapObj.documentCheckObj.Tech_Content_Document_Id__c)){
                    cv.ContentDocumentId = wrapObj.documentCheckObj.Tech_Content_Document_Id__c;    
                }
                contentVersionList.add(cv);
            }
        }
        return contentVersionList;
    }
    
    /****************************************************************************************************
    Method Name : prepareDocumentCheckList
    Parameters  : List<ContentVersion>, List<WrapFileUploadHolder>
    Return type : List<Application_Document_Checklist__c>
    Description : This method is used to prepare the document checklist records list to insert.
    ******************************************************************************************************/
    private List<Application_Document_Checklist__c> prepareDocumentCheckList(List<ContentVersion> cvList, List<WrapFileUploadHolder> wrapperFHList){
        Application_Document_Checklist__c documentCheck = null;
        List<Application_Document_Checklist__c> docCheckList = new List<Application_Document_Checklist__c>();
        fileIdSet = new Set<Id>();
        Set<String> docIdSet = new Set<String>();
        if(!cvList.isEmpty()){
            for(ContentVersion cv : cvList){
                fileIdSet.add(cv.Id);
                for(WrapFileUploadHolder wrapObj : wrapperFHList){
                    if(cv.Title == wrapObj.fileName && !docIdSet.contains(wrapObj.documentCheckObj.Id)){
                        documentCheck = new Application_Document_Checklist__c();
                        documentCheck = wrapObj.documentCheckObj;
                        if(Label.SG11_Not_Submitted.equals(documentCheck.Status__c)){
                            documentCheck.Status__c = Label.SG12_Uploaded;
                        }else if(Label.SG12_Uploaded.equals(documentCheck.Status__c) || Label.SG94_Submitted.equals(documentCheck.Status__c) || Label.SG33_Doucment_Signed.equals(documentCheck.Status__c) || MISSINGINFO_CONSTANT.equals(documentCheck.Status__c)){
                            documentCheck.Status__c = Label.SG14_Re_Uploaded;
                        }else {
                            if(Label.SG13_Document_Sent_for_Signature.equals(documentCheck.Status__c)){
                                documentCheck.Status__c = Label.SG12_Uploaded;
                            }
                        }
                        documentCheck.File_Name__c = wrapObj.fileName;
                        documentCheck.File_URL__c = Label.SG15_Instance_Url+cv.ContentDocumentId;
                        documentCheck.File_Size__c = SGA_Util06_FileUploadHelper.fileSizeConvertion(documentCheck.File_Size__c);
                        documentCheck.Tech_Content_Document_Id__c = cv.ContentDocumentId;
                        docCheckList.add(documentCheck);
                        docIdSet.add(documentCheck.Id);
                    }
                }
            }
        }
        return docCheckList;
    }
    
    
    
    /****************************************************************************************************
    Method Name : insertContentDocumentLink
    Parameters  : List<Application_Document_Checklist__c>
    Return type : void
    Description : This method is used to create ContentDocumentLin records to map uploaded file to document
    checklist record.
    ******************************************************************************************************/
    private void insertContentDocumentLink(List<Application_Document_Checklist__c> dcRecordList, Map<String, String> cdLinkIdMap){
        List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
        Map<String,String> cvMap = new Map<String,String>();
        ContentDocumentLink cdl = null;
        Set<Id> docCheckSet = new Set<Id>();
        List<ContentVersion> cdList = new List<ContentVersion>();
        cdList = [SELECT Id, title, ContentDocumentId FROM ContentVersion WHERE Id IN : fileIdSet LIMIT 100];
        if(!cdList.isEmpty()){
            for(ContentVersion cv : cdList){
                cvMap.put(cv.Title, cv.ContentDocumentId);
            }
        }
        
        for(Application_Document_Checklist__c docCheck : dcRecordList){
            if(!cvMap.isEmpty() && cvMap.containsKey(docCheck.File_Name__c)){
               if(!cdLinkIdMap.containsKey(docCheck.Tech_Content_Document_Id__c)){
                    cdl = new ContentDocumentLink();
                    cdl.ContentDocumentId = cvMap.get(docCheck.File_Name__c);
                    cdl.LinkedEntityId = docCheck.Id;
                    cdl.ShareType = SHARE_V_CONSTANT;
                	cdl.Visibility = VISIBILITY_ALL_CONSTANT;
                    cdlList.add(cdl);
               }
            } 
        }
        if(!cdlList.isEmpty()){
            List<ContentDocumentLink> cdlinkList = SGA_Util05_FilesDataAccessHelper.dmlContentDCLinklist(cdlList, SG01_Constants.UPSERT_OPERATION);
        }
    }
    
    /****************************************************************************************************
    Class Name  : WrapFileUploadHolder
    Description : This is wrapper class to display document checklist object and fileContent, contentType 
    and fleName variables in SGA_VF04_FileUpload page.
    ******************************************************************************************************/
    public without sharing class WrapFileUploadHolder{
        public transient blob fileContent{get;set;}
        public String contentType { get; set; }
        public String fileName { get; set; }
        public Application_Document_Checklist__c documentCheckObj{get;set;}
        /****************************************************************************************************
        Constructor Name  : WrapFileUploadHolder
        Description : This is used to assign document checklist object.
        ******************************************************************************************************/
        public WrapFileUploadHolder(Application_Document_Checklist__c docCheckObj){
            documentCheckObj = new Application_Document_Checklist__c();
            documentCheckObj = docCheckObj;
        }
    }
}