@isTest
private class E2C_CaseReopenExtCtrl_Test {
	
	// setup data to be used across test methods
    static void testSetupData() {
        User u = E2C_Util_TestDataFactory.createUserList(1, null, true)[0];
        System.runAs(u) {
            Case caseRec = E2C_Util_TestDataFactory.createCaseList(1, true)[0];
        }
    }

    // test re-opening a closed case
    static testMethod void testReopenClosedCase() {
    	testSetupData();
    	Case caseRec = null;
    	User u = [SELECT Id from User where userName = 'standarduser0@testorg111.com'];
        E2C_CaseReopenExtCtrl ctrl = null;
        PageReference pgRef = null;

        Test.startTest();
	        System.runAs (u) {
                //insert a new closed case
	        	caseRec = E2C_Util_TestDataFactory.createCaseList(1, false)[0];
	        	caseRec.Status = 'Closed'; 
	        	insert caseRec;
	            
                //load page
	        	ApexPages.StandardController sc = new ApexPages.StandardController(caseRec);
        		ctrl = new E2C_CaseReopenExtCtrl(sc);
        		pgRef = ctrl.reopenCase();
	        }
        Test.stopTest();

        //query updated case
      	Case uCase = [Select Id, Status from Case where Id = :caseRec.Id];

        //case re-open should be successful and should return the Case page
        System.assertEquals('/' + caseRec.Id, pgRef.getUrl());
        //case status should be changed to 'Closed - Reopen'
        System.assertEquals('Closed - Reopen', uCase.status);
    }

    // test case reopen with non-closed Case
    static testMethod void testReopenCaseWithOtherStatus() {
    	testSetupData();
        // get any existing case record
    	Case caseRec = [Select Id, Status from Case where Origin='Email' Limit 1];
    	User u = [SELECT Id from User where userName = 'standarduser0@testorg111.com'];
        E2C_CaseReopenExtCtrl ctrl = null;
        PageReference pgRef = null;

        Test.startTest();
        	System.runAs(u) {
	        	ApexPages.StandardController sc = new ApexPages.StandardController(caseRec);
	        	ctrl = new E2C_CaseReopenExtCtrl(sc);
                pgref = ctrl.reopenCase();
	        }
        Test.stopTest();

      	Case uCase = [Select Id, Status from Case where Id = :caseRec.Id];

        //should simply redirect to Case page
        System.assertEquals('/' + caseRec.Id, pgRef.getUrl());
        //Case status will not be udpated
        System.assertEquals(caseRec.status, uCase.status);
    }

    // test re-run of assignment rules when re-opening
    static testMethod void testRerunAssignmentRule() {
    	testSetupData();
    	Case caseRec = null; //[Select Id, Status from Case where Origin='Email' Limit 1];

    	User u = [SELECT Id from User where userName = 'standarduser0@testorg111.com'];
        E2C_CaseReopenExtCtrl ctrl = null;

        Test.startTest();
        	System.runAs(u)	{
                //create/insert new Closed case
                caseRec = E2C_Util_TestDataFactory.createCaseList(1, false)[0];
                caseRec.Status = 'Closed'; 
                insert caseRec;
                
                //re-open case through page
	        	ApexPages.StandardController sc = new ApexPages.StandardController(caseRec);
	        	ctrl = new E2C_CaseReopenExtCtrl(sc);
                ctrl.reopenCase();
	        }
        Test.stopTest();

        //get updated case record
      	Case uCase = [Select Id, Status, OwnerId from Case where Id = :caseRec.Id];

        //get exisiting active assignment rule
      	AssignmentRule[] ar = [SELECT Id FROM AssignmentRule WHERE SObjectType = 'Case' AND Active = true LIMIT 1];

        //if an assignment rule is active
      	if(!ar.isEmpty()) {
            //case ownership should have been changed
			System.assert(uCase.OwnerId != u.Id);      		
      	}
      	else { //if no active assignment rules
            //case ownership will not change
      		System.assertEquals(u.Id, uCase.ownerId);	
      	}
    }
}