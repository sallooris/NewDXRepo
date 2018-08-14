/*
* Class Name   : SGA_AP21_CreatePEIMCaseController
* Created Date : 24-July-2017
* Created By   : IDC Offshore
* Description  :  1. Apex Controller to handle In SGA_LTNG11_CreatePEIMCase Lightning Component
*             
**/
public with Sharing class SGA_AP21_CreatePEIMCaseController {
 
    public static Id caseRecId=SGA_Util11_ObjectRecordTypeHelper.getObjectRecordTypeId(Case.sobjectType, SG01_Constants.CASE_RECORDTYPENAME_ENROLL);
    public static WrpAgentDetails  wrpAgent;
    private static final string defaultOriginValue='Web';
    private static final string picklistStateNone='---None---';
    /****************************************************************************************************
    Method Name : createCase
    Parameters  : Case
    Return type : void
    Description : fetches the case information from UI and performs the case record creation operaion.
******************************************************************************************************/
    @AuraEnabled
    public static Case createCase(Case cs,Id accId){
    List<Case> csListToInsert = new List<Case>();
       
            if(cs != null && accId != NULL){
                cs.AccountID=accId;
                cs.RecordTypeId=caseRecId;
                cs.Origin=defaultOriginValue;
                cs.Subject=cs.BR_Category__c;
                //apply assignement Rule
                Database.DMLOptions dmo = new Database.DMLOptions();
                dmo.assignmentRuleHeader.useDefaultRule = true;
                cs.setOptions(dmo);
                csListToInsert.add(cs);
                
            }
      Try{
            if(!csListToInsert.isEmpty()){
             SGA_Util12_CaseDataAccessHelper.dmlOnCase(csListToInsert,SGA_Util12_CaseDataAccessHelper.INSERT_OPERATION);
            }
            
        }Catch(Exception ex) { UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_AP21_CREATEPEIMCASECTRL, SG01_Constants.SGA_AP21CREATECASE, SG01_Constants.BLANK, Logginglevel.ERROR);}
        
        return csListToInsert[0] ;
    }
    
     /****************************************************************************************************
    Method Name : getCaseNumber 
    Parameters  : String
    Return type : String
    Description : This method is used to fetch the CaseNumber for inserted Case through WebForm
 ******************************************************************************************************/
    @AuraEnabled
    public static String getCaseNumber (String insertedCaseId) {
        String caseNumber='';
        Try {
            if(insertedCaseId !=NULL){
            caseNumber =[Select Id,CaseNumber from Case where Id =: insertedCaseId].CaseNumber;
            }
        }
         Catch(Exception ex) { UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_AP21_CREATEPEIMCASECTRL, SG01_Constants.SGA_AP21GETCASENUMBER, SG01_Constants.BLANK, Logginglevel.ERROR);}
    
        return caseNumber; 
    }
    
 /****************************************************************************************************
    Method Name : getAgent 
    Parameters  : void
    Return type : WrpAgentDetails
    Description : This method is used to fetch the Agent Details based on current LoggedIn User AccountId
 ******************************************************************************************************/
@AuraEnabled
   public static WrpAgentDetails getAgent () {
        Contact con=new Contact();
        User userDetails=new User();
       
       Try{
          userDetails=[Select Id,AccountId,ContactId from User where Id =:userinfo.getUserId()];
          if(userDetails.ContactId !=NULL){
          con=[Select Id,Name,ETIN__c from Contact Where Id=: userDetails.ContactId limit 1 ];
          //System.debug('con details::>'+con);
          }
         if(con != NULL){
           wrpAgent= new WrpAgentDetails(con.ETIN__c,con.Name,NULL);
         }
       } Catch(Exception ex) { UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_AP21_CREATEPEIMCASECTRL, SG01_Constants.SGA_AP21GETAGENT, SG01_Constants.BLANK, Logginglevel.ERROR);}
       return wrpAgent; 
  }
    
 @AuraEnabled
    /****************************************************************************************************
    Method Name : getCaseSates
    Parameters  : String docId
    Return type : List<PicklistOptionStates>
    Description : This method is used to fetch status value from document check list records
    ******************************************************************************************************/
    public static List<PicklistOptionStates> getCaseSates(){
        List<PicklistOptionStates> options = new List<PicklistOptionStates>();
        options.add(new PicklistOptionStates(picklistStateNone,''));
        try{
            Schema.DescribeFieldResult fieldResult = Case.BR_State__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry f: ple) {
                if(f.getLabel().equals(SG01_Constants.STATE_NY)){
                    options.add(new PicklistOptionStates(f.getLabel(),f.getLabel()));
                }
            }
         } Catch(Exception ex) { UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_AP21_CREATEPEIMCASECTRL, SG01_Constants.SGA_AP21GETCASESTATES, SG01_Constants.BLANK, Logginglevel.ERROR);}
        return options ;
    }
   

 /**
     * The system class PicklistEntry is not aura enabled so cannot be returned from @AuraEnabled method.
     * Workaround is to define our own class with aura enabled properties.
     */
    public without sharing class PicklistOptionStates {
        
        @AuraEnabled
        public String label { get; set; }
        
        @AuraEnabled
        public String value { get; set; }
        /**
        * The system class PicklistEntry is not aura enabled so cannot be returned from @AuraEnabled method.
        * Workaround is to define our own class with aura enabled properties.
        */
        public picklistOptionStates( String label, String value ) {
            this.label = label;
            this.value = value;
        
        }
    }
    /****************************************************************************************************
    Class Name  : WrpAgentDetails
    Description : This is Inner Class to embed Agent Informations 
    ******************************************************************************************************/
   public with sharing class WrpAgentDetails {
        
        @AuraEnabled
        Public String writingAgentETIN{get;set;}
        @AuraEnabled
        Public String writingAgentName{get;set;}
        @AuraEnabled
        Public String agentId{get;set;}
    
   /********************************************************************************
          Method Name  : WrpApplication()
      Description : Parameterized constructor to intialize WrpApplication
  **********************************************************************************/
    public wrpAgentDetails(String writingAgentETIN,String writingAgentName,String agentId) {
           this.writingAgentETIN=writingAgentETIN;
           this.writingAgentName=writingAgentName;
           this.agentId=agentId;
       }
     
   }
}