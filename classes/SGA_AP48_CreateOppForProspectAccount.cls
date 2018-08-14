/***********************************************************************
Class Name   : SGA_AP48_CreateOppForProspectAccount
Date Created : 09/18/2017 (MM/DD/YYYY)
Created By   : IDC Offshore
Description  : 1. This is a Handler Class to create Opportunity and Opportunity Product
**************************************************************************/
public without sharing class  SGA_AP48_CreateOppForProspectAccount {
 private static Final String PROSPECT_TYPE ='Prospect';
 private static Final String SGQUOTING ='SG Quoting';
 private static Final String OPPSTAGE_NEW='New Opportunity';
 private static Final String OPP_TYPE = 'New Sales';
 private static Final String PRODUCT_LINE='Med Den Vis Lif Dis';
 private static Final String DEFAULT_DATE='1/1/2999';
 private static Final String OPP='Opp -';
 private static Date oppClosedDate= System.today() + 30;
 private static Id oppRecId=SGA_Util11_ObjectRecordTypeHelper.getObjectRecordTypeId(Opportunity.sobjectType,SGQUOTING);
 private static Map<Id,AccountTeamMember> accAssociateMap = new Map<Id,AccountTeamMember>();
 public static boolean runOnce = true;
 private static Final String PRD_TYPE= 'Product_Type__c';
 private static Map<Id,Opportunity> oppMapToCreate =NULL;
 private static Map<Id,List<Opportunity>> existingOppForAccount = NULL;
 private static Map<Id,Id> errOnAccounts = NULL;
 private static Final String ERR_MSG ='Duplicate Opportunity Present for Account: ';
 private static Final String OP_ERR_MSG=' and Opportunity: ';
 private static Final String AE='Account Executive';
 private static Final String AE_LIKE='%' + AE + '%';
/****************************************************************************************************
    Method Name : createOppForProspect
    Parameters  : Map<id, Account> newAccMap 
    Return type : Void
    Description : 1.Create Opportunity Records if Account Type : Prospect
                  2. Create Opportunity Product records for  LoBs (medical, dental, vision, life and disability)
                  
******************************************************************************************************/
public static void createOppForProspect(Map<Id, Account> newIncAccMap) { 
        //System.debug('<<<< createOppForProspect Call >>>>');
        Map<Id,Account> filteredAccountMap = new Map<Id,Account>();
        if(!newIncAccMap.isEmpty()){
              for(Account accObj : newIncAccMap.Values()){
                  if(String.isNotBlank(accObj.Type) && PROSPECT_TYPE.equalsIgnoreCase(accObj.Type)){
                      filteredAccountMap.put(accObj.Id,accObj);
                  }
              }
         }
        // method call to processOppForProspect
         if(!filteredAccountMap.isEmpty()){
            processOppForProspect(filteredAccountMap,newIncAccMap);
         }    
    }
   
 /****************************************************************************************************
    Method Name : processOppForProspect
    Parameters  : Map<id, Account> newAccMap 
    Return type : Void
    Description : 1.Create Opportunity Records if Account Type : Prospect
                  2. Create Opportunity Product records for  LoBs (medical, dental, vision, life and disability)
                  
******************************************************************************************************/
 public static void processOppForProspect(Map<Id, Account> accountMap,Map<Id, Account> newAccMap) {
      Map<Id,Opportunity> oppMapToCreate = new Map<Id,Opportunity>();
      errOnAccounts = new Map<Id,Id>();
      Try {  // call fetchAssociateDetails() to get the existing Associates
             accAssociateMap=fetchAssociateDetails(accountMap.keySet());
             // call getExistingOpportunities() to get the existing Opportunies
              getExistingOpportunities(accountMap.keySet());
              for(Id acId:accountMap.keySet()){
                 Opportunity opToCreate= createOppRecord(accountMap.get(acId),accAssociateMap);
                 //check duplicate opportunity for current account
                 if(!existingOppForAccount.containsKey(acId)){
                     oppMapToCreate.put(acId,opToCreate);
                 }
                 
              }
    
              if(!oppMapToCreate.isEmpty()) {
                  // call checkExistingDupOpportunities() to perform Evaluation of Duplicate Opportunies for account
                  checkExistingDupOpportunities(oppMapToCreate.values());
                  // perform DML on oppMapToCreate
                  SGA_Util07_OpportunityDataAccessHelper.dmlOnOpportunity(oppMapToCreate.values(),SGA_Util07_OpportunityDataAccessHelper.INSERT_OPERATION);
              }
              // indicates opportunity is created and Opportunity Id is populated
              if(!oppMapToCreate.keySet().isEmpty()){
                  createPrdList(oppMapToCreate.values());
              }
        } Catch(Exception ex) {
           if(!errOnAccounts.isEmpty()){ showDupErrMsgForAccount(newAccMap.values());}}             
 } 
 /****************************************************************************************************
    Method Name : createOppRecord
    Parameters  : Account acc
    Return type : Opportunity
    Description : create Opportunity Essential Information
                  
******************************************************************************************************/
  private static Opportunity  createOppRecord(Account acc,Map<Id,AccountTeamMember> accountAssociateMap ){
      Opportunity opp = new Opportunity();
      opp.StageName=OPPSTAGE_NEW;
      opp.Type=OPP_TYPE;
      opp.RecordTypeId = oppRecId;
      opp.AccountId= acc.Id;
      opp.Name= generateName(acc);
      opp.Annualized_Group_Premium__c= acc.Tech_Annualized_Group_Premium__c;
      opp.Increase_Release_Renewal__c= acc.Tech_Increase_Release_Renewal__c;
      opp.Total_Employee_Count__c= acc.Tech_Total_of_Eligible_Employees__c;
      opp.Enrolled_Employees__c= acc.Tech_Enrolled_Employees__c;
      opp.On_Exchange__c= acc.Tech_On_Exchange__c;
      //opp.Effective_Date__c= acc.Requested_Effective_Date__c;
      opp.CloseDate = oppClosedDate;
      if(acc.Number_of_Employees__c != NULL){
           opp.Total_Employee_Count__c =acc.Number_of_Employees__c;
      }
      //System.debug('accountAssociateMap in creteOppRecord>>>'+accountAssociateMap);
      if(!accountAssociateMap.isEmpty() && accountAssociateMap.containskey(acc.Id)){
          if(accountAssociateMap.get(acc.Id).UserId != NULL){
             opp.ownerId= accountAssociateMap.get(acc.Id).UserId;
          }
      }
      return opp; 
  }
    
    /****************************************************************************************************
    Method Name : fetchAssociateDetails
    Parameters  : Set<Id> accIdSet
    Return type : Map<Id,Id>
    Description : fetch the Associate Details for Account in Bulk
                  
******************************************************************************************************/
  private static Map<Id,AccountTeamMember>  fetchAssociateDetails(Set<Id> accIdSet){
      Map<Id,AccountTeamMember> accAssociateToSend = new Map<Id,AccountTeamMember>();
      List<AccountTeamMember> accteamList= new List<AccountTeamMember>();
      if(!accIdSet.isEmpty()){
          accteamList=[SELECT AccountId,Id,OpportunityAccessLevel,TeamMemberRole,Title,UserId FROM AccountTeamMember WHERE TeamMemberRole LIKE : AE_LIKE  and AccountId IN :accIdSet];
      }
      if(!accteamList.isEmpty()) {
          for(AccountTeamMember acTeam:accteamList){
              accAssociateToSend.put(acTeam.AccountId,acTeam);
          }
      }  
     return accAssociateToSend; 
  }
    
/****************************************************************************************************
    Method Name : generateName
    Parameters  : Account
    Return type : String
    Description : populate the Opportunity Name
                  
******************************************************************************************************/
  private static String generateName(Account acDetails) {
      String opName='';
      if(acDetails !=NULL){
          opName = acDetails.Name+SG01_Constants.SPACE+DEFAULT_DATE+SG01_Constants.SPACE+OPP+SG01_Constants.SPACE+PRODUCT_LINE;
      }
     return opName; 
  }
    
/****************************************************************************************************
    Method Name : generateName
    Parameters  : Account
    Return type : String
    Description : populate the Opportunity Name
                  
******************************************************************************************************/
  private static void createPrdList(List<Opportunity> opIdsCreated) {
     //System.debug('opIdsCreated>>'+opIdsCreated);
     List<Opportunity_Products__c> prdListToInsert = new List<Opportunity_Products__c>(); 
     Map<String, Schema.SObjectField> objFieldMap = Opportunity_Products__c.SoBjectType.getDescribe().fields.getMap();
     List<Schema.PicklistEntry> businessLines = objFieldMap.get(PRD_TYPE.toLowerCase()).getDescribe().getPicklistValues();
      if( !opIdsCreated.isEmpty() && !businessLines.isEmpty()){
          for(Opportunity opId:opIdsCreated){
              for(Schema.PicklistEntry pic: businessLines){
              Opportunity_Products__c opPrd= new Opportunity_Products__c();
              opPrd.Opportunity__c =opId.Id;
              opPrd.Product_Type__c = pic.getValue();
              prdListToInsert.add(opPrd);
              }
          }
      }
      if(!prdListToInsert.isEmpty()){
          Database.insert(prdListToInsert);
      }
  }
  
  /****************************************************************************************************
    Method Name : getExistingOpportunities
    Parameters  : Set<Id> acIds
    Return type : Map<Id,List<Opportunity>>
    Description : fetch the existing Opportunity Map 
                  
******************************************************************************************************/
  private static void getExistingOpportunities(Set<Id> acIds) {
      List<Opportunity> extOppList = new List<Opportunity>();
      existingOppForAccount = new Map<Id,List<Opportunity>>();
      extOppList =[Select Id,AccountId,Name,StageName,Type,Effective_Date__c from Opportunity Where AccountId IN :acIds AND RecordTypeId =:oppRecId AND StageName =: OPPSTAGE_NEW AND Type =:OPP_TYPE ];
      if(!extOppList.isEmpty()){
          for(Opportunity op : extOppList){
              if(existingOppForAccount.containskey(op.AccountId)){
                  List<Opportunity> exOps = existingOppForAccount.get(op.AccountId); 
                  exOps.add(op);
                  existingOppForAccount.put(op.AccountId,exOps);
              }else {
                  existingOppForAccount.put(op.AccountId,new List<Opportunity>{op});
              }
          }
      }
  }
     
  
  /****************************************************************************************************
    Method Name : checkExistingDupOpportunities
    Parameters  : Map<Id,List<Opportunity>> , List<Opportunity>
    Return type : String
    Description : Perform Evaluation for the Duplicate Opportunities on Account and populate errOnAccounts
                  
******************************************************************************************************/
  public static void checkExistingDupOpportunities(List<Opportunity> opIdsCreated) {
      errOnAccounts= new Map<Id,Id>();
      if(!opIdsCreated.isEmpty() && !existingOppForAccount.isEmpty()){
          for(Opportunity opNw:opIdsCreated){
              Id newOppAcID = opNw.AccountId;
              if(existingOppForAccount.containsKey(newOppAcID)){
                  for(Opportunity opEx:existingOppForAccount.get(newOppAcID)){
                      if(opNw.Effective_Date__c == opEx.Effective_Date__c){
                          errOnAccounts.put(newOppAcID,opEx.Id);
                      }
                  }
              }
          }
      }
  }
    
 /****************************************************************************************************
    Method Name : showDupErrMsgForAccount
    Parameters  : List<Account>
    Return type : void
    Description : populate the Opportunity Name
                  
******************************************************************************************************/
    public static void showDupErrMsgForAccount(List<Account> newAccList) {
        for(Account acNew:newAccList){
            if(errOnAccounts.containsKey(acNew.ID)){
               acNew.addError(ERR_MSG + acNew.ID +OP_ERR_MSG +errOnAccounts.get(acNew.ID));
            }
        }
    }
}