/**
 * Class Name : OpportunityApplicationSharingHandler
 * Author : nmishra@vlocity.com
 * Description : Trigger Handler for the Opportunity SObject. This class provides as an handler for Application Sharing logic in OpportunityAfterUpdate.Trigger
 * Last Modified Date : 23-08-2016
 */

public class OpportunityApplicationSharingHandler {
	/**
	 * Method Name : evaluateApplicationSharing
	 * Author : nmishra@vlocity.com
	 * Description : Accepts Trigger.new values from the AfterUpdate event on OpportunityAfterUpdate.Trigger
	 * Param : List<Opportunity>
	 * Return :	Void
	 */

	public void evaluateApplicationSharing(final Map<Id, Opportunity> idToOldOpportunityMap, final Map<Id, Opportunity> oppIdToNewOpportunityMap) {
	 	Set<Id> opportunityIdSet = new Set<Id>();
	 	Map<Id, Set<Id>> oldAccIdToGroupIdsMap = new Map<Id, Set<Id>>();
	 	Map<Id, Set<Id>> newAccIdToGroupIdsMap = new Map<Id, Set<Id>>();
	 	Map<Id, vlocity_ins__Application__c> idToApplicationMap = new Map<Id, vlocity_ins__Application__c>();
	 	List<ApplicationAndAccountWrapper> applicationAndAccountWrapperForinsertList = new List<ApplicationAndAccountWrapper>();
	 	List<ApplicationAndAccountWrapper> applicationAndAccountWrapperForDeleteList = new List<ApplicationAndAccountWrapper>();


	 	for(Id tmpOppId : oppIdToNewOpportunityMap.keySet()) {
	 		Opportunity oldOpp = idToOldOpportunityMap.get(tmpOppId);

	 		if(oldOpp.Broker__c != oppIdToNewOpportunityMap.get(tmpOppId).Broker__c || oldOpp.GeneralAgency__c != oppIdToNewOpportunityMap.get(tmpOppId).GeneralAgency__c || oldOpp.PaidAgency__c != oppIdToNewOpportunityMap.get(tmpOppId).PaidAgency__c) {
	 			opportunityIdSet.add(oldOpp.Id);
	 		}
	 	}
	 	System.debug(+'##1 '+opportunityIdSet);

	 	for(vlocity_ins__Application__c tmpApp : [SELECT Id,Opportunity_Id__c FROM vlocity_ins__Application__c]) {
	 		if(tmpApp.Opportunity_Id__c != '' && tmpApp.Opportunity_Id__c != null && opportunityIdSet.contains(Id.valueOf(tmpApp.Opportunity_Id__c))) {
	 			idToApplicationMap.put(tmpApp.Id, tmpApp);
	 		} 
	 	}
	 	System.debug('##2 '+idToApplicationMap);

	 	for(vlocity_ins__Application__c tmpApp : idToApplicationMap.values()) {
	 		if(tmpApp.Opportunity_Id__c != '') {
	 			applicationAndAccountWrapperForDeleteList.add(new ApplicationAndAccountWrapper(tmpApp.Id, tmpApp.Opportunity_Id__c, idToOldOpportunityMap.get(tmpApp.Opportunity_Id__c).GeneralAgency__c, idToOldOpportunityMap.get(tmpApp.Opportunity_Id__c).PaidAgency__c, idToOldOpportunityMap.get(tmpApp.Opportunity_Id__c).system_Broker_Account_Id__c));
	 			applicationAndAccountWrapperForinsertList.add(new ApplicationAndAccountWrapper(tmpApp.Id, tmpApp.Opportunity_Id__c, oppIdToNewOpportunityMap.get(tmpApp.Opportunity_Id__c).GeneralAgency__c, oppIdToNewOpportunityMap.get(tmpApp.Opportunity_Id__c).PaidAgency__c, oppIdToNewOpportunityMap.get(tmpApp.Opportunity_Id__c).system_Broker_Account_Id__c));
	 		}
	 	}
	 	System.debug('##3 '+applicationAndAccountWrapperForDeleteList);
	 	System.debug('##4 '+applicationAndAccountWrapperForinsertList);

	 	ApplicationSharingHelper appSharingHelper = new ApplicationSharingHelper();

		oldAccIdToGroupIdsMap = appSharingHelper.getAccountIdToGroupRoleIds(applicationAndAccountWrapperForDeleteList);
		newAccIdToGroupIdsMap = appSharingHelper.getAccountIdToGroupRoleIds(applicationAndAccountWrapperForinsertList);

		System.debug('##9 '+oldAccIdToGroupIdsMap);
	 	System.debug('##10 '+newAccIdToGroupIdsMap);

		revokeApplicationAccess(oldAccIdToGroupIdsMap, idToApplicationMap, applicationAndAccountWrapperForDeleteList);
		reAssignApplicationAccess(newAccIdToGroupIdsMap, applicationAndAccountWrapperForinsertList);

	}


	private void revokeApplicationAccess(Map<Id, Set<Id>> oldAccIdToGroupIdsMap, Map<Id, vlocity_ins__Application__c> idToApplicationMap, List<ApplicationAndAccountWrapper> applicationAndAccountWrapperForDeleteList) {
		Set<Id> groupIdSet = new Set<Id>();
        
        List<vlocity_ins__Application__Share> appShareList = new List<vlocity_ins__Application__Share>();
		List<vlocity_ins__Application__Share> appShareToDeleteList = new List<vlocity_ins__Application__Share>();
		try {
			for(Id tmpAccId : oldAccIdToGroupIdsMap.keySet()) {
				groupIdSet.addAll(oldAccIdToGroupIdsMap.get(tmpAccId));
			}
            if(idToApplicationMap.size() > 0 && groupIdSet.size() > 0){
                appShareList = [SELECT Id, ParentId,UserOrGroupId,RowCause FROM vlocity_ins__Application__Share WHERE ParentId IN: idToApplicationMap.keySet() AND UserOrGroupId IN: groupIdSet];
            }

			for(ApplicationAndAccountWrapper appWrap : applicationAndAccountWrapperForDeleteList) {
				for(vlocity_ins__Application__Share tmpAppShare : appShareList) {
					if(tmpAppShare.ParentId == appWrap.applicationId) {
						for(Id tmpAccId : appWrap.agenciesIdSet) {
							if(oldAccIdToGroupIdsMap.get(tmpAccId).contains(tmpAppShare.UserOrGroupId)) {
								appShareToDeleteList.add(tmpAppShare);
							}
						}
					}
				}
			}
			System.debug('##11 '+appShareToDeleteList);
			Delete appShareToDeleteList;
		}catch(Exception exptn) {
			System.debug('##0001 '+exptn.getMessage());
		}
	}

	private void reAssignApplicationAccess(Map<Id, Set<Id>> newAccIdToGroupIdsMap, List<ApplicationAndAccountWrapper> applicationAndAccountWrapperForinsertList) {
		List<vlocity_ins__Application__Share> applicationShareToBeInsertedList = new List<vlocity_ins__Application__Share>();
		try {
			for(ApplicationAndAccountWrapper tmpWrap : applicationAndAccountWrapperForinsertList) {
				System.debug('##12 '+tmpWrap.agenciesIdSet);
				for(Id tmpAccId : tmpWrap.agenciesIdSet) {
					if(newAccIdToGroupIdsMap.containsKey(tmpAccId)) {
						for(Id tmpGrpId : newAccIdToGroupIdsMap.get(tmpAccId)) {
							vlocity_ins__Application__Share appShare = new vlocity_ins__Application__Share();
							appShare.ParentId = tmpWrap.applicationId;
							appShare.AccessLevel = Label.Application_Access_Level;
							appShare.RowCause = 'Manual';
							appShare.UserOrGroupId = tmpGrpId;

							applicationShareToBeInsertedList.add(appShare);

						}
					}	 
				}
			}
			System.debug('##13 '+applicationShareToBeInsertedList);
			if(!applicationShareToBeInsertedList.isEmpty())
				insert applicationShareToBeInsertedList;
		}catch(Exception exptn) {
			System.debug('##0002 '+exptn.getMessage());
		}
	}

}