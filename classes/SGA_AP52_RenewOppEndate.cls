/************************************************************************
Class Name   : SGA_AP52_RenewOppEndate
Date Created : 09-OCT-2017
Created By   : IDC Offshore
Description  : Apex Class to populate Effective Date for a renewal opportunity 
                should autopopulate as one year after the previous year’s effective date
******************************************************************************************/
public class SGA_AP52_RenewOppEndate
{
     public static final string CLS_AP52_RenewOppEndate = 'SGA_AP52_RenewOppEndate';
     public static final string UPDATEENDATE = 'updateEndate';
    /****************************************************************************************************
    Method Name : updateEndate
    Parameters  : List<Opportunity> oppNewList
    Return type : void
    Description : Method
    *****************************************************************************************************/
    public static void updateEndate(List<Opportunity> oppNewList)
    {
        try
        {
            set<Id> accIdSet = new set<Id>();
            Date TempEffDate = NULL;
            
            for(Opportunity opp: oppNewList)
            {
                if(opp.AccountId != NULL && opp.Type == Label.SG91_Renewal)
                {
                    accIdSet.add(opp.AccountId);
                }
            }
            Map<ID,Account> accMap = new Map<ID,Account>([select Id,(select Id,Effective_Date__c from Opportunities Order By Effective_Date__c DESC LIMIT 1) 
                                     from Account where ID IN:accIdSet LIMIT 50000]);
            
            for(Opportunity opp : oppNewList)
            {
                if(String.isNotBlank(opp.AccountId) && opp.Type == Label.SG91_Renewal){
                    Account accObj = accMap.get(opp.AccountId);
                    List<Opportunity> oldOppList = accObj.opportunities;
                    if(oldOppList != NULL && !oldOppList.isEmpty()){
                        Date tempEffectiveDate = oldOppList[0].Effective_Date__c; 
                        opp.Effective_Date__c = tempEffectiveDate != NULL ? tempEffectiveDate.addYears(1) : tempEffectiveDate ;
                    }
                }               
            }
        }
        catch(exception ex)
        {UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME, CLS_AP52_RenewOppEndate, UPDATEENDATE, SG01_Constants.BLANK,Logginglevel.ERROR);}
    }
    
}