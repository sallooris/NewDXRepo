/**
@Description: Apex class to perform custom search on the Account object and retirve account its related opportunity, quote, case, contacts.
@Name : SGA_AP27_SearchController
@Date: 07/24/2017
@Author: IDC offshore Resource
*/ 
public without sharing class SGA_AP27_SearchController
{
    public List<Account> results{get; set;}
    public List<Contact> contactList{get; set;} 
    public List<Case> caseList{get; set;}    
    public List<quote> quoteList{get; set;}
    public List<Opportunity> oppList{get; set;}
    public List<License_Appointment__c> aptList{get; set;}
    public String tinText{get; set;}
    public String einText{get; set;}
    public String nameText{get; set;}
    public map<id, Account> accMap{get; set;}
    public static final string ID_SEARCH = ' ID IN :accountIdSet ';
    public List<Account> accList{get; set;}
    
/**
@Description: Method performs custom search on the Account object and retirve account results.
@Name : doSearch
@Param :    NA
@Return : PageReference
@throws Exception : 
*/ 
    public PageReference doSearch()
    {
        results = new List<Account>();
        contactList = new List<Contact>();
        caseList = new List<Case>();
        quoteList = new List<quote>();
        oppList = new List<Opportunity>();
        aptList = new List<License_Appointment__c>();
        string searchParameter = SG01_Constants.WHERE_CLAUSE;
        accMap = new map<id, Account>();
        accList = new List<Account>();
        
        try
        {
            
            if(tinText != Null && !string.isBlank(tinText))
            {
                searchParameter += SG01_Constants.SPACE+SG01_Constants.ENCRYPTED_TIN_WHERE+String.escapeSingleQuotes(tinText)+SG01_Constants.BACK_SLASH; 
            }
            if(einText != Null && !string.isBlank(einText))
            {
                searchParameter += SG01_Constants.WHERE_CLAUSE.equalsIgnoreCase(searchParameter) ? SG01_Constants.EMPLOYER_EIN_WHERE+String.escapeSingleQuotes(einText)+SG01_Constants.BACK_SLASH : SG01_Constants.OR_EMPLOYER_EIN_WHERE+String.escapeSingleQuotes(einText)+SG01_Constants.BACK_SLASH;                
            }
            if(nameText != Null && !string.isBlank(nameText))
            {
                //searchParameter += SG01_Constants.WHERE_CLAUSE.equalsIgnoreCase(searchParameter) ? SG01_Constants.NAME_LIKE+String.escapeSingleQuotes(nameText)+SG01_Constants.LIKE_SEARCH_END : SG01_Constants.OR_SPACE+SG01_Constants.NAME_LIKE+String.escapeSingleQuotes(nameText)+SG01_Constants.LIKE_SEARCH_END; 
                List<List<SObject>> searchList = [FIND :'\''+nameText+'*\'' IN ALL FIELDS RETURNING Account (Id, Name, Site, BR_Encrypted_TIN__c, Employer_EIN__c, Phone, Owner.Alias, LastModifiedDate, BR_National_Producer_Number__c, License_Number__c) LIMIT 100];
                accList = ((List<Account>)searchList[0]);
                Set<ID> accountIdSet = new Set<ID>();
                for(Account acc : accList)
                {
                    accountIdSet.add(acc.Id);
                }
                SGA_Util01_AccountDataAccessHelper.accountIdSet = accountIdSet;
                searchParameter += SG01_Constants.WHERE_CLAUSE.equalsIgnoreCase(searchParameter) ? ID_SEARCH : SG01_Constants.OR_SPACE+ID_SEARCH;
            }
            if(!SG01_Constants.WHERE_CLAUSE.equalsIgnoreCase(searchParameter)){
                accMap = SGA_Util01_AccountDataAccessHelper.fetchAccountsMap(SG01_Constants.SEARCHACCOUNT_QUERY, searchParameter, SG01_Constants.BLANK, SG01_Constants.LIMIT_100);   
                results.addAll(accMap.values());
            }
            if(!results.isEmpty())
            {
                searchRelated(results);
            }
        }
        catch(exception ex)
        {
            UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_SEARCHCONTROLLER , SG01_Constants.AP_SEARCHCTL_DOSEARCH , SG01_Constants.BLANK, Logginglevel.ERROR);
        }
        
        return Null;
    }
    
/**
@Description: Metod performs custom search on opportunity, quote, case, contacts based on AccountId.
@Name : searchRelated
@Param :   List of Account
@Return : NA
@throws Exception : 
*/  
    private void searchRelated(List<Account> accSearchList)
    {
        set<id> accIdSet=  new set<id>();
        map<id, contact> contactMap  = new map<id, contact>(); 
        map<id, case> caseMap  = new map<id, case>();        
        map<id, quote> quoteMap  = new map<id, quote>();  
        map<id, opportunity> oppMap  = new map<id, opportunity>();        
        
        for(Account acc: accSearchList)
        {
            accIdSet.add(acc.id);
        }
        
        if(!accIdSet.isEmpty())
        {
            SGA_Util13_ContactDataAccessHelper.accIdSet = accIdSet;
            SGA_Util12_CaseDataAccessHelper.accIdSet = accIdSet;  
            SGA_Util08_QuoteDataAccessHelper.accIdSet = accIdSet;  
            SGA_Util07_OpportunityDataAccessHelper.accIdSet = accIdSet;  
            
            contactMap = SGA_Util13_ContactDataAccessHelper.fetchContactMap(SG01_Constants.SEARCH_CONTACT_QUERY, SG01_Constants.WHERE_CLAUSE+SG01_Constants.ACCOUNT_IN, SG01_Constants.BLANK, SG01_Constants.LIMIT_100);
            contactList.addAll(contactMap.values());
                        
            caseMap = SGA_Util12_CaseDataAccessHelper.fetchCaseMap(SG01_Constants.SEARCH_CASE_QUERY, SG01_Constants.WHERE_CLAUSE+SG01_Constants.ACCOUNT_IN, SG01_Constants.BLANK, SG01_Constants.LIMIT_100);
            caseList.addAll(caseMap.values());
                       
            quoteMap = SGA_Util08_QuoteDataAccessHelper.fetchQuoteMap(SG01_Constants.SEARCH_QUOTE_QUERY, SG01_Constants.WHERE_CLAUSE+SG01_Constants.ACCOUNT_IN, SG01_Constants.BLANK, SG01_Constants.LIMIT_100);
            quoteList.addAll(quoteMap.values());
                
            oppMap = SGA_Util07_OpportunityDataAccessHelper.fetchOpportunityMap(SG01_Constants.SEARCH_OPPORTUNITY_QUERY, SG01_Constants.WHERE_CLAUSE+SG01_Constants.ACCOUNT_IN, SG01_Constants.BLANK, SG01_Constants.LIMIT_100);
            oppList.addAll(oppMap.values());
            
            aptList = [select name, BR_External_Id__c, BR_Number__c, BR_State__c, BR_Status__c from License_Appointment__c where BR_Broker__c IN: accIdSet or BR_Agency__c IN: accIdSet  LIMIT 100];
            
        }
    }
    
/**
@Description: Method to clear the Input fields on the Visualforce page.
@Name : clearFields
@Param :    NA
@Return : void
*/ 
    public void clearFields()
    {
        try
        {
            tinText = SG01_Constants.BLANK;
            einText = SG01_Constants.BLANK;
            nameText = SG01_Constants.BLANK;
        }
        catch(exception ex)
        {
            UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, SG01_Constants.CLS_SGA_SEARCHCONTROLLER , SG01_Constants.AP_SEARCHCTL_DOSEARCH , SG01_Constants.BLANK, Logginglevel.ERROR);
        }
    }

}