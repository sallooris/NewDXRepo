/**
* Dispatcher class to help split Account by RecordTypes and route to the
* proper method.
* 
* @Date: 5/22/2015
* @Author: Andres Di Geronimo-Stenberg (Magnet360)
* 
*/
public with sharing class AccountTriggerDispatcher 
{
    // BEFORE INSERT 
    public static void onBeforeInsert( List< Account > a_acc_list )
    {

    }
    /*
    // BEFORE UPDATE 
    public static void onBeforeUpdate( Map< Id , Account > a_acc_map , Map< Id , Account > a_old_acc_map )
    {
    }
    
    // BEFORE DELETE 
    public static void onBeforeDelete( Map< Id , Account > a_acc_map )
    {
    }

    // AFTER INSERT 
    public static void onAfterInsert( Map< Id , Account > a_acc_map )
    {
    }

    // AFTER UPDATE 
    public static void onAfterUpdate(  Map< Id , Account > a_acc_map , Map< Id , Account > a_old_acc_map )
    {
    }
    
    // AFTER DELETE 
    public static void onAfterDelete(  Map< Id , Account > a_acc_map )
    {
    }

    // AFTER UNDELETE 
    public static void onAfterUnDelete(  Map< Id , Account > a_acc_map )
    {
    }
    */

}