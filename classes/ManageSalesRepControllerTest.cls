@isTest 
private class ManageSalesRepControllerTest {
    
    static testMethod void testResetCounterOpp() {
        TestResources.createProfilesCustomSetting();
        TestResources.createRTypeBTrackCustomSettings();
        Test.StartTest();
            User salesRep;
            User broker2;
            User leadController;
            User thisUser = TestResources.getCurrentUser();
        
            System.runAs ( thisUser ) {
        
                leadController = TestResources.LeadController('Lead','Controller','leadcontroller@anthem.com','leadcontroller@anthem.com');
                insert leadController;
                    
                salesRep = TestResources.SalesRep('Sales','Representative','salesrep@anthem.com','salesrep@anthem.com');
                insert salesRep;            
                /*
                Id accAntOppsRecTypeId = [SELECT Id, Name FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Anthem_Opps'].Id;
                Account acc = new Account(Name='Account Test', RecordTypeId = accAntOppsRecTypeId);
                insert acc;
                
                Id conAntOppsRecTypeId = [SELECT Id, Name FROM RecordType WHERE sObjectType = 'Contact' AND DeveloperName = 'Anthem_Opps'].Id;
                Contact cont= new Contact(LastName = 'lastName', AccountId = acc.id, RecordTypeId = conAntOppsRecTypeId);
                insert cont;
                
                Id salesRepProfileId = [select id from Profile where Name = 'Anthem Opps Sales Rep' Limit 1].Id;
                salesRep  = new User(
                    FirstName = 'firstName',
                    LastName = 'lastName',
                    Email = 'email@email.com',
                    Username = 'userName@email.com',
                    ProfileId = salesRepProfileId ,
                    Alias = 'lna',
                    emailencodingkey = 'UTF-8', 
                    localesidkey = 'en_US',
                    languagelocalekey = 'en_US', 
                    timezonesidkey = 'America/Los_Angeles',
                    Regional_Brand__c ='Brand',
                    User_State__c='Minnesota',
                    contactId=cont.Id);
                insert salesRep;
                
                */
                
                
                
                State__c state = TestResources.createState(LeadController.id);
                insert state;
                
                Zip_City_County__c zip = TestResources.createZipCityCounty(state.id);
                insert zip;
                
                User_by_Zip_City_County__c userByZip = TestResources.createUserByZipCityCounty(salesRep.id,zip.id); 
                insert userByZip;
                
                Assignment_Rule__c ar = TestResources.createAssignmentRule(state.id, leadController.id);
                insert ar;                  
                
                List<User> brokers = new List<User>();
                
                User broker1 = TestResources.broker('1brokerName','1brokerLastName','1broker@anthem.com','1broker@anthem.com',leadController.id);
                brokers.add(broker1);
                    
                broker2 = TestResources.broker('2brokerName','2brokerLastName','2broker@anthem.com','2broker@anthem.com',leadController.id);    
                brokers.add(broker2);
                
                User broker3 = TestResources.broker('3brokerName','3brokerLastName','3broker@anthem.com','3broker@anthem.com',leadController.id);   
                brokers.add(broker3);   
                insert brokers;
                
                User_by_Zip_City_County__c userByZip2 = TestResources.createUserByZipCityCounty(broker2.id,zip.id); 
                insert userByZip2;  
                
                ManageSalesRepController mSalesRepCon = new ManageSalesRepController();                         

            }
            System.runas(leadController){
                
                ManageSalesRepController mSalesRepCon = new ManageSalesRepController();
                mSalesRepCon.salesRep= String.valueOf(salesRep.id);
                mSalesRepCon.updateBrokers();
                mSalesRepCon.getSalesRepStates();
                mSalesRepCon.getSalesRepTerritories();              
                mSalesRepCon.brokers = new List<String>();
                mSalesRepCon.brokers.add(String.valueOf(broker2.id));
                mSalesRepCon.save();
                mSalesRepCon.cancel();
                
                
                List<User> brokersBySR = [Select id, Name  from User Where ProfileID =:TestResources.brokerProfile.id and Sales_Rep__c=: salesRep.id]; 
                
                system.assertequals(brokersBySR.size(),0);
            }
        Test.StopTest();
    }   

}