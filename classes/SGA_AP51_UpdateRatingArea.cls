/*
* Class Name   : SGA_AP51_UpdateRatingArea
* Created Date : 25-09-2015 (dd/mm/yyyy)
* Created By   : IDC Offshore
* Description  :  1.Handler class to populate the Rating Area Based on State and ZipCode
*                
**/
public without sharing class SGA_AP51_UpdateRatingArea {
    private static final string BLANK = '';
    private static Set<String> stateZipSet=new set<String>();
    private static Set<String> stateCountySet=new set<String>();
    private static Map<String,String> ratingAreaMap= new Map<String,String> ();
    private static Map<String,String> ratingAreaCountyMap= new Map<String,String> ();
    private static final string CLS_SGA_AP51_UpdateRatingArea = 'SGA_AP51_UpdateRatingArea';
    private static final string AP51_populateRatingArea = 'populateRatingArea';
    /************************************************************************************
Method Name : populateRatingArea
Parameters  : Map<Id,Account> newAccMap
Return type : void
Description : populates the Rating Area Based on State and ZipCode

*************************************************************************************/ 
    public static void populateRatingArea(List<Account> newAccList) {
        try{
        for(Account acc:newAccList){
            
            if(acc.Company_State__c != null && acc.Company_Zip__c!= null){
                if(acc.County__c != null) {
                    stateCountySet.add(acc.Company_State__c+'-'+acc.Company_Zip__c+'-'+acc.County__c);
                } else {
                    stateZipSet.add(acc.Company_State__c+'-'+acc.Company_Zip__c);    
                }
            }
            
        }
        if(!stateZipSet.isEmpty()){
            fetchRatingMap();
        }
        if(!stateCountySet.isEmpty()){
            fetchRatingMap();
        }
        if(!ratingAreaMap.isEmpty()){
            updateAccountArea(newAccList);
        }
        if(!ratingAreaCountyMap.isEmpty()){
            updateAccountArea(newAccList);
        }
        }
       Catch(Exception ex) { UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, CLS_SGA_AP51_UpdateRatingArea, AP51_populateRatingArea, SG01_Constants.BLANK, Logginglevel.ERROR);}
    }
    
    
    /************************************************************************************
Method Name : fetchRatingMap
Parameters  : Map<Id,Account> newAccMap
Return type : void
Description : 
1)Fetches the Rating Area Based on State and ZipCode from Custom Setting

*************************************************************************************/ 
    private static void fetchRatingMap(){
        List<Geographical_Info__c> gList= new List<Geographical_Info__c> ();
        gList = [Select State__c, Zip_Code__c,Tech_Zipcode_State__c,Tech_Zip_State_County__c,RatingArea__c from Geographical_Info__c where Tech_Zipcode_State__c IN:stateZipSet OR Tech_Zip_State_County__c IN:stateCountySet];
        for(Geographical_Info__c g:gList){
            ratingAreaMap.put(g.Tech_Zipcode_State__c, string.valueOf(g.RatingArea__c));
            ratingAreaCountyMap.put(g.Tech_Zip_State_County__c, string.valueOf(g.RatingArea__c));
        }
        
    }
    /************************************************************************************
Method Name : updateAccountArea
Parameters  : accList
Return type : void
Description : 
1)Updates the account with rating area

*************************************************************************************/     
    private static void updateAccountArea(List<Account> accList){
        for(Account a:accList){
            if(ratingAreaCountyMap.containsKey(a.Company_State__c+'-'+a.Company_Zip__c+'-'+a.County__c)){
                a.Rating_Area__c = ratingAreaCountyMap.get(a.Company_State__c+'-'+a.Company_Zip__c+'-'+a.County__c);
            }
            else if(ratingAreaMap.containsKey(a.Company_State__c+'-'+a.Company_Zip__c)){
                   a.Rating_Area__c = ratingAreaMap.get(a.Company_State__c+'-'+a.Company_Zip__c);
            }
         }
    }
}