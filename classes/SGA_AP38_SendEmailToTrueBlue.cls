/*************************************************************************************
 * Class Name  : SGA_AP38_SendEmailToTrueBlue
 * CratedDate  : 08/24/2017
 * Created By  : IDC Offshore
 * Description : This is used to send an email to true blue team
 * 				 when the category = Other Department and sub category = true blue
 *************************************************************************************/
public without sharing class SGA_AP38_SendEmailToTrueBlue {
    public static final string AGENCY_BROKER_NAME = '#AGENCY_BROKER_NAME#';
    public static final string CREATED_DATE = '#CREATED_DATE#';
    public static final string AGENCY_BROKER_ACC_NAME = '#AGENCY_BROKER_ACC_NAME#';
    public static final string AGENCY_BROKER_ETIN = '#AGENCY_BROKER_ETIN#';
    public static final string AGENCY_BROKER_NPN = '#AGENCY_BROKER_NPN#';
    public static final string CONTACT_NAME = '#CONTACT_NAME#';
    public static final string CONTACT_EMAIL = '#CONTACT_EMAIL#';
    public static final string CONTACT_PHONE = '#CONTACT_PHONE#';
    public static final string STATE_VALUE = '#STATE_VALUE#';
    public static final string LOB_VALUE = '#LOB_VALUE#';
    public static final string GROUP_ACC_NAME = '#GROUP_ACC_NAME#';
    public static final string APPL_NAME = '#APPL_NAME#';
    public static final string QUOTE_NAME = '#QUOTE_NAME#';
    public static final string MEMBER_COUNT = '#MEMBER_COUNT#';
    public static final string EFFECTIVE_DATE = '#EFFECTIVE_DATE#';
    public static final string ISSUE_DESCRIPTION = '#ISSUE_DESCRIPTION#';
    public static final string NOTES_COMMENTS = '#NOTES_COMMENTS#';
    public static final string CASE_COMMENTS = '#CASE_COMMENTS#';
    public static final string CHATTER_POSTS = '#CHATTER_POSTS#';
    public static final string EMAIL_LIST = '#EMAIL_LIST#';
    public static final string CASE_NUMBER = '#CASE_NUMBER#';
	public static final string BLANK_VALUE = '';
    public static final string BREAK_VALUE = '<br/>';
    public static final string START_BOLD_VALUE = '<b>';
    public static final string END_BOLD_VALUE = '</b>';
    public static final string BODY = 'Body:';
    public static final string TITLE = 'Title:';
    public static final string COMMENT_BODY = 'Comment Body:';
    public static final string TEXT_POST = 'TextPost';
    public static final string CHATTER_POST = 'Chatter Post:';
    public static final string EMAIL_MESSAGE = 'Email Message:';
    public static final string SUBJECT = 'Subject:';
    public static final string SENDER = 'Sender:';
    public static final string MAIL_BODY = 'Email Body:';
    public static final string EMAIL_TEMPLATE_NAME = 'SGA18_Case_Email_Notification_to_True_Blue';
    public static final string CLS_SGA_AP38_SENDMAILTOTRUEBLUE = 'SGA_AP38_SendEmailToTrueBlue';
    public static final string METHOD_FETCHTRUEBLUECASE = 'fetchTrueBlueCases';
    Map<String,String> caseNotesMap = new Map<String,String>();
    Map<String,String> caseCommentsMap = new Map<String,String>();
    Map<String,String> feedItemMap = new Map<String,String>();
    Map<String,String> caseEmailMessageMap = new Map<String,String>();
    Map<String,List<String>> caseAttachmentMap = new Map<String,List<String>>();
    Map<String,List<String>> caseIdQuoteDocIdMap = new Map<String,List<String>>();
    Map<String,List<String>> caseContentVersionMap = new Map<String,List<String>>();
    /*************************************************************************************
     * Method Name : fetchTrueBlueCases
     * CratedDate  : 08/24/2017
     * Parameters  : Map<ID, Case>,Map<ID, Case>
     * Return Type : Void
     * Description : This is used to send fetch the true blue case ids
     *************************************************************************************/
    public void fetchTrueBlueCases(Map<ID, Case> newCaseMap, Map<ID, Case> oldCaseMap){
        try{
            Set<String> trueBlueCases = new Set<String>();
            for(Case caseObj : newCaseMap.values()){
                if((caseObj.BR_Category__c != oldCaseMap.get(caseObj.Id).BR_Category__c && System.Label.SG66_OtherDepartment.equalsIgnoreCase(caseObj.BR_Category__c) && 
                   System.Label.SG67_TrueBlue.equalsIgnoreCase(caseObj.BR_Sub_Category__c) ) || (caseObj.BR_Sub_Category__c != oldCaseMap.get(caseObj.Id).BR_Sub_Category__c && 
                   System.Label.SG66_OtherDepartment.equalsIgnoreCase(caseObj.BR_Category__c) && System.Label.SG67_TrueBlue.equalsIgnoreCase(caseObj.BR_Sub_Category__c))){
                       trueBlueCases.add(caseObj.Id);
                   }
            }
            if(!trueBlueCases.isEmpty()){
                sendEmailToTrueBlue(trueBlueCases);
            }
        }Catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,CLS_SGA_AP38_SENDMAILTOTRUEBLUE, METHOD_FETCHTRUEBLUECASE, SG01_Constants.BLANK, Logginglevel.ERROR);}
    }
    /*************************************************************************************
     * Method Name : sendEmailToTrueBlue
     * CratedDate  : 08/24/2017
     * Parameters  : Set<String>
     * Return Type : Void
     * Description : This is used to send an email to true blue team
     * 				 when the category = Other Department and sub category = true blue
     *************************************************************************************/
    private void sendEmailToTrueBlue(Set<String> CaseIds){
        List<Case> caseList = [select Id,CaseNumber,Contact.Name,CreatedDate,Contact.Account.Name,Contact.ETIN__c,
                               Contact.vlocity_ins__NPNNumber__c,Contact.Email,Contact.Phone,BR_State__c,BR_Line_of_Business__c,Account.Name,
                               Quote_Name__r.Name,Quote_Name__c,Application_Name__r.Name,Application_Name__c,Member_Count__c,Effective_Date__c,Description from Case where ID IN :CaseIds];
		String userType = Schema.SObjectType.User.getKeyPrefix();
        String groupType = Schema.SObjectType.Group.getKeyPrefix();
        ID grpId = [select id from group where name = :System.Label.SG68_TrueBlueTeamGroup].Id;
        List<String> userIds = new List<String>();
        List<String> emailList = new List<String>();

        for(GroupMember groupMember  :  [Select Id, UserOrGroupId From GroupMember Where GroupId = :grpId]){
            if (((String)groupMember.UserOrGroupId).startsWith(userType)){userIds.add(groupMember.UserOrGroupId);}
        }
        for(User userObj : [select Email from User where Id IN :userIds]){
            emailList.add(userObj.Email);
        }
        constructCaseNotesMap(CaseIds);
		constructCaseCommentsMap(CaseIds);
        contructFeedItemMap(CaseIds);
        constructCaseEmailAttachMap(CaseIds);
        constructCaseQuoteDocCVMap(caseList,caseIds);
        
        EmailTemplate trueBlueTemplate = [Select Id,Subject,Body,Htmlvalue from EmailTemplate where developername = :EMAIL_TEMPLATE_NAME];
        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :System.Label.SG69_TrueBlueEmailFromAddress];
        for(Case caseObj : caseList){
            String templateSubject = trueBlueTemplate.Subject;
            String templateBody = trueBlueTemplate.Htmlvalue;
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(emailList);
            mail.setTemplateID(trueBlueTemplate.Id); 
            
            templateSubject = templateSubject.replace(AGENCY_BROKER_NAME, caseObj.Contact.Name != NULL ? caseObj.Contact.Name : BLANK_VALUE);
            templateSubject = templateSubject.replace(CREATED_DATE, String.valueOf(caseObj.CreatedDate) != NULL ? String.valueOf(caseObj.CreatedDate) : BLANK_VALUE);
            mail.setSubject(templateSubject);
            
            templateBody = templateBody.replace(AGENCY_BROKER_ACC_NAME,caseObj.Contact.Account.Name != NULL ? caseObj.Contact.Account.Name : BLANK_VALUE);
            templateBody = templateBody.replace(AGENCY_BROKER_ETIN,caseObj.Contact.ETIN__c != NULL ? caseObj.Contact.ETIN__c : BLANK_VALUE);
            templateBody = templateBody.replace(AGENCY_BROKER_NPN,caseObj.Contact.vlocity_ins__NPNNumber__c != NULL ? caseObj.Contact.vlocity_ins__NPNNumber__c : BLANK_VALUE);
            templateBody = templateBody.replace(CONTACT_NAME,caseObj.Contact.Name != NULL ? caseObj.Contact.Name : BLANK_VALUE);
            templateBody = templateBody.replace(CONTACT_EMAIL,caseObj.Contact.Email != NULL ? caseObj.Contact.Email : BLANK_VALUE);
            templateBody = templateBody.replace(CONTACT_PHONE,caseObj.Contact.Phone != NULL ? caseObj.Contact.Phone : BLANK_VALUE);
            templateBody = templateBody.replace(STATE_VALUE,caseObj.BR_State__c != NULL ? caseObj.BR_State__c : BLANK_VALUE);
            templateBody = templateBody.replace(LOB_VALUE,caseObj.BR_Line_of_Business__c != NULL ? caseObj.BR_Line_of_Business__c : BLANK_VALUE);
            templateBody = templateBody.replace(GROUP_ACC_NAME,caseObj.Account.Name != NULL ? caseObj.Account.Name : BLANK_VALUE);
            templateBody = templateBody.replace(APPL_NAME,caseObj.Application_Name__r.Name != NULL ? caseObj.Application_Name__r.Name : BLANK_VALUE);
            templateBody = templateBody.replace(QUOTE_NAME,caseObj.Quote_Name__r.Name != NULL ? caseObj.Quote_Name__r.Name : BLANK_VALUE);
            templateBody = templateBody.replace(MEMBER_COUNT,caseObj.Member_Count__c != NULL ? String.valueOf(caseObj.Member_Count__c) : BLANK_VALUE);
            templateBody = templateBody.replace(EFFECTIVE_DATE,caseObj.Effective_Date__c != NULL ? String.valueOf(caseObj.Effective_Date__c) : BLANK_VALUE);
            templateBody = templateBody.replace(CREATED_DATE,String.valueOf(caseObj.CreatedDate));
            templateBody = templateBody.replace(ISSUE_DESCRIPTION,caseObj.Description != NULL ? caseObj.Description : BLANK_VALUE);
            templateBody = templateBody.replace(NOTES_COMMENTS,caseNotesMap.get(caseObj.Id) != NULL ? caseNotesMap.get(caseObj.Id) : BLANK_VALUE);
            templateBody = templateBody.replace(CASE_COMMENTS,caseCommentsMap.get(caseObj.Id) != NULL ? caseCommentsMap.get(caseObj.Id) : BLANK_VALUE);
            templateBody = templateBody.replace(CHATTER_POSTS,feedItemMap.get(caseObj.Id) != NULL ? feedItemMap.get(caseObj.Id) : BLANK_VALUE);
            templateBody = templateBody.replace(EMAIL_LIST,caseEmailMessageMap.get(caseObj.Id) != NULL ? caseEmailMessageMap.get(caseObj.Id) : BLANK_VALUE);
            templateBody = templateBody.replace(CASE_NUMBER,caseObj.CaseNumber);
            
            List<String> allDocsList = new List<String>();
            if(caseAttachmentMap.get(caseObj.Id) != NULL){
                allDocsList.addAll(caseAttachmentMap.get(caseObj.Id));
            }
            if(caseIdQuoteDocIdMap.get(caseObj.Id) != NULL){
                allDocsList.addAll(caseIdQuoteDocIdMap.get(caseObj.Id));
            }
            if(caseContentVersionMap.get(caseObj.Id) != NULL){
                allDocsList.addAll(caseContentVersionMap.get(caseObj.Id));
            }
            mail.setEntityAttachments(allDocsList);
            mail.setHtmlBody(templateBody);
            if (owea.size() > 0) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            emailMessages.add(mail);
        }
        
        Messaging.sendEmail(emailMessages,false);
    }
    
    /*************************************************************************************
    * Method Name : constructCaseNotesMap
    * CratedDate  : 08/24/2017
    * Parameters  : Set<String>
    * Return Type : Void
    * Description : This is used to construct constructCaseNotesMap
    *************************************************************************************/
    private void constructCaseNotesMap(Set<String> CaseIds){
        for(Note noteObj : [Select Id,ParentId,Title,Body,Createddate from Note where ParentId IN :CaseIds Order By CreatedDate DESC]){
            if(caseNotesMap.containsKey(noteObj.ParentId)){
                String existingContent = caseNotesMap.get(noteObj.ParentId);
                existingContent+= BREAK_VALUE+BREAK_VALUE+START_BOLD_VALUE+TITLE+END_BOLD_VALUE+noteObj.Title+BREAK_VALUE+START_BOLD_VALUE+BODY+END_BOLD_VALUE+noteObj.body;
                caseNotesMap.put(noteObj.ParentId,existingContent);
            }else{
                String newContent = BREAK_VALUE+START_BOLD_VALUE+TITLE+END_BOLD_VALUE+noteObj.Title+BREAK_VALUE+START_BOLD_VALUE+BODY+END_BOLD_VALUE+noteObj.body;
                caseNotesMap.put(noteObj.ParentId,newContent);
            }
        }

    }
    /*************************************************************************************
    * Method Name : constructCaseCommentsMap
    * CratedDate  : 08/24/2017
    * Parameters  : Set<String>
    * Return Type : Void
    * Description : This is used to construct constructCaseCommentsMap
    *************************************************************************************/
    private void constructCaseCommentsMap(Set<String> CaseIds){

        for(CaseComment caseCommentObj : [Select Id,ParentId,CommentBody from CaseComment Where ParentId IN :CaseIds Order By CreatedDate DESC]){
            if(caseCommentsMap.containsKey(caseCommentObj.ParentId)){
                String existingContent = caseCommentsMap.get(caseCommentObj.ParentId);
                existingContent+= BREAK_VALUE+START_BOLD_VALUE+COMMENT_BODY+END_BOLD_VALUE+BREAK_VALUE+caseCommentObj.CommentBody;
                caseCommentsMap.put(caseCommentObj.ParentId,existingContent);
            }else{
                String newContent = START_BOLD_VALUE+COMMENT_BODY+END_BOLD_VALUE+BREAK_VALUE+caseCommentObj.CommentBody;
                caseCommentsMap.put(caseCommentObj.ParentId,newContent);
            }
        }
    }
    /*************************************************************************************
    * Method Name : contructFeedItemMap
    * CratedDate  : 08/24/2017
    * Parameters  : Set<String>
    * Return Type : Void
    * Description : This is used to construct contructFeedItemMap
    *************************************************************************************/
    private void contructFeedItemMap(Set<String> CaseIds){
        for(FeedItem feedItemObj : [select ParentId, Body FROM FeedItem where Type = :TEXT_POST and ParentId IN :CaseIds]){
            String feedText = feedItemObj.Body;
            if(feedItemMap.containsKey(feedItemObj.ParentId)){
                String existingFeed = feedItemMap.get(feedItemObj.ParentId);
                existingFeed+= START_BOLD_VALUE+CHATTER_POST+END_BOLD_VALUE+BREAK_VALUE+feedText;
                feedItemMap.put(feedItemObj.ParentId,existingFeed);
            }else{
                String newContent = START_BOLD_VALUE+CHATTER_POST+END_BOLD_VALUE+BREAK_VALUE+feedText ;
                feedItemMap.put(feedItemObj.ParentId,newContent);
            }
        }
    }
    
    /*************************************************************************************
    * Method Name : constructCaseEmailAttachMap
    * CratedDate  : 08/24/2017
    * Parameters  : Set<String>
    * Return Type : Void
    * Description : This is used to construct constructCaseEmailAttachMap
    *************************************************************************************/
    private void constructCaseEmailAttachMap(Set<String> CaseIds){
        List<EmailMessage> emailMessageList = [SELECT Id,ParentId,FromAddress,HasAttachment,Subject,TextBody,ToAddress FROM EmailMessage where ParentId IN :CaseIds];    
        Map<String,String> hasAttachmentMap = new Map<String,String>();
        Set<String> emailIdsSet = new Set<String>();
        for(EmailMessage emailMsgObj : emailMessageList){
            if(caseEmailMessageMap.containsKey(emailMsgObj.ParentId)){
                String existingEmails = caseEmailMessageMap.get(emailMsgObj.ParentId);
                existingEmails+= BREAK_VALUE+BREAK_VALUE+START_BOLD_VALUE+EMAIL_MESSAGE+END_BOLD_VALUE+BREAK_VALUE+START_BOLD_VALUE+SENDER+END_BOLD_VALUE+emailMsgObj.FromAddress+BREAK_VALUE+ START_BOLD_VALUE+SUBJECT+END_BOLD_VALUE+emailMsgObj.subject+BREAK_VALUE+START_BOLD_VALUE+MAIL_BODY+END_BOLD_VALUE+emailMsgObj.TextBody;
                caseEmailMessageMap.put(emailMsgObj.ParentId,existingEmails);
            }else{
                String newContent = BREAK_VALUE+START_BOLD_VALUE+EMAIL_MESSAGE+END_BOLD_VALUE+BREAK_VALUE+START_BOLD_VALUE+SENDER+END_BOLD_VALUE+emailMsgObj.FromAddress+BREAK_VALUE+ START_BOLD_VALUE+SUBJECT+END_BOLD_VALUE+emailMsgObj.subject+BREAK_VALUE+START_BOLD_VALUE+MAIL_BODY+END_BOLD_VALUE+emailMsgObj.TextBody;
                caseEmailMessageMap.put(emailMsgObj.ParentId,newContent);
            }
            
            if(emailMsgObj.HasAttachment){
                hasAttachmentMap.put(emailMsgObj.Id,emailMsgObj.ParentId);
            }
        }
        List<String> attachParentids = new List<String>();
        attachParentids.addAll(caseIds);
        attachParentids.addAll(hasAttachmentMap.keySet());
        List<Attachment> attachmentList = [select Id,Name,ParentId,Body,ContentType FROM Attachment where ParentId IN :attachParentids];
        for(Attachment attObj : attachmentList){
            String caseId = hasAttachmentMap.get(attObj.ParentId);
            if(caseAttachmentMap.containsKey(caseId)){
                List<String> attachList = caseAttachmentMap.get(caseId);
                attachList.add(attObj.Id);
                caseAttachmentMap.put(caseId,attachList);
            }else{
                List<String> attachList = new List<String>();
                attachList.add(attObj.Id);
                caseAttachmentMap.put(caseId,attachList);
            }
        }
    }
    /*************************************************************************************
    * Method Name : constructCaseQuoteDocCVMap
    * CratedDate  : 08/24/2017
    * Parameters  : List<Case>
    * Return Type : Void
    * Description : This is used to construct constructCaseQuoteDocCVMap
    *************************************************************************************/
    private void constructCaseQuoteDocCVMap(List<Case> caseList,Set<String> caseIds){
        Map<String,String> quoteCaseIdMap = new Map<String,String>();
        for(Case caseObj : caseList){
            quoteCaseIdMap.put(caseObj.Quote_Name__c,caseObj.Id);
        }
        
        for(QuoteDocument quoteDocObj : [select Id,ContentVersionDocumentId,QuoteId from QuoteDocument where QuoteId IN :quoteCaseIdMap.KeySet() Order By CreatedDate ASC]){
            String caseId = quoteCaseIdMap.get(quoteDocObj.QuoteId);
            if(caseIdQuoteDocIdMap.containsKey(caseId)){
                List<String> qDocList = caseIdQuoteDocIdMap.get(caseId);
                qDocList.add(quoteDocObj.ContentVersionDocumentId);
                caseIdQuoteDocIdMap.put(caseId,qDocList);
            }else{
                List<String> qDocList = new List<String>();
                qDocList.add(quoteDocObj.ContentVersionDocumentId);
                caseIdQuoteDocIdMap.put(caseId,qDocList);
            }
        }
        Map<String,String> caseIdConDocIdMap = new Map<String,String>();
        for(ContentDocumentLink conDocLinkObj : [select Id,LinkedEntityId,ContentDocumentId from ContentDocumentLink Where LinkedEntityId IN :caseIds]){
            caseIdConDocIdMap.put(conDocLinkObj.ContentDocumentId,conDocLinkObj.LinkedEntityId);
        }
        
        for(Application_Document_CheckList__c docCheckObj : [select Case__c,Tech_Content_Document_Id__c from Application_Document_CheckList__c where Case__c IN :quoteCaseIdMap.values() AND Document_Name__c = :System.Label.SG23_EmployerApplication]){
            if(!caseIdConDocIdMap.containsKey(docCheckObj.Case__c)){
                caseIdConDocIdMap.put(docCheckObj.Tech_Content_Document_Id__c,docCheckObj.Case__c);
            }
        }   

        for(ContentVersion cvObj : [select Id,ContentDocumentId from ContentVersion Where ContentDocumentId IN :caseIdConDocIdMap.keySet()]){
            String caseId = caseIdConDocIdMap.get(cvObj.ContentDocumentId);
            if(caseContentVersionMap.containsKey(caseId)){
                List<String> cvList = caseContentVersionMap.get(caseId);
                cvList.add(cvObj.Id);
                caseContentVersionMap.put(caseId,cvList);
            }else{
                List<String> cvList = new List<String>();
                cvList.add(cvObj.Id);
                caseContentVersionMap.put(caseId,cvList);
            }
        }
        
    }

}