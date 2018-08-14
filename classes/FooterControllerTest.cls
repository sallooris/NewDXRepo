@isTest 
private class FooterControllerTest {
	
	static testMethod void footerByUserTest() {
		TestResources.createProfilesCustomSetting();   	
        Branding__c brand = new Branding__c();
        brand.Regional_Legal_Disclaimer__c= 'Test';
        brand.Regional_Legal_Disclaimer_2__c= 'Test';
        brand.Regional_Legal_Disclaimer_3__c= 'Test';
        brand.Regional_Legal_Disclaimer_4__c= 'Test';
        brand.Regional_Legal_Disclaimer_5__c= 'Test';
        brand.Regional_Legal_Disclaimer_6__c= 'Test';
        brand.Regional_Legal_Disclaimer_7__c= 'Test';
        brand.Regional_Legal_Disclaimer_8__c= 'Test';
        brand.Regional_Legal_Disclaimer_9__c= 'Test';	
    	brand.Name = 'Anthem Blue Cross';
    	
    	insert brand;
    	
    	Test.StartTest();
    	
    		User thisUser = TestResources.getCurrentUser();
    		User admin;
			System.runAs(thisUser) {
		    	admin = TestResources.admin('1AdminName','1AdminLastName','1admin@anthem.com','1Admin@anthem.com');
		    	admin.Regional_Brand__c = 'Anthem Blue Cross';
				insert admin;			
			}
			
			System.runAs(admin) {
				footerController fc = new footerController();
			}
			
		Test.StopTest();			

		
	}

}