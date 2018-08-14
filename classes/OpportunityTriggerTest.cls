@isTest 
public class OpportunityTriggerTest {
    
    private static State__c state;  
    private static User broker;
    private static RecordType  geoRT;
    private static RecordType  campaignRT;
    private static User leadController;
    //private static Event_ID__c eventID; 
    private static String event_code;
    private static Campaign camp;
    private static User salesRep;
        
    private static Zip_City_County__c createZipCityCounty(String zipCode, ID stateID){
        
        return new Zip_City_County__c (
            Name = zipCode,
            State__c = stateID,
            County__c = 'Hennepin',
            City__c =  'Minneapolis'
        );
    }

    private static ID anthem_opps_rt
    {
        get{
            if ( anthem_opps_rt == null )
            {
                anthem_opps_rt = [ Select Id From RecordType 
                                   Where DeveloperName =: 'Anthem_Opps' And SobjectType = :'Opportunity' 
                                   Limit 1 ].id;
            }
            return anthem_opps_rt;
        } set;
    }

    
    public static void init() {
        TestResources.createProfilesCustomSetting();   
        TestResources.createCustomSettings();   
        state = new State__c();
        state.Name = 'Minneapolis';
        
        insert state;
        List<Zip_City_County__c> zipCityCountyList = new List<Zip_City_County__c>();
        
        Zip_City_County__c zipCityCounty1 = OpportunityTriggerTest.createZipCityCounty('55404', State.id);
        Zip_City_County__c zipCityCounty2 = OpportunityTriggerTest.createZipCityCounty('55405', State.id);
        zipCityCountyList.add(zipCityCounty1);
        zipCityCountyList.add(zipCityCounty2);
        insert zipCityCountyList;
        
        Profile systemAdd = [Select id from Profile Where Name=: 'System Administrator' limit 1];
        
        salesRep = TestResources.createTestUser('Sunny','Test123','sunnytest@anthem.com','sunnytest@anthem.com',systemAdd.Id);
        insert salesRep;
 
        broker = TestResources.createTestUser('Joe','DiGeronimo','joe@acme.com','joe123@acme.com',systemAdd.Id);
        broker.Sales_Rep__c = salesRep.id;
        insert broker;  

        List<User_by_Zip_City_County__c> ubzccList = new List<User_by_Zip_City_County__c>();
        for(Zip_City_County__c z: zipCityCountyList){
        
            User_by_Zip_City_County__c ubzcc = new User_by_Zip_City_County__c();
            ubzcc.Zip_Code__c = z.id;
            ubzcc.User__c = salesRep.id;
            ubzccList.add(ubzcc);
            
            User_by_Zip_City_County__c ubzccBroker = new User_by_Zip_City_County__c();
            ubzccBroker.Zip_Code__c = z.id;
            ubzccBroker.User__c = broker.id;
            ubzccBroker.Broker__c = true;
            ubzccList.add(ubzccBroker);
        }
        
        insert ubzccList;
        
        
        camp = new Campaign();
        //camp.Event_Code__c = '0001';
        camp.Name = '0001';
        insert camp;

        event_code = camp.Name;
        
        //eventID = new Event_ID__c();
        //eventID.Name = '001';
        //eventId.Event_Campaign_Name__c = camp.id;
        
        //insert eventID;
        
        geoRT = [Select id from RecordType where DeveloperName =:'Geographical_Record_Type'];
        campaignRT = [Select id from RecordType where DeveloperName =:'Campaign_Record_Type'];
        
        leadController = TestResources.createTestUser('Lead','Controller','leadController@acme.com','leadController@acme.com',systemAdd.Id);
        insert leadController;
        
        
    }
    
    static void assertOwner(List<Opportunity> oppList){
        Set<id> oppIdSet = new Set<id>();
        
        for(Opportunity opp: oppList){
            oppIdSet.add(opp.id);
        }
        
        List<Opportunity> oppOwnerList = [Select id, OwnerId from Opportunity Where id in: oppIdSet];
        
        for(Opportunity opp: oppOwnerList)  {
           // system.assertequals(broker.id,opp.ownerID);
        }
    }
    
    static void assertLeadControllerOwner(List<Opportunity> oppList){
        Set<id> oppIdSet = new Set<id>();
        
        for(Opportunity opp: oppList){
            oppIdSet.add(opp.id);
        }
        
        List<Opportunity> oppOwnerList = [Select id, OwnerId from Opportunity Where id in: oppIdSet];
        
        for(Opportunity opp: oppOwnerList)  {
            system.assertequals(leadController.id,opp.ownerID);
        }
    }   
    
    static testMethod void testAssignmentByState() {
        
        OpportunityTriggerTest.init();
    
        Assignment_Rule__c assignmentRule = new Assignment_Rule__c();
        assignmentRule.State__c = state.id;
        assignmentRule.Assignment_by_State__c = true;
        assignmentRule.recordTypeID = geoRT.id;
        assignmentRule.Lead_Controller__c = leadController.id;
        insert assignmentRule;
        
        Test.StartTest();
        
            List<Opportunity> oppList = new List<Opportunity>();
            
            For(Integer i=0; i<2; i++){
                Opportunity opp= new Opportunity();
                opp.Name= 'Test';
                opp.Site_ZIP__c= '55404';
                opp.StageName = 'New';
                opp.RecordTypeId = anthem_opps_rt;
                opp.closeDate = date.today();
                oppList.add(opp);
    
                Opportunity opp2= new Opportunity();
                opp2.Name= 'Test';
                opp2.Site_ZIP__c= '55405';
                opp2.StageName = 'New';
                opp2.RecordTypeId = anthem_opps_rt;
                opp2.closeDate = date.today();
                oppList.add(opp2);  
            }        
             
             insert oppList;    

        Test.StopTest();
        
        OpportunityTriggerTest.assertOwner(oppList);
        

    }
    
    static testMethod void testAssignmentByCounty() {
        
        OpportunityTriggerTest.init();
    
        Assignment_Rule__c assignmentRule = new Assignment_Rule__c();
        assignmentRule.State__c = state.id;
        assignmentRule.Assignment_by_County__c = true;
        assignmentRule.recordTypeID = geoRT.id;
        assignmentRule.Lead_Controller__c = leadController.id;
        
        insert assignmentRule;
        
        Test.StartTest();
        
            List<Opportunity> oppList = new List<Opportunity>();
            
            For(Integer i=0; i<2; i++){
                Opportunity opp= new Opportunity();
                opp.Name= 'Test';
                opp.Site_ZIP__c= '55404';
                opp.StageName = 'New';
                opp.closeDate = date.today();
                opp.RecordTypeId = anthem_opps_rt;
                oppList.add(opp);
    
                Opportunity opp2= new Opportunity();
                opp2.Name= 'Test';
                opp2.Site_ZIP__c= '55405';
                opp2.StageName = 'New';
                opp2.closeDate = date.today();
                opp2.RecordTypeId = anthem_opps_rt;
                oppList.add(opp2);  
            }        
             
             insert oppList;    

        Test.StopTest();
        
        OpportunityTriggerTest.assertOwner(oppList);
    } 
 
 
    static testMethod void testAssignmentByCity() {
        
        OpportunityTriggerTest.init();
    
        Assignment_Rule__c assignmentRule = new Assignment_Rule__c();
        assignmentRule.State__c = state.id;
        assignmentRule.Assignment_by_City__c = true;
        assignmentRule.recordTypeID = geoRT.id;
        assignmentRule.Lead_Controller__c = leadController.id;
        
        insert assignmentRule;
        
        Test.StartTest();
        
            List<Opportunity> oppList = new List<Opportunity>();
            
            For(Integer i=0; i<2; i++){
                Opportunity opp= new Opportunity();
                opp.Name= 'Test';
                opp.Site_ZIP__c= '55404';
                opp.StageName = 'New';
                opp.closeDate = date.today();
                opp.RecordTypeId = anthem_opps_rt;
                oppList.add(opp);
    
                Opportunity opp2= new Opportunity();
                opp2.Name= 'Test';
                opp2.Site_ZIP__c= '55405';
                opp2.StageName = 'New';
                opp2.closeDate = date.today();
                opp2.RecordTypeId = anthem_opps_rt;
                oppList.add(opp2);  
            }        
             
             insert oppList;    

        Test.StopTest();
        
        OpportunityTriggerTest.assertOwner(oppList);
    } 
    
    static testMethod void testAssignmentByZipCode() {
        
        OpportunityTriggerTest.init();
    
        Assignment_Rule__c assignmentRule = new Assignment_Rule__c();
        assignmentRule.State__c = state.id;
        assignmentRule.Assignment_by_Zip_Code__c = true;
        assignmentRule.recordTypeID = geoRT.id;
        assignmentRule.Lead_Controller__c = leadController.id;
        
        insert assignmentRule;
        
        Test.StartTest();
        
            List<Opportunity> oppList = new List<Opportunity>();
            
            For(Integer i=0; i<2; i++){
                Opportunity opp= new Opportunity();
                opp.Name= 'Test';
                opp.Site_ZIP__c= '55404';
                opp.StageName = 'New';
                opp.closeDate = date.today();
                opp.RecordTypeId = anthem_opps_rt;
                oppList.add(opp);
    
                Opportunity opp2= new Opportunity();
                opp2.Name= 'Test';
                opp2.Site_ZIP__c= '55405';
                opp2.StageName = 'New';
                opp2.closeDate = date.today();
                opp2.RecordTypeId = anthem_opps_rt;
                oppList.add(opp2);  
            }        
             
             insert oppList;    

        Test.StopTest();
        
        OpportunityTriggerTest.assertOwner(oppList);
    }
    
    
    static testMethod void testAssignmentByBroker() {
        
        OpportunityTriggerTest.init();
    
        Assignment_Rule__c assignmentRule = new Assignment_Rule__c();
        assignmentRule.State__c = state.id;
        assignmentRule.Assignment_by_Zip_Code__c = true;
        assignmentRule.recordTypeID = geoRT.id;
        assignmentRule.Lead_Controller__c = leadController.id;
        
        insert assignmentRule;
        
        Test.StartTest();
        
            List<Opportunity> oppList = new List<Opportunity>();
            
            For(Integer i=0; i<2; i++){
                Opportunity opp= new Opportunity();
                opp.Name= 'Test';
                opp.Site_ZIP__c= '55404';
                opp.StageName = 'New';
                opp.closeDate = date.today();
                opp.Broker_Name__c = 'Broker Name';
                opp.RecordTypeId = anthem_opps_rt;
                oppList.add(opp);
    
                Opportunity opp2= new Opportunity();
                opp2.Name= 'Test';
                opp2.Site_ZIP__c= '55405';
                opp2.StageName = 'New';
                opp2.closeDate = date.today();
                opp2.Broker_Name__c = 'Broker Name';
                opp2.RecordTypeId = anthem_opps_rt;
                oppList.add(opp2);  
            }        
             
             insert oppList;    

        Test.StopTest();

        OpportunityTriggerTest.assertLeadControllerOwner(oppList);
        
    }    
    
    static testMethod void testAssignmentByEvent() {
        
        OpportunityTriggerTest.init();
    
        Assignment_Rule__c assignmentRule = new Assignment_Rule__c();
        assignmentRule.Name = 'Test';
        assignmentRule.recordTypeID = campaignRT.id;
        //assignmentRule.Event_ID__c =eventID.id;
        assignmentRule.Campaign__c = camp.id;
        assignmentRule.User__c = leadController.id;
        
        insert assignmentRule;
        
        Test.StartTest();
        
            List<Opportunity> oppList = new List<Opportunity>();
            
            For(Integer i=0; i<2; i++){
                Opportunity opp= new Opportunity();
                opp.Name= 'Test';
                opp.Site_ZIP__c= '55404';
                opp.StageName = 'New';
                opp.Marketing_Event__c = event_code;              
                opp.closeDate = date.today();
                opp.RecordTypeId = anthem_opps_rt;
                oppList.add(opp);
    
                Opportunity opp2= new Opportunity();
                opp2.Name= 'Test';
                opp2.Site_ZIP__c= '55405';
                opp2.StageName = 'New';
                opp2.Marketing_Event__c = event_code;             
                opp2.closeDate = date.today();
                opp2.RecordTypeId = anthem_opps_rt;
                oppList.add(opp2);  
            }        
             
             insert oppList;    

        Test.StopTest();
        //OpportunityTriggerTest.assertLeadControllerOwner(oppList);
        
    }     
 
    static testMethod void testDeclineOppToAdmin() {
        
        OpportunityTriggerTest.init();
    
        Assignment_Rule__c assignmentRule = new Assignment_Rule__c();
        assignmentRule.State__c = state.id;
        assignmentRule.Assignment_by_State__c = true;
        assignmentRule.recordTypeID = geoRT.id;
        assignmentRule.Lead_Controller__c = leadController.id;
        insert assignmentRule;
        
        Test.StartTest();
        
            Opportunity opp= new Opportunity();
            opp.Name= 'Test';
            opp.Site_ZIP__c= '55404';
            opp.StageName = 'New';
            opp.Marketing_Event__c = event_code;  
            opp.RecordTypeId = anthem_opps_rt;            
            opp.closeDate = date.today();
           
            insert opp;
            OpportunityTriggerHandler.afterWorkFlow = true;
            
            Opportunity oppToUpdate = [Select id, Secondary_Disposition_new__c, StageName, Declined__c from Opportunity where id =: opp.id];
            oppToUpdate.StageName = 'Decline';
            oppToUpdate.Secondary_Disposition_new__c = 'Test';  
            update oppToUpdate;


        Test.StopTest();

        
    }  

    static testMethod void testDeclineOppToRR() {
        
        OpportunityTriggerTest.init();
    
        Assignment_Rule__c assignmentRule = new Assignment_Rule__c();
        assignmentRule.State__c = state.id;
        assignmentRule.Assignment_by_State__c = true;
        assignmentRule.recordTypeID = geoRT.id;
        assignmentRule.Lead_Controller__c = leadController.id;
        insert assignmentRule;
        
        
        Test.StartTest();
        
            Opportunity opp= new Opportunity();
            opp.Name= 'Test';
            opp.Site_ZIP__c= '55404';
            opp.StageName = 'New'; 
            opp.RecordTypeId = anthem_opps_rt;         
            opp.closeDate = date.today();
            
            insert opp;
            OpportunityTriggerHandler.afterWorkFlow = true;

        Test.StopTest();

        Opportunity oppToUpdate = [Select id, Secondary_Disposition_new__c, StageName, Declined__c from Opportunity where id =: opp.id];
        oppToUpdate.StageName = 'Decline';
        oppToUpdate.Secondary_Disposition_new__c = 'Test';
        oppToUpdate.Declined__c = true;

        update oppToUpdate;

        
    }
    
    static testMethod void testAutoAssignment() {

        OpportunityTriggerTest.init();
    
        Assignment_Rule__c assignmentRule = new Assignment_Rule__c();
        assignmentRule.State__c = state.id;
        assignmentRule.Assignment_by_State__c = true;
        assignmentRule.recordTypeID = geoRT.id;
        assignmentRule.Lead_Controller__c = leadController.id;
        insert assignmentRule;
        
        
        Test.StartTest();
        
            Opportunity opp= new Opportunity();
            opp.Name= 'Test';
            opp.Site_ZIP__c= '55404';
            opp.StageName = 'New'; 
            opp.RecordTypeId = anthem_opps_rt;         
            opp.closeDate = date.today();
            
            insert opp;
            
            OpportunityTriggerHandler.afterWorkFlow = true;
            OpportunityTriggerHandler.afterUpdate = true;
        
            Opportunity oppToUpdate = [Select id, Auto_assignment__c from Opportunity where id =: opp.id];
            oppToUpdate.Auto_assignment__c = true;

            update oppToUpdate; 
              
        Test.StopTest();
        
       
            OpportunityTriggerHandler.afterUpdate = true;
            oppToUpdate = [Select id, Auto_assignment__c from Opportunity where id =: opp.id];
            oppToUpdate.Auto_assignment__c = true;

            update oppToUpdate;        
    }
 /*   
    static testMethod void testChangeEventID() {

        OpportunityTriggerTest.init();
    
        Assignment_Rule__c assignmentRule = new Assignment_Rule__c();
        assignmentRule.State__c = state.id;
        assignmentRule.Assignment_by_State__c = true;
        assignmentRule.recordTypeID = geoRT.id;
        assignmentRule.Lead_Controller__c = leadController.id;
        insert assignmentRule;
        
        
        Test.StartTest();
        
            Opportunity opp= new Opportunity();
            opp.Name= 'Test';
            opp.Site_ZIP__c= '55404';
            opp.StageName = 'New';  
            opp.RecordTypeId = anthem_opps_rt;        
            opp.closeDate = date.today();
            
            insert opp;
            
            OpportunityTriggerHandler.afterUpdate = true;
            
            Campaign camp2 = new Campaign();
            camp2.Name = 'TestCampaign2';
            
            insert camp2;

            Campaign aux_camp  = [Select id, Event_Code__c  from Campaign Where id =:camp2.id limit 1];
            
            Event_ID__c eventID2 = new Event_ID__c();
            eventID2.Name = '002';
            eventId2.Event_Campaign_Name__c = camp2.id;
            eventId2.Event_Description__c = 'Description';
            
            insert  eventId2;       
            
        
            Opportunity oppToUpdate = [Select id, Event_ID__c from Opportunity where id =: opp.id];
            oppToUpdate.Event_ID__c = eventId2.id;

            update oppToUpdate; 
              
        Test.StopTest();
        
        
        oppToUpdate = [Select id, CampaignID from Opportunity where id =: opp.id];
        
        system.assertEquals(oppToUpdate.CampaignID, camp2.ID);
        //system.assertEquals(oppToUpdate.Event_Code__c, eventID2.Name);
             
    }  */  
    
 
     static testMethod void testChangeZipCode() {

        OpportunityTriggerTest.init();
    
        Assignment_Rule__c assignmentRule = new Assignment_Rule__c();
        assignmentRule.State__c = state.id;
        assignmentRule.Assignment_by_State__c = true;
        assignmentRule.recordTypeID = geoRT.id;
        assignmentRule.Lead_Controller__c = leadController.id;
        insert assignmentRule;
        
        
        Test.StartTest();
        
            Opportunity opp= new Opportunity();
            opp.Name= 'Test';
            opp.Site_ZIP__c= '55404';
            opp.StageName = 'New';
            opp.RecordTypeId = anthem_opps_rt;          
            opp.closeDate = date.today();
            
            insert opp;
            
            OpportunityTriggerHandler.afterUpdate = true;
            

            Opportunity oppToUpdate = [Select id, Site_ZIP__c from Opportunity where id =: opp.id];
            oppToUpdate.Site_ZIP__c = '55405';

            update oppToUpdate; 
              
        Test.StopTest();
        
        oppToUpdate = [Select id, Zip_Code__c  from Opportunity where id =: opp.id];
        
        Zip_City_County__c zipCode = [Select id, Name from Zip_City_County__c Where Name =: '55405'];
        
        system.assertEquals(oppToUpdate.Zip_Code__c, zipCode.id);
       
    }
    
    static testMethod void testUpdateUser() {
        TestResources.createProfilesCustomSetting();
        TestResources.createRTypeBTrackCustomSettings();
        User broker1;
        Contact contSR;

        OpportunityTriggerTest.init();
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        Test.StartTest();
        System.runAs ( thisUser ) {   
            
            Assignment_Rule__c assignmentRule = new Assignment_Rule__c();
            assignmentRule.State__c = state.id;
            assignmentRule.Assignment_by_State__c = true;
            assignmentRule.recordTypeID = geoRT.id;
            assignmentRule.Lead_Controller__c = leadController.id;
            insert assignmentRule;
    
            Profile salesRepProf = AnthemOppsProfiles.salesRepProfile;
            Profile brokerProf = AnthemOppsProfiles.brokerProfile;
            Profile leadControllerProf = AnthemOppsProfiles.salesAdminProfile;
    
            Account acc = new Account(Name='Account Test');
            insert acc;
                    
            User leadController2 = TestResources.createTestUser('acontrolador','acontrolador','controlador@acme.com','controlador@acme.com',leadControllerProf.Id);
            insert leadController2;
                
            contSR= new Contact(LastName = 'Sales Rep', AccountId = acc.id);
            insert contSR;
                            
            User salesRep2 = TestResources.createTestUser('Sales','Representative','salesrep@acme.com','salesrep@acme.com',salesRepProf.Id);
            salesRep2.contactId = contSR.id;
            salesRep2.Sales_Manager__c = leadController2.id;
            salesRep2.Regional_Brand__c = 'Brand';
            Profile portalUserProfile = [Select id from Profile where Name Like '%Portal User%' Limit 1];   
            salesRep2.ProfileId = portalUserProfile.id;
            insert salesRep2;           
                
            Contact contBR= new Contact(LastName = 'Broker1', AccountId = acc.id);
            insert contBR;
            
            broker1 = TestResources.createTestUser('Broker','Broker','broker@acme.com','broker@acme.com',brokerProf.Id);
            broker1.Sales_Rep__c = salesRep2.id;
            broker1.Opp_Assigned__c = 0;  
            broker1.contactId = contBR.id; 
            broker1.Regional_Brand__c = 'Brand';
            broker1.ProfileId = portalUserProfile.id;
            insert broker1;         
            
            Opportunity opp= new Opportunity();
            opp.Name= 'Test';
            opp.Site_ZIP__c= '55404';
            opp.StageName = 'New';
            opp.RecordTypeId = anthem_opps_rt;          
            opp.closeDate = date.today();
            insert opp;
            
            OpportunityTriggerHandler.afterUpdate = true;               
            Opportunity oppUpdated =  new Opportunity(ID=opp.id);
            // oppUpdated.OwnerID = broker1.id;
    
            update oppUpdated; 
        
            oppUpdated = [Select Id, OwnerId, AccountId, Sales_Rep__c  from Opportunity where id =: opp.id];
            //system.assertEquals(oppUpdated.Sales_Rep__c, contSR.id);
        }       
        
        Test.StopTest();
    }

    /**
     * Tests against OpportunityTriggerHandler.createAccountSharing(LIST newOpps, Map oldOppsMap)
     */
    Static testMethod void testCreateAccountSharing() {
        TestResources.createProfilesCustomSetting();
        TestResources.createRTypeBTrackCustomSettings();
        Contact contSR;

        OpportunityTriggerTest.init();
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        Test.StartTest();
        System.runAs ( thisUser ) {   
            
            Assignment_Rule__c assignmentRule = new Assignment_Rule__c();
            assignmentRule.State__c = state.id;
            assignmentRule.Assignment_by_State__c = true;
            assignmentRule.recordTypeID = geoRT.id;
            assignmentRule.Lead_Controller__c = leadController.id;
            insert assignmentRule;
    
            Profile salesRepProf = AnthemOppsProfiles.salesRepProfile;
            Profile brokerProf = AnthemOppsProfiles.brokerProfile;
            Profile leadControllerProf = AnthemOppsProfiles.salesAdminProfile;
    
            Account acc = new Account(Name='Account Test');
            insert acc;
                    
            User leadController2 = TestResources.createTestUser('acontrolador','acontrolador','controlador@acme.com','controlador@acme.com',leadControllerProf.Id);
            insert leadController2;
                
            contSR= new Contact(LastName = 'Sales Rep', AccountId = acc.id);
            insert contSR;
                            
            User salesRep2 = TestResources.createTestUser('Sales','Representative','salesrep@acme.com','salesrep@acme.com',salesRepProf.Id);
            salesRep2.contactId = contSR.id;
            salesRep2.Sales_Manager__c = leadController2.id;
            salesRep2.Regional_Brand__c = 'Brand';
            Profile portalUserProfile = [Select id from Profile where Name Like '%Portal User%' Limit 1];   
            salesRep2.ProfileId = portalUserProfile.id;
            insert salesRep2;
                
            Contact contBR= new Contact(LastName = 'Broker1', AccountId = acc.id);
            insert contBR;
                       
            Opportunity opp= new Opportunity();
            opp.Name= 'Test';
            opp.Site_ZIP__c= '55404';
            opp.StageName = 'New';
            opp.RecordTypeId = anthem_opps_rt;          
            opp.closeDate = date.today();
            
            insert opp;
            
            OpportunityTriggerHandler.afterUpdate = true;               
            Opportunity oppUpdated =  new Opportunity(ID=opp.id);
            
            oppUpdated.OwnerID = salesRep2.id;
            update oppUpdated; 

            oppUpdated = [Select Id, OwnerId, AccountId, Sales_Rep__c  from Opportunity where id =: opp.id];
            
            List<AccountShare> actShrs = [  SELECT  Id
                                            FROM    AccountShare
                                            WHERE  AccountId = :oppUpdated.AccountId
                                                AND RowCause = 'Manual'];
            // System.assert(actShrs.size() > 0, 'Unable to create Account Sharing.');
        }
        Test.StopTest();
    }
    
     static testMethod void testUpdateOppName() {
         TestResources.createProfilesCustomSetting(); 
         TestResources.createCustomSettings();   
        Test.StartTest();
        
            Opportunity opp= new Opportunity();
            opp.Name= 'Test';
            opp.Company_Name__c = 'Anthem';
            opp.First_Name__c = 'Name';
            opp.Last_Name__c = 'LastName';
            opp.Site_ZIP__c= '55404';
            opp.StageName = 'New'; 
            opp.RecordTypeId = anthem_opps_rt;         
            opp.closeDate = date.today();
            insert opp;   
            
            
            
            Opportunity updateOpp = new Opportunity(id=opp.id);
            updateOpp.First_Name__c ='UpdateName';
            
            update updateOpp;
            
            Opportunity updatedOpp = [Select id, Name,Company_Name__c, First_Name__c,Last_Name__c, CreatedDate from Opportunity Where id=:opp.id limit 1];
            
            String createdDate = date.newinstance(updatedOpp.CreatedDate.year(), updatedOpp.CreatedDate.month(), updatedOpp.CreatedDate.day()).format();
            
            system.assertEquals(updatedOpp.Name , updatedOpp.Company_Name__c + ' - ' + updatedOpp.First_Name__c + ' '+  updatedOpp.Last_Name__c +' '+ createdDate);
        
        
        Test.StopTest();
     }    
       
 
     
}