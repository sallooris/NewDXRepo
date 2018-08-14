/*********************************************************************************************
Class Name   : SG01_Constants
Date Created : 06-April-2017
Created By   : IDC Offshore
Description  : This class contains constants which are used in Small Group Automation project
*********************************************************************************************/
public with sharing class SG01_Constants {
    /*Used for Broker Search Controller class*/
    public static final string WHERE_CLAUSE = ' where ';
    public static final string AND_SPACE = ' AND ';
    public static final string OR_SPACE = ' OR ';
    public static final string NAME_LIKE = 'name like \'%';
    public static final string LIKE_SEARCH_END = '%\'';
    public static final string SPACE = ' ';
    public static final string BACK_SLASH = '\'';
    public static final string GROUP_NUMBER = 'Group_Number__c = \'';
    public static final string GROUP_NUMBER2 = 'Group_Number_2__c = \'';
    public static final string TAX_ID = 'Employer_EIN__c = \'';
    public static final string ACC_BR_SEARCH_QUERY = 'SELECT Id,Name,Phone,Employer_EIN__c,Group_Number__c,Group_Number_2__c,Type, BillingState,BillingStreet,BillingCity,BillingCountry,County__c,BillingPostalCode,Company_City__c,Company_State__c,Company_Street__c,Company_Zip__c,Email_Address__c FROM Account ';
    public static final string FROM_ACCOUNT = ' FROM Account ';
    public static final string LIMIT_100 = ' limit 100';
    public static final string LIMIT_1 = ' limit 1';
    public static final string QUOTE_NUMBER_LIKE = 'QuoteNumber like \'%';
    public static final string CREATED_DATE_BETWEEN = 'CreatedDate > :dateOfLastAct AND CreatedDate < :dateOfLastAct1 ';
    public static final string QUOTE_BR_SEARCH_QUERY = 'SELECT Id,Name,QuoteNumber,Status,ExpirationDate,Coverage_Options__c ';
    public static final string FROM_QUOTE = ' FROM Quote ';
    public static final string APP_ENROLLMENT_DATE_BETWEEN = 'Date_Enrollment_Complete__c  > :effectiveDt AND Date_Enrollment_Complete__c < :effectiveDt1 ';
    public static final string APP_BR_SEARCH_QUERY = 'SELECT Id,Name,vlocity_ins__Status__c,Application_Number__c,Broker_Name__c';
    public static final string FROM_APPLICATION = ' FROM vlocity_ins__Application__c ';
    public static final string BLANK = '';
    public static final string LEFT_BRACKET = '(';
    public static final string RIGHT_BRACKET = ')';
    public static Final String ORGID =  UserInfo.getOrganizationId();
    public static Final String APPLICATIONNAME= 'Anthem SG';
    public static Final String CLS_SGA_AP01_BROKERSEARCHCONTROLLER= 'SGA_AP01_BrokerSearchController';
    public static Final String GETUSERDETAILS= 'getUserDetails';
    public static Final String GETACCOUNTSEARCHRESULTS= 'getAccountSearchResults';
    public static Final String GETQUOTESEARCHRESULTS= 'getQuoteSearchResults';
    public static Final String GETAPPLICATIONSEARCHRESULTS='getApplicationSearchResults';
    public static Final String GETQUOTEDETAIL='getQuoteDetail';
    public static Final String CLS_VALIDATESELECTIONSERVICE= 'ValidateSelectionService';
    public static Final String INVOKEMETHOD= 'invokeMethod';
    public static Final String VALIDATEMEDICAL= 'validateMedical';
    public static Final String VALIDATEDENTAL= 'validateDental';
    public static Final String VALIDATEVISION= 'validateVision';
    public static Final String VALIDATEQUOTEMEDICAL= 'validateQuoteMedical';
    public static Final String VALIDATEQUOTEDENTAL= 'validateQuoteDental';
    public static Final String VALIDATEQUOTEVISION= 'validateQuoteVision';
    public static final String PARENT_ID = 'ParentId';
    public static Final String ID = 'Id';
    public static final string EQUALS_SLASH = '= \'';
    public static final String OPPORTUNITY = 'Opportunity';
    public static final String FIELD_HISTORY = 'FieldHistory';
    public static final String HISTORY = 'History';
    public static final String HISTORY_TRACK_QUERY = 'SELECT CreatedDate,CreatedById,Field,NewValue,OldValue FROM ';
    public static final String HISTORY_TRACK_QUERY_2 = 'ORDER BY CreatedDate DESC ';
    public static final String EQUAL_BACK_SLASH = ' =\'';
    public static final String LIMIT_KEY = 'LIMIT ';
    public static final String NEW_VALUE = 'newValue';
    public static final String OLD_VALUE = 'oldValue';
    public static final String USERID_PREFIX = '005';
    public static final String GROUP_PREFIX = '00G';
    public static final String CREATED_DATE = 'CreatedDate';
    public static final String CREATED_BY_ID = 'CreatedById';
    public static final String FIELD = 'Field';
    public static final String CREATED = 'created';
    public static final String DOT = '.';
    public static final String DELETED = 'Deleted ';
    public static final String BOLD_TEXT = ' in <b>';
    public static final String BOLD_TAG_END = '</b>.';
    public static final String FROM_CLAUSE = ' from ';
    public static final String CHANGED_BTAG = 'Changed <b>';
    public static final String CLOSE_BTAG = '</b>';
    public static final String TO_BTAG = ' to <b>';
    public static final String GRP_COV_DATE_TEST = 'Group_Coverage_Date__c';
    public static final String DATE_ENROLL_COMPLTE_TEST = 'Date_Enrollment_Complete__c';
    public static final String GRP_NUMBER2_TEST = 'Group_Number_2__c';
    public static final String GRP_NUMBER_TEST = 'Group_Number__c';
    public static Final String CLS_SGA_AP02_MYPROFILECONTROLLER = 'SGA_AP02_MyProfileController';
    public static Final String GETUSERSCONTACTID= 'getUsersContactId';
    public static final String CONTACT_PREFIX = '/contact/';
    public static final String DETAIL_PREFIX = '/detail/';
    public static final String FNAME_TEST = 'Test';
    public static final String LNAME_TEST = 'McTesty';
    public static final String EMAIL_TEST = 'test@test.com';
    public static final String ACCNAME_TEST = 'Test Account';
    public static final String SOBJECT_TEST = 'Account';
    public static final String RNAME_TEST = 'Agency';
    public static final String PNAME_TEST = 'Anthem SG Broker';
    public static final String USERNAME_TEST = 'test12345@test.com';
    public static final String ALIAS_TEST = 'test123';
    public static final String ENCODING_TEST = 'UTF-8';
    public static final String NICKNAME_TEST = 'test12345';
    public static final String LOCALE_TEST = 'en_US';
    public static final String LANG_TEST = 'en_US';
    public static final String TIMEZONE_TEST = 'America/Los_Angeles';
    
    /* Specfic to Account Related List Constants and Methods Names */
    public static Final String STATUSINPROGRESS = 'In Progress';
    public static Final String STATUSCANCELLED = 'Cancelled';
    public static Final String STATUSINCOMPLETED = 'Completed';
    public static Final String ACCOUNT = 'Account';
    public static Final String SG_QUOTING = 'SG Quoting';
    public static Final String SUBTYPE_ENROLLMENT = 'Enrollment';
    public static Final String TYPE_ENROLLMENT = 'Enrollment';
    public static Final String SUBTYPE_NEWYORK = 'New York';
    public static Final String SUBTYPE_NEWYORK1 = 'New_York';
    public static Final String STATUSINENROLLMENTCOMPLETED = 'Enrollment Complete';
    public static Final String CLS_SGA_LTNG03_ACCOUNTRELATEDLISTQUERYHELPER  = 'SGA_LTNG03_AccountRelatedListQueryHelper';
    public static Final String CLS_SGA_LTNG05_VIEWAPPLICATIONSCONTROLLER = 'SGA_LTNG05_ViewApplicationsController';
    public static Final String CLS_SGA_LTNG04_INPROGRESSCONTROLLER = 'SGA_LTNG04_InProgressController';
    public static Final String CLS_SGA_LTNG07_INPROGRESSAPPCTRL = 'SGA_LTNG07_InProgressApplicationsCtrl';
    public static Final String GETCURRENTACCOUNTDETAILS= 'SGA_LTNG03_getCurrentAccountDetails';
    public static Final String GETAPPLICATIONS = 'SGA_LTNG03_getApplications';
    public static Final String SGA_LTNG03_INPROCESSQUOTESLIST = 'SGA_LTNG03_InProcessQuotesList';
    Public static final String GETAPPLICATIONLIST='SGA_LTNG03_getApplicationList';
    public static Final String INPROGRESSAPPLICATIONLIST='SGA_LTNG05_ViewApplicationsController';
    public static Final String COMPLETEDAPPLICATIONLIST='SGA_LTNG05_CompletedApplicationList';
    public static Final String INPROCESSQUOTESLIST ='InProcessQuotesList';
    public static final String HYPHEN = '-';
    /* Specfic to Open Show/Hide Action Buttons Constants and Methods Names */
    
     public static final String CLS_SGA_AP09_ApplicationActionBtnRenderer = 'SGA_AP09_ApplicationActionBtnRenderer';
     public static final String DOCUMENT_SUBMITTED_STATUS = 'Group Submitted, Under Review';
     public static final String ENROLLMENT_EXPIRED_STATUS = 'Group Expired';
     public static final string CLS_SGA_AP09_GETBUTTONVISIBILITY = 'getButtonVisibility';
    
    /* Specific to InProgress Quotes Component Controller Constants */
    
    public static final string CLS_SGA_LTNG03_ACC_QUERY = 'SELECT Id,Name,Group_Number__c, Group_Number_2__c, Sic, Employer_EIN__c, vlocity_ins__PartyId__c FROM ACCOUNT ';
    public static final string CLS_SGA_LTNG03_OSINSTANCE_QUERY = 'SELECT Id,LastModifiedDate,vlocity_ins__ResumeLink__c, Name, vlocity_ins__Status__c, vlocity_ins__LastSaved__c FROM vlocity_ins__OmniScriptInstance__c ';
    public static final string CLS_SGA_LTNG03_OBJ_LABEL = 'vlocity_ins__ObjectLabel__c';
    public static final string CLS_SGA_LTNG03_STATUS = ' vlocity_ins__Status__c ';
    public static final string CLS_SGA_LTNG03_OSSUBTYPE = ' vlocity_ins__OmniScriptSubType__c ';
    public static final string CLS_SGA_LTNG03_OSTYPE = ' vlocity_ins__OmniScriptType__c ';
    public static final string CLS_SGA_LTNG03_OBJ_ID = ' vlocity_ins__ObjectId__c ';
    
    public static final string CLS_SGA_LTNG03_APP_QUERY = 'SELECT  Id, Name, vlocity_ins__Type__c, vlocity_ins__Status__c, Coverage_Option__c ,Date_Enrollment_Complete__c , Member_Count__c, WritingAgentETIN__c, Group_Coverage_Date__c, CreatedDate FROM vlocity_ins__Application__c';
    public static final string CLS_SGA_LTNG03_APP_QUERY_WHERE = ' WHERE Id IN (SELECT vlocity_ins__ApplicationId__c FROM vlocity_ins__ApplicationPartyRelationship__c WHERE vlocity_ins__PartyId__c';
    public static final string CLS_SGA_LTNG03_APP_QUERY_ORDERBY = ' ORDER BY CreatedDate DESC ';
    public static final string CLS_SGA_LTNG03_OSINSTANCE_QUERY_ORDERBY = ' ORDER BY LastModifiedDate DESC ';
    /* Specfic to Open Activity List Constants and Methods Names */
    
    public static Final String CLS_SGA_LTNG08_OPENACTIVITYLISTQUERYHELPER    = 'SGA_LTNG08_OpenActivityListQueryHelper';
    public static Final String CLS_SGA_LTNG08_OPENACTIVITYCTRL   = 'SGA_LTNG08_OpenActivityCtrl';
    public static Final String OPENACTIVITYLIST  = 'SGA_LTNG08_OpenActivityList';
     public static Final String GETOPENACTIVITYLIST  ='getOpenActivityList';
 
    
    /* Specfic to Open DocumentCheckList Constants and Methods Names */
    
    public static Final String SGA_AP08_DOCUMENTCHECKLISTHELPER  = 'SGA_LTNG10_DocumentCheckListHelper';
    public Static Final String CLS_SGA_AP08_DOCUMENTCHECKLIST    = 'SGA_LTNG10_DocumentCheckList';
    public Static Final String DOCUMENTCHECKLIST     = 'SGA_LTNG10_DocumentCheckList';
    public Static Final String GETDOCUMENTCHECKLIST='getDocumentCheckList';
    public Static Final String GETDELETEDLIST='getDeletedlist';
    public Static Final String UPDATEDDOCUMENT='updatedDocument';
    public Static Final String GETDOCUMENTDETAILS='getdocumentDetails';
    public Static Final String GETCURRENTUSERPROFILE='getCurrentUserProfile';
 
    public Static Final String CLS_SGA_AP05_ACCOUNTTRIGGERHANDLER = 'SGA_AP05_AccountTriggerHandler';
    public Static Final String CHECKBROKERAGENCYAGENCYTINSAME ='checkBrokerAgencyAgencyTinSame';
    public static final string CLS_SGA_AP08_DCQUERY = 'SELECT Id,Name,Application__c,Case__c,Required__c,Document_Name__c,Status__c,File_Name__c,File_Size__c,File_URL_Formula__c,File_URL__c,Reviewer_Notes__c, Date_Time_Submitted__c,Document_Returned_Reason__c FROM Application_Document_Checklist__c ';
    public static final string APPLICATION_API_NAME = ' Application__c ';
    public static final string CLS_SGA_AP08_DCQUERY_DOCID = 'SELECT Application_Document_Config__c,Application__c,File_URL_Formula__c,Application__r.Name,Application__r.Id,Application_Document_Config__r.Document_Name__c,Application_Document_Config__r.Name,CreatedById,CreatedDate,Document_Name__c,File_Name__c,File_Size__c,File_URL__c,Id,LastModifiedById,LastModifiedDate,Name,Required__c,Reviewer_Notes__c,Status__c FROM Application_Document_Checklist__c ';
    
    /*Specific for DML Operations */
    public static final String INSERT_OPERATION = 'Insert';
    public static final String UPDATE_OPERATION = 'Update';
    public static final String DELETE_OPERATION = 'Delete';
    public static final String UPSERT_OPERATION = 'Upsert';
    public static final string CLS_SGA_UTIL04_DCDATAACCESSHELPER = 'SGA_Util04_DCDataAccessHelper';
    public static final string CLS_SGA_UTIL04_FETCHDCMAP = 'fetchDocumentChecklistMap';
    public static final string CLS_SGA_UTIL04_DMLDC = 'dmlDocChecklist';
    public static final string CLS_SGA_UTIL03_APPDATAACCESSHELPER = 'SGA_Util03_ApplicationDataAccessHelper';
    public static final string CLS_SGA_UTIL03_FETCHAPPMAP = 'fetchApplicationMap';
    public static final string CLS_SGA_UTIL03_DMLAPP = 'dmlApplicationlist';
    public static final string CLS_SGA_UTIL02_OSDATAACCESSHELPER = 'SGA_Util02_OSInstanceDataAccessHelper';
    public static final string CLS_SGA_UTIL04_FETCHOSMAP = 'fetchOSInstanceMa';
    public static final string CLS_SGA_UTIL04_DMLOS = 'dmlOnOmniScript';
    public static final string CLS_SGA_UTIL01_ACCDATAACCESSHELPER = 'SGA_Util01_AccountDataAccessHelper';
    public static final string CLS_SGA_UTIL04_FETCHACCMAP = 'fetchAccountsMap';
    public static final string CLS_SGA_UTIL04_DMLACC = 'dmlOnAccount';
    /** Specific for File Upload Controller constant and method name **/
    public static Final String SGA_AP06_APPLICATIONOBJQUERY = 'SELECT ID, NAME, Account_State__c, vlocity_ins__Status__c, Application_Number__c,Group_Coverage_Date__c FROM vlocity_ins__Application__c';
    public static final String CLS_SGA_AP06_FILEUPLOAD = 'SGA_AP06_FileUploadController';
    public static final String SGA_AP06_DOCUMENTNEEDTOUPLOAD = 'documentsNeedtoUpload';
    public static final String SGA_AP06_SAVEFILES = 'saveFiles';
    public static Final String SGA_AP06_DCCHECKLISTQUERY = 'select id, Document_Name__c, File_Size__c, File_Name__c, Required__c, Application_Document_Config__c, Application__c, Case__c, Status__c, Tech_Content_Document_Id__c from Application_Document_Checklist__c';
    public static final String APPLICATIONID = 'Application__c';
    public static final String CLS_SGA_UTIL05_FILESDATAACCESSHELPER = 'SGA_Util05_FilesDataAccessHelper';
    public static final String CLS_SGA_FCCDLMAP = 'fetchContentDocumentLinkMap';
    public static final String CLS_SGA_UTIL05_DMLCV = 'dmlContentVersionlist';
    public static final String CLS_SGA_UTIL05_DMLCDL = 'dmlContentDCLinklist';
    public static final String CLS_VlOCITYAPPLDATAACCESS = 'VlocityApplicationDataAccess';
    public static final String CLS_CREATEDOCUMENT_DML = 'createDocumentCheckRecords';
    public static final String CLS_VLOCITYAPPL_TRIGGERHELPER = 'SGA_AP14_CreateDocumentChecklist';
    public static final String CREATEDOCUMENTS = 'createDocumentsForApplication';
    
    /*Specific for SGA_BC01_ExpireAppByEffectiveDate Batch Class */
    public static final string CLS_SGA_BAP01_ExpireAppByEffectiveDate = 'SGA_BAP01_ExpireAppByEffectiveDate';
    public static final String CLS_SGA_BAP01_START = 'start';
    public static final String CLS_SGA_BAP01_EXECUTE = 'execute';
    public static final String CLS_SGA_BAP01_FINISH = 'finish';
    public static final String CLS_SGA_BAP01_QUERY = 'Select Id,Name,vlocity_ins__Status__c,Group_Coverage_Date__c from vlocity_ins__Application__c Where Group_Coverage_Date__c != NULL';
   
    /*Specific for SGA_SC01_ExpireAppByEffectiveDate Schedulable Class */
    
    public static final string CLS_SGA_SCAP01_ExpireAppByEffectiveDate = 'SGA_SCAP01_ExpireAppByEffectiveDate';
    
    public static final String CLS_SGA_SCAP01_EXECUTE = 'execute';
    
    
    /* Specific for SGA_AP12_QuotePDFGeneration class */
    public static final string NONE_STRING = '--None--';
    
    /* Specific for SGA_AP11_GenerateAndAttachQuotePDF */
    public static final string ATTACH_PDF_METHOD = 'attachQuotePdf';
    public static final string DRID_QUOTE = 'DRId_Quote';
    
    public static final string QUOTE_PDF_IMG = 'QuotePDFImage';
    public static final string COLUMN = 'Column';
    public static final string LABEL = 'Label';
    public static final string SIGNATURE = 'Signature';
    public static final string EBCBS = 'EBCBS';
    public static final string EMPIRE_CROSS_SHIELD = 'Empire Logo Cross Shield';
    public static final string EMPIRE_CROSS_ONLY = 'Empire Logo Cross Only';
    public static final string FILE_SERVER_URL = '/servlet/servlet.FileDownload?file=';
    public static final string BORDER_UPPER = 'BorderUpper';
    public static final string MEDICAL = 'Medical';
    public static final string ONE = '1';
    public static final string TWO = '2';
    public static final string THREE = '3';
    public static final string DENTAL = 'Dental';
    public static final string VISION = 'Vision';
    public static final string CLS_SGA_AP10_ATTACHQUOTE = 'SGA_AP10_AttachQuotePDFToQuote';
    public static final string INVOKE_METHOD = 'invokeMethod';
    public static final String QUOTE_SGA_AP10_QUERY ='select id,AccountId,Coverage_Options__c,Brand__c,vlocity_ins__EffectiveDate__c from Quote ';
    
    /*Used in SGA_AP13_UploadProposalDocument class */
    public static final string APP_DOC_CHECK_QUERY = 'select id,Document_Name__c,Status__c,File_Name__c,File_Size__c,File_URL__c,Tech_Content_Document_Id__c,Application__c,Application__r.vlocity_ins__QuoteId__c,Application__r.Medical__c FROM Application_Document_Checklist__c';
    public static final string APP_DOC_WHERE_1 = ' ID IN :documentCheckListIds AND Document_Name__c IN (';
    public static final String CLS_UPLOAD_PROPOSAL_DOC = 'SGA_AP13_UploadProposalDocument';
    public static final String CLS_METHOD_UPLOAD_PROPOSAL_DOC = 'uploadProposalDocumentDetails';
    
    
    /* Specific for SGA_AP15_EmailTempComponentCtrl class */
     public static Final String ACCOUNTID = 'AccountId';
     public static final string OPPORTUNITY_QUERY = 'Select ID,Name From Opportunity';
     public static Final String OPPORTUNITYID = 'OpportunityId';
     public static final string QUOTE_QUERY = 'SELECT Id,CreatedDate,Brand__c,Name from Quote';
     public static final String QUOTE_QUERY_2 = 'ORDER BY CreatedDate DESC ';
     public static final string CLS_SGA_AP15_EMAILTEMPCOMPONETCTRL = 'SGA_AP15_EmailTempComponentCtrl';
     public static final String SGA_AP15_GETBRAND = 'getBrand';
     public static final String SGA_AP15_GETOPPORTUNITYDETAILS = 'getOpportuntiyDetails';
     public static final String SGA_AP15_GETQUOTEDETAILS = 'getQuoteDetails';
     public static final String SGA_AP15_GETAPPLICATIONDETAILS = 'getApplicationDetails';
     public static Final String CLS_SGA_AP15_APPLICATIONOBJQUERY = 'SELECT ID, NAME, Account_State__c, vlocity_ins__Status__c, Application_Number__c,Opportunity_Id__c,vlocity_ins__AccountId__c FROM vlocity_ins__Application__c';
    
    public static final string CLS_SGA_AP17_UPDATEDOCCHECKLIST = 'SGA_AP17_UpdateDocCheckListDSStatus';
    public static final string METHOD_SGA_AP17_UPDATEDOCCHECKLIST = 'updateDCList';
    public static final string COMMA = ',';
    
     /* Query for Profile  */
     public static final string PROFILE_QUERY = 'SELECT Id, Name FROM Profile';
     
     /* Specific for SGA_AP27_searchController */
     public static final string CLS_SGA_SEARCHCONTROLLER = 'SGA_AP27_searchController';
     public static final string AP_SEARCHCTL_DOSEARCH = 'doSearch';
     public static final string SEARCHACCOUNT_QUERY = 'Select id, Name, Site, BR_Encrypted_TIN__c, Employer_EIN__c, Phone, Owner.Alias, LastModifiedDate, BR_National_Producer_Number__c, License_Number__c from Account';
     public static final string ENCRYPTED_TIN_WHERE = ' BR_Encrypted_TIN__c = \'';
     public static final string EMPLOYER_EIN_WHERE = ' Employer_EIN__c = \'';
     public static final string OR_EMPLOYER_EIN_WHERE = ' Or Employer_EIN__c = \'';
     public static final string SEARCH_CASE_QUERY = 'select CaseNumber, Account.Name, Origin, BR_State__c, Subject, BR_Sub_Category__c, CreatedDate, Owner.Name, BR_HCID_GroupNumber__c, LastModifiedDate from case';
     public static final string ACCOUNT_IN = ' AccountID IN: accIdSet '; 
     public static final string SEARCH_QUOTE_QUERY = 'select name, Account.Name,Opportunity.Name, IsSyncing, ExpirationDate, Subtotal, LastModifiedDate, TotalPrice from quote';
     public static final string SEARCH_OPPORTUNITY_QUERY = 'select Name, Account.Name, Account.Site, StageName, CloseDate, Owner.Alias, LastModifiedDate from Opportunity ';
     public static final string SEARCH_CONTACT_QUERY = 'select name, Account.Name, Account.Site, Phone, Email, LastModifiedDate, Owner.Alias from Contact';
    
     /*Specific for SGA_AP26_CaseCommentHandler */
     public static final string CASE_COMMENT_EDIT_ERROR = 'Cannot edit Case Comment';
     public static final string CASE_SGA_AP26_QUERY = 'select id from Case';
     public static final string IN_COLON = ' IN:';
     public static final string TECH_BUSINESSTRACK_EQUALS = ' Tech_Businesstrack__c =';
     public static final string SGQUOTING = 'SGQUOTING';
     public static final string CASE_SGA_AP26_WHERE_CLAUSE = ' where id IN: caseIDSet';
     public static final string CLS_SGA_AP26_CASECOMMENTHANDLER = 'SGA_AP26_CaseCommentHandler';
     public static final string AP26_DONOTEDITCASECOMMENT = 'doNotEditComment';
     public static final string RECORDTYPE_NAME = 'RecordType.Name';
    
     /*Specific for SGA_AP20_CreateInstallationCase */
    public static final string CLS_SGA_AP20_CREATEINSTALCASE = 'SGA_AP20_CreateInstallationCase';
    public static final string AP20_CREATEORUPDATE = 'createOrUpdateInstallationCase';
    public static final string AP20_CREATECASERECORD = 'createCaseRecord';
    public static final string AP20_GETOPPDETAILS = 'getOpportuntiyDetails';
    public static final string AP20_GETQUOTEDETAILS = 'getQuoteDetails';
    public static final string AP20_ACTIONAFTERFILTER = 'actionAfterFilterization';
    public static final string AP20_CHECKEXISTCASERECORD = 'checkExistCaseRecord';
    public static Final String CASE_RECORDTYPE_INSTALLATION='Small Group Case Installation';
    public static Final String CASE_RECORDTYPE_ENROLL='Small_Group_Pre_Enrollment_Inquiry';
    public static Final String CASE_RECORDTYPENAME_ENROLL='Small Group Pre-Enrollment Inquiry';
    public static Final String STATUS_CLOSED='Closed';
    public static Final String CASE_OBJECTNAME = 'Case';
    public static Final String DEPART_SALES_SUPPORT='Sales Support';
    public static Final String APP_STATUS_GROUP_SUBMITED='Group Submitted, Under Review';
    public static Final String APP_TYPE_ONLINE='Online';
    public static Final String APP_TYPE_PAPER='Paper';
    /*Specific for SGA_AP22_UpdateAppStatus */
    public static final string CLS_SGA_AP22_UPDATEAPPSTATUS = 'SGA_AP22_UpdateAppStatus';
    public static final string AP22_UPDATEAPPLICATION = 'updateApplication';
    public static final string AP22_GETSTATUSFORAPP = 'getStatusForApp';
    
    /*Specific for SGA_AP21_CreatePEIMCaseController */
    public static final string CLS_SGA_AP21_CREATEPEIMCASECTRL = 'SGA_AP21_CreatePEIMCaseController';
    public static final string SGA_AP21CREATECASE = 'createCase';
    public static final string SGA_AP21GETCASENUMBER = 'getCaseNumber';
    public static final string SGA_AP21GETAGENT = 'getAgent';
    public static final string SGA_AP21GETCASESTATES = 'getCaseSates';
    public static Final String STATE_NY='NY';
     /*Specific for SGA_AP22_LookUpController */
    public static final string CLS_SGA_AP22_LOOKUPCONTROLLER = 'SGA_AP22_LookUpController';
    public static final string SGA_AP22_SEARCHSOBJECT = 'searchSObject';
    public static final string SGA_AP22_NAME_FIELD = 'Name';
    
      /*Specific for SGA_AP33_CreateCaseComment */
    public static final string CLS_SGA_AP33_CREATECASECOMMENT = 'SGA_AP33_CreateCaseComment';
    public static final string SGA_AP33_CREATECASECOMMENT = 'createCaseComment';
    
    public static final string CASEID = 'Case__c';
    
    /*Specific for SGA_AP30_CreateTaskToConnetTeam */
    public static final string SGA_AP30_TASK_REC_TYPE = 'SGA Task';    
    public static final string SGA_AP30_TASK_SUBJECT = 'Load GROUP into DDS';
    public static final string SGA_AP30_TASK_STATUS_NOT_STARTED = 'Not Started';
    public static final string SGA_AP30_TASK_PRIORITY_NORMAL = 'Normal';
    public static final string SGA_AP30_CONNECT_QUEUE = 'Connect Case Installation';
    public static final string SGA_AP30_QUEUE = 'Queue';    
}