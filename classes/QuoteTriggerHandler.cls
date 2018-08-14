/*****************************************************************************************************
 * Class Name   : QuoteTriggerHandler
 * Created Date : 21-June-2017
 * Created By   : IDC Offshore
 * Description  : Used to insert the Quote Status Dashboard record which is used for my quotes report
 * 				  and dashboard creation for community use.
 ****************************************************************************************************/
public with sharing class QuoteTriggerHandler {
    /*****************************************************************************************************
     * Method Name  : onAfterInsert
     * Created Date : 21-June-2017
     * Created By   : IDC Offshore
     * Description  : 1. Used to insert the Quote Status Dashboard record which is used for my quotes report
     * 				  and dashboard creation for community use.
     * 				  2. Used to update quote created/modified date on Account
     *****************************************************************************************************/
    public static void onAfterInsert(List<Quote> quoteList){
        SGA_AP16_InsertQuoteStatusDashboard qsdObj = new SGA_AP16_InsertQuoteStatusDashboard();
        qsdObj.insertQuoteStatusDashboard(quoteList);
        //to update quote created date on account
        SGA_AP28_UpdateLastModifiedDateOnAccount updateLastModObj = new SGA_AP28_UpdateLastModifiedDateOnAccount();
        updateLastModObj.handlerUtilInsertUpdate(quoteList);
    }
    
    /*****************************************************************************************************
     * Method Name  : onAfterUpdate
     * Created Date : 8-Aug-2017
     * Created By   : IDC Offshore
     * Description  : Used to update quote last modified date on Account
     *****************************************************************************************************/
    public static void onAfterUpdate(List<Quote> quoteList){
        SGA_AP28_UpdateLastModifiedDateOnAccount updateLastModObj = new SGA_AP28_UpdateLastModifiedDateOnAccount();
        updateLastModObj.handlerUtilInsertUpdate(quoteList);
    }
    
    
}