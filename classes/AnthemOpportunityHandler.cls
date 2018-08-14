/**
* Methods that process Opportunities with RecordType = Anthem_Opps
* 
* @Date: 5/11/2015
* @Author: Andres Di Geronimo-Stenberg (Magnet360)
* 
*/
public class AnthemOpportunityHandler 
{
    //Method called befire insert an opportunity with recordType AnthemLeads
    public static void onBeforeInsert( List< Opportunity > a_opp_list )
    {
        system.debug( '*****************Before Insert ' + a_opp_list );
        
        OpportunityTriggerHandler.checkConversion( a_opp_list );
        
        OpportunityTriggerHandler.updateOppName( a_opp_list , true );
        
        //Check if it is a batch insert
        if( !OpportunityTriggerHandler.insertingBatch() )
        {
            RoundRobin.assignmentRules( a_opp_list );       
        }
        
        
    }

    //Method called before update an opportunity with recordType AnthemLeads
    public static void onBeforeUpdate( List< Opportunity > a_opp_list , Map< Id , Opportunity > a_old_opp_map )
    {
        system.debug( '*****************Before Update' + a_opp_list );
        
        OpportunityTriggerHandler.createAccountSharing( a_opp_list, a_old_opp_map );
        OpportunityTriggerHandler.checkBeforeUpdateOppName( a_opp_list , a_old_opp_map );

        if( OpportunityTriggerHandler.afterUpdate )
        {
            OpportunityTriggerHandler.afterUpdate( a_opp_list , a_old_opp_map );
            OpportunityTriggerHandler.afterUpdate = false;
        }
        //We need to wait for the workflow to updated the field Declined__c,
        //so the first time that the trigger is execute, we dont want to call the method
        if( OpportunityTriggerHandler.afterWorkFlow )
        {  
            OpportunityTriggerHandler.afterWorkFlow( a_opp_list , a_old_opp_map );  
        }
        else
        {
            OpportunityTriggerHandler.afterWorkFlow = true;
        }

        OpportunityTriggerHandler.setOppTeam( a_opp_list );
    }

    //Method called after insert an opportunity with recordType AnthemLeads
    public static void onAfterInsert( List< Opportunity > a_opp_list )
    {
    
        system.debug( '*****************After Insert ' + a_opp_list );
        //Check if it is a batch insert
        if( !OpportunityTriggerHandler.insertingBatch() )
        {
            RoundRobin.afterInsert( a_opp_list );    
        }
            
        OpportunityTriggerHandler.setOppTeam( a_opp_list ); 
    }
}