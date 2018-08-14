/*****************************************************************************************************
* Class Name   : SGA_AP16_InsertQuoteStatusDashboard
* Created Date : 21-June-2017
* Created By   : IDC Offshore
* Description  : Used to insert the Quote Status Dashboard record which is used for my quotes report
* 				  and dashboard creation for community use.
****************************************************************************************************/
public with sharing class SGA_AP16_InsertQuoteStatusDashboard {
    public static final string CLS_INSERTQUOTEDASHBOARD = 'SGA_AP16_InsertQuoteStatusDashboard';
    public static final string METHOD_INSERTQUOTEDASHBOARD = 'insertQuoteStatusDashboard';
    /*****************************************************************************************************
    * Class Name   : insertQuoteStatusDashboard
    * Created Date : 21-June-2017
    * Created By   : IDC Offshore
    * Description  : Used to insert the Quote Status Dashboard record which is used for my quotes report
    * 				  and dashboard creation for community use.
    ****************************************************************************************************/
    public void insertQuoteStatusDashboard(List<Quote> quoteList){
        try{
            List<Quote_Status_Dashboard__c> quoteDashBoardList = new List<Quote_Status_Dashboard__c>();
            for(Quote qObj : quoteList){
                Quote_Status_Dashboard__c qsdObj = new Quote_Status_Dashboard__c();
                qsdObj.Quote__c = qObj.Id;
                quoteDashBoardList.add(qsdObj);
            }
            if(!quoteDashBoardList.isEmpty()){
                Database.Insert(quoteDashBoardList);
            }
        }Catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,CLS_INSERTQUOTEDASHBOARD, METHOD_INSERTQUOTEDASHBOARD, SG01_Constants.BLANK, Logginglevel.ERROR);}
    }
}