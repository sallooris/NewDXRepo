@isTest 
private class LogoControllerTest {
    
    static testMethod void footerByUserTest() {
        TestResources.createProfilesCustomSetting();
        TestResources.createRTypeBTrackCustomSettings();
        Branding__c brand = new Branding__c();
        brand.Name = 'Anthem Blue Cross';
        insert brand;

        Test.StartTest();
        
            User salesRep = TestResources.SalesRep('Sales','Representative','salesrep@anthem.com','salesrep@anthem.com');
            salesRep.Regional_Brand__c = 'Anthem Blue Cross';
            insert salesRep;
            
            System.runAs(salesRep) {
                logoController logo = new logoController();
                String imageUrl = logo.getImageURL();
                
            }
            
        Test.StopTest();            
    }

}