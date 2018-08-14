@isTest 
private class ManageGeographyControllerTest {

    static testMethod void testResetCounterOpp() {
        TestResources.createProfilesCustomSetting();
        TestResources.createCustomSettings();
        User salesRep;
        User leadController;
        State__c state;

        Test.StartTest();
        
            User thisUser = TestResources.getCurrentUser();
            System.runAs(thisUser){
                                                
                leadController = TestResources.LeadController('Lead','Controller','leadcontroller@anthem.com','leadcontroller@anthem.com');
                insert leadController;              
            
                salesRep = TestResources.SalesRep('Sales','Representative','salesrep@anthem.com','salesrep@anthem.com');
                insert salesRep;                        
                
                List<State__c> statesList =  new List<State__c>();
                state = TestResources.createState(LeadController.id);
                statesList.add(state);
   
                State__c state2 = TestResources.createState(LeadController.id, 'New York'); 
                statesList.add(state2);
                insert statesList;          
                
                Assignment_Rule__c ar = TestResources.createAssignmentRule(state.id, leadController.id);
                ar.recordTypeId = TestResources.mRecordType.get('Assignment_Rule__c').get('Geographical_Record_Type').Id;
                insert ar;              
                
                List<Zip_City_County__c> zccList = new List<Zip_City_County__c>();
                Zip_City_County__c zip = new Zip_City_County__c(Name='55404', City__c='Minneapolis', State__c=state.id, County__c='Hennepin', Territory__c='Hennepin');
                zccList.add(zip);
                
                Zip_City_County__c zip2 = new Zip_City_County__c(Name='20122', City__c='New York City', State__c=state2.id, County__c='New York', Territory__c='New York');
                zccList.add(zip2);  
                        
                insert zccList;
                
                List<User_by_Zip_City_County__c> uzccList = new List<User_by_Zip_City_County__c>();
                User_by_Zip_City_County__c userByZip = new User_by_Zip_City_County__c(Zip_Code__c=zip.id, User__c = salesRep.id);
                uzccList.add(userByZip);        
                insert uzccList;
                                
                List<User> brokers = new List<User>();
                
                User broker1 = TestResources.broker('1brokerName','1brokerLastName','1broker@anthem.com','1broker@anthem.com',salesRep.id);
                brokers.add(broker1);
                    
                User broker2 = TestResources.broker('2brokerName','2brokerLastName','2broker@anthem.com','2broker@anthem.com',salesRep.id); 
                brokers.add(broker2);
                    
                insert brokers;             
                
                ManageGeographyController mGeoController = new ManageGeographyController();
            }

            System.runAs(leadController){           
                
                ManageGeographyController mGeoController = new ManageGeographyController();
                mGeoController.salesRep= String.valueOf(salesRep.id);
                mGeoController.salesRepSelectedActions();
                mGeoController.statesSelected.add(state.id);
                mGeoController.territoriesSelected.add('New York');         
                mGeoController.save();
                mGeoController.cancel();
                
                List<User> brokersBySR = [Select id, Name  from User Where ProfileID =:TestResources.brokerProfile.id and Sales_Rep__c=: leadController.id];
                
                List<User_by_Zip_City_County__c> salesRepByZip = [ Select id from  User_by_Zip_City_County__c where User__c =: salesRep.id ] ;
            
                system.assertEquals(2,salesRepByZip.size()); 
            }
        Test.StopTest();
    }       
    

}