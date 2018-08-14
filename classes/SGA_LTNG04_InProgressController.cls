/************************************************************************************************
Class Name   : SGA_LTNG04_InProgressController
Created Date : 4/25/2017
Created By   : IDC Offshore
Description  :  1. Apex Controller to handle In SGA_LTNG04_InProgressQuotes Component
2. Used to get the In Process Quotes details for the particular record and construct
the SGA_LTNG04_InProgressController list and return back to component.
**************************************************************************************************/
public with sharing class SGA_LTNG04_InProgressController { 
    public Account acct{get;set;}
/****************************************************************************************************
Method Name : SGA_LTNG04_InProgressController
Parameters  : ApexPages.StandardController
Return type : 
Description : This is Parameterized Constructor to intialize Account data
******************************************************************************************************/
public sga_LTNG04_InProgressController(ApexPages.StandardController controller) {
        this.acct = (Account)controller.getRecord();
}
    
    @AuraEnabled
    /****************************************************************************************************
    Method Name : getInProcessQuotesList
    Parameters  : String accId 
    Return type : List<vlocity_ins__OmniScriptInstance__c>
    Description : This method is used to fetch the Quotes record based on Account Id,OmniScriptType,SubType
    ******************************************************************************************************/
    public static List<vlocity_ins__OmniScriptInstance__c> getInProcessQuotesList(String accId) {
        
        List<vlocity_ins__OmniScriptInstance__c> savedOmniscripts = new List<vlocity_ins__OmniScriptInstance__c>();
        List<string> StatusList= new List<string>();
        StatusList.add(SG01_Constants.STATUSCANCELLED); 
        StatusList.add(SG01_Constants.STATUSINPROGRESS);
        try {
            savedOmniscripts= SGA_LTNG03_AccountRelatedListQueryHelper.getInProcessQuotesList(SG01_Constants.ACCOUNT,SG01_Constants.STATUSINPROGRESS,StatusList,
                                                                                              SG01_Constants.SUBTYPE_NEWYORK1,SG01_Constants.SG_QUOTING,accId);
        }Catch(Exception ex) { UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,SG01_Constants.CLS_SGA_LTNG04_INPROGRESSCONTROLLER,SG01_Constants.INPROCESSQUOTESLIST, SG01_Constants.BLANK, Logginglevel.ERROR);}
        return savedOmniscripts;
    }
    /****************************************************************************************************
    Method Name : cancelInProgressQuotes
    Parameters  : String accId String Aid
    Return type : List<vlocity_ins__OmniScriptInstance__c>
    Description : This method is used to fetch the Applications record based on Account Id and OmniScriptType
    ******************************************************************************************************/
     @AuraEnabled
    public static List<vlocity_ins__OmniScriptInstance__c> cancelInProgressQuotes(vlocity_ins__OmniScriptInstance__c Rec,String accId) {
        List<vlocity_ins__OmniScriptInstance__c> savedOmniscripts =new List<vlocity_ins__OmniScriptInstance__c>();   
        try{
            Rec.vlocity_ins__Status__c = SG01_Constants.STATUSCANCELLED;
            Database.update(Rec);
            savedOmniscripts=getInProcessQuotesList(accId);
        }
        catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_LTNG04_INPROGRESSCONTROLLER, SG01_Constants.INPROCESSQUOTESLIST, SG01_Constants.BLANK, Logginglevel.ERROR);}   
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
        }Catch(Exception ex){ UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_LTNG04_INPROGRESSCONTROLLER, SG01_Constants.GETCURRENTUSERPROFILE, SG01_Constants.BLANK, Logginglevel.ERROR);}
        
        return profileName;
    }
}