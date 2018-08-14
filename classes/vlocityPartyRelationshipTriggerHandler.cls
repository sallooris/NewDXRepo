/**
 * Class Name : vlocityPartyRelationshipTriggerHandler
 * Author : nmishra@vlocity.com
 * Description : Trigger Handler for the vlocity_ins__PartyRelationship__c SObject. This class provides as an handler for events in vlocityPartyRelationship.Trigger
 * Last Modified Date : 08-08-2016
 */
public class vlocityPartyRelationshipTriggerHandler {

	/**
	 * Method Name : onAfterInsert
	 * Author : nmishra@vlocity.com
	 * Description : Accepts Trigger.new values from the AfterInsert event on vlocityPartyRelationship.Trigger
	 * Param : List<vlocity_ins__PartyRelationship__c>
	 * Return :	Void
	 */

	public void onAfterInsert(final List<vlocity_ins__PartyRelationship__c> newPartyRelationshipList) {
		Map<Id, Set<Id>> accountIdToGroupRoleIdsMap 				= new Map<Id, Set<Id>>();
		List<vlocity_ins__PartyRelationship__c> partRelList 	= new List<vlocity_ins__PartyRelationship__c>();

		for(vlocity_ins__PartyRelationship__c tmpRel : newPartyRelationshipList) {
			if(tmpRel.vlocity_ins__IsActive__c) {
				partRelList.add(tmpRel);
			}
		}
		if(!partRelList.isEmpty()) {
				
			try {
		  		accountIdToGroupRoleIdsMap = getAccountIdToGroupRoleIds(newPartyRelationshipList);
		  		List<AccountShare> sharesToCreateList = new List<AccountShare>();
		  		if(!accountIdToGroupRoleIdsMap.isEmpty()) {
		  			for(Id tmpAccId : accountIdToGroupRoleIdsMap.keySet()) {
		  				for(Id tmpGrpId : accountIdToGroupRoleIdsMap.get(tmpAccId)) {
		  					AccountShare accShare = new AccountShare();
			  				accShare.AccountAccessLevel = 'Read';
			  				accShare.OpportunityAccessLevel = 'None';
			  				accShare.AccountId = tmpAccId;
			  				accShare.UserOrGroupId =  tmpGrpId;

			  				sharesToCreateList.add(accShare);
		  				}
		  			}
		  		}
		  		if(!sharesToCreateList.isEmpty())
		  			insert sharesToCreateList;

		  	}catch(Exception exptn) {System.debug(exptn.getMessage());}
		}
	}

	/**
	 * Method Name : onAfterUpdate
	 * Author : nmishra@vlocity.com
	 * Description : Accepts Trigger.new and Trigger.oldMap values from the AfterUpdate event on vlocityPartyRelationship.Trigger
	 * Param : List<vlocity_ins__PartyRelationship__c>, Map<Id, vlocity_ins__PartyRelationship__c>
	 * Return :	Void
	 */

	public void onAfterUpdate(final List<vlocity_ins__PartyRelationship__c> newPartyRelationshipList, final Map<Id, vlocity_ins__PartyRelationship__c> oldPartyRelationshipMap) {
		
		Map<Id, vlocity_ins__PartyRelationship__c> partyRelationshipToBeReevalutedMap 	= new Map<Id, vlocity_ins__PartyRelationship__c>();
		List<partyRelationshipToBeReevaluted> relationshipsToBeReevaluatedList 			=  new List<partyRelationshipToBeReevaluted>();
		List<vlocity_ins__PartyRelationship__c> relationShipShareToBeRevokedList 		=  new List<vlocity_ins__PartyRelationship__c>();
        List<vlocity_ins__PartyRelationship__c> relationshipShareToBeReevaluatedList 	= new List<vlocity_ins__PartyRelationship__c>();
		Boolean activeChanged;
		Boolean partiesChanged;
		Boolean isActive;
		Boolean partyRolesChanged;

		for(vlocity_ins__PartyRelationship__c tmpPrtyRel : newPartyRelationshipList) {
			activeChanged 		= false;
			partiesChanged 		= false;
			partyRolesChanged 	= false;

            vlocity_ins__PartyRelationship__c oldPrtyRel = oldPartyRelationshipMap.get(tmpPrtyRel.Id);
            if(oldPrtyRel.vlocity_ins__IsActive__c != tmpPrtyRel.vlocity_ins__IsActive__c) {
            	activeChanged 	= true;
            	isActive 		= tmpPrtyRel.vlocity_ins__IsActive__c;
            	if((oldPrtyRel.vlocity_ins__SourcePartyId__c != tmpPrtyRel.vlocity_ins__SourcePartyId__c) ||(oldPrtyRel.vlocity_ins__TargetPartyId__c != tmpPrtyRel.vlocity_ins__TargetPartyId__c)) {
            		partiesChanged = true;
            	} else {
            		partiesChanged = false;
            	}

            } else {
            	activeChanged = false;
            	isActive = tmpPrtyRel.vlocity_ins__IsActive__c;
            	if((oldPrtyRel.vlocity_ins__SourcePartyId__c != tmpPrtyRel.vlocity_ins__SourcePartyId__c) ||(oldPrtyRel.vlocity_ins__TargetPartyId__c != tmpPrtyRel.vlocity_ins__TargetPartyId__c)) {
            		
            		partiesChanged = true;
            	} else {
            		partiesChanged = false;
            	}
            }

            if((oldPrtyRel.vlocity_ins__PrimaryRole__c != tmpPrtyRel.vlocity_ins__PrimaryRole__c)||(oldPrtyRel.vlocity_ins__TargetRole__c != tmpPrtyRel.vlocity_ins__TargetRole__c)) {
            	partyRolesChanged = true;
    		} else {
    			partyRolesChanged = false;
    		}

            relationshipsToBeReevaluatedList.add(New partyRelationshipToBeReevaluted(tmpPrtyRel,activeChanged, partiesChanged, tmpPrtyRel.vlocity_ins__IsActive__c, partyRolesChanged));

        }

        // Check if it is a valid update operation where reevaluation of visiblity/revoking of visibility is required based on change of 
        // source/target Party, source/target Role or isActive change. 
        // Boolean variables activeChanged, partiesChanged, partyRolesChanged keeps track of the values changed during update operation with the help of partyRelationshipToBeReevaluted inner class.
      

        for(partyRelationshipToBeReevaluted tmpPartyRel : relationshipsToBeReevaluatedList) {
        	if(tmpPartyRel.activeChanged && !tmpPartyRel.partyRelationship.vlocity_ins__IsActive__c) {
        		if(!tmpPartyRel.partiesChanged) {
        			relationShipShareToBeRevokedList.add(tmpPartyRel.partyRelationship);
        		} else {
        			relationShipShareToBeRevokedList.add(oldPartyRelationshipMap.get(tmpPartyRel.partyRelationship.Id));
        		}
        	} else if(tmpPartyRel.activeChanged && tmpPartyRel.partyRelationship.vlocity_ins__IsActive__c) {
        			relationshipShareToBeReevaluatedList.add(tmpPartyRel.partyRelationship);
        	} else if(!tmpPartyRel.activeChanged && (tmpPartyRel.partiesChanged || tmpPartyRel.partyRolesChanged)) {
    			if(tmpPartyRel.partyRelationship.vlocity_ins__IsActive__c) {
    				relationShipShareToBeRevokedList.add(oldPartyRelationshipMap.get(tmpPartyRel.partyRelationship.Id));
    				relationshipShareToBeReevaluatedList.add(tmpPartyRel.partyRelationship);
    			}	
        	}

        }
        System.debug('##1 '+relationShipShareToBeRevokedList);
        System.debug('##2 '+relationshipShareToBeReevaluatedList);
        try {

	        if(!relationShipShareToBeRevokedList.isEmpty()) {
	        	revokeAccountAccess(relationShipShareToBeRevokedList);
	        }

	        if(!relationshipShareToBeReevaluatedList.isEmpty()) {
	        	Map<Id, Set<Id>> accountIdToGroupRoleIdsMap 				= new MAp<Id, Set<Id>>();
				accountIdToGroupRoleIdsMap = getAccountIdToGroupRoleIds(relationshipShareToBeReevaluatedList);
				List<AccountShare> sharesToCreateList = new List<AccountShare>();
		  		if(!accountIdToGroupRoleIdsMap.isEmpty()) {
		  			for(Id tmpAccId : accountIdToGroupRoleIdsMap.keySet()) {
		  				for(Id tmpGrpId : accountIdToGroupRoleIdsMap.get(tmpAccId)) {
		  					AccountShare accShare = new AccountShare();
			  				accShare.AccountAccessLevel = 'Read';
			  				accShare.OpportunityAccessLevel = 'None';
			  				accShare.AccountId = tmpAccId;
			  				accShare.UserOrGroupId =  tmpGrpId;

			  				sharesToCreateList.add(accShare);
		  				}
		  			}
		  		}
		  		if(!sharesToCreateList.isEmpty())
		  			insert sharesToCreateList;
	        }
	    } catch(Exception exptn) {System.debug(exptn.getMessage());}

	}

	/**
	 * Method Name : onAfterDelete
	 * Author : nmishra@vlocity.com
	 * Description : Accepts Trigger.old values from the AfterDelete event on vlocityPartyRelationship.Trigger
	 * Param : List<vlocity_ins__PartyRelationship__c>
	 * Return :	Void
	 */

	public void onAfterDelete(final List<vlocity_ins__PartyRelationship__c> oldPartRelationshipList) {
		try {
			revokeAccountAccess(oldPartRelationshipList);
		} catch(Exception exptn) {System.debug(exptn.getMessage());}
		
	}

	/**
	 * Method Name : getAccountIdToGroupRoleIds
	 * Author : nmishra@vlocity.com
	 * Description : Accepts a List of Party_Relationship Records and finds out List of Roles and Groups related to the SourceAccount and Target Account of the records.
	 * Param : List<vlocity_ins__PartyRelationship__c>
	 * Return :	This method returns a Map of TargetAccountId as Key and Source Acount's Group Role as value and vise versa.
	 */


	private Map<Id, Set<Id>> getAccountIdToGroupRoleIds(List<vlocity_ins__PartyRelationship__c> partyRelationshipList) {

		Map<Id, Set<Id>> sourceToTargetAccountIdMap 	= new Map<Id, Set<Id>>();
		Map<Id, Set<Id>> targetToSourceAccountIdMap 	= new Map<Id, Set<Id>>();
		Map<Id, Id> sourceAccountIdToUserRoleMap 		= new Map<Id, Id>();
		Map<Id, Id> targetAccountIdToUserRoleMap 		= new Map<Id, Id>();
		Map<Id, Id> accountIdToRoleIdMap 				= new Map<Id, Id>();
		Map<Id, List<Id>> accountIdToRoleIdsMap 		= new Map<Id, List<Id>>();
		Map<Id, Id> accountIdToGroupIdMap 				= new Map<Id, Id>();
		Map<Id, Set<Id>> accountIdToGroupIdsMap 		= new Map<Id, Set<Id>>();
		Map<Id, Id> userRoleToGrpRoleMap 				= new Map<Id, Id>();
		Set<Id> roleIdSet 								= new Set<Id>();
		Set<String> sourcePartyRolesSet					= new Set<String>(Party_Roles__c.getValues('Role1').Source_Roles__c.split(';'));
		Set<String> targetPArtyRolesSet					= new Set<String>(Party_Roles__c.getValues('Role1').Target_Roles__c.split(';'));
 
		System.debug('##4 '+partyRelationshipList);
		for(vlocity_ins__PartyRelationship__c tmpPrtyRel : partyRelationshipList) {

			// filter records based on Account's Record Type, SourceParty Roles, TargetParty Roles and create respective sourceToTarget AccountIds and targetToSource Account Ids Maps.
			
			if((sourcePartyRolesSet.contains(tmpPrtyRel.vlocity_ins__PrimaryRole__c)) && (targetPArtyRolesSet.contains(tmpPrtyRel.vlocity_ins__TargetRole__c))) {
				if(tmpPrtyRel.system_Source_Account_Record_Type__c == System.label.Source_and_Target_Account_Record_Type && tmpPrtyRel.system_Target_Account_Record_Type__c == System.label.Source_and_Target_Account_Record_Type) {

					if(!sourceToTargetAccountIdMap.containsKey(tmpPrtyRel.system_Source_Account_Id__c)) {
						sourceToTargetAccountIdMap.put(tmpPrtyRel.system_Source_Account_Id__c, new Set<Id> {tmpPrtyRel.system_Target_Account_Id__c});
					}else {
						sourceToTargetAccountIdMap.get(tmpPrtyRel.system_Source_Account_Id__c).add(tmpPrtyRel.system_Target_Account_Id__c);
					}
					if(!targetToSourceAccountIdMap.containsKey(tmpPrtyRel.system_Target_Account_Id__c)) {
						targetToSourceAccountIdMap.put(tmpPrtyRel.system_Target_Account_Id__c, new Set<Id> {tmpPrtyRel.system_Source_Account_Id__c});
					}else {
						targetToSourceAccountIdMap.get(tmpPrtyRel.system_Target_Account_Id__c).add(tmpPrtyRel.system_Source_Account_Id__c);
					}
				}
			}

		}
		if(!targetToSourceAccountIdMap.isEmpty() && !sourceToTargetAccountIdMap.isEmpty()) {
			for(UserRole tmpRole: [SELECT DeveloperName,Id,Name,PortalAccountId,PortalType FROM UserRole WHERE PortalAccountId IN: sourceToTargetAccountIdMap.keySet() AND DeveloperName LIKE '%PartnerUser%']) {
				if(!sourceAccountIdToUserRoleMap.containsKey(tmpRole.PortalAccountId)) {
					sourceAccountIdToUserRoleMap.put(tmpRole.PortalAccountId, tmpRole.Id);
				}
			}

			for(UserRole tmpRole: [SELECT DeveloperName,Id,Name,PortalAccountId,PortalType FROM UserRole WHERE PortalAccountId IN: targetToSourceAccountIdMap.keySet() AND DeveloperName LIKE '%PartnerUser%']) {
				if(!targetAccountIdToUserRoleMap.containsKey(tmpRole.PortalAccountId)) {
					targetAccountIdToUserRoleMap.put(tmpRole.PortalAccountId, tmpRole.Id);
				}
			}

		}


		if(!targetToSourceAccountIdMap.isEmpty() && !sourceToTargetAccountIdMap.isEmpty()) {
			for(Id tmpAccId : sourceToTargetAccountIdMap.keySet()) {

				for(Id tmpId : sourceToTargetAccountIdMap.get(tmpAccId)) {
					if(targetAccountIdToUserRoleMap.containsKey(tmpId)) {
						if(!accountIdToRoleIdsMap.containsKey(tmpAccId)) {
							accountIdToRoleIdsMap.put(tmpAccId, new List<Id> {targetAccountIdToUserRoleMap.get(tmpId)});
						} else {
							accountIdToRoleIdsMap.get(tmpAccId).add(targetAccountIdToUserRoleMap.get(tmpId));
						}
					}
					
				}
				
			}
			
			for(Id tmpAccId : targetToSourceAccountIdMap.keySet()) {
				for(Id tmpId : targetToSourceAccountIdMap.get(tmpAccId)) {
					if(sourceAccountIdToUserRoleMap.containsKey(tmpId)) {
						if(!accountIdToRoleIdsMap.containsKey(tmpAccId)) {
							accountIdToRoleIdsMap.put(tmpAccId, new List<Id> {sourceAccountIdToUserRoleMap.get(tmpId)});
						} else {
							accountIdToRoleIdsMap.get(tmpAccId).add(sourceAccountIdToUserRoleMap.get(tmpId));
						}
					}	
				}
			}
		}
		System.debug('##6 '+sourceToTargetAccountIdMap);
		System.debug('##7 '+targetToSourceAccountIdMap);
		System.debug('##8 '+sourceAccountIdToUserRoleMap);
		System.debug('##9 '+targetAccountIdToUserRoleMap);
		System.debug('##10 '+accountIdToRoleIdsMap);

		for(Id tmpAccId : accountIdToRoleIdsMap.keySet()) {
			roleIdSet.addAll(accountIdToRoleIdsMap.get(tmpAccId));
			
		}
		
		for(Group tmpGrp : [SELECT Id, RelatedId FROM Group WHERE RelatedId IN: roleIdSet AND Type = 'Role']) {
			if(!userRoleToGrpRoleMap.containsKey(tmpGrp.RelatedId)) {
				userRoleToGrpRoleMap.put(tmpGrp.RelatedId, tmpGrp.Id);
			}
		}

		for(Id tmpAccId : accountIdToRoleIdsMap.keySet()) {
			for(Id tmpRoleId : accountIdToRoleIdsMap.get(tmpAccId)) {
				if(!accountIdToGroupIdsMap.containsKey(tmpAccId)) {
					accountIdToGroupIdsMap.put(tmpAccId, new Set<Id> {userRoleToGrpRoleMap.get(tmpRoleId)});
				} else {
					accountIdToGroupIdsMap.get(tmpAccId).add(userRoleToGrpRoleMap.get(tmpRoleId));
				}
			}
		}
		System.debug('##11 '+accountIdToGroupIdsMap);
		return accountIdToGroupIdsMap;
	}

	/**
	 * Method Name : revokeAccountAccess
	 * Author : nmishra@vlocity.com
	 * Description : Accepts a List of Party_Relationship Records and revokes their Source Accounts' and Tagert Accounts' corresponding AccountShare records.
	 * Param : List<vlocity_ins__PartyRelationship__c>
	 * Return :	void
	 */

	private void revokeAccountAccess(List<vlocity_ins__PartyRelationship__c> partyRelationshipList) {
		System.debug('##3 '+partyRelationshipList);
		Map<Id, Set<Id>> accountIdToGroupIdsMap = new Map<Id, Set<Id>>();
		List<AccountShare> sharesToDeleteList = new List<AccountShare>();
		List<AccountShare> accSharesList = new List<AccountShare>();
		Set<Id> groupIdSet = new Set<Id>();

		accountIdToGroupIdsMap = getAccountIdToGroupRoleIds(partyRelationshipList);	

		for(Id tmpAccId : accountIdToGroupIdsMap.keySet()) {
			groupIdSet.addAll(accountIdToGroupIdsMap.get(tmpAccId));
		}
		System.debug('##12 '+groupIdSet);
		accSharesList = [SELECT Id, AccountId,UserOrGroupId FROM AccountShare WHERE AccountId IN:  accountIdToGroupIdsMap.keySet()];

		for(Id tmpAccId : accountIdToGroupIdsMap.keySet()) {
			for(AccountShare tmpShare : accSharesList) {
				if(tmpShare.AccountId == tmpAccId && accountIdToGroupIdsMap.get(tmpAccId).contains(tmpShare.UserOrGroupId)) {
					sharesToDeleteList.add(tmpShare);
				}
			}
		}

		//sharesToDeleteList = [SELECT Id, AccountId,UserOrGroupId FROM AccountShare WHERE AccountId IN:  accountIdToGroupIdsMap.keySet() AND UserOrGroupId IN: groupIdSet];
		System.debug('##13 '+sharesToDeleteList);
  		if (!sharesToDeleteList.isEmpty())
  			delete sharesToDeleteList;

	}

	public class partyRelationshipToBeReevaluted {
		public vlocity_ins__PartyRelationship__c partyRelationship {get; set;}
		Boolean activeChanged {get; set;}
		Boolean partiesChanged {get; set;}
		Boolean partyRolesChanged {get; set;}
		Boolean isActive {get; set;}

		public partyRelationshipToBeReevaluted (vlocity_ins__PartyRelationship__c partyRelationship, Boolean activeChanged, Boolean partiesChanged, Boolean isActive, Boolean partyRolesChanged) {
			this.partyRelationship = partyRelationship;
			this.activeChanged = activeChanged;
			this.partiesChanged = partiesChanged;
			this.partyRolesChanged = partyRolesChanged;
			this.isActive = isActive;
		}
	}



}