/*
* Class Name   : SGA_LTNG05_ViewApplicationsController
* Created Date : 4/25/2017
* Created By   : IDC Offshore
* Description  :  1. Apex Controller to handle In SGA_LTNG05_CompletedApplications Component
*                 2. Used to get the In Submitted Application details for the particular record and construct
*                    the WrpApplication list and return back to component.
**/
public with sharing class SGA_LTNG05_ViewApplicationsController {
    /****************************************************************************************************
    Method Name : SGA_LTNG05_CompletedApplicationList 
    Parameters  : String accId
    Return type : List<WrpApplication>
    Description : This method is used to fetch the Completed Application record based on AccountId and retruns as a List of WrpApplication
    ******************************************************************************************************/
    @AuraEnabled
    public static List<wrpApplication> completedApplicationList (String accId) {
        WrpApplication[]  wrpApplicationList= new List<WrpApplication>();
       //Details to get list of wrpApplication based on AccountId
         Try{
          Map<Id,Id> partyIdAccountMap= new Map<Id,Id>();
          
          List<vlocity_ins__Application__c> appList=new List<vlocity_ins__Application__c>();
        
          Map<Id,Account> idAccountMap = SGA_LTNG03_AccountRelatedListQueryHelper.getSGACurrentAccountDetails(accId);
       // System.debug('idAccountMap in completedApplicationList::>'+idAccountMap);
        if(idAccountMap!=NULL && !idAccountMap.isEmpty()) {
            Id partyId=idAccountMap.get(accId).vlocity_ins__PartyId__c;
           // System.debug('partyId::>'+partyId);
            partyIdAccountMap.put(partyId,accId);
            appList = SGA_LTNG03_AccountRelatedListQueryHelper.getSGAApplicationList(partyId);
            
        }
        // check if Application Status is Enrollment Complete and populate wrpApplicationList
        if(appList!= NULL && !appList.isEmpty()){
            for(vlocity_ins__Application__c  ap:appList){
                if(!String.isBlank(ap.vlocity_ins__Status__c) && ap.vlocity_ins__Status__c.contains(SG01_Constants.STATUSINENROLLMENTCOMPLETED)) {
                    wrpApplicationList.add(new WrpApplication(ap.Name,idAccountMap.get(accId).Name,ap.vlocity_ins__Status__c,ap.Coverage_Option__c,ap.Group_Coverage_Date__c,Integer.valueof(ap.Member_Count__c),ap.WritingAgentETIN__c,ap.Id));  
                }
            } 
           }       
         } 
          Catch(Exception ex){
           // System.debug('***Exception in completedApplicationList*** Line Number::'+ex.getLineNumber()+':::Message:::'+ex.getMessage());
            UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_LTNG05_VIEWAPPLICATIONSCONTROLLER, SG01_Constants.COMPLETEDAPPLICATIONLIST, SG01_Constants.BLANK, Logginglevel.ERROR);
         }
         
        return wrpApplicationList; 
    }
        
    /****************************************************************************************************
    Class Name  : WrpApplication
    Description : This is Inner Class to embed Applications and Account Informations together 
    ******************************************************************************************************/
   public with sharing class WrpApplication {
        
        @AuraEnabled
        Public String ApplicationName {get;set;}
        @AuraEnabled
        Public String GroupAccountName{get;set;}
        @AuraEnabled
        Public String Status {get;set;}
        @AuraEnabled
        Public String CoverageOptions{get;set;}
        @AuraEnabled
        Public Date EffectiveDate{get;set;}
        @AuraEnabled
        Public Integer MemberCount {get;set;}
        @AuraEnabled
        Public String WritingAgentName{get;set;}
        @AuraEnabled
        Public Id appId{get;set;}
        
      /********************************************************************************
          Method Name  : WrpApplication()
          Description : Parameterized constructor to intialize WrpApplication
      **********************************************************************************/
      public WrpApplication(String ApplicationName,String GroupAccountName,String Status,String CoverageOptions,Date EffectiveDate,Integer MemberCount,String WritingAgentName,Id appId){
           this.ApplicationName=ApplicationName;
           this.GroupAccountName=GroupAccountName;
           this.Status=Status;
           this.CoverageOptions=CoverageOptions;
           this.EffectiveDate=EffectiveDate;
           this.MemberCount=MemberCount;
           this.WritingAgentName=WritingAgentName;
           this.appId=appId;
       }
             
    }
    
}