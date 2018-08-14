/*********************************************************************
Class Name   : VFCE04_LeadViewEditOverride
Date Created : 26-June-2015
Created By   : Bhaskar
Description  : This class is used to override Lead standard buttons(View/Edit)
**********************************************************************/
public with sharing class VFCE04_LeadViewEditOverride{
    private final Lead ld;
    /*
        Constructor
    */
    public VFCE04_LeadViewEditOverride(ApexPages.StandardController stdController) {
        this.ld = (Lead)stdController.getRecord();
    }
    /*
       Method Name: redirectView
       Return Type: PageReference
       Description: This method is used to restrict the user to view the lead
                    1. User should not able to view if the lead does not belongs the same state even if the lead is part of his queue. 
                    2. User should able to view the lead even it does not belongs to his state but if he owns lead
    */
  public PageReference redirectView() {
                if('TELESALES'.equalsIgnoreCase(ld.Tech_Businesstrack__c)){
                    User u = [SELECT ID,NAME,profile.name,ENABLED_TO_WORK__c FROM USER WHERE ID =:UserInfo.getUserId()];
                    if(u.Profile.Name=='System Administrator'){
                           pageReference pg = new pagereference('/'+ld.id+'?nooverride=1');
                            pg.setRedirect(false);
                            return pg;
                    }else if(string.valueOf(ld.OwnerId).startsWith('005')){
                       if(ld.ownerId==u.id){
                            pageReference pg = new pagereference('/'+ld.id+'?nooverride=1');
                            pg.setRedirect(false);
                            return pg;
                       }else if(ld.state__c == null || ld.state__c == ''){
                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.RestrictViewEditState);
                                ApexPages.addMessage(myMsg);
                                return null;
                        }else if(u.enabled_to_work__c!=null){
                            if(u.enabled_to_work__c.contains(ld.state__c)){
                                 pageReference pg = new pagereference('/'+ld.id+'?nooverride=1');
                                 pg.setRedirect(false);
                                 return pg;
                            }else{
                                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.RestrictViewEditState);
                                 ApexPages.addMessage(myMsg);
                                 return null;
                            }
                        }else{
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.RestrictViewEditState);
                            ApexPages.addMessage(myMsg);
                            return null;
                        }
                   }else if(!string.valueOf(ld.OwnerId).startsWith('005')){
                            if(u.enabled_to_work__c==null){
                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.RestrictViewEditState);
                                ApexPages.addMessage(myMsg);
                                return null;
                            }else if(ld.state__c == null || ld.state__c == ''){
                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.RestrictViewEditState);
                                ApexPages.addMessage(myMsg);
                                return null;
                            }else if(u.enabled_to_work__c!=null){
                                    if(u.enabled_to_work__c.contains(ld.state__c)){
                                        pageReference pg = new pagereference('/'+ld.id+'?nooverride=1');
                                        pg.setRedirect(false);
                                        return pg;
                                    }else{
                                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.RestrictViewEditState);
                                        ApexPages.addMessage(myMsg);
                                        return null;  
                                    } 
                             }
                   }   
                 }else{
                        pageReference pg = new pagereference('/'+ld.id+'?nooverride=1');
                        pg.setRedirect(false);
                        return pg;
                 }
    return null;
 }

    /*
       Method Name: redirectEdit
       Return Type: PageReference
       Description: This method is used to restrict the user to edit the lead
                    1. User should not able to edit if the lead does not belongs the same state even if the lead is part of his queue. 
                    2. User should able to edit the lead even it does not belongs to his state but if he owns lead
    */
  public PageReference redirectEdit() {
     // if(ld.Tech_Businesstrack__c!=null && ld.Tech_Businesstrack__c!=''){
              if('TELESALES'.equalsIgnoreCase(ld.Tech_Businesstrack__c)){
                    User u = [SELECT ID,NAME,Profile.Name,ENABLED_TO_WORK__c FROM USER WHERE ID =:UserInfo.getUserId()];
                    if(u.Profile.Name=='System Administrator'){
                            pageReference pg = new pagereference('/'+ld.id+'/e?retURL='+ld.id);
                            pg.getParameters().put('nooverride','1');
                            pg.setRedirect(false);
                            return pg;
                    }else if(string.valueOf(ld.OwnerId).startsWith('005'))
                    {
                        if(ld.ownerId==u.id){
                            pageReference pg = new pagereference('/'+ld.id+'/e?retURL='+ld.id);
                            pg.getParameters().put('nooverride','1');
                            pg.setRedirect(false);
                            return pg; 
                        }else if(ld.state__c == null || ld.state__c == ''){
                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.RestrictViewEditState);
                                ApexPages.addMessage(myMsg);
                                return null;
                        }else if(u.enabled_to_work__c!=null){
                              if(u.enabled_to_work__c.contains(ld.state__c)){
                                  pageReference pg = new pagereference('/'+ld.id+'/e?retURL='+ld.id);
                                  pg.getParameters().put('nooverride','1');
                                  pg.setRedirect(false);
                                  return pg; 
                              }else{
                                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.RestrictViewEditState);
                                  ApexPages.addMessage(myMsg);
                                  return null;
                              }
                       }else{
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.RestrictViewEditState);
                            ApexPages.addMessage(myMsg);
                            return null;
                       }        
                   }else if(!string.valueOf(ld.OwnerId).startsWith('005')){
                       if(u.enabled_to_work__c==null){
                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.RestrictViewEditState);
                                ApexPages.addMessage(myMsg);
                                return null;
                       }else if(ld.state__c == null || ld.state__c == ''){
                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.RestrictViewEditState);
                                ApexPages.addMessage(myMsg);
                                return null;
                       }else if(u.enabled_to_work__c!=null){
                             if(u.enabled_to_work__c.contains(ld.state__c)){
                                    pageReference pg = new pagereference('/'+ld.id+'/e?retURL='+ld.id);
                                    pg.getParameters().put('nooverride','1');
                                    pg.setRedirect(false);
                                    return pg;
                             }else{
                                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.RestrictViewEditState);
                                    ApexPages.addMessage(myMsg);
                                    return null;
                             }
                       }
                   }
               }else{
                    pageReference pg = new pagereference('/'+ld.id+'/e?retURL='+ld.id);
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