/*******************************************************
Class Name  :  AP02_ConvertLead
Date Created:
Created By  :  Aman/Santosh
Description :  Class used for Lead conversion. 
Change History :   
*******************************************************/
global with sharing class AP02_ConvertLead
{
/*
Method Name : con_lead_method
Param 1 : Accepts set of lead ids, User ID
Return type : String 
Description : This method is used to get the lead ids as input and convert the lead record 
*/
public static boolean isFirstRunOPPBeforeInsert= true;
    webservice static String con_lead_method(id l,id userID)
    { 
        try{
			
			Lead lsr=[Select Id,FirstName, LastName, name, Street, City, State, PostalCode, OwnerId,Company from Lead where Id=:l  AND (Tech_Businesstrack__c='TELESALES' OR IsSGLead__c = TRUE)];    
            //	Daryl - SPE project - 7/18/17
            String year = String.valueof(system.now()).substring(0,4);
            String optyName = year + (lsr.FirstName).substring(0,3) + (lsr.LastName).substring(0,3);
            system.debug('AP02_ConvertLead optyname = '+optyName);
            // Daryl - SPE project - 7/18/17
            lsr.OwnerId=userID;
            lsr.Id=l;
            update lsr;
            Database.LeadConvert ldConvert = new database.LeadConvert();
            ldConvert.setLeadId(lsr.Id);
            LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
            //ldConvert.setConvertedStatus(convertStatus.MasterLabel);
            ldConvert.setConvertedStatus(System.label.TeleSales_LeadConvert);
            //Daryl - SPE project - 7/18/17
            ldConvert.setOpportunityName(optyName);
            Database.LeadConvertResult lcr = Database.convertLead(ldConvert);
            System.assert(lcr.isSuccess());
            String accId=lcr.getAccountId();
 			
 			// Daryl - SPE project - 7/18/17 - update billing address fields on Account            
            try
            {     
	            Account acc = [select Id, Billing_Street__c, Billing_City__c, Billing_State__c, Billing_PostalCode__c from Account where Id =:accId];
	            acc.Billing_Street__c = lsr.Street;
	            acc.Billing_City__c = lsr.City;
	            acc.Billing_State__c = lsr.State;
	            acc.Billing_PostalCode__c = lsr.PostalCode;
	            update acc;
            } 
            catch(DmlException e) 
            {
			    System.debug('An error has occurred while updating account billing fields: ' + e.getMessage());
			}
            
            return accId;
        }catch(Exception e){
            e.getMessage();
            return null;
        }
}
}