/**********************************************************************************
Class Name :   SGA_AP17_UpdateDocCheckListDSStatus
Date Created : 22-June-2017
Created By   : IDC Offshore
Description  : 1. This class is called from DocuSignStatusTriggerHandler
			   2. This class is used to update the file_size__c,File_URL__c,
			   Tech_Content_Document_ID__c,Status__c on DocumentChecklist
			   from taking the attachments from DocuSignStatus object.				  
Change History : 
*************************************************************************************/
public class SGA_AP17_UpdateDocCheckListDSStatus {
    
    private static Map<String,String> docNameSubjectMap = new Map<String,String>();//used to store document checklist document name and docusign status subject from custom setting.
	private static Map<String,List<dsfs__DocuSign_Status__c>> subjectDocuSignListMap ;
	private static Map<String,SGA_CS01_DocNameSubjectValue__c> docNameSubjectCSMap = SGA_CS01_DocNameSubjectValue__c.getAll();
	private static Map<String,List<String>> subjectFormNameMap = new Map<String,List<String>>();//to store the subject and list form names from custom setting
	private static Map<ID,ID> docuSignStatusAppIdMap;
	private static List<Application_Document_CheckList__c> appDocCheckList ;
	private static Map<ID,List<Attachment>> docuSignIdAttachListMap;
	private static List<Attachment> attachList = new List<Attachment>();
    private static final string COMMA = ',';
	private static Map<ID,ContentVersion> docCheckIdCVMap;
    private static Map<String,String> oldAdcDocuSignIdMap = new Map<String,String>();
    private static Map<String,String> newAdcDocuSignIdMap = new Map<String,String>();
    /****************************************************************************************************
    Method Name : updateDCList
	Parameters  : NewMap, OldMap
	Return Type : void
    Description : This method is used to update document checklist records list
    ******************************************************************************************************/
    public static void updateDCList(Set<ID> docuSignStatusIds){
        docuSignIdAttachListMap = new Map<ID,List<Attachment>>();//storing docusignstatus id and its related attachments
        appDocCheckList = new List<Application_Document_CheckList__c>();
        docuSignStatusAppIdMap = new Map<ID,ID>();//storing docusign status object id and application id
        docCheckIdCVMap = new Map<ID,ContentVersion>(); //to store documentchecklist id and contentversion
        subjectDocuSignListMap = new Map<String,List<dsfs__DocuSign_Status__c>>(); // to store the subject and related docusign status record list
        Map<ID,dsfs__DocuSign_Status__c> docuSignStatusMap = new Map<ID,dsfs__DocuSign_Status__c>([select id,dsfs__Subject__c,
                                                                                                  Application__c,dsfs__Envelope_Status__c
                                                                                                   from dsfs__DocuSign_Status__c where id in :docuSignStatusIds]) ;
        try{
            for(SGA_CS01_DocNameSubjectValue__c dsObj : docNameSubjectCSMap.values()){
                docNameSubjectMap.put(dsObj.Name, dsObj.DocuSignStatus_Subject__c);
            }
            //constructing the map to store list of docusignstatus records based on the subject
            for(dsfs__DocuSign_Status__c docSignStatusObj : docuSignStatusMap.values()){
                if(String.isNotBlank(docSignStatusObj.Application__c)) 
                {
                    if(subjectDocuSignListMap.containsKey(docSignStatusObj.dsfs__Subject__c)){
                        List<dsfs__DocuSign_Status__c> docSignStatusList = subjectDocuSignListMap.get(docSignStatusObj.dsfs__Subject__c);
                        docSignStatusList.add(docSignStatusObj);
                        subjectDocuSignListMap.put(docSignStatusObj.dsfs__Subject__c, docSignStatusList);
                    }else{
                        List<dsfs__DocuSign_Status__c> docSignStatusList = new List<dsfs__DocuSign_Status__c>();
                        docSignStatusList.add(docSignStatusObj);
                        subjectDocuSignListMap.put(docSignStatusObj.dsfs__Subject__c, docSignStatusList);
                    }
                    docuSignStatusAppIdMap.put(docSignStatusObj.Id, docSignStatusObj.Application__c);
                }
            }
            //retrieving the document checklist records based on the document names which need to be updated on document checklist
            //and docusignstatus record application ids
            appDocCheckList = [select Id,Application__c,File_Name__c,Document_Name__c,File_Size__c,File_URL__c,
                               Status__c,Tech_Content_Document_Id__c,Tech_DocuSign_Status_ID__c from 
                               Application_Document_Checklist__c where 
                               Application__c IN :docuSignStatusAppIdMap.values() 
                               AND Document_Name__c IN :docNameSubjectMap.keySet()];
            for(Application_Document_CheckList__c adcObj : appDocCheckList){
                oldAdcDocuSignIdMap.put(adcObj.Id,adcObj.Tech_DocuSign_Status_ID__c);
            }
            if(appDocCheckList != NULL && !appDocCheckList.isEmpty()){
                Boolean attachmentsCreated = constructDSAttachListMap(docuSignStatusAppIdMap);//constructing attachment map
                if(attachmentsCreated){
                    List<ContentVersion> cvList = createContentVersions();
                    updateDocumentCheckList(cvList);
                }
            }
        }catch(Exception ex){
            UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_AP17_UPDATEDOCCHECKLIST, SG01_Constants.METHOD_SGA_AP17_UPDATEDOCCHECKLIST, SG01_Constants.BLANK, Logginglevel.ERROR);
        }
        
		
		
	}
	/****************************************************************************************************
    Method Name : constructDSAttachListMap
	Parameters  : Map<ID,ID>
	Return Type : void
    Description : This method is used to construct the map of docusignstatus record id and its related 
				  attachments
    ******************************************************************************************************/
	private static boolean constructDSAttachListMap(Map<ID,ID> dsStatusAppIdMap){
		Boolean isAttachmentsCreated = false;
        List<Attachment> attachList = [select id,Name,Body,ParentId from Attachment where ParentId IN :dsStatusAppIdMap.keySet()] ;
        if(attachList != NULL && !attachList.isEmpty()){
            for(Attachment attachObj : attachList){
                if(docuSignIdAttachListMap.containsKey(attachObj.ParentId)){
                    List<Attachment> innerAttachList = docuSignIdAttachListMap.get(attachObj.ParentId);
                    innerAttachList.add(attachObj);
                    docuSignIdAttachListMap.put(attachObj.ParentId, innerAttachList);
                }else{
                    List<Attachment> innerAttachList = new List<Attachment>();
                    innerAttachList.add(attachObj);
                    docuSignIdAttachListMap.put(attachObj.ParentId, innerAttachList);
                }
            }
        }
        if(docuSignIdAttachListMap != NULL && !docuSignIdAttachListMap.isEmpty()){
            isAttachmentsCreated = true;
        }
        return isAttachmentsCreated;
	}

    /****************************************************************************************************
    Method Name : createContentVersions
	Parameters  : none
	Return Type : List<ContentVersion>
    Description : This method is used to create contentversions for the attachments and return the 
				  inserted contentversions.
    ******************************************************************************************************/
	private static List<ContentVersion> createContentVersions(){
		List<ContentVersion> cvList = new List<ContentVersion>();
		if(appDocCheckList != NULL && !appDocCheckList.isEmpty()){
            for(Application_Document_CheckList__c adcObj : appDocCheckList){
                String subject = docNameSubjectMap.get(adcObj.Document_Name__c);
                List<dsfs__DocuSign_Status__c> docuSignStatusList = NULL;
                if(subject.contains(COMMA)){
                    List<String> subjectList = subject.split(COMMA);
                    for(String sub : subjectList){
                        if(docuSignStatusList == NULL){
                            docuSignStatusList = subjectDocuSignListMap.get(sub);
                        }else{
                            break;
                        }
                    }
                }else{
                    docuSignStatusList = subjectDocuSignListMap.get(subject);
                }

                if(docuSignStatusList != NULL && !docuSignStatusList.isEmpty()){
                    for(dsfs__DocuSign_Status__c docuSignStatusObj : docuSignStatusList){
                        if(adcObj.Application__c == docuSignStatusObj.Application__c && docuSignStatusObj.Id != oldAdcDocuSignIdMap.get(adcObj.Id)){
                            newAdcDocuSignIdMap.put(adcObj.Id, docuSignStatusObj.Id);
                            List<Attachment> innertAttachList = docuSignIdAttachListMap.get(docuSignStatusObj.Id);
                            if(innertAttachList != NULL && !innertAttachList.isEmpty()){
                                for(Attachment attachObj : innertAttachList){
                                    ContentVersion cv = NULL;
                                    if(System.Label.SG25_Initial_Payment.equalsIgnoreCase(adcObj.Document_Name__c) && System.Label.SG26_Intial_Payment_Form_Name.equalsIgnoreCase(attachObj.Name)){
                                        cv = contructContentVersion(attachObj,adcObj,SG01_Constants.HYPHEN+System.Label.SG25_Initial_Payment);
                                    }else if(System.Label.SG27_HRA.equalsIgnoreCase(adcObj.Document_Name__c) && System.Label.SG29_HRA_Form_Name.equalsIgnoreCase(attachObj.Name)){
                                        cv = contructContentVersion(attachObj,adcObj,SG01_Constants.HYPHEN+System.Label.SG28_HRA_Form);
                                    }else if(System.Label.SG23_EmployerApplication.equalsIgnoreCase(adcObj.Document_Name__c) && 
                                             (System.Label.SG30_Employer_Application_EBCBS_Form_Name.equalsIgnoreCase(attachObj.Name) || 
                                              System.Label.SG31_Employer_Application_EBC_Form_Name.equalsIgnoreCase(attachObj.Name) || 
                                              System.Label.SG93_EmployerAppSubjects.contains(docuSignStatusObj.dsfs__Subject__c))){
                                        cv = contructContentVersion(attachObj,adcObj,SG01_Constants.HYPHEN+System.Label.SG23_EmployerApplication);
                                    }else if(System.Label.SG32_Voided_Cheque.equalsIgnoreCase(adcObj.Document_Name__c) && attachObj.Name != System.Label.SG26_Intial_Payment_Form_Name){
                                        cv = contructContentVersion(attachObj,adcObj,SG01_Constants.HYPHEN+System.Label.SG32_Voided_Cheque);
                                    }
                                    if(cv != NULL){
                                        cvList.add(cv) ;
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
		}

		return cvList;
	}
    
    /****************************************************************************************************
    Method Name : contructContentVersion
	Parameters  : Attachment,Application_Document_CheckList__c,String
	Return Type : List<ContentVersion>
    Description : This method is used to create contentversions for the attachments and return the 
				  inserted contentversions.
    ******************************************************************************************************/
	private static ContentVersion contructContentVersion(Attachment attachObj,Application_Document_CheckList__c adcObj,String docName){

        ContentVersion cv = new ContentVersion();
		cv.Title = attachObj.Name;
		cv.versionData = attachObj.Body;
		cv.PathOnClient = attachObj.Name;
		cv.ReasonForChange = adcObj.Id+docName;
		cv.ContentDocumentId = String.isNotBlank(adcObj.Tech_Content_Document_Id__c) ? adcObj.Tech_Content_Document_Id__c : NULL;
		return cv;
	}
	
    /****************************************************************************************************
    Method Name : updateDocumentCheckList
	Parameters  : List<ContentVersion>
	Return Type : void
    Description : This method is used to create contentversions for the attachments and return the 
				  inserted contentversions.
    ******************************************************************************************************/
	private static void updateDocumentCheckList(List<ContentVersion> cvList){

		Set<ID> cvIdSet = new Set<ID>();

		if(cvList != NULL && !cvList.isEmpty()){
			Database.insert(cvList);
			for(ContentVersion cv : cvList){
				cvIdSet.add(cv.Id);
				docCheckIdCVMap.put(cv.ReasonForChange.subStringBefore(SG01_Constants.HYPHEN),cv);
			}
		}
		List<Application_Document_CheckList__c> updateDocCheckList = new List<Application_Document_CheckList__c>();
		Map<ID,ContentVersion> conDocMap = new Map<ID,ContentVersion>([select Id,ContentDocument.Id,ContentDocument.Title,ContentDocument.LatestPublishedVersionId,ContentDocument.ContentSize from 
																	   ContentVersion where Id IN :cvIdSet]);
		for(Application_Document_CheckList__c adcObj : appDocCheckList){
			if(docCheckIdCVMap.containsKey(adcObj.Id)){
				ContentVersion cv = docCheckIdCVMap.get(adcObj.Id);

				ContentVersion cv1 = conDocMap.get(cv.Id);
				if(String.isNotBlank(adcObj.Tech_Content_Document_Id__c)){
                    adcObj.Tech_DocuSign_Status_ID__c = newAdcDocuSignIdMap.get(adcObj.Id);
                    adcObj.Status__c = System.Label.SG14_Re_Uploaded;
                    adcObj.File_Name__c = cv1.ContentDocument.Title;
                    adcObj.File_Size__c = SGA_Util06_FileUploadHelper.fileSizeConvertion(String.valueOf(cv1.ContentDocument.ContentSize));
				}else{
					adcObj.File_Name__c = cv1.ContentDocument.Title;
					adcObj.File_Size__c = SGA_Util06_FileUploadHelper.fileSizeConvertion(String.valueOf(cv1.ContentDocument.ContentSize));
					adcObj.File_URL__c = Label.SG15_Instance_Url+cv1.ContentDocument.Id;
					adcObj.Status__c = System.Label.SG32_Voided_Cheque.equalsIgnoreCase(adcObj.Document_Name__c) ? System.Label.SG12_Uploaded : System.Label.SG33_Doucment_Signed;
					adcObj.Tech_Content_Document_Id__c = cv1.ContentDocument.Id;
                    adcObj.Tech_DocuSign_Status_ID__c = newAdcDocuSignIdMap.get(adcObj.Id);
				}
			}
			updateDocCheckList.add(adcObj);
		}

        if(updateDocCheckList != NULL && !updateDocCheckList.isEmpty()){
            Database.update(updateDocCheckList);
        }
		
	}
}