/*************************************************************
Class Name   : E2C_EmailViewOverrideCtrl
Date Created : 28-JUL-2016
Created By   : Wendy Kelley
Description  : Controller class for E2C_EmailViewOverride page
*****************************************************************/
public with sharing class E2C_EmailViewOverrideCtrl {
    
    transient EmailMessage emailMessageRec {get; set;}
    public Case caseRec = null;
    public String redirectUrl {get; set;}

    /*
    Method Name : Controller
    Parameter   : ApexPages.StandardController
    */
    public E2C_EmailViewOverrideCtrl(ApexPages.StandardController stdController) {
    
        if(!Test.isRunningTest()) {
            stdController.addFields( new String[] {'ParentId', 'Parent.CaseNumber'});
        }
        this.emailMessageRec = (EmailMessage) stdController.getRecord();

        this.caseRec = [Select Id, BR_Tech_Case_RoutingAddress__c, Contact.Id, Contact.Email, SuppliedEmail from Case where Id = :emailMessageRec.ParentId];
    }

    /*
    Method Name : reply
    Parameter   : none
    Return type : PageReference
    Description : This method is used to refer to SF standard Reply page for Email Messages
    */
    public PageReference reply() {
        PageReference pg = new PageReference(E2C_Util_SendEmail.buildSendEmailURL(caseRec, new List<String> {'replyToAll=0'}));
        redirectURL = pg.getURL();
        //System.debug('$$$redirectURL----' + redirectURL);
        return null;
    }

    /*
    Method Name : replyToAll
    Return type : PageReference
    Description : This method is used to refer to SF standard Reply page for Email Messages, sets 'replyToAll' parameter to 1
    */
    public PageReference replyToAll() {
        PageReference pg = new PageReference(E2C_Util_SendEmail.buildSendEmailURL(caseRec, new List<String> {'replyToAll=1'}));
        redirectURL = pg.getURL();
        //System.debug('$$$redirectURL----' + redirectURL);
        return null;
    }

    /*
    Method Name : forward
    Return type : PageReference
    Description : This method is used to refer to SF standard Reply page for Email Messages, sets 'foward' parameter to 1
    */
    public PageReference forward() {
        PageReference pg = new PageReference(E2C_Util_SendEmail.buildSendEmailURL(caseRec, new List<String> {'forward=1'}));
        redirectURL = pg.getURL();
        //System.debug('$$$redirectURL----' + redirectURL);
        return null;
    }
}