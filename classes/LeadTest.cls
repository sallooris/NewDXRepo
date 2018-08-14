@isTest
private class LeadTest
{
    @testSetUp static void setUpCustomSetting(){
        List<sObject> ls0=Test.loadData(CS001_RecordTypeBusinessTrack__c.sObjectType,'Test_CS001RecordTypeBusinessTrack');
         List<sObject> ls1=Test.loadData(Profiles__c.sObjectType,'AnthemOppsProfiles');
    }
    
    @testSetup static void initCustomSetting() 
    {
        List< Map_Lead_Fields__c > map_list =  new List< Map_Lead_Fields__c >();
        Map_Lead_Fields__c mlf_acc = new Map_Lead_Fields__c();
        mlf_acc.Name = 'Acc1';
        mlf_acc.Field_Api_ID__c = 'Name';
        mlf_acc.Lead_Field_API_Name__c = 'Company';
        mlf_acc.Object__c = 'Account';
        map_list.add( mlf_acc );

        Map_Lead_Fields__c mlf_acc2 = new Map_Lead_Fields__c();
        mlf_acc2.Name = 'Acc2';
        mlf_acc2.Field_Api_ID__c = 'Phone';
        mlf_acc2.Lead_Field_API_Name__c = 'Phone';
        mlf_acc2.Object__c = 'Account'; 
        mlf_acc2.Field_Type_Not_Text__c = true;
        map_list.add( mlf_acc2 ); 

        Map_Lead_Fields__c mlf_cont = new Map_Lead_Fields__c();
        mlf_cont.Name = 'Cont1';
        mlf_cont.Field_Api_ID__c = 'LastName';
        mlf_cont.Lead_Field_API_Name__c = 'LastName';
        mlf_cont.Object__c = 'Contact'; 
        map_list.add( mlf_cont );

        Map_Lead_Fields__c mlf_opp = new Map_Lead_Fields__c();
        mlf_opp.Name = 'Opp';
        mlf_opp.Field_Api_ID__c = 'StageName';
        mlf_opp.Lead_Field_API_Name__c = 'Status';
        mlf_opp.Object__c = 'Opportunity'; 
        map_list.add( mlf_opp );                      

        insert map_list;    

    }

    public static ID anthem_opps_rt
    {
        get{
            if ( anthem_opps_rt == null )
            {
                anthem_opps_rt = [ Select Id From RecordType 
                                   Where DeveloperName = 'Anthem_Opps' And SobjectType = 'Lead' 
                                   Limit 1 ].id;
            }
            return anthem_opps_rt;
        } set;
    }

    public static ID other_rt
    {
        get{
            if ( other_rt == null )
            {
                other_rt = [ Select Id From RecordType 
                                   Where DeveloperName != 'Anthem_Opps' And SobjectType = 'Lead' 
                                   Limit 1 ].id;
            }
            return other_rt;
        } set;
    }

  @isTest
  static void convertLead()
  {
        TestResources.createProfilesCustomSetting();

        List< Campaign > campaign_list = new List< Campaign >();
        Id rtId = [SELECT Id FROM RecordType where SobjectType = 'Campaign' AND DeveloperName = 'Anthem_Opps'].Id ;

        Campaign cc = new Campaign();
        cc.RecordTypeId = rtId ;
        cc.Name = '0003';
        campaign_list.add( cc );

        Campaign cc2 = new Campaign();
        cc2.RecordTypeId = rtId ;
        cc2.Name = '0008';
        campaign_list.add( cc2 );   

        insert campaign_list;


        Test.startTest();
            Lead l = new lead();
            l.RecordTypeId = anthem_opps_rt;
            l.LastName = 'TestLastName';
            l.Company = 'TestCompany';
            l.PostalCode = '00000';
            l.City = 'Minneapolis';
            l.Street = '1501 Fake St';
            l.State = 'XX';
            //l.Group__c = true;
            l.ETL_Process__c = 1;
            l.Working_with_Broker__c = 'No';
            l.Currently_Offer_Insurance__c = 'No';
            l.Marketing_Event__c = cc2.id;
      		l.Tech_Businesstrack__c = 'ANTHEMOPPS';
            //l.Event_Code__c = '0008';
            insert l;

            Lead l_updated = [ Select id,ETL_Process__c, RecordTypeId From Lead Where id = :l.id Limit 1 ];
            l_updated.ETL_Process__c = 2;
            update l_updated;

            l_updated = [ Select id, isConverted From Lead Where id = :l.id Limit 1 ];
            System.assertEquals( l_updated.isConverted , true );   

            Lead l_converted = [Select id, ConvertedAccountId, ConvertedContactId, ConvertedOpportunityId From Lead Where Id = : l.id];

            Lead l_2 = new lead();
            l_2.RecordTypeId = anthem_opps_rt;
            l_2.LastName = 'TestLastName';
            l_2.Company = 'TestCompany';
            l_2.PostalCode = '00000';
            l_2.City = 'Minneapolis';
            l_2.Street = '1501 Fake St';
            l_2.State = 'XX'; 
            l_2.Marketing_Event__c = cc.id;
            //l_2.Event_Code__c = '0003';
            l_2.FirstName ='TestFirstName';
            l_2.Title = 'Mister';
            l_2.Phone = '612592123';
            l_2.Email = 'di@di.com';
            l_2.Call_Center_Notes__c = 'Notes';
            l_2.Anthem_Prospect_ID__c = '2323131';
            l_2.Status = 'New';
            l_2.NumberOfEmployees = 8;
            l_2.Language__c = 'EN';
            l_2.Currently_Offer_Insurance__c = 'Yes';
            l_2.Current_Provider__c = 'Test';
            l_2.Renewal_Date__c = date.today();
            l_2.Working_with_Broker__c = 'Yes';
            l_2.Broker_Name__c = 'Name';
            l_2.Products_of_Interest__c = 'Test';
            l_2.Dental__c = 'Yes';
            l_2.Disability__c = 'Yes';
            l_2.Vision__c = 'Yes';
            l_2.Life__c = 'Yes';
            l_2.LeadOpportunityID__c = l_converted.ConvertedOpportunityId;
            l_2.LeadAccountID__c = l_converted.ConvertedAccountId;
            l_2.LeadContactID__c = l_converted.ConvertedContactId;
            //l_2.Group__c = true;
            l_2.ETL_Process__c = 1;
            insert l_2;        

            Lead l_updated_2 = [ Select Id,ETL_Process__c, RecordTypeId From Lead Where id = :l_2.id Limit 1 ];

            l_updated_2.ETL_Process__c = 2;
            update l_updated_2;

            l_updated_2 = [ Select id, isConverted From Lead Where id = :l_updated_2.id Limit 1 ];
            System.assertEquals( l_updated_2.isConverted , true );            

        Test.stopTest();

  }
}