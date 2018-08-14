@isTest
public with sharing class IssuesControllerTest {
	static testMethod void testIssuesController(){
		IssuesController isc=new IssuesController();
		
		isc.getMyAssignedIssues();
		isc.getRecentIssues();
		
		Issue__c iss=new Issue__c();
		iss.Date_Reported__c=date.today();
		iss.Issue_Description__c='test me';
		iss.Systems_Affected__c='Homebase';
		iss.Status__c='Open';
		insert iss;
		
		ApexPages.currentPage().getParameters().put('Issueid', iss.Id);
		isc.viewIssue();
		
	}
}