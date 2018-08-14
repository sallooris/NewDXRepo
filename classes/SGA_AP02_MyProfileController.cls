/**********************************************************************************
Class Name :   SGA_AP02_MyProfileController
Date Created : 10-April-2017
Created By   : IDC Offshore
Description  : 1. This class is used in SGA_Ltng03_Quote_Omniscript.cmp (lightning component)
2. This class is used to fetch logged in user details.
Change History : 
*************************************************************************************/
public without sharing class SGA_AP02_MyProfileController {
    
    @AuraEnabled
    /****************************************************************************************************
    Method Name : getUsersContactId
    Parameters  : None
    Return type : Strind
    Description : This method is used to fetch the logged in user contact id.
    ******************************************************************************************************/
    public static String getUsersContactId() {
        String strUrl = null;
        try{
            User usr = [SELECT Id, Name, ContactId From User WHERE Id=:UserInfo.getUserId() LIMIT 1];
            if(usr.ContactId!=null){
                strUrl = SG01_Constants.CONTACT_PREFIX+usr.ContactId;
            }else{
                strUrl = SG01_Constants.DETAIL_PREFIX+usr.Id;
            } 
        }catch(Exception ex){ UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_AP02_MYPROFILECONTROLLER,SG01_Constants.GETUSERSCONTACTID, SG01_Constants.BLANK, Logginglevel.ERROR); }
        return strUrl;
    }
}