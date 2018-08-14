/**
* Test Class for OpportunityViewController
*
* @Date:       02.13.2016
* @Author:     Usman Ali (Magnet360)
* @Updates:    
* @Purpose:    
*/

@isTest 
public with sharing class OpportunityViewControllerTest 
{
	// Method to test 
    public static testMethod void viewOpp()
    {
    	// Get reocrd type Id for Anthem Opps 
    	Id anthem_opps_rt = [ Select Id From RecordType Where DeveloperName = 'Anthem_Opps' And SobjectType = 'Opportunity' Limit 1 ].Id;

    	// Get Profile Id for StandardUser
    	Profile txtProfile = [SELECT Id FROM Profile WHERE Name='Standard User' Limit 1]; 

    	// Create a new User
        User tstUser = new User(Alias = 'standt', Email='standarduser@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = txtProfile.Id, TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg111.com');
        insert tstUser ;

        // insert settings 
    	OpportunityTriggerTest.init();

    	// Create Opportunity
    	Opportunity opp= new Opportunity(Name= 'Test', Site_ZIP__c= '55404', StageName = 'New', RecordTypeId = anthem_opps_rt, CloseDate = date.today() ) ;
        insert opp ;

        // Insert custom setting
        Anthem_Opps_No_Access__c settings = new Anthem_Opps_No_Access__c( Record_Type_Id__c = anthem_opps_rt, Message__c = 'TEst');
        insert settings ;

        // Set OpportunityView as current page
        Test.setCurrentPage(Page.OpportunityView);
        // Call conroller methods
        ApexPages.currentPage().getParameters().put('Id',opp.id);
        OpportunityViewController cont = new OpportunityViewController( new ApexPages.StandardController(opp));
        cont.redirect();

        // Run As inserted user
        System.runAs(tstUser)
        {
	        cont = new OpportunityViewController( new ApexPages.StandardController( opp ));
	        cont.redirect();
	    }
    }
}