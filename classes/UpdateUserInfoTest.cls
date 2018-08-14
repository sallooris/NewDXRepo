@isTest 
private class UpdateUserInfoTest {

	static testMethod void testAssignmentByState() {
		TestResources.createProfilesCustomSetting();		
		test.StartTest();
			User backUpUser2;
			User userToTest;
    		User thisUser = TestResources.getCurrentUser();
    		System.runAs ( thisUser ) {		
    			
		    	User backUpUser = TestResources.admin('1AdminName','1AdminLastName','1admin@anthem.com','1Admin@anthem.com');
				insert backUpUser;
	
		    	backUpUser2 = TestResources.admin('2AdminName','2AdminLastName','2admin@anthem.com','2admin@anthem.com');
				insert backUpUser2;				
				
		    	userToTest = TestResources.admin('3AdminName','3AdminLastName','3admin@anthem.com','3admin@anthem.com');
		    	userToTest.Back_up__c = backUpUser.id;
				insert userToTest;	
			
    		}
			System.runAs(userToTest){					
				
				UpdateUserInfoController uic =  new UpdateUserInfoController();
				uic.currentUser.Back_up__c = backUpUser2.id;
				uic.saveUser();
				
				uic.currentUser.Back_up__c = null;
				uic.saveUser();
				
				uic.showBackup();			
			
			}
		test.stopTest();
	}

}