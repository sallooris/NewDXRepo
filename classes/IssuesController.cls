public with sharing class IssuesController {
	
	public Issue__c[] getMyAssignedIssues(){
		ID UserID=userinfo.getUserID();
		
		Issue__c[] retRows=[select id,name,status__c,systems_affected__c,Issue_Description__c,createddate from Issue__c
			where Assigned_To__c=:UserID and (status__c='Assigned' or status__c='Retest')];
		
		return retRows;
	}

	public pageReference viewIssue(){
		String IssueID=ApexPages.currentpage().getParameters().get('IssueID');
		String strURL=URL.getSalesforceBaseUrl().toExternalForm()+'/' + IssueID;
		
		pageReference pge=new pageReference(strURL);
		
		return pge;
	}
	
	public Issue__c[] getRecentIssues(){
		Issue__c[] retRows=[select id,name,status__c,systems_affected__c,Issue_Description__c,createddate from Issue__c
			order by lastmodifieddate desc limit 10];
		
		return retRows;
	}
}