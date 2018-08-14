/**
* Dispatcher class to help split Opportunities by RecordTypes and route to the
* proper method.
* 
* @Date: 5/11/2015
* @Author: Andres Di Geronimo-Stenberg (Magnet360)
* 
*/
public class OpportunityTriggerDispatcher 
{

    private static String CREATED_UPON_CONVERSION = 'created_upon_conversion';

    public static ID anthem_opps_rt
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

    // BEFORE INSERT 
    public static void onBeforeInsert( List< Opportunity > a_opp_list )
    {
        List< Opportunity > l_anthem_list = getOpportunitiesByRecordTypeOrName( a_opp_list , anthem_opps_rt );

        if( l_anthem_list.size() > 0 )
        {
            AnthemOpportunityHandler.onBeforeInsert( l_anthem_list );
        }
    }

    // BEFORE UPDATE 
    public static void onBeforeUpdate( Map< Id , Opportunity > a_opp_map , Map< Id , Opportunity > a_old_opp_map )
    {
        List< Opportunity > l_anthem_list = getOpportunitiesByRecordType( a_opp_map.values() , anthem_opps_rt );

        if( l_anthem_list.size() > 0 )
        {
            AnthemOpportunityHandler.onBeforeUpdate( l_anthem_list , a_old_opp_map );
        }
    }
    
    // BEFORE DELETE 
    public static void onBeforeDelete( Map< Id , Opportunity > a_opp_map )
    {
    }

    // AFTER INSERT 
    public static void onAfterInsert( Map< Id , Opportunity > a_opp_map )
    {
        List< Opportunity > l_anthem_list = getOpportunitiesByRecordType( a_opp_map.values() , anthem_opps_rt );

        if( l_anthem_list.size() > 0 )
        {
            AnthemOpportunityHandler.onAfterInsert( l_anthem_list );
        }
    }

    // AFTER UPDATE 
    public static void onAfterUpdate(  Map< Id , Opportunity > a_opp_map , Map< Id , Opportunity > a_old_opp_map )
    {
    }
    
    // AFTER DELETE 
    public static void onAfterDelete(  Map< Id , Opportunity > a_opp_map )
    {
    }

    // AFTER UNDELETE 
    public static void onAfterUnDelete(  Map< Id , Opportunity > a_opp_map )
    {
    }

    //Get a Map of Opportunities by the RecordType passed as paramether
    private Static List< Opportunity > getOpportunitiesByRecordType( List< Opportunity > a_opp_list ,  Id a_record_type )
    {
        List< Opportunity > l_opp_list = new List< Opportunity >();

        for( Opportunity opp : a_opp_list )
        {
            if( opp.RecordTypeId == a_record_type )
            {
                l_opp_list.add( opp );
            }
        }
        return l_opp_list;        
    }

    //Get a Map of Opportunities by the RecordType passed as paramether or
    //by opp.name
    private Static List< Opportunity > getOpportunitiesByRecordTypeOrName( List< Opportunity > a_opp_list ,  Id a_record_type )
    {
        List< Opportunity > l_opp_list = new List< Opportunity >();

        for( Opportunity opp : a_opp_list )
        {
            if( opp.RecordTypeId == a_record_type || opp.Name == CREATED_UPON_CONVERSION )
            {
                l_opp_list.add( opp );
            }
        }
        return l_opp_list;        
    }
       
}