/*****************************************************************
Class Name :   AP15_AllowedDuplicateRecords
Date Created : 22-July-2015
Created By   : Bhaskar
Description  : This class is used to update the Allowed Duplicate check box when the users ignored the duplicate rule alert
Referenced/Used in :DuplicateRecordItemAfterInsert 
Changed History : 
**********************************************************************/
public with sharing class AP15_AllowedDuplicateRecords{
    /*  
    Method name : updateDuplicateLeadRecords
    Param 1     : List of Lead Ids
    Return Type : Void
    Description : This method is used to update the Allowed Duplicate check box when the users ignored the duplicate rule alert
    */
    public static void updateDuplicateLeadRecords(List<ID> leadIds){
        try{
            List<Lead> leadList = [SELECT ID,NAME,Allowed_Duplicate__c,Tech_BusinessTrack__c FROM LEAD WHERE ID IN :leadIds AND Tech_Businesstrack__c='TELESALES'];
            List<lead> dupLeadList = new List<Lead>();
            List<Lead> updateLeadList = new List<lead>();
            if(!leadList.isEmpty()){
                for(Lead ld : leadList){
                    if('TELESALES'.equalsIgnoreCase(ld.Tech_BusinessTrack__c) && ld.Allowed_Duplicate__c!=true){
                    dupLeadList.add(ld);
                    }
                }
            }
            if(!leadList.isEmpty()){
                for(Lead l : dupLeadList){
                    l.Allowed_Duplicate__c = true;
                    updateLeadList.add(l);
                }
            }
            if(!updateLeadList.isEmpty()){
                update updateLeadList;   
            }
         }catch(Exception e){
             
         }
    }
}