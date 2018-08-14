/*****************************************************************
Class Name :   AP03_RestrictMultipleSpouseDP
Date Created : 20-May-2015
Created By   : Santosh/Aman
Description  : This is class used in After Insert/Update trigger on Household Member to Restrict Multiple spouse/DP
Referenced/Used in :HouseholdMemberAfterUpdate Trigger, HouseholdMemberAfterInsert Trigger
Changed History : 
**********************************************************************/
Public with sharing Class AP03_RestrictMultipleSpouseDP{

private SET<ID> householdSet= new SET<ID>();
private MAP<ID,Integer> householdMap=new MAP<ID,Integer>();
Public Static boolean isFirstRunHHMbeforeInsert= true;
Public Static boolean isFirstRunHHMbeforeUpdate= true;
/*  
Method name : restrictMultipleSpouceDP
Param 1 : Accepts Household Records List
Return Type : Void
Description : This Method will Check if already Spouse or Domestic Record Exist for Particular Account and restrict Creation 
of new Record if Found any
*/
public void restrictMultipleSpouceDP(List<Household_Member__c> householdList){
    try{
        for(Household_Member__c hr: householdList){     
            householdSet.add(hr.Household_ID__c);             
        }
        for(Household_Member__c h : [Select Id,First_Name__c,Relationship_Type__c,Household_ID__c 
        from Household_Member__c 
        where Household_ID__c in : householdSet
        and ((Relationship_Type__c=:System.Label.Spouse)
        or 
        (Relationship_Type__c=:System.Label.DomesticPartner)) LIMIT 10000]){
            if(householdMap.containsKey(h.Household_ID__c)){
                integer recCount = householdMap.get(h.Household_ID__c);
                recCount = recCount+1;
                householdMap.put(h.Household_ID__c,recCount); 
            }
            else{
                Integer recCount = 1;
                householdMap.put(h.Household_ID__c,recCount);
            }                                              
        }
        if(!householdMap.isEmpty()){                                        
            for (Household_Member__c hr1 : householdList){            
                if (householdMap.containsKey(hr1.Household_ID__c) && householdMap.get(hr1.Household_ID__c)>1 && hr1.RelationShip_Type__c !='Dependent'){
                    hr1.addError(System.Label.Single_SPDP);
                }
            }
        }
    }catch(Exception e){ 
        e.getMessage();
    }
}
}