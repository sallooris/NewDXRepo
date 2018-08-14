@isTest 
private class ManageMyBrokersControllerTest {
    
    static testMethod void testManageMyBrokers() {
        TestResources.createProfilesCustomSetting();
        TestResources.createCustomSettings();
        Test.StartTest();
        
            User thisUser = TestResources.getCurrentUser();
            User salesRep;
            System.runAs ( thisUser ) {
        
                salesRep = TestResources.SalesRep('salesRepName','salesRepLastName','salesrep@anthem.com','salesrep@anthem.com');
                insert salesRep;
    
                List<User> brokers = new List<User>(); 
                User broker1 = TestResources.broker('1BrokerName','1BrokerLastName','broker1@anthem.com','broker1@anthem.com',salesRep.id);
                brokers.add(broker1);
                
                User broker2 = TestResources.broker('2BrokerName','2BrokerLastName','broker2@anthem.com','broker2@anthem.com',salesRep.id);
                brokers.add(broker2);
                
                User broker3 = TestResources.broker('3BrokerName','3BrokerLastName','broker3@anthem.com','broker3@anthem.com',salesRep.id); 
                brokers.add(broker3);           
                
                insert brokers; 
            
            }
            
            System.runAs(salesRep){
                ManageMyBrokersController mby= new ManageMyBrokersController();
                mby.brokersList[0].Out_of_office__c=true;
                mby.save();
                mby.cancel();
                
            }
        ManageMyBrokersController mby2= new ManageMyBrokersController();
        
        Test.StopTest();
    }   
        

}