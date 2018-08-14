/*
* Class Name   : SGA_LTNG07_InProgressApplicationsCtrl
* Created Date : 5/5/2017
* Created By   : IDC Offshore
* Description  :  1. Apex Controller to handle In SGA_LTNG07_OmpniInProgressApplications Component
*                 2. Used to get the In Process Application details for the particular record and construct
*                    the vlocity_ins__OmniScriptInstance__c list and return back to component.
**/
public with sharing class SGA_LTNG07_InProgressApplicationsCtrl { 

public Account acct{get;set;}
   
/****************************************************************************************************
Method Name : sga_LTNG07_InProgressApplicationsCtrl
Parameters  : ApexPages.StandardController
Return type : 
Description : This is Parameterized Constructor to intialize Account data
******************************************************************************************************/
    public sga_LTNG07_InProgressApplicationsCtrl(ApexPages.StandardController controller) {
        this.acct = (Account)controller.getRecord();
    }
    
    @AuraEnabled
    /****************************************************************************************************
Method Name : inProgressApplications
Parameters  : String accId
Return type : List<vlocity_ins__OmniScriptInstance__c>
Description : This method is used to fetch the Applications record based on Account Id and OmniScriptType
******************************************************************************************************/
    public static List<vlocity_ins__OmniScriptInstance__c> inProgressApplications(String accId) {
        List<vlocity_ins__OmniScriptInstance__c> savedOmniscripts = new List<vlocity_ins__OmniScriptInstance__c>();
        List<vlocity_ins__OmniScriptInstance__c> savedOmniscripts1 = new List<vlocity_ins__OmniScriptInstance__c>();
        List<vlocity_ins__OmniScriptInstance__c> savedOmniscripts2 = new List<vlocity_ins__OmniScriptInstance__c>();
        List<string> statusList= new List<string>();
        statusList.add(SG01_Constants.STATUSCANCELLED); 
        statusList.add(SG01_Constants.STATUSINPROGRESS);
        try {
            if(!String.isBlank(accId)) {
                //call applications for SUBTYPE= ENROLLMENT and TYPE= SG Quoting 
                savedOmniscripts1= SGA_LTNG03_AccountRelatedListQueryHelper.getInProcessQuotesList(SG01_Constants.ACCOUNT,SG01_Constants.STATUSINPROGRESS,statusList,SG01_Constants.SUBTYPE_ENROLLMENT,SG01_Constants.SG_QUOTING,accId);
                //call applications for SUBTYPE= New_York and TYPE= ENROLLMENT  
                savedOmniscripts2= SGA_LTNG03_AccountRelatedListQueryHelper.getInProcessQuotesList(SG01_Constants.ACCOUNT,SG01_Constants.STATUSINPROGRESS,statusList,SG01_Constants.SUBTYPE_NEWYORK1,SG01_Constants.TYPE_ENROLLMENT,accId);
            //prepare final list to be displayed combining both
               if(!savedOmniscripts1.isEmpty()){
                    savedOmniscripts.addAll(savedOmniscripts1); 
               }
               if(!savedOmniscripts2.isEmpty()){
                    savedOmniscripts.addAll(savedOmniscripts2); 
               }
                    
            }
        } Catch(Exception ex) { UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_LTNG07_INPROGRESSAPPCTRL, SG01_Constants.INPROCESSQUOTESLIST, SG01_Constants.BLANK, Logginglevel.ERROR); }
        
        return savedOmniscripts;
    }

/****************************************************************************************************
Method Name : cancelInProgressApplications
Parameters  : String accId String Aid
Return type : List<vlocity_ins__OmniScriptInstance__c>
Description : This method is used to fetch the Applications record based on Account Id and OmniScriptType
******************************************************************************************************/
    @AuraEnabled
    public static List<vlocity_ins__OmniScriptInstance__c> cancelInProgressApplications(vlocity_ins__OmniScriptInstance__c Rec,String accId) {
        List<vlocity_ins__OmniScriptInstance__c> savedOmniscripts =new List<vlocity_ins__OmniScriptInstance__c>();   
        try{
            Rec.vlocity_ins__Status__c = SG01_Constants.STATUSCANCELLED;
            Database.update(Rec);
            savedOmniscripts=inProgressApplications(accId);
        }
        catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_LTNG07_INPROGRESSAPPCTRL, SG01_Constants.INPROCESSQUOTESLIST, SG01_Constants.BLANK, Logginglevel.ERROR);}   
        return savedOmniscripts;
     }
    
/****************************************************************************************************
    Method Name : getCurrentUserProfile
    Parameters  : None
    Return type : String
    Description : This method is used to fetch the current Logged In user Profile and returns Profile Name
    ******************************************************************************************************/
     @AuraEnabled
    public static String getCurrentUserProfile() {
        String profileName='';
        Try{
            Map<Id,Profile> profileMap=new Map<Id,Profile>();
        // Select clause for Profile            
        String appSelectClause=SG01_Constants.PROFILE_QUERY;
        // Where clause for Profile
        String profileWhereClause = SG01_Constants.WHERE_CLAUSE+SG01_Constants.SPACE+SG01_Constants.ID+SG01_Constants.EQUALS_SLASH+String.escapeSingleQuotes(userinfo.getProfileId())+SG01_Constants.BACK_SLASH; 
        // fetch the Profile details from SGA_Util10_ProfileDataAccessHelper
        profileMap = SGA_Util10_ProfileDataAccessHelper.fetchProfileMap(appSelectClause,profileWhereClause,SG01_Constants.BLANK,SG01_Constants.LIMIT_1 );
                if(!profileMap.isEmpty() ){
                 profileName = profileMap.get(userinfo.getProfileId()).Name;    
                }
        }Catch(Exception ex){ UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_LTNG07_INPROGRESSAPPCTRL, SG01_Constants.GETCURRENTUSERPROFILE, SG01_Constants.BLANK, Logginglevel.ERROR);}
        
        return profileName;
    }

}