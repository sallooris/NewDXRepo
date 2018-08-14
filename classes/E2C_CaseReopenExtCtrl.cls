/*************************************************************
Class Name   : E2C_CaseReopenExtCtrl
Date Created : 20-JUL-2016
Created By   : Wendy Kelley 
Description  : Extension Controller Class for E2C Case Reopen page
*****************************************************************/
public with sharing class E2C_CaseReopenExtCtrl {
	
	Case caseRec;

	/*
  	Description : Constructor
  	Parameter   : ApexPages.StandardController
  	*/
	public E2C_CaseReopenExtCtrl(ApexPages.StandardController stdController) {
		if(!Test.isRunningTest()) { 
			stdController.addFields(new String [] {'Status'});
		}
		caseRec = (Case) stdController.getRecord(); 
	}

	/*
  	Method Name : reopenCase
  	Parameter   : none
  	Return type : PageReference
  	Description : This method updates case status to 'Closed - Reopen' when case is already closed and re-runs active Assignment rule if there is any
  	*/
	public PageReference reopenCase() {

		if(caseRec.Status == 'Closed') {

			//update case status to 'Closed - Reopen'
			caseRec.Status = 'Closed - Reopen';

			//Retrieve active assignment rule
    		AssignmentRule[] ar = [SELECT Id FROM AssignmentRule WHERE SObjectType = 'Case' AND Active = true LIMIT 1];

    		//if there is an active assignment rule
    		if(!ar.isEmpty()) {
    			//Create DML Options to run active assignment rule
	    		Database.DMLOptions dmlOpts = new Database.DMLOptions();
	    		dmlOpts.AssignmentRuleHeader.AssignmentRuleId = ar[0].Id;
				
				//Set created DML Options as Case DML Options
        		caseRec.setOptions(dmlOpts);
        	}
			
			//update case
			try {
				update caseRec;
			}
			catch(Exception e) {
				System.debug('$$$ Error in E2C_CaseReopenExtCtrl.reopenCase : ' + e.getMessage());
				//show error message on page in case of error
				return null;
			}
		}

		//return to Case page
		PageReference pg = returnToCase();
		return pg;
	}

	/*
  	Method Name : returnToCase
  	Parameter   : none
  	Return type : PageReference
  	Description : This method simply does a redirect to the Case page
  	*/
	public PageReference returnToCase() {
		//return to Case page
		PageReference pg = new PageReference ('/'+caseRec.Id);
		pg.setRedirect(true);
		return pg;	
	}
}