/****************************************************************************
Class Name  :  QuoteCanvasExt
Date Created:  20-April-2015
Created By  :  Arun/Daryl
Description :  This class will be called at the time of launching PTB 
Change History :    
****************************************************************************/

public without sharing class QuoteCanvasExt{
String accountId = null;
String householdMemberIds= null;
String householdRoles= null;
String accountJSON = null;
String maritalStatus = null;
Account accnt = null;
    public QuoteCanvasExt(ApexPages.StandardController controller){
      this.accnt = (Account) controller.getRecord();       
      accountId = ApexPages.currentpage().getparameters().get('ParentId'); 
      householdMemberIds  = ApexPages.currentpage().getparameters().get('HouseholdMemberIds'); 
      householdRoles = ApexPages.currentpage().getparameters().get('HouseholdMemberRoles'); 
     } 
    public pagereference backMethod()
    {
         return new PageReference('/apex/VFP01_HouseholdQuotePage?scontrolCaching=1&id=' + accountId);
    }
    public String GetaccountJSON(){
             System.debug('{AccountId:\''+accountId+'\',HouseholdMemberIds:\''+householdMemberIds+'\',HouseholdMemberRoles:\''+householdRoles+'\'}');   
             return '{AccountId:\''+accountId+'\',HouseholdMemberIds:\''+householdMemberIds+'\',HouseholdMemberRoles:\''+householdRoles+'\'}';
    }
 
 }