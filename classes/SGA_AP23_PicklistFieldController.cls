/***********************************************************************
Class Name   : SGA_AP23_PicklistFieldController
Date Created : 08/04/2017 (MM/DD/YYYY)
Created By   : IDC Offshore
Description  : 1. This is  class to handle SGA_LTNG12_DependentPicklistcomponent
**************************************************************************/
public without sharing class SGA_AP23_PicklistFieldController
{ 

 private Static final Integer ONE=1;
 private static final string BLANK = '';
 private static List<Schema.PicklistEntry> contrEntries = NULL;
 private static List<PicklistEntryWrapper> depEntries =  NULL;
 private Static final string CLS_SGA_AP23='SGA_AP23_PicklistFieldController';
 private Static final string SGA_AP23_GET_DEP ='getDependentOptionsImpl';
@AuraEnabled  
/************************************************************************************
    Method Name : getDependentOptionsImpl
    Parameters  : objApi,contrfieldApi,depfieldApi
    Return type : void
    Description : 
	1)Provides Dependent Picklist Values based on incoming parameters
	2)Parses the Dependent Picklist Values based on incoming parameters	             
*************************************************************************************/ 
public static Map<String,List<String>> getDependentOptionsImpl(string objApiName, string contrfieldApiName , string depfieldApiName) {
    Map<String, List<String>> objResults = new Map<String, List<String>>();
    Try {
     // validFor property cannot be accessed via a method or a property,
     // so we need to serialize the PicklistEntry object and then deserialize into a wrapper.
     if(String.isNotBlank(objApiName) && String.isNotBlank(contrfieldApiName) && String.isNotBlank(depfieldApiName)){
         preparePicklists(objApiName,contrfieldApiName,depfieldApiName);
     }
     List<String> controllingValues = new List<String>();
		for (Schema.PicklistEntry ple : contrEntries) {
			String label = ple.getLabel();
			objResults.put(label, new List<String>());
			controllingValues.add(label);
		}
		for (PicklistEntryWrapper plew : depEntries) {
			String label = plew.label;
			String validForBits = SGA_AP24_ProcessControllingFields.base64ToBits(plew.validFor);
			for (Integer i = 0; i < validForBits.length(); i++) {
				// For each bit, in order: if it's a 1, add this label to the dependent list for the corresponding controlling value
				String bit = validForBits.mid(i, ONE);
				if (bit.equals(BLANK+ONE)) {
					objResults.get(controllingValues.get(i)).add(label);
				}
			}
		}
        objResults = filterFinalResult(objResults);
  } Catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,CLS_SGA_AP23,SGA_AP23_GET_DEP, SG01_Constants.BLANK, Logginglevel.ERROR);}
    return objResults;    		
}
    
/************************************************************************************
    Method Name : preparePicklists
    Parameters  : string objApiName, string contrfieldApiName , string depfieldApiName
    Return type : void
    Description : 
	1) fetches the PicklistEntry for Controlling and Depenedent Picklist from Schema.
    2) Sets List<PicklistEntryWrapper> for Dependent Vlaues
	             
*************************************************************************************/ 
private static void preparePicklists(string objApiName,string contrfieldApiName,string depfieldApiName){
        contrEntries = new List<Schema.PicklistEntry>();
        depEntries =  new List<PicklistEntryWrapper>();
        Schema.SObjectType obj = Schema.getGlobalDescribe().get(objApiName);
        Schema.DescribeSObjectResult objResult = obj.getDescribe();
        Schema.DescribeFieldResult ctr = objResult.fields.getMap().get(contrfieldApiName).getDescribe();
        Schema.sObjectField ctrlField = ctr.getSObjectField();
		Schema.DescribeFieldResult depField =objResult.fields.getMap().get(depfieldApiName).getDescribe();
        Schema.sObjectField theField = depField.getSObjectField();
        contrEntries=ctrlField.getDescribe().getPicklistValues();
		depEntries = wrapPicklistEntries(theField.getDescribe().getPicklistValues());
    }
/************************************************************************************
    Method Name : filterFinalResult
    Parameters  : Map<String,List<String>>
    Return type : Map<String,List<String>>
    Description : 
	1) Provides Final Outcome after filtering it with SGA_CS04_PreEnrollmentCategory__c 
	   Custom Setting which keeps the information for Picklist Values Based on Record Type
	             
*************************************************************************************/ 
private static Map<String,List<String>> filterFinalResult(Map<String,List<String>> outcome) {
		/* Filter logic as per Custom Setting*/
	   Map<String,List<String>> filteredOutcome = new Map<String,List<String>>();
        List<SGA_CS04_PreEnrollmentCategory__c> pcs = SGA_CS04_PreEnrollmentCategory__c.getall().values();
        if(!outcome.isEmpty() && !pcs.isEmpty()){
         for(Integer i=0;i<pcs.size();i++){
             String fromRecTypeLabel=pcs.get(i).picklistValue__c;
             if(outcome.containsKey(fromRecTypeLabel)){
                filteredOutcome.put(fromRecTypeLabel,outcome.get(fromRecTypeLabel));
             }
        }
      }
       /* Filter logic as per Custom Setting*/
	return filteredOutcome;
}

/************************************************************************************
    Method Name : filterFinalResult
    Parameters  : Map<String,List<String>>
    Return type : Map<String,List<String>>
    Description : 
	1) Provides Final Outcome after filtering it with SGA_CS04_PreEnrollmentCategory__c 
	   Custom Setting which keeps the information for Picklist Values Based on Record Type
	             
*************************************************************************************/ 
 private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> pickEntry) {
		return (List<PicklistEntryWrapper>)
			JSON.deserialize(JSON.serialize(pickEntry), List<PicklistEntryWrapper>.class);
 }

/************************************************************************************
    Class Name : PicklistEntryWrapper
    Description :Wrapper Class to hold multiple values for Picklist             
*************************************************************************************/
   public class PicklistEntryWrapper {
		public String active {get; set;}
		public String defaultValue {get; set;}
		public String label {get; set;}
		public String value {get; set;}
		public String validFor {get; set;}
	}

}