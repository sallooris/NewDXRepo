/**
* Dispatcher class to help split Leads by RecordTypes and route to the
* proper method.
* 
* @Date: 5/14/2015
* @Author: Andres Di Geronimo-Stenberg (Magnet360)
* 
*/
public class LeadTriggerDispatcher 
{
    public static ID anthem_opps_rt
    {
        get{
            if ( anthem_opps_rt == null )
            {
                anthem_opps_rt = [ Select Id From RecordType 
                                   Where DeveloperName =: 'Anthem_Opps' And SobjectType = :'Lead' 
                                   Limit 1 ].id;
            }
            return anthem_opps_rt;
        } set;
    }

    // BEFORE INSERT 
    public static void onBeforeInsert( List< Lead > a_lead_list )
    {
        List< Lead > l_anthem_list = getLeadsByRecordType( a_lead_list , anthem_opps_rt , true );

        if( l_anthem_list.size() > 0 )
        {
            AnthemOppsLeadHandler.onBeforeInsert( l_anthem_list );
        }
    }
    
    // BEFORE UPDATE 
    public static void onBeforeUpdate( Map< Id , Lead > a_lead_map , Map< Id , Lead > a_old_lead_map )
    {
        List< Lead > l_anthem_list = getLeadsByRecordType( a_lead_map.values() , anthem_opps_rt , true );

        if( l_anthem_list.size() > 0 )
        {
            AnthemOppsLeadHandler.onBeforeUpdate( l_anthem_list , a_old_lead_map  );
        }        
    }
    /*
    // BEFORE DELETE 
    public static void onBeforeDelete( Map< Id , Lead > a_lead_map )
    {
    }
    */
    // AFTER INSERT 
    public static void onAfterInsert( Map< Id , Lead > a_lead_map )
    {
        List< Lead > l_anthem_list = getLeadsByRecordType( a_lead_map.values() , anthem_opps_rt , true );

        if( l_anthem_list.size() > 0 )
        {
            AnthemOppsLeadHandler.onAfterInsert( l_anthem_list );
        }          
    }
    
    
    // AFTER UPDATE 
    public static void onAfterUpdate(  Map< Id , Lead > a_lead_map , Map< Id , Lead > a_old_lead_map )
    {
        List< Lead > l_anthem_list = getLeadsByRecordType( a_lead_map.values() , anthem_opps_rt , true );

        if( l_anthem_list.size() > 0 )
        {
            AnthemOppsLeadHandler.onAfterUpdate( l_anthem_list , a_old_lead_map );
        }        
    }
    /*
    // AFTER DELETE 
    public static void onAfterDelete(  Map< Id , Lead > a_lead_map )
    {
    }

    // AFTER UNDELETE 
    public static void onAfterUnDelete(  Map< Id , Lead > a_lead_map )
    {
    }

    */
    //Get a List of Leads by the RecordType passed as paramether
    // @param a_include_rt : if true, it will get the leads with recordtype == a_record_type
    // if false, it will get the leads with recordType != a_record_type and Group checked
    private Static List< Lead > getLeadsByRecordType( List< Lead > a_lead_list ,  Id a_record_type , Boolean a_include_rt  )
    {
        List< Lead > l_lead_list = new List< Lead >();

        for( Lead l : a_lead_list )
        {
            if( l.RecordTypeId == a_record_type && a_include_rt && l.EventText__c != 'FAIL')
            {
                l_lead_list.add( l );
            }
            else if( !a_include_rt && l.Group__c )
            {
                l_lead_list.add( l );
            }
        }
        return l_lead_list;        
    }

}