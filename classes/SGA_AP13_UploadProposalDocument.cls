/**********************************************************************************
Class Name :   SGA_AP13_UploadProposalDocument
Date Created : 15-June-2017
Created By   : IDC Offshore
Description  : 1. This class is called from DocumentCheckListTriggerHandler.
2. This called is used to update the File_Name__c, File_Size__c, File_URL__c,
Tech_Content_Document_Id__c fields on Document Check List record when it is 
created by fetching the details from corresponding Quote
Change History : 
*************************************************************************************/
public without sharing class SGA_AP13_UploadProposalDocument {
    public Static Final String B_CONSTANT = 'B';
    public static final String QUOTE_PROPOSAL = 'Quote Proposal';
    public static final String NYS45 = 'NYS 45';
    public static final String NOT_SUBMITTED = 'Not Submitted';
    public static final string COMMA = ',';
    public static final string AND_STATUS = ' AND Status__c ';
    public static final string APP_DOC_WHERE_1 = ' ID IN ';
    public static final string APP_DOC_WHERE_2 = ' AND Document_Name__c IN (';
    public List<Application_Document_Checklist__c> updateDocumentCheckList = new List<Application_Document_Checklist__c>();
    
    /**
* Method Name : uploadProposalDocumentDetails
* Parameters  : Set<ID> - document checklist ids.
* Return Type : void
* Description : This method will be called from handler class. This is used to update the quote proposal
* 				 document check list record File_Name__c, File_Size__c, File_URL__c, Tech_Content_Document_Id__c
* 				 field values by fetching the details from ContentDocument object.
**/
    public void uploadProposalDocumentDetails(Set<ID> documentCheckListIds){
        try{

            Set<ID> quoteIdSet = new Set<ID>();
            Map<ID,ID> quoteIdContentIdMap = new Map<ID,ID>();
            Map<ID,QuoteDocument> contentDocQuoteDocMap = new Map<ID,QuoteDocument>();
            String paramValues = SG01_Constants.BLANK;
            for(ID docId : documentCheckListIds){
                paramValues+=SG01_Constants.BACK_SLASH +docId+SG01_Constants.BACK_SLASH+COMMA;
            }
            paramValues = paramValues.substringBeforeLast(COMMA);
            String whereClause = SG01_Constants.WHERE_CLAUSE+SG01_Constants.SPACE+APP_DOC_WHERE_1+SG01_Constants.LEFT_BRACKET+
                paramValues+SG01_Constants.RIGHT_BRACKET+SG01_Constants.SPACE+APP_DOC_WHERE_2+
                SG01_Constants.BACK_SLASH+String.escapeSingleQuotes(QUOTE_PROPOSAL)+SG01_Constants.BACK_SLASH
                +COMMA+SG01_Constants.BACK_SLASH+String.escapeSingleQuotes(NYS45)+SG01_Constants.BACK_SLASH+SG01_Constants.RIGHT_BRACKET
                +AND_STATUS+SG01_Constants.EQUALS_SLASH+String.escapeSingleQuotes(NOT_SUBMITTED)+SG01_Constants.BACK_SLASH;
            //fetching document check list records based on the quote proposal and not submitted document checklist ids
            Map<ID,Application_Document_Checklist__c>  documentCheckListMap = SGA_Util04_DCDataAccessHelper.fetchDocumentChecklistMap(SG01_Constants.APP_DOC_CHECK_QUERY,
                                                                                                                                      whereClause,SG01_Constants.BLANK,SG01_Constants.BLANK);
            List<Application_Document_Checklist__c> documentCheckList = documentCheckListMap != NULL && !documentCheckListMap.isEmpty() ?
                documentCheckListMap.values() : NULL;

            //checking the list is null or not
            if(documentCheckList != NULL && !documentCheckList.isEmpty()){
                
                for(Application_Document_Checklist__c appDocCheckObj : documentCheckList){
                    //creating set to store quote id, based on this set, we will fetch quotedocuments
                    quoteIdSet.add(appDocCheckObj.Application__r.vlocity_ins__QuoteId__c);
                }

                //checking the quoteids are empty or not
                if(!quoteIdSet.isEmpty()){
                    //fetching quotedocument records for the quotes
                    //fetching in desc order because we need only latest quotedocument

                    for(QuoteDocument qdObj : [select Id,Name,QuoteId,Document,ContentVersionDocumentId
                                               from QuoteDocument
                                               where QuoteId IN :quoteIdSet 
                                               Order By CreatedDate DESC])
                    {
                        //We need only latest quotedocument record
                        //once the quoteid for latest quotedocument is added to map, not adding the older
                        //quote documents hence checking the quote id is already exists or not.                           
                        if(!quoteIdContentIdMap.containsKey(qdObj.QuoteId)){
                            //this map is used to fetch ContentDocument based on the ConentVersionDocumentId
                            quoteIdContentIdMap.put(qdObj.QuoteId,qdObj.ContentVersionDocumentId);
                            //As there is no direct relationship between quotedocument and contentdocument
                            //we are storing contentversiondocumentid and quotedocument in the below map
                            //which will be used later in getting the quotedocument based on the contentdocument latest version id
                            contentDocQuoteDocMap.put(qdObj.ContentVersionDocumentId,qdObj);
                        }
                    }
                    //creating map to store latestpublishedversionid and contentdocument object
                    //which is used while updating the document checklist record
                    Map<String,ContentDocument> contentDocMap = new Map<String,ContentDocument>();
                    for(ContentDocument cdocObj : [select id, Title,LatestPublishedVersionId, ContentSize 
                                                   from contentdocument where LatestPublishedVersionId 
                                                   IN :quoteIdContentIdMap.values()])
                    {
                        contentDocMap.put(cdocObj.LatestPublishedVersionId,cdocObj);                         
                    }


                    //updating the document check list records
                    for(Application_Document_Checklist__c docCheckListObj : documentCheckList){
                        if(docCheckListObj.Document_Name__c.equalsIgnoreCase(QUOTE_PROPOSAL)){

                            String contentDocumentVersionId = quoteIdContentIdMap.get(docCheckListObj.Application__r.vlocity_ins__QuoteId__c);
                            ContentDocument contentDocObj = contentDocMap.get(contentDocumentVersionId);
                            if(!contentDocQuoteDocMap.isEmpty()){
                                QuoteDocument qdObj = contentDocQuoteDocMap.get(contentDocObj.LatestPublishedVersionId);
                                
                                docCheckListObj.File_Name__c = qdObj.Name;
                                docCheckListObj.File_Size__c = SGA_Util06_FileUploadHelper.fileSizeConvertion(String.valueOf(contentDocObj.ContentSize));
                                docCheckListObj.File_URL__c = Label.SG15_Instance_Url+contentDocObj.Id;
                                docCheckListObj.Tech_Content_Document_Id__c = contentDocObj.Id;
                                docCheckListObj.Status__c = Label.SG12_Uploaded;
                            }
                        }else if(docCheckListObj.Document_Name__c.equalsIgnoreCase(NYS45) && 
                                 docCheckListObj.Application__r.Medical__c){
                                     docCheckListObj.Required__c = true;
                                 }
                        updateDocumentCheckList.add(docCheckListObj);
                    }
                    if(!updateDocumentCheckList.isEmpty()){
                        update updateDocumentCheckList;
                    }
                }     
            }
        }catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,SG01_Constants.CLS_UPLOAD_PROPOSAL_DOC, SG01_Constants.CLS_METHOD_UPLOAD_PROPOSAL_DOC, SG01_Constants.BLANK, Logginglevel.ERROR);        }
    }
    
}