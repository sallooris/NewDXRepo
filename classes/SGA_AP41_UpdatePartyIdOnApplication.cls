/*******************************************************************************
* Class Name   : SGA_AP41_UpdatePartyIdOnApplication
* Created By   : IDC Offshore
* Created Date : 8/25/2017
* Description  : This class is Used to update party id on application record.
*******************************************************************************/
public without sharing class SGA_AP41_UpdatePartyIdOnApplication {
    /*****************************************************************************************************
     * Method Name  : updatePartyAccount
     * Created Date : 25-Aug-2017
     * Parameters   : List<vlocity_ins__Application__c>
     * Return type  : void
     * Created By   : IDC Offshore
     * Description  : Used to update party id on application record.
     *****************************************************************************************************/
    public void updatePartyAccount(List<vlocity_ins__Application__c> appList){
        Set<String> accountSet = new Set<String>();//this contains the ids of the accounts where party id is null
        Set<String> partySet = new Set<String>();//this contains the ids of the party where account id is null
        
        for(vlocity_ins__Application__c applicationObj : appList){
            if(String.isBlank(applicationObj.vlocity_ins__PrimaryPartyId__c) && String.isNotBlank(applicationObj.vlocity_ins__AccountId__c)){
                accountSet.add(applicationObj.vlocity_ins__AccountId__c);
            }else if(String.isNotBlank(applicationObj.vlocity_ins__PrimaryPartyId__c) && String.isBlank(applicationObj.vlocity_ins__AccountId__c)){
                partySet.add(applicationObj.vlocity_ins__PrimaryPartyId__c);
            }
        }
        //map to store the account ids and its party id
        Map<String,String> accountPartyMap = new Map<String,String>();
        if(!accountSet.isEmpty()){
            List<vlocity_ins__Party__c> partyList = [SELECT ID,vlocity_ins__AccountId__c FROM vlocity_ins__Party__c WHERE vlocity_ins__AccountId__c IN :accountSet];
            for(vlocity_ins__Party__c partyObj : partyList){
                accountPartyMap.put(partyObj.vlocity_ins__AccountId__c,partyObj.Id);
            }
        }
        //map to store the party ids and its account id
        Map<String,String> partyAccountMap = new Map<String,String>();
        if(!partySet.isEmpty()){
            List<vlocity_ins__Party__c> partyList = [SELECT ID,vlocity_ins__AccountId__c FROM vlocity_ins__Party__c WHERE ID IN :partySet];
            for(vlocity_ins__Party__c partyObj : partyList){
                partyAccountMap.put(partyObj.Id,partyObj.vlocity_ins__AccountId__c);
            }
        }
        for(vlocity_ins__Application__c applicationObj : appList){
            if(String.isBlank(applicationObj.vlocity_ins__PrimaryPartyId__c) && String.isNotBlank(applicationObj.vlocity_ins__AccountId__c)){
                if(accountPartyMap.get(applicationObj.vlocity_ins__AccountId__c) != NULL){
                    applicationObj.vlocity_ins__PrimaryPartyId__c = accountPartyMap.get(applicationObj.vlocity_ins__AccountId__c);
                }
            }else if(String.isNotBlank(applicationObj.vlocity_ins__PrimaryPartyId__c) && String.isBlank(applicationObj.vlocity_ins__AccountId__c)){
                if(partyAccountMap.get(applicationObj.vlocity_ins__PrimaryPartyId__c) != NULL){
                    applicationObj.vlocity_ins__AccountId__c = partyAccountMap.get(applicationObj.vlocity_ins__PrimaryPartyId__c);
                }
            }
        }
    }
}