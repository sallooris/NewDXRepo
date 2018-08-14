/****************************************************************************
Class Name  :  OpportunityDelete_Test
Date Created:  15-Aug-2015
Created By  :  Bhaskar
Description :  1. Test Class for Opportunity Before Delete / After Delete and After undelete
Change History :    
****************************************************************************/
/*    Test Class : - OpportunityBefore/After Delete and After Undelete Trigger */
@isTest
private  class OpportunityDelete_Test{ 
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
            
            Opportunity op = [select id from opportunity where id = :opp.id];
            delete op;
            
            undelete op;
            
        Test.StopTest();
     }    

}