/*************************************************************
Class Name   : E2C_CaseCustomEmailMessageListCtrl
Date Created : 07-JUN-2016
Created By   : Wendy Kelley
Description  : Controller Class for Custom Email List
*****************************************************************/
public with sharing class E2C_CaseCustomEmailMessageListCtrl {
    
    //added by IDC Offshore
    public boolean isSGQuoting{get;set;}
    /**************************** Class Properties *******************************************************/
    // Case record from which Email records will be retrieved
    public Case caseRec {get; set;}
    
    // Index of the first record to be shown on the page from the retrieved Emails list
    public Integer currIndex {get; set;}
    
    // Minimum number of records to be shown per page  
    public Integer minPageSize {get; set;}
    
    // String placeholder for the new field by which the email list will be sorted
    public String newSortByField {get; set;}
    
    // Return url to be used for returning to originating page
    public String retURL {get; set;}
    
    // Page URL to re-direct to
    public String redirectURL {get; set;}
    
    // Number of records to be shown per page
    public Integer pageSize {
        get {
            if(pageSize == null) {
                this.pagesize = minPageSize;
            }
            return pageSize;
        }
        set;
    }
    
    // Email list to be displayed per page
    public List<PageEmailMessage> pageEmailList {
        get {
            getEmailList();
            pageEmailList = new List<PageEmailMessage>();
            for(Integer i = currIndex; i < currIndex + pageSize; i++) {
                if(i < emailList.size()) {  
                    pageEmailList.add(new PageEmailMessage(emailList.get(i)));
                }
            }
            return pageEmailList;
        }
        set;
    }
    
    // Check if there are more records to show other than those currently displayed on page list
    public boolean hasMoreRecords {
        get { 
            getEmailList();
            Integer remainingRecs = emailList.size() - (currIndex + pageSize);   //check remaining records based on current page list recs
            if(remainingRecs > 0) {
                return true;      
            }   
            return false;
        }   
        set;
    }
    
    // Check if there are records preceding the current records on page list
    public boolean hasPrevious {
        get {
            if(currIndex > 0) {
                return true;
            }
            return false;
        }
        set;
    }
    
    // Boolean flag to check if fewer records can be shown on page, page list size must not be below minimum page size
    public boolean canShowLess {
        get {
            if(pageEmailList.size() > minPageSize) {
                return true;
            }
            return false;
        }
        set;
    }
    
    transient List<EmailMessage> emailList;
    // List of All Email Message records retrieved for case
    /*public List<EmailMessage> emailList {
get {
if(emailList == null) {
emailList = new List<EmailMessage>();  
if(queryStr != null) 
{
try {
emailList = Database.query(queryStr);
}
catch(Exception e) {
System.debug('Exception in getEmailList: ' + e.getMessage());
}
}
}
return emailList;
}
set;
}*/
    
    // Query string to be used for retrieving related Email Message records
    public String queryStr {
        get {
            queryStr = 'SELECT Id, Status, Incoming, Subject, TextBody, MessageDate, FromAddress, ToAddress, CcAddress, HasAttachment FROM EmailMessage ' +
                'WHERE ParentId = \'' + caseRec.Id  + '\' ';
                        /* BR_Tech_Case_RoutingAddress__c,*/  
            if(sortByField != null && !String.isEmpty(sortByField)) {
                queryStr += ' ORDER BY ' + sortByField + ' ';
                if(sortOrder != null && !String.isEmpty(sortOrder)) {
                    queryStr += ' ' + sortOrder;
                }
            } 
            
            //limit to only 1000 records
            queryStr += ' LIMIT 1000';
            return queryStr;
        }
        set;
    }
    
    // Name of the field by which the list will be sorted, string to be used in query string
    public String sortByField {
        get {
            if(sortByField == null) {
                sortByField = 'MessageDate';  // default field to sort the list by
            }
            return sortByField;
        }
        set;        
    }
    
    // Order by which list will be sorted, string to be used in query string
    // Accepted values: 'ASC', 'DESC'
    public String sortOrder {
        get {
            if(sortOrder == null) {
                sortOrder = 'DESC';     // default order
            }
            return sortOrder;
        }
        set;
    }
    
    /**************************** Class Properties - End ************************************************************/
    
    /*
Description : Constructor
Parameter   : ApexPages.StandardController
*/
    public E2C_CaseCustomEmailMessageListCtrl(ApexPages.StandardController stdController) {
        if(!Test.isRunningTest()) {
            stdController.addFields(new String[] {
                'BR_Tech_Case_RoutingAddress__c',
                    'Contact.Id',
                    'Contact.Email',
                    'SuppliedEmail'
                    });
        }
        
        this.caseRec = (Case)stdController.getRecord();
        //added by IDC Offshore - to not show the custom Emails Related list
        if(System.Label.SG_BusinessTrack.equalsIgnoreCase(caseRec.Tech_Businesstrack__c)){
            isSGQuoting = true;
        }
        this.minPageSize = 10; //default pageSize
        currIndex = 0;         //start with first record on list on page 
        
        //retrieve custom settings for default page size
        Email_to_Case_Custom_Settings__c emailCS = Email_to_Case_Custom_Settings__c.getValues('Default List Page Size');
        
        //if custom setting is set
        if(emailCS != null && emailCS.value__c != null) {
            try {
                this.minPageSize = Integer.valueOf(emailCS.value__c);
            }
            catch(Exception e) {
                System.debug('Exception in retrieving page settings : ' + e.getMessage());
            }
        }
    }
    
    /*
Method Name : sendAnEmail
Parameter   : none
Return type : PageReference
Description : This method is used to refer to SF standard Send Email page
*/
    public PageReference sendAnEmail() {
        PageReference pg = new PageReference(E2C_Util_SendEmail.buildSendEmailURL(caseRec, null));
        redirectURL = pg.getURL();
        return null;
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
Method Name : showMore
Parameter   : none
Return type : PageReference
Description : Method used for displaying more Email message records, increases pageSize value used for setting page list records
*/
    public PageReference showMore() {
        if(hasMoreRecords) {
            // double current pageSize value
            pageSize = pageSize*2;
        }
        return null;
    }
    
    /*
Method Name : showLess
Parameter   : none
Return type : PageReference
Description : Method used for displaying fewer Email message records, decreases pageSize value used for setting page list records
*/
    public PageReference showLess() {
        
        if(canShowLess) {
            pageSize = pageSize/2;
        }
        return null;
    }
    
    /*
Method Name : previous
Parameter   : none
Return type : PageReference
Description : Method used for displaying previous records on current all e-mails list, sets currIndex to the index of first record to be displayed on page list
*/
    public PageReference previous() {
        if(hasPrevious) {
            currIndex = currIndex - pageSize;
        }       
        if(currIndex < 0) {
            //reset to 0
            currIndex = 0;
        }
        return null;
    }
    
    /*
Method Name : next
Parameter   : none
Return type : PageReference
Description : Method used for displaying next available records on current all e-mails list, sets currIndex to the index of the first record of the next set of records to be included in page list
*/
    public PageReference next() {
        if(hasMoreRecords ) {
            //set to next index
            currIndex = currIndex + pageSize;
        }
        return null;
    }
    
    /*
Method Name : next
Parameter   : none
Return type : PageReference
Description : Method used sorting all e-mails list
*/
    public PageReference sort() {
        //reset list and currIndex value
        emailList = null;
        currIndex  = 0; //set to 0 to go the first page
        
        //if sorting list with a different field (newSortByField)
        // - set sortByField to vaue of newSortByField
        // - set default sort order to ascending
        if(newSortByField != sortByField) {
            sortByField = newSortByField;
            sortOrder = 'ASC';
        }
        //if sorting list with the same field 
        else {
            if(sortOrder == 'DESC') {
                sortOrder = 'ASC';
            }
            else {
                sortOrder = 'DESC';
            }
        }
        return null;
    }
    
    public List<EmailMessage> getEmailList() {
        if(emailList == null) {
            emailList = new List<EmailMessage>();  
            if(queryStr != null) 
            {
                try {
                    emailList = Database.query(queryStr);
                }
                catch(Exception e) {
                    System.debug('Exception in getEmailList: ' + e.getMessage());
                }
            }
        }
        return emailList;
    }
    
    public class PageEmailMessage {
        public Id Id {get; set;}
        public String FromAddress {get; set;}
        public String ToAddress {get; set;}
        public String CcAddress {get; set;}
        public boolean Incoming {get; set;}
        public String Subject;
        public String MessageDate {get; set;}
        //public Datetime MessageDate {get; set;}
        public boolean hasAttachment {get; set;}
        transient String TextBody;
        transient String Status;
        
        
        public PageEmailMessage(EmailMessage em) {
            this.Id = em.Id;
            this.Status = em.Status;
            this.FromAddress = em.FromAddress;
            this.ToAddress = em.ToAddress;
            this.CcAddress = em.ccAddress;
            this.TextBody = em.TextBody;
            this.Incoming = em.Incoming;
            this.Subject = em.Subject;
            //this.MessageDate = getLocalDateTime(em.MessageDate);
            this.MessageDate = em.MessageDate.format('M/d/YYY h:mm a');
            this.hasAttachment = em.HasAttachment;
        }
        
        public String getTextBody() {
            if(textBody != null) {
                textBody = textBody.trim();
                if(textBody.length() > 77) {
                    textBody = textBody.substring(0, 77) + '...';
                }
            }
            return textBody;
        }
        
        public String getStatus() {
            //{!CASE(email.Status,'0','New','1','Read','2','Replied','3','Sent','')}
            if(status == '0') {
                return 'New';
            } else if(status == '1') {
                return 'Read';
            } else if(status == '2') {
                return 'Replied';
            } if(status == '3') {
                return 'Sent';
            } if(status == '4') {
                return 'Forwarded';
            }
            return status;
        }
        
        public String getSubject() {
            if(subject == null || (subject != null && subject.trim() == '')) {
                subject = '(blank subject)';
            }
            return subject;
        }
    }
}