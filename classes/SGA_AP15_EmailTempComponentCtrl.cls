/*
* Class Name   : SGA_AP15_EmailTempComponentCtrl
* Created Date : 20/05/2017
* Created By   : IDC Offshore
* Description  :  1. Apex Controller to handle In SGA_C01_ApplicationEmailComponent Component
*                 2. Fetches the value for BRAND from Quote record.
**/
public with Sharing class SGA_AP15_EmailTempComponentCtrl {
    public String appId{get;set;}
    public Quote infoQuote = NULL;
    public vlocity_ins__Application__c app = NULL;
    public Opportunity opp  = NULL;
    
/****************************************************************************************************
    Method Name : getBrand
    Parameters  : NONE
    Return type : String
    Description : Fetches the value for BRAND from Quote record for the related Application.
******************************************************************************************************/
    public String getBrand(){
        String brandToSend =SG01_Constants.BLANK;
        try{
            if(appId != NULL ){
                vlocity_ins__Application__c appObj = [select ID,vlocity_ins__AccountId__r.Company_Zip__c from vlocity_ins__Application__c where ID=:appId];
                String companyZip = appObj.vlocity_ins__AccountId__r.Company_Zip__c != NULL ? appObj.vlocity_ins__AccountId__r.Company_Zip__c : SG01_Constants.BLANK;
                if(String.isNotBlank(companyZip)){
                    List<Geographical_Info__c> geoList = [select Name from Geographical_Info__c where Zip_Code__c =:companyZip LIMIT 1];
                    if(geoList != NULL && !geoList.isEmpty()){
                        brandToSend = geoList[0].Name;
                        return brandToSend;
                    }
                }
                Map<Id,vlocity_ins__Application__c> applicationMap = new  Map<Id,vlocity_ins__Application__c>();
                applicationMap =getApplicationDetails(appId);
                if( !applicationMap.isEmpty()) {
                    app=applicationMap.get(appId);
                }  
                if( app != NULL && !String.isBlank(app.vlocity_ins__AccountId__c)){
                    
                    Map<Id,Opportunity> OpportunityMap =getOpportuntiyDetails(app.vlocity_ins__AccountId__c);
                    if(!OpportunityMap.isEmpty()){
                        opp=OpportunityMap.values()[0];
                    }
                }       
                if(opp != NULL ){
                    Map<Id,Quote> existingQuoteMap=getQuoteDetails(opp.Id);
                    if (!existingQuoteMap.isEmpty()) {
                        infoQuote = new Quote();
                        infoQuote = existingQuoteMap.values()[0];
                        
                        if(!String.isBlank(infoQuote.Brand__c) && infoQuote.Brand__c!=NULL ){
                            brandToSend=infoQuote.Brand__c;
                        }
                    } 
                }
            }
        }Catch(Exception ex){ UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_AP15_EMAILTEMPCOMPONETCTRL, SG01_Constants.SGA_AP15_GETBRAND, SG01_Constants.BLANK, Logginglevel.ERROR);}
        return brandToSend;
    }
    
/****************************************************************************************************
    Method Name : getApplicationDetails
    Parameters  : Id
    Return type : Map<Id,vlocity_ins__Application__c>
    Description : provides the Map<Id,vlocity_ins__Application__c> based on application Id.
******************************************************************************************************/
    public static Map<Id,vlocity_ins__Application__c> getApplicationDetails(Id apId){ 
        Map<Id,vlocity_ins__Application__c> appMapToSend = New Map<Id,vlocity_ins__Application__c>();
		Try{
			// Select clause for Application            
        String appSelectClause=SG01_Constants.CLS_SGA_AP15_APPLICATIONOBJQUERY;
        // Where clause for Application
        String appWhereClause = SG01_Constants.WHERE_CLAUSE+SG01_Constants.SPACE+SG01_Constants.ID+SG01_Constants.EQUALS_SLASH+String.escapeSingleQuotes(apId)+SG01_Constants.BACK_SLASH; 
        
        // fetch the Application details from SGA_Util03_ApplicationDataAccessHelper
        appMapToSend = SGA_Util03_ApplicationDataAccessHelper.fetchApplicationMap(appSelectClause,appWhereClause,SG01_Constants.BLANK,SG01_Constants.LIMIT_1 );
		}Catch(Exception ex){ UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_AP15_EMAILTEMPCOMPONETCTRL, SG01_Constants.SGA_AP15_GETAPPLICATIONDETAILS, SG01_Constants.BLANK, Logginglevel.ERROR);}
        
        return appMapToSend;
    }

/****************************************************************************************************
    Method Name : getOpportuntiyDetails
    Parameters  : Id
    Return type : Map<Id,Opportunity>
    Description : provides the Map<Id,Opportunity> based on AccountId.
******************************************************************************************************/
    public static Map<Id,Opportunity> getOpportuntiyDetails(Id acId){  
        Map<Id,Opportunity> oppMapToSend= new Map<Id,Opportunity>();
		Try{
			// Select clause for Opportunity
        String oppSelectClause =SG01_Constants.OPPORTUNITY_QUERY;
        // Where clause for Opportunity
        String oppWhereClause = SG01_Constants.WHERE_CLAUSE+SG01_Constants.SPACE+SG01_Constants.ACCOUNTID+SG01_Constants.EQUALS_SLASH+String.escapeSingleQuotes(acId)+SG01_Constants.BACK_SLASH;
        
        //Fetch Opportunity record from SGA_Util07_OpportunityDataAccessHelper
        oppMapToSend = SGA_Util07_OpportunityDataAccessHelper.fetchOpportunityMap(oppSelectClause,oppWhereClause,SG01_Constants.BLANK,SG01_Constants.LIMIT_1);
		}Catch(Exception ex){ UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_AP15_EMAILTEMPCOMPONETCTRL, SG01_Constants.SGA_AP15_GETOPPORTUNITYDETAILS, SG01_Constants.BLANK, Logginglevel.ERROR);} 
        return oppMapToSend;
    }
    
/****************************************************************************************************
    Method Name : getQuoteDetails
    Parameters  : Id
    Return type :  Map<Id,Quote>
    Description : provides the Map<Id,Quote> based on OpportunityId.
******************************************************************************************************/
    public static Map<Id,Quote> getQuoteDetails(Id opId){
        Map<Id,Quote> quoteMapToSend= new Map<Id,Quote>();
        Try{
			// Select clause for Quote
        String quoteSelectClause =SG01_Constants.QUOTE_QUERY;
        // Where clause for Quote  
        String quoteWhereClause = SG01_Constants.WHERE_CLAUSE+SG01_Constants.SPACE+SG01_Constants.OPPORTUNITYID+SG01_Constants.EQUALS_SLASH+String.escapeSingleQuotes(opId)+SG01_Constants.BACK_SLASH;
        
        //Fetch recently created Quote record from SGA_Util08_QuoteDataAccessHelper 
        quoteMapToSend= SGA_Util08_QuoteDataAccessHelper.fetchQuoteMap(quoteSelectClause,quoteWhereClause,SG01_Constants.QUOTE_QUERY_2,SG01_Constants.LIMIT_1);
		}Catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_AP15_EMAILTEMPCOMPONETCTRL, SG01_Constants.SGA_AP15_GETQUOTEDETAILS, SG01_Constants.BLANK, Logginglevel.ERROR);}		
        return quoteMapToSend;
    } 
}