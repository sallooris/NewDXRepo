/*********************************************************************
Class Name   : VFCE05_AccountViewEditOverride
Date Created : 26-June-2015
Created By   : Bhaskar
Description  : This class is used to override Account standard buttons
**********************************************************************/
public with sharing class  VFCE05_AccountViewEditOverride{
        private final Account acc;
        public VFCE05_AccountViewEditOverride(ApexPages.StandardController stdController) {
            this.acc = (Account )stdController.getRecord();
        }
      /*
         Method Name: redirectEdit
         Return Type: PageReference
         Description: This method is used to restrict the user to edit the account 
      */
       public PageReference redirectView() {
           //if(acc.Tech_Businesstrack__c!=null && acc.Tech_Businesstrack__c!=''){
                   if(('SGQUOTING'.equalsIgnoreCase(acc.Tech_Businesstrack__c) && System.Label.SG92_AccRecordTypeID.equalsIgnoreCase(acc.recordTypeId)) || 
                      'TELESALES'.equalsIgnoreCase(acc.Tech_Businesstrack__c)){
                        User u = [SELECT ID,NAME,Profile.Name,ENABLED_TO_WORK__c FROM USER WHERE ID =:UserInfo.getUserId()];
                        if(u.Profile.Name=='System Administrator'){
                                pageReference pg = new pagereference('/'+acc.id+'?nooverride=1');
                                pg.setRedirect(false);
                                return pg;
                        }else if(acc.ownerId==u.id){
                                pageReference pg = new pagereference('/'+acc.id+'?nooverride=1');
                                pg.setRedirect(false);
                                return pg;
                        }else if(('TELESALES'.equalsIgnoreCase(acc.Tech_Businesstrack__c)) && (acc.state__c == null || acc.state__c == '')){
                                pageReference pg = new pagereference('/'+acc.id+'?nooverride=1');
                                pg.setRedirect(false);
                                return pg;
                        }else if(u.enabled_to_work__c!=null){
                            if(('TELESALES'.equalsIgnoreCase(acc.Tech_Businesstrack__c)) && u.enabled_to_work__c.contains(acc.state__c)){
                                pageReference pg = new pagereference('/'+acc.id+'?nooverride=1');
                                pg.setRedirect(false);
                                return pg;
                            } else if('SGQUOTING'.equalsIgnoreCase(acc.Tech_Businesstrack__c)) {
                                if (acc.Company_State__c != null && acc.Company_State__c != '' && u.enabled_to_work__c.contains(acc.Company_State__c)) {
                                    pageReference pg = new pagereference('/'+acc.id+'?nooverride=1');
                                    pg.setRedirect(false);
                                    return pg;
                                } else {
                                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.RestrictViewEditState);
                                    ApexPages.addMessage(myMsg);
                                    return null;
                                }
                            } else {
                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.RestrictViewEditState);
                                ApexPages.addMessage(myMsg);
                                return null;
                            } 
                        }else{
                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.RestrictViewEditState);
                                ApexPages.addMessage(myMsg);
                                return null;
                        }        
                     }else{
                            pageReference pg = new pagereference(Site.getPathPrefix()+'/'+acc.id+'?nooverride=1');
                            pg.setRedirect(false);
                            return pg;
                     }
             /*}else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.BusinessTrackIssue);
                    ApexPages.addMessage(myMsg);
                    return null;
             } */
          return null;
      }
    /*
    Method Name: redirectEdit
    Return Type: PageReference
    Description: This method is used to restrict the user to edit the account 
    */
    public PageReference redirectEdit() {
        //  if(acc.Tech_Businesstrack__c!=null && acc.Tech_Businesstrack__c!=''){
        if(('SGQUOTING'.equalsIgnoreCase(acc.Tech_Businesstrack__c) && System.Label.SG92_AccRecordTypeID.equalsIgnoreCase(acc.recordTypeId)) || 
           'TELESALES'.equalsIgnoreCase(acc.Tech_Businesstrack__c)){
               User u = [SELECT ID,NAME,Profile.Name,ENABLED_TO_WORK__c FROM USER WHERE ID =:UserInfo.getUserId()];
               if(u.Profile.Name=='System Administrator'){
                   pageReference pg = new pagereference('/'+acc.id+'/e?retURL='+acc.id);
                   pg.getParameters().put('nooverride','1');
                   pg.setRedirect(false);
                   return pg;
               }else if(acc.ownerId==u.id){
                   pageReference pg = new pagereference('/'+acc.id+'/e?retURL='+acc.id);
                   pg.getParameters().put('nooverride','1');
                   pg.setRedirect(false);
                   return pg;                          
               }else if(('TELESALES'.equalsIgnoreCase(acc.Tech_Businesstrack__c)) && (acc.state__c == null || acc.state__c == '')) {
                   pageReference pg = new pagereference('/'+acc.id+'?nooverride=1');
                   pg.setRedirect(false);
                   return pg;
               }else if(u.enabled_to_work__c!=null){
                   if(('TELESALES'.equalsIgnoreCase(acc.Tech_Businesstrack__c)) && u.enabled_to_work__c.contains(acc.state__c)){
                       pageReference pg = new pagereference('/'+acc.id+'/e?retURL='+acc.id);
                       pg.getParameters().put('nooverride','1');
                       pg.setRedirect(false);
                       return pg; 
                   } else if('SGQUOTING'.equalsIgnoreCase(acc.Tech_Businesstrack__c)) {
                       if (acc.Company_State__c != null && acc.Company_State__c != '' && u.enabled_to_work__c.contains(acc.Company_State__c)) {
                           pageReference pg = new pagereference('/'+acc.id+'/e?retURL='+acc.id);
                           pg.getParameters().put('nooverride','1');
                           pg.setRedirect(false);
                           return pg; 
                       } else {
                           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.RestrictViewEditState);
                           ApexPages.addMessage(myMsg);
                           return null;
                       }
                   } else {
                       ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.RestrictViewEditState);
                       ApexPages.addMessage(myMsg);
                       return null;
                   } 
               } else {
                   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.RestrictViewEditState);
                   ApexPages.addMessage(myMsg);
                   return null;
               } 
               
           }else{
               pageReference pg = new pagereference('/'+acc.id+'/e?retURL=%2f'+acc.id);
               System.Debug('@#@#@'+pg.getUrl());
               pg.getParameters().put('nooverride','1');
               pg.setRedirect(false);
               return pg;
           }
        /* }else{
ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.BusinessTrackIssue);
ApexPages.addMessage(myMsg);
return null;
}*/ 
        return null;
    }
}