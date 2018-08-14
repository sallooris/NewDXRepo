/**
* Class that handles leads with Recordtype Anthem Opps
* proper method.
* 
* @Date: 5/14/2015
* @Author: Andres Di Geronimo-Stenberg (Magnet360)
* 
*/
public class AnthemOppsLeadHandler 
{
    public static ID anthem_opps_acc_rt
    {
        get{
            if ( anthem_opps_acc_rt == null )
            {
                anthem_opps_acc_rt = [ Select Id From RecordType 
                                        Where DeveloperName =: 'Anthem_Opps' And SobjectType = :'Account' 
                                        Limit 1 ].id;
            }
            return anthem_opps_acc_rt;
        } set;
    }

    public static ID anthem_opps_cont_rt
    {
        get{
            if ( anthem_opps_cont_rt == null )
            {
                anthem_opps_cont_rt = [ Select Id From RecordType 
                                        Where DeveloperName =: 'Anthem_Opps' And SobjectType = :'Contact' 
                                        Limit 1 ].id;
            }
            return anthem_opps_cont_rt;
        } set;
    }

    //Custom setting with all the fields to be copy from the lead to the 
    //Acc, Cont and Opp.
    private static List< Map_Lead_Fields__c > map_lead_fields
    {
        get{
            if ( map_lead_fields == null )
            {
                map_lead_fields =  new List< Map_Lead_Fields__c >();
                Map< String, Map_Lead_Fields__c > l_map = Map_Lead_Fields__c.getAll();
                if( l_map.size() > 0 )
                {
                    map_lead_fields = l_map.values();
                }
            }
            return map_lead_fields;
        } set;
    }


    public static void onBeforeInsert( List< Lead > a_lead_list )
    {
        //changeRecordType( a_lead_list , LeadTriggerDispatcher.anthem_opps_rt );
        List< Lead > l_lead_to_update = new List< Lead >();
        Set< ID > l_camp_id = new Set< ID >();


        for( Lead l : a_lead_list )
        {
            //Check if the lead should be converted. ETL_Process__c == 2
            if( l.ETL_Process__c == 2 )
            {
                l.ETL_Process__c = 3;
            }
            if( l.Marketing_Event__c != null )
            {
                l_camp_id.add( l.Marketing_Event__c );
            }
        }

        if( l_camp_id.size() > 0 )
        {
            setEventID( a_lead_list , l_camp_id );
        }

    }

    private static void setEventID( List< Lead > a_lead_list , Set< ID > a_camp_id )
    {
        Map<String, Campaign> l_camp_map =new Map<String, Campaign>();
        Map<Id,String> campaignIdToName = new Map<Id,String>();
        Set<String> campaignNames = new Set<String>();
        List<Campaign> campaigns = [SELECT Id, Name FROM Campaign Where ID IN: a_camp_id  ] ; //AND RecordType.DeveloperName = 'Anthem_Opps'
        System.debug('UAC: campaigns ' + campaigns );

        for( Campaign c : campaigns )
        {
            campaignNames.add(c.Name);
            campaignIdToName.put(c.Id, c.Name);
        }
        System.debug('UAC: campaignNames ' + campaignNames );
        
        for( Campaign c : [SELECT Id, Name FROM Campaign Where Name IN :campaignNames AND RecordType.DeveloperName = 'Anthem_Opps' ]) 
        {
            l_camp_map.put(c.Name, c);
        }
        System.debug('UAC: l_camp_map ' + l_camp_map );
        
        for( Lead l : a_lead_list )
        {
            if( l.Marketing_Event__c != null )
            {
                if( l_camp_map.containsKey( campaignIdToName.get(l.Marketing_Event__c)) ) 
                {
                    l.Event_Code__c = l_camp_map.get(  campaignIdToName.get(l.Marketing_Event__c) ).Name;
                    l.Marketing_Event__c =   l_camp_map.get(  campaignIdToName.get(l.Marketing_Event__c) ).Id ;
                }
            }
        }
    }

    //
    public static void onBeforeUpdate( List< Lead > a_lead_list , Map< Id, Lead > a_lead_old_map )
    {
        List< Lead > l_lead_to_update = new List< Lead >();
        Set< ID > l_camp_id = new Set< ID >();

        for( Lead l : a_lead_list )
        {
            //Lead old_lead = a_lead_old_map.get( l.id );

            /*if( l.Group__c !=  old_lead.Group__c && l.Group__c )
            {
                l_lead_to_update.add( l );
            }

            if( l.Group__c ) 
            {*/
                //Check if the lead should be converted. ETL_Process__c == 2
                if( l.ETL_Process__c == 2 )
                {
                    l.ETL_Process__c = 3;
                }
                if( l.Marketing_Event__c != null && l.Marketing_Event__c != a_lead_old_map.get(l.id).Marketing_Event__c )
                {
                    l_camp_id.add( l.Marketing_Event__c );
                }
                else if( l.Marketing_Event__c == null &&  a_lead_old_map.get(l.id).Marketing_Event__c != null )
                {
                    l.Event_Code__c = '';
                }

            //}
        }

        /*if( l_lead_to_update.size() > 0 )
        {
            changeRecordType( l_lead_to_update , LeadTriggerDispatcher.anthem_opps_rt );
        }*/

        if( l_camp_id.size() > 0 )
        {
            setEventID( a_lead_list , l_camp_id );
        }

    }    

    //Call the lead convertion
    public static void onAfterInsert( List< Lead > a_lead_list )
    {
        List< Lead > l_lead_to_update = new List< Lead >();

        for( Lead l : a_lead_list )
        {
            if( l.ETL_Process__c == 3)
            {
                l_lead_to_update.add( l );
            }
        }

        if( l_lead_to_update.size() > 0 )
        {
            convertLeads( l_lead_to_update );
        }

    }

    //Checks if a lead needs to be converted
    public static void onAfterUpdate( List< Lead > a_lead_list , Map< Id, Lead > a_lead_old_map )
    {

        List< Lead > l_lead_to_update = new List< Lead >();

        for( Lead l : a_lead_list )
        {
            Lead old_lead = a_lead_old_map.get( l.id );
            
            if( l.ETL_Process__c == 3)
            {
                l_lead_to_update.add( l );
            }
        }

        if( l_lead_to_update.size() > 0 )
        {
            convertLeads( l_lead_to_update );
        }
    }    

    //After a lead with record Type = AnthemOpps is created, it will be converted to an
    //Account with Opp and Cont. All those records will have record type AnthemOpps
    private static void convertLeads( List< Lead > a_lead_list )
    {
        try{
            LeadStatus l_convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];

            List< Database.LeadConvert > l_lead_convert_List = new List<Database.LeadConvert>();

            List< Account > l_acc_to_insert = new List< Account >();
                                                    //The Acc associated with the opp
                                                    //should have opps_lead recort type
            for( Lead l : a_lead_list )
            {
                if( !l.IsConverted )
                {
                    l_acc_to_insert.add( setAccount( l ) );
                }
            }

            if( l_acc_to_insert.size() > 0 )
            {
                upsert l_acc_to_insert;
            }

            List< Contact > l_cont_to_insert = new List< Contact >();
            Integer i = 0;
                                                    //The Cont associated with the opp
                                                    //should have opps_lead recort type
            for( Lead l : a_lead_list )
            {
                if( !l.IsConverted )
                {
                    l_cont_to_insert.add( setContact( l , l_acc_to_insert[i].id ) );
                    i++;
                }
            }

            if( l_cont_to_insert.size() > 0  )
            {
                upsert l_cont_to_insert;
            }

            List< Lead > l_lead_for_opportunity = new List< Lead >();
            i = 0;
            for( Lead l : a_lead_list )
            {
                if( !l.IsConverted )
                {
                    Database.LeadConvert lc = new Database.LeadConvert();
                    lc.setLeadId( l.id );
                    //lc.setConvertedStatus('Opportunity');
                    lc.setConvertedStatus('Qualified');

                    if( l.LeadAccountID__c != null && l.LeadOpportunityID__c!=null )
                    {
                        lc.doNotCreateOpportunity = true;   
                        l_lead_for_opportunity.add( l );
                    }
                    else
                    {
                        lc.setOpportunityName( 'created_upon_conversion' );
                    }
                    lc.setAccountId(l_acc_to_insert[i].id);
                    lc.setContactId(l_cont_to_insert[i].id); 
                    l_lead_convert_List.add( lc );

                    i++;
                }
            }

            List< Database.LeadConvertResult > l_lead_convert_results_List;

            if ( ! l_lead_convert_List.isEmpty() )
            {
                l_lead_convert_results_List = Database.convertLead( l_lead_convert_List, true );
                copyLeadToOpportunity( l_lead_for_opportunity );
            }
        }
        catch( System.DmlException e )
        {
            a_lead_list[0].addError( e.getDmlMessage(0) /*+ '. Please note that Prospect ID should be unique.'*/ );
        }
    }


    //Copy values from the a_lead to a_object. We will use the custom setting to 
    //know which fields are going to be copy. 
    private static SObject copyToObject( SObject a_lead , SObject a_object , String a_object_name )
    {

        for( Map_Lead_Fields__c mlf : map_lead_fields )
        {
            if( mlf.Object__c == a_object_name )
            {
                if( !mlf.Field_Type_Not_Text__c )
                {
                    if( String.isNotBlank( (String)a_lead.get( mlf.Lead_Field_API_Name__c ) ) )
                    {
                        a_object.put( mlf.Field_Api_ID__c, a_lead.get(mlf.Lead_Field_API_Name__c ) );
                    }
                }
                else
                {
                    if( a_lead.get( mlf.Lead_Field_API_Name__c ) != null )
                    {
                        a_object.put( mlf.Field_Api_ID__c, a_lead.get(mlf.Lead_Field_API_Name__c ) );
                    }
                }
            }
        }
        return a_object;
    }


    //If Opp Id is present in the Lead, will update some field in the Opp
    private static void copyLeadToOpportunity( List< Lead > a_lead_list )
    {
        List< Opportunity > l_opp_to_update = new List< Opportunity >();

        for( Lead l : a_lead_list )
        {
            Opportunity opp = new Opportunity( ID = l.LeadOpportunityID__c );
            //opp.Converted_Lead_ID__c = l.id;

            l_opp_to_update.add( (Opportunity)(copyToObject( (SObject) l , (SObject) opp , 'Opportunity' ) ) );        
        }

        if( l_opp_to_update.size() > 0 )
        {
            update l_opp_to_update;
        }
    }
    //If account Id is present in the Lead, will update some field in the Account
    private static Account setAccount( Lead a_lead )
    {
        Account acc ;

        if( a_lead.LeadAccountID__c !=null )
        {
            acc =  new Account( Id = a_lead.LeadAccountID__c );
        }
        else
        {
            acc =  new Account();
            acc.Lead_ID__c = a_lead.id;
        }
        acc.Lead_ID__c = a_lead.id;
        acc.RecordTypeId = anthem_opps_acc_rt;

        return (Account)(copyToObject( (SObject)a_lead , (SObject)acc , 'Account' ) );
    }

    //If contact Id is present in the Lead, will update some field in the Contact
    private static Contact setContact( Lead a_lead , ID a_acc_id ) 
    {
        Contact cont;

        if( a_lead.LeadAccountID__c != null && a_lead.LeadContactID__c!=null )
        {
            cont = new Contact( ID = a_lead.LeadContactID__c );
        }
        else
        {
            cont = new Contact();
            cont.Lead_ID__c = a_lead.id;
        }

        cont.Lead_ID__c = a_lead.id;
        cont.AccountID = a_acc_id;
        cont.RecordTypeId = anthem_opps_cont_rt;

        return (Contact)(copyToObject( (SObject)a_lead , (SObject)cont , 'Contact' ) );
    }

    //Changes the recorType of the Lead, with the recordType passed as parameter
    /*private static void changeRecordType( List< Lead > a_lead_list , Id a_record_type ) 
    {
        for( Lead l : a_lead_list )
        {
            l.RecordTypeId = a_record_type;
        }
    } */ 

}