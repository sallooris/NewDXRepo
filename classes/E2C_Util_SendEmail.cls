/*************************************************************
Class Name   : E2C_Util_SendEmail
Date Created : 28-JUL-2016
Created By   : Wendy Kelley
Description  : Utility class for E2C Custom Page controllers
*****************************************************************/
public with sharing class E2C_Util_SendEmail {
  
  /*
  Method Name : buildSendEmailURL
  Parameter   : List<String>
  Return type : String
  Description : This method builds the URL to the send e-mail page, adds parameters to the URL if additional parameters are specified, Case record must have the following fields: Id, Contact.Id, Contact.Email, Contact.BR_Tech_Case_RoutingAddress__c, SuppliedEmail
  */
  public static String buildSendEmailURL(Case caseRec, List<String> additionalParams) {
    String emailURl = '/_ui/core/email/author/EmailAuthor?p3_lkid=' + ((String) caseRec.Id).left(15)+
          '&p5=' +                            //To set 'Bcc' field to blank
          '&p2_lkid=' + caseRec.Contact.Id;   //to set 'To' field on Send E-mail page
    String emailId = ApexPages.currentPage().getParameters().get('emailId');
    String emailCC = ApexPages.currentPage().getParameters().get('emailCC');
    String emailFrom = ApexPages.currentPage().getParameters().get('emailFrom');
    String emailTo = ApexPages.currentPage().getParameters().get('emailTo');
    String retUrl = ApexPages.currentPage().getParameters().get('retUrl');

    String addlToStr = '';    //String to be set on the 'Additional To' field
    String ccAddrStr = '';    //String to be set on the 'CC' field

    //Set addresses to be put on the 'Additional To' field
    if(emailFrom != null) { 
      if(!isCaseContactEmail(caseRec, emailFrom.trim())) {
        addlToStr += emailFrom;
      }
    }

    //Set additional addresses on the 'Additional To' field if method is called for reply to all
    if(emailTo != null && String.valueOf(additionalParams).contains('replyToAll=1')) {
      List<String> emailToList = emailTo.split(';');
      if(emailToList.size() > 1) {
        for(String addr : emailToList) {
          addr = addr.trim();
          if( addlToStr.containsIgnoreCase(addr)                                  // already in the string
                || caseRec.BR_Tech_Case_RoutingAddress__c.equalsIgnoreCase(addr)  // is already the From Address
                  || isCaseContactEmail(CaseRec, addr)                            // email address is already in 'To' field
                ) {
                    continue;
          }
          if(addlToStr != '') {
            addlToStr += '; ';
          }
          addlToStr += addr;
        }
      }
    }

    //Set addresses to be put on the 'CC' field
    if(emailCC != null) {
     	List<String> ccAddrList = emailCC.split(';');
     	for(String addr : ccAddrList) {
    		addr = addr.trim();
    		if( ccAddrStr.containsIgnoreCase(addr)                                  // address already in string
              || caseRec.BR_Tech_Case_RoutingAddress__c.equalsIgnoreCase(addr)  // is already the From Address
                || isCaseContactEmail(caseRec, addr)                            // email address is already in 'To' field
                  || addlToStr.containsIgnoreCase(addr)                         // address is already in Additional To
          ) {
    			           continue; // do not add address
    		}
    		if(ccAddrStr != '') {
    			ccAddrStr += '; ';
    		}
    		ccAddrStr += addr;
    	}
    }
    
    if(emailId != null) {
      //reference used by the Send E-mail page to the e-mail record
      emailURL += '&email_id=' + emailId;
    }

    //setting 'From' field on the Send Email Page when case BR_Tech_Case_RoutingAddress__c is not null and only a single e-mail address
    if(caseRec.BR_Tech_Case_RoutingAddress__c != null 
        && caseRec.BR_Tech_Case_RoutingAddress__c.split(';').size() == 1    //only 1 e-mail address is set on the field
      ) {
        emailUrl += '&p26=' + caseRec.BR_Tech_Case_RoutingAddress__c;     //set to Case record's Tech Case Routing Address
    }

    //set 'Additional To' field on the Send Email Page
    if(addlToStr != '') {
       emailURL += '&p24=' + addlToStr;
    }

    //set 'CC' field on the Send Email Page
    if(ccAddrStr != '') {
      emailURl += '&p4=' + ccAddrStr;
    }
    
    //any additional parameters used by the Send E-mail Page
    if(additionalParams != null) {
      for(String param : additionalParams) {
        emailURL += '&' + param;
      }
    }

    emailURL += '&retURL=' + retUrl;
    //System.debug('$$$emailUrl----' + emailUrl);
    return emailURl;
  }

  /*
  Method Name : isCaseContactEmail
  Parameter   : Case, String
  Return type : boolean
  Description : Checks if the specified String address is the Case Contact email address
  */
  private static boolean isCaseContactEmail(Case caseRec, String addr) {
    if(caseRec != null && caseRec.Contact != null) {
      //the only time the 'To' field will be populated for E2C cases is if the Case's Email Sent From field (SuppliedEmail) = Case's Contact Email

      //E2C cases
      if(caserec.SuppliedEmail != null) {
        if(caseRec.Contact.Email != null) {
          if(caseRec.SuppliedEmail.equalsIgnoreCase(addr) && caseRec.Contact.Email.equalsIgnoreCase(addr)) {
            return true;
          }
        }
      }
      //non-E2C cases
      else {
        if(caseRec.Contact.Email != null) {
          if(caseRec.Contact.Email.equalsIgnoreCase(addr)) {
            return true;
          }
        }
      }
    }
    return false;
  }
}