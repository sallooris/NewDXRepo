@isTest 
private class UserTriggerHandlerTest {
    
    static testMethod void testResetCounterOpp() {
        TestResources.createProfilesCustomSetting();
        Profile systemAdd = [Select id from Profile Where Name=: 'System Administrator' limit 1];
        
        Test.StartTest();
        
            User salesRep = TestResources.createTestUser('Peter','Smith','peter3@acme.com','peter3@acme.com',systemAdd.Id);
            insert salesRep;
            
            List<User> users = new List<User>();
            
            User broker1 = TestResources.createTestUser('Joe','DiGeronimo','joe@acmesa.com','joe@acmesa.com',systemAdd.Id);
            broker1.Sales_Rep__c = salesRep.id;
            broker1.Opp_Assigned__c = 1;  
            users.add(broker1);
            
            User broker2 = TestResources.createTestUser('Joel','Fernandez','joel@acmesb.com','joel@acmesb.com',systemAdd.Id);
            broker2.Sales_Rep__c = salesRep.id; 
            broker2.Opp_Assigned__c = 4;    
            users.add(broker2);
            
            User broker3 = TestResources.createTestUser('Joelo','Rodriguez','joelo123456@acmess.com','joelo12356@acmess.com',systemAdd.Id);
            broker3.Sales_Rep__c = salesRep.id; 
            broker3.Opp_Assigned__c = 3;    
            users.add(broker3);         
            
            insert users; 
            
            User brok2ToUpdate = [Select id,Out_of_office__c from User where id =: broker2.id];
            brok2ToUpdate.Out_of_office__c = true;
            update brok2ToUpdate;
            
            brok2ToUpdate.Out_of_office__c = false;
            update brok2ToUpdate;           
            
            User brok3 = [Select id,Opp_Assigned__c from User where id =: broker3.id];
            system.assertequals(brok3.Opp_Assigned__c, 2);
        
        Test.StopTest();
    }
    
    static testMethod void testINDChange() {    
        TestResources.createProfilesCustomSetting();
        Profile systemAdd = [Select id from Profile Where Name=: 'System Administrator' limit 1];
        
        Test.StartTest();
        
            User salesRep1 = TestResources.createTestUser('Peter','Smith','peter@acmeabcdef.com','peter@acmeabcdef.com',systemAdd.Id);
            insert salesRep1;
            
            User salesRep2 = TestResources.createTestUser('Roberto','Perezida','perecita@acmexyz.com','perecita@acmexyz.com',systemAdd.Id);
            insert salesRep2;           
            
            List<User> users = new List<User>();
            
            User broker1 = TestResources.createTestUser('Joe','DiGeronimo','joe@acmepqr.com','joe@acmepqr.com',systemAdd.Id);
            broker1.Sales_Rep__c = salesRep1.id;
            broker1.Opp_Assigned__c = 0;  
            broker1.IND__c = false;
            users.add(broker1);
            
            User broker2 = TestResources.createTestUser('Joel','Fernandez','joel@acmestv.com','joel@acmestv.com',systemAdd.Id);
            broker2.Sales_Rep__c = salesRep1.id; 
            broker2.Opp_Assigned__c = 0;  
            broker2.IND__c = false; 
            users.add(broker2);
            
            User broker3 = TestResources.createTestUser('Joelo','Rodriguez','joelo@acmeupr.com','joelo@acmeupr.com',systemAdd.Id);
            broker3.Sales_Rep__c = salesRep2.id; 
            broker3.Opp_Assigned__c = 0;
            broker3.IND__c = true;      
            users.add(broker3);         

            User broker4 = TestResources.createTestUser('TesLo','TesLotin','teslo12345@acmessuvw.com','teslo12345@acmessuvw.com',systemAdd.Id);
            broker4.Sales_Rep__c = salesRep2.id; 
            broker4.Opp_Assigned__c = 0;  
            broker4.IND__c = true;  
            users.add(broker4); 
            
            insert users; 
            
            
            User brok2ToUpdate = [Select id,IND__c,Out_of_office__c,Sales_Rep__c from User where id =: broker2.id];
            brok2ToUpdate.IND__c = true;
            update brok2ToUpdate;
            
            brok2ToUpdate.Out_of_office__c = false;
            update brok2ToUpdate;

            brok2ToUpdate.Sales_Rep__c = salesRep2.id; 
            update brok2ToUpdate;                       
            
        
        Test.StopTest();

    }
    

    static testMethod void testLaguageChange() {    
        TestResources.createProfilesCustomSetting();
        Profile systemAdd = [Select id from Profile Where Name=: 'System Administrator' limit 1];
        
        Test.StartTest();
        
            User salesRep1 = TestResources.createTestUser('Peter','Smith','peter@acmeuvw.com','peter@acmeuvw.com',systemAdd.Id);
            insert salesRep1;
            
            User salesRep2 = TestResources.createTestUser('Roberto','Perezida','perecita@acmexyz.com','perecita@acmexyz.com',systemAdd.Id);
            insert salesRep2;           
            
            List<User> users = new List<User>();
            
            User broker1 = TestResources.createTestUser('Joe','DiGeronimo','joe@acmestu.com','joe@acmestu.com',systemAdd.Id);
            broker1.Sales_Rep__c = salesRep1.id;
            broker1.Opp_Assigned__c = 0;  
            broker1.language__c = 'English';
            users.add(broker1);
            
            User broker2 = TestResources.createTestUser('Joel','Fernandez','joel@acmeabc.com','joel@acmeabc.com',systemAdd.Id);
            broker2.Sales_Rep__c = salesRep1.id; 
            broker2.Opp_Assigned__c = 0;  
            broker2.language__c = 'English';    
            users.add(broker2);
            
            User broker3 = TestResources.createTestUser('Joelo','Rodriguez','joelo@acmerxy.com','joelo@acmerxy.com',systemAdd.Id);
            broker3.Sales_Rep__c = salesRep2.id; 
            broker3.Opp_Assigned__c = 0;
            broker3.language__c = 'English';    
            users.add(broker3);         

            User broker4 = TestResources.createTestUser('TesLo','TesLotin','teslo123456@acmesspqr.com','teslo123456@acmesspqr.com',systemAdd.Id);
            broker4.Sales_Rep__c = salesRep2.id; 
            broker4.Opp_Assigned__c = 0;  
            broker4.language__c = 'English';    
            users.add(broker4); 
            
            insert users; 
            
            
            User brok2ToUpdate = [Select id,language__c,Out_of_office__c,Sales_Rep__c from User where id =: broker2.id];
            brok2ToUpdate.language__c = 'English;Spanish';  
            update brok2ToUpdate;
            
            brok2ToUpdate.Out_of_office__c = false;
            update brok2ToUpdate;

            brok2ToUpdate.Sales_Rep__c = salesRep2.id; 
            update brok2ToUpdate;                       
            
        
        Test.StopTest();

    }   


    static testMethod void testAddBackUp() {    
        TestResources.createProfilesCustomSetting();
        TestResources.createRTypeBTrackCustomSettings();
        Profile systemAdd = [Select id from Profile Where Name=: 'System Administrator' limit 1];
        
        Test.StartTest();
        
            User salesRep1 = TestResources.createTestUser('Peter','Smith','peter2@acme.com','peter2@acme.com',systemAdd.Id);
            insert salesRep1; 
            
            User salesRep2 = TestResources.createTestUser('Roberto','Perezida','perecita@acme.com','perecita@acme.com',systemAdd.Id);
            insert salesRep2;           
            
            Id anthemOppsOppRecId = [Select Id From RecordType where sObjectType = 'Opportunity' and DeveloperName = 'Anthem_Opps' LIMIT 1].Id;
            
            
            
            
            Opportunity opp= new Opportunity();
            opp.Name= 'Test';
            opp.Site_ZIP__c= '55404';
            opp.StageName = 'New';          
            opp.closeDate = date.today();
            opp.OwnerID = salesRep1.id;
            opp.RecordTypeId = anthemOppsOppRecId;
            insert opp; 
            
            
            Opportunity oppToU = new Opportunity(Id=opp.id);
            oppToU.OwnerID = salesRep1.id;
            update oppToU;             
            
            User userWithBackUp = new User(Id=salesRep1.id);
            userWithBackUp.Back_up__c =salesRep2.id;
            update userWithBackUp;  
            
            userWithBackUp.Back_up__c =null;        
            update userWithBackUp;
        
        Test.StopTest();

    }       
    

}