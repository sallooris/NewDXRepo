/*************************************************************
Trigger Name : LeadBeforeInsert/LeadBeforeUpdate
ClassName    : AP19_TechStreetValue
Date Created : 20-August-2015
Created By   : Amanjot
Description  : This class is used to copy value from Street field to TECH_Street
*****************************************************************/
public with sharing class AP19_PopulateTechStreetValue{
 public static boolean isLeadInsertFirstRun = true;
 public static boolean isLeadUpdateFirstRun = true;
 /*
    Method Name: Tech_street_value
    Parameter1 : List of lead records, which are inserting/updating.
    Return Type: void
    Description: This class is used to copy value from Street field to TECH_Street
                
*/
public void  populateTechStreetVal(List<Lead> ldList){ 
         for(Lead l : ldList)
         {
           if(l.street != null){
                l.Tech_Street__c = l.Street;
           }
         }
    }
}