/**********************************************************************************
Class Name :   SGA_BAP04_CreateContentDocLink
Date Created : 27-Oct-2017
Created By   : IDC Offshore
Description  : 1. This is the batch for creating the Content Document Link for 
			   Content Documents as the API user is not able to create CDL hence
			   Broker/Internal User is not able to view the document.
Change History : 
*************************************************************************************/
global class SGA_BAP04_CreateContentDocLink implements Database.Batchable<sObject> {
	string query = 'SELECT ID,Tech_Content_Document_Id__c,Tech_CDL_Created__c from Application_Document_CheckList__c Where Tech_CDL_Created__c = FALSE AND Tech_Content_Document_Id__c != NULL';
    public static final string SHARE_TYPE= 'V';
    public static final string VISIBILITY_MODE = 'AllUsers';
    /****************************************************************
     * Method Name : start
     * Parameters  : Database.BatchableContext
     * Return Type : Database.QueryLocator
     * Description : Interface method is used to query the results
     * **************************************************************/
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(query);
    }
    
    /*********************************************************************************
     * Method Name : execute
     * Parameters  : Database.BatchableContext,List<Application_Document_CheckList__c>
     * Description : Interface method is used to process the query results
     * *******************************************************************************/
    global void execute(Database.BatchableContext bc, List<Application_Document_CheckList__c> docList){
        //this map contains content document id and doc check id
        Map<String,String> contentDocDocCheckMap = new Map<String,String>();
        //map to check the document checklist record link field updated to true or not
        Map<String,Application_Document_CheckList__c> adcCheckListMap = new Map<String,Application_Document_CheckList__c>();
       	//constructing maps for processing the CDL creation logic
        for(Application_Document_CheckList__c adcObj : docList){
            contentDocDocCheckMap.put(adcObj.Tech_Content_Document_Id__c,adcObj.Id);
            adcCheckListMap.put(adcObj.Tech_Content_Document_Id__c,adcObj);
        }
        if(Test.isRunningTest()){
            List<ContentDocument> contentDocList = [SELECT ID FROM ContentDocument WHERE ID IN:contentDocDocCheckMap.keySet()];
        }
        //fetching the content documents from document checklist records
        List<ContentDocument> conDocList = [select ID,(select ID,LinkedEntityId,ContentDocumentId from ContentDocumentLinks) from ContentDocument where 
                                            ID IN :contentDocDocCheckMap.keySet()];
        //list to create CDL
        List<ContentDocumentLink> conDocLinkList = new List<ContentDocumentLink>();
        //List to update the content document link information
        List<Application_Document_CheckList__c> adcList = new List<Application_Document_CheckList__c>();
        
        for(ContentDocument conDocObj : conDocList){
            Boolean cdlCreated = false;//to check the CDL is created for it or not
            List<ContentDocumentLink> cdlList = conDocObj.ContentDocumentLinks;
            if(cdlList != NULL && !cdlList.isEmpty()){
                for(ContentDocumentLink cdlObj : cdlList){
                    String linkedEntityId = cdlObj.LinkedEntityId;
                    if(linkedEntityId.equalsIgnoreCase(contentDocDocCheckMap.get(cdlObj.ContentDocumentId))){
                        cdlCreated = true;
                        Application_Document_CheckList__c adcObj = adcCheckListMap.get(cdlObj.ContentDocumentId);
                        //updating the CDL creation info on document checklist record.
                        if(!adcObj.Tech_CDL_Created__c){
                            adcObj.Tech_CDL_Created__c = true;
                            adcList.add(adcObj);
                        }
                        Break;
                    }
                }
            }
            //creating content document checklist records if it is already not exist.
            if(!cdlCreated){
                ContentDocumentLink cdl = new ContentDocumentLink();                  
                cdl.ContentDocumentId = conDocObj.ID;
                cdl.LinkedEntityId = contentDocDocCheckMap.get(conDocObj.ID);
                cdl.ShareType = SHARE_TYPE;
                cdl.Visibility = VISIBILITY_MODE;
                conDocLinkList.add(cdl);
            }
        }
        if(!conDocLinkList.isEmpty()){
            Database.insert(conDocLinkList);
        }
        Set<ID> conDocIdSet = new Set<ID>();
        for(ContentDocumentLink cdl : conDocLinkList){
            conDocIdSet.add(cdl.Id);
        }
        if(!conDocIdSet.isEmpty()){
            List<ContentDocumentLink> insertedList = [select ID,ContentDocumentId,LinkedEntityId from ContentDocumentLink where ID IN:conDocIdSet];
            if(insertedList != NULL){
                for(ContentDocumentLink cdlObj : insertedList){
                    String linkedEntityId = cdlObj.LinkedEntityId;
                    if(linkedEntityId.equalsIgnoreCase(contentDocDocCheckMap.get(cdlObj.ContentDocumentId))){
                        Application_Document_CheckList__c adcObj = new Application_Document_CheckList__c();
                        adcObj.ID=linkedEntityId;
                        adcObj.Tech_CDL_Created__c = true;
                        adcList.add(adcObj);
                    }
                }
            }
        }
        
        if(!adcList.isEmpty()){
            Database.Update(adcList);
        }
    }
    /*********************************************************************************
     * Method Name : finish
     * Parameters  : Database.BatchableContext
     * Description : Interface method is used to write post processing logic
     * *******************************************************************************/
    global void finish(Database.BatchableContext bc){
        
    }
}