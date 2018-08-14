/**
 * Class Name : ApplicationSharingHelper
 * Author : nmishra@vlocity.com
 * Description : This class contains business logic methods required for Application Sharing with Paid Agency, General Agency and Brokers.
 * Last Modified Date : 22-08-2016
 */


public class ApplicationSharingHelper {


	/**
	 * Method Name : getAccountIdToGroupRoleIds
	 * Author : nmishra@vlocity.com
	 * Description : Accepts a List of ApplicationAndAccountWrapper and finds out List of Roles and Groups related to the Paid Agency, General Agency and Broker of the records.
	 * Param : List<ApplicationAndAccountWrapper>
	 * Return :	This method returns a Map of AccountId as Key and Acount's Group Role as value.
	 */

	public Map<Id, Set<Id>> getAccountIdToGroupRoleIds(List<ApplicationAndAccountWrapper> applicationAndAccountWrapperList) {
		Map<Id, Id> appIdToAccountGroupRoleMap = new Map<Id, Id>();
		Set<Id> accountIdSet = new Set<Id>();
		try {
			if(!applicationAndAccountWrapperList.isEmpty()) {
				for(ApplicationAndAccountWrapper tmpWrap : applicationAndAccountWrapperList) {
					accountIdSet.addAll(tmpWrap.agenciesIdSet);
				}
			}
			System.debug('##5 '+accountIdSet);

			Map<Id, Set<Id>> accIdToUserRoleIdsMap = new Map<Id, Set<Id>>();
			Map<Id, Id> roleIdToGroupIdMap = new Map<Id, Id>();
			Set<Id> roleIdSet = new Set<Id>();
			Map<Id, Set<Id>> accIdToGroupIdsMap = new Map<Id, Set<Id>>();
			
			if(!accountIdSet.isEmpty()) {
				for(UserRole tmpRole: [SELECT DeveloperName,Id,Name,PortalAccountId,PortalType FROM UserRole WHERE PortalAccountId IN: accountIdSet AND (DeveloperName LIKE '%PartnerManager%' OR DeveloperName LIKE '%PartnerExecutive%')]) {
					if(!accIdToUserRoleIdsMap.containsKey(tmpRole.PortalAccountId)) {
						accIdToUserRoleIdsMap.put(tmpRole.PortalAccountId, new Set<Id> {tmpRole.Id});
					} else {
						accIdToUserRoleIdsMap.get(tmpRole.PortalAccountId).add(tmpRole.Id);
					}
				}
			}		
			for(Id tmpAccId : accIdToUserRoleIdsMap.keySet()) {
				roleIdSet.addAll(accIdToUserRoleIdsMap.get(tmpAccId));
				
			}
            if(roleIdSet.size() > 0){
                for(Group tmpGrp : [SELECT Id, RelatedId FROM Group WHERE RelatedId IN: roleIdSet AND Type = 'Role']) {
					if(!roleIdToGroupIdMap.containsKey(tmpGrp.RelatedId)) {
						roleIdToGroupIdMap.put(tmpGrp.RelatedId, tmpGrp.Id);
					}
				}   
            }
			for(Id tmpAccId : accIdToUserRoleIdsMap.keySet()) {
				for(Id tmpRoleId : accIdToUserRoleIdsMap.get(tmpAccId)) {
					if(!accIdToGroupIdsMap.containsKey(tmpAccId)) {
						accIdToGroupIdsMap.put(tmpAccId, new Set<Id> {roleIdToGroupIdMap.get(tmpRoleId)});
					} else {
						accIdToGroupIdsMap.get(tmpAccId).add(roleIdToGroupIdMap.get(tmpRoleId));
					}
				}
			}
			System.debug('##6 '+accIdToUserRoleIdsMap);
			System.debug('##7 '+roleIdToGroupIdMap);
			System.debug('##8 '+accIdToGroupIdsMap);

			return accIdToGroupIdsMap;
		}catch(Exception exptn) {
			System.debug('##000 '+exptn.getMessage());
			throw exptn;
		}
	} 
}