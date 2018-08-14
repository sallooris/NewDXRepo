/*******************************************************************************************
* Class Name  : SGA_AP25_UpdateStageStatusOwner
* Created By  : IDC Offshore
* CreatedDate : 8/2/2017
* Description : This class is used to track the time on changes of stage,status and owner.
********************************************************************************************/
public without sharing class SGA_AP25_UpdateStageStatusOwner {
    public static boolean isAfterUpdate = true;
	private static final string BLANK = '';
    private static string newOwnerId = BLANK;
    private static string oldOwnerId = BLANK;
    private static string newStatus = BLANK;
    private static string oldStatus = BLANK;
    private static string newStage = BLANK;
    private static string oldStage = BLANK;
    private static final string INSERT_OPERATION = 'Insert';
    private static final string REUPDATE = 'ReUpdate';
    private static final string UPDATE_OPERATION = 'Update';
    private static final string STATUS_UPDATE = 'Status Update';
    private static final string STAGE_UPDATE = 'Stage Update';
    private static final string OWNER_UPDATE = 'Owner Update';
    private static final string HASH = '#';
    private static final string STATUS = 'Status';
    private static final string STAGE = 'Stage';
    private static final string OWNER = 'Owner';
    private static final string CLS_SGA_AP25_UPDATESTAGESTATUSOWNER = 'SGA_AP25_UpdateStageStatusOwner';
    private static final string METHOD_CREATESTATUSSTAGEOWNER = 'createStatusStageLineItems';
    private static final string METHOD_UPDATESTATUSSTAGEOWNER = 'updateStatusStageLineItems';
    private static final string CASE_QUERY_1 = 'select Id,OwnerId,Owner.Name,Stage__c,Status,Recordtype.Name from Case ';
    private static final string CASE_QUERY_1_WHERE = 'Where Id IN :caseIDSet';
    private List<Case_Status_Stage_Line_Item__c> caseStatusLineItemInsertList = new List<Case_Status_Stage_Line_Item__c>();
    private List<Case_Status_Stage_Line_Item__c> caseStatusLineItemUpdateList = new List<Case_Status_Stage_Line_Item__c>();
    /**********************************************************************************************
    * Method Name : createStatusStageLineItems
    * Parameters  : Map<ID,Case>
    * Return Type : void
    * Description : This method is used to create case stage line items when the case is created.
    **********************************************************************************************/
    public void createStatusStageLineItems(Map<ID,Case> caseMap){
        try
        {
            SGA_Util12_CaseDataAccessHelper.caseIDSet = caseMap.keySet();
            Map<ID,Case> newCaseMap = SGA_Util12_CaseDataAccessHelper.fetchCaseMap(CASE_QUERY_1,CASE_QUERY_1_WHERE,SG01_Constants.BLANK,SG01_Constants.BLANK);
            List<Case> caseList = newCaseMap != NULL ? newCaseMap.values() : NULL;
            for(Case caseObj : caseList){
                //if status is not blank, constructing the line item record
                if(String.isNotBlank(caseObj.status)){
                    Case_Status_Stage_Line_Item__c caseStatusLineItemObj = constructCaseLineItem(STATUS_UPDATE,caseObj.Id,caseObj.Status,STATUS,caseObj.OwnerId,System.Now());

                    caseStatusLineItemInsertList.add(caseStatusLineItemObj);
                }
                //if stage is not blank, constructing the line item record
                if(String.isNotBlank(caseObj.stage__c) && System.Label.SG50_CaseInstallationRecType.equalsIgnoreCase(caseObj.Recordtype.Name)){
                    Case_Status_Stage_Line_Item__c caseStageLineItemObj = constructCaseLineItem(STAGE_UPDATE,caseObj.Id,caseObj.Stage__c,STAGE,caseObj.OwnerId,System.Now());
                    caseStatusLineItemInsertList.add(caseStageLineItemObj);
                    
                    //default owner should be there, hence constructing the record without checking isblank
                    Case_Status_Stage_Line_Item__c caseOwnerLineItemObj = constructCaseLineItem(OWNER_UPDATE,caseObj.Id,caseObj.Owner.Name,OWNER,caseObj.OwnerId,System.Now());
					
                    caseStatusLineItemInsertList.add(caseOwnerLineItemObj);
                }
            }
            
            if(!caseStatusLineItemInsertList.isEmpty()){
                Database.Insert(caseStatusLineItemInsertList);
            }
        } catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,CLS_SGA_AP25_UPDATESTAGESTATUSOWNER, METHOD_CREATESTATUSSTAGEOWNER, SG01_Constants.BLANK, Logginglevel.ERROR);       }
    }
    /**********************************************************************************************
    * Method Name : constructCaseLineItem
    * Parameters  : String name,String fieldName,Id caseId,
    String fieldValue,String ownerId,DateTime startDateTime,
    DateTime endDateTime,String operation,Id lineItemId,Decimal timeSpentInMins
    * Return Type : Case_Status_Stage_Line_Item__c
    * Description : This method is used to construct the line item object
    **********************************************************************************************/
    private static Case_Status_Stage_Line_Item__c constructCaseLineItem(String name,Id caseId,
                                                                        String fieldValue,String fieldName,String ownerId,DateTime startDateTime){
                                                                            Case_Status_Stage_Line_Item__c caseLineItemObj =  new Case_Status_Stage_Line_Item__c();
																			caseLineItemObj.Name = name;
																			caseLineItemObj.Case__c = caseId ;
																			caseLineItemObj.Value__c = fieldValue ;
																			caseLineItemObj.Field__c = fieldName;
																			caseLineItemObj.Owner_Name__c = ownerId;
																			caseLineItemObj.Start_Date__c = startDateTime;

                                                                            return caseLineItemObj;
                                                                        }
    /*****************************************************************************************************
    * Method Name : updateStatusStageLineItems
    * Parameters  : Map<ID,Case>,Map<ID,Case>
    * Return Type : void
    * Description : This method is used to create/update case stage line items when the case is updated.
    ******************************************************************************************************/
    public void updateStatusStageLineItems(Map<ID,Case> caseNewMap,Map<ID,Case> caseOldMap){
        try
        {
            //retriving the data from case stage line items
            List<Case_Status_Stage_Line_Item__c> existingLineItemList = [select Id,Name,Time_Spent_in_Minuts__c,Times_in_Stage__c,Case__c,Field__c,Value__c,Start_Date__c,End_Date__c,
                                                                         Owner_Name__c from Case_Status_Stage_Line_Item__c where Case__c IN : caseNewMap.keySet() and End_Date__c = NULL];

            //fetching the data from case
            SGA_Util12_CaseDataAccessHelper.caseIDSet = caseNewMap.keySet();
            Map<ID,Case> newCaseMap = SGA_Util12_CaseDataAccessHelper.fetchCaseMap(CASE_QUERY_1,CASE_QUERY_1_WHERE,SG01_Constants.BLANK,SG01_Constants.BLANK);
            List<Case> caseList = newCaseMap != NULL ? newCaseMap.values() : NULL;
            
            Map<String,Case_Status_Stage_Line_Item__c> caseIdLineItemMap = constructCaseLineItemMap(existingLineItemList);
            
            for(Case caseObj : caseList){
                //checking the new status is not equals to old status and fetching the line item from the map based on the status
                if(caseObj.Status != caseOldMap.get(caseObj.Id).Status && (!newStatus.equalsIgnoreCase(String.valueOf(caseObj.Status)) || !oldStatus.equalsIgnoreCase(String.valueOf(caseOldMap.get(caseObj.Id).Status))) ){
                    newStatus = caseObj.Status;
                    oldStatus = caseOldMap.get(caseObj.Id).Status;
                    //updating the old line item object record

                    Case_Status_Stage_Line_Item__c oldStatusLineItemObj = caseIdLineItemMap.get(caseObj.Id+HASH+STATUS);                                                                              

                    if(oldStatusLineItemObj != NULL){
                        oldStatusLineItemObj.End_Date__c = System.Now();
                        oldStatusLineItemObj.Time_Spent_in_Minuts__c = getTimeDifference(System.Now(),oldStatusLineItemObj.Start_Date__c);
                        caseStatusLineItemUpdateList.add(oldStatusLineItemObj);
                        
                        Case_Status_Stage_Line_Item__c caseStatusLineItemObj = constructCaseLineItem(STATUS_UPDATE,caseObj.Id,caseObj.Status,STATUS,caseObj.OwnerId,System.Now());

						caseStatusLineItemInsertList.add(caseStatusLineItemObj);
                    }
                    
                }
                //checking the new Stage__c is not equals to old Stage__c and fetching the line item from the map based on the Stage__c
                if(caseObj.Stage__c != caseOldMap.get(caseObj.Id).Stage__c && (!newStage.equalsIgnoreCase(String.valueOf(caseObj.Stage__c)) || !oldStage.equalsIgnoreCase(String.valueOf(caseOldMap.get(caseObj.Id).Stage__c))) 
                   && System.Label.SG50_CaseInstallationRecType.equalsIgnoreCase(caseObj.Recordtype.Name)){
                    newStage = caseObj.Stage__c;
                    oldStage = caseOldMap.get(caseObj.Id).Stage__c;
                       
                    //updating the old line item object record
                    Case_Status_Stage_Line_Item__c oldStatusLineItemObj = caseIdLineItemMap.get(caseObj.Id+HASH+STAGE);                                                                              
                    if(oldStatusLineItemObj != NULL){
                        oldStatusLineItemObj.End_Date__c = System.Now();
                        oldStatusLineItemObj.Time_Spent_in_Minuts__c = getTimeDifference(System.Now(),oldStatusLineItemObj.Start_Date__c);
                        caseStatusLineItemUpdateList.add(oldStatusLineItemObj);
						
                        Case_Status_Stage_Line_Item__c caseStageLineItemObj = constructCaseLineItem(STAGE_UPDATE,caseObj.Id,caseObj.Stage__c,STAGE,caseObj.OwnerId,System.Now());
						caseStatusLineItemInsertList.add(caseStageLineItemObj);
                    }
                }
                //checking the new OwnerId is not equals to old OwnerId and fetching the line item from the map based on the OwnerId
                if(caseObj.OwnerId != caseOldMap.get(caseObj.Id).OwnerId && (!newOwnerId.equalsIgnoreCase(String.valueOf(caseObj.OwnerId)) || !oldOwnerId.equalsIgnoreCase(String.valueOf(caseOldMap.get(caseObj.Id).OwnerId))) &&
                   System.Label.SG50_CaseInstallationRecType.equalsIgnoreCase(caseObj.Recordtype.Name)){
                    newOwnerId = caseObj.OwnerId;
                    oldOwnerId = caseOldMap.get(caseObj.Id).OwnerId;
                    
                    //updating the old line item object record
                    Case_Status_Stage_Line_Item__c oldStatusLineItemObj = caseIdLineItemMap.get(caseObj.Id+HASH+OWNER);
                    if(oldStatusLineItemObj != NULL){
                        oldStatusLineItemObj.End_Date__c = System.Now();
                        oldStatusLineItemObj.Time_Spent_in_Minuts__c = getTimeDifference(System.Now(),oldStatusLineItemObj.Start_Date__c);
                        caseStatusLineItemUpdateList.add(oldStatusLineItemObj);
                        
                        Case_Status_Stage_Line_Item__c caseOwnerLineItemObj = constructCaseLineItem(OWNER_UPDATE,caseObj.Id,caseObj.Owner.Name,OWNER,caseObj.OwnerId,System.Now());
					
						caseStatusLineItemInsertList.add(caseOwnerLineItemObj);
                    }
                    
                }
            }
            if(!caseStatusLineItemInsertList.isEmpty()){
                Database.Insert(caseStatusLineItemInsertList);
            }
            if(!caseStatusLineItemUpdateList.isEmpty()){
                Database.update(caseStatusLineItemUpdateList);
            }
            
        } catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,CLS_SGA_AP25_UPDATESTAGESTATUSOWNER, METHOD_UPDATESTATUSSTAGEOWNER, SG01_Constants.BLANK, Logginglevel.ERROR);       }
    }
    /*****************************************************************************************************
    * Method Name : getTimeDifference
    * Parameters  : DateTime endDate,DateTime startDate
    * Return Type : Long
    * Description : This method is used to find the difference between two date time fieds and convert 
    *                them into minuts
    ******************************************************************************************************/
    private static Long getTimeDifference(DateTime endDate,DateTime startDate){
        
        Long dt1Long = startDate.getTime();
        Long dt2Long = endDate.getTime();
        Long milliseconds = dt2Long - dt1Long; 
        Long seconds = milliseconds / 1000;
        Long minutes = seconds / 60;
        return minutes;
    }
    /*****************************************************************************************************
    * Method Name : constructCaseLineItemMap
    * Parameters  : List<Case_Status_Stage_Line_Item__c> existingLineItemList
    * Return Type : Map<String,Case_Status_Stage_Line_Item__c>
    * Description : This method is used to construct the existing lineitem records map with some constant
    ******************************************************************************************************/
    private Map<String,Case_Status_Stage_Line_Item__c> constructCaseLineItemMap(List<Case_Status_Stage_Line_Item__c> existingLineItemList){
        
        Map<String,Case_Status_Stage_Line_Item__c> caseIdLineItemMap = new Map<String,Case_Status_Stage_Line_Item__c>();
        for(Case_Status_Stage_Line_Item__c caseLineItemObj : existingLineItemList){
            //constructing the map by comparing the field values with line item field name
            if(STATUS.equalsIgnoreCase(caseLineItemObj.Field__c)){
                caseIdLineItemMap.put(caseLineItemObj.Case__c+HASH+STATUS,caseLineItemObj);
            }else if(STAGE.equalsIgnoreCase(caseLineItemObj.Field__c)){
                caseIdLineItemMap.put(caseLineItemObj.Case__c+HASH+STAGE,caseLineItemObj);
            }else if(OWNER.equalsIgnoreCase(caseLineItemObj.Field__c)){
                caseIdLineItemMap.put(caseLineItemObj.Case__c+HASH+OWNER,caseLineItemObj);
            }
        }
        return caseIdLineItemMap;
    }
}