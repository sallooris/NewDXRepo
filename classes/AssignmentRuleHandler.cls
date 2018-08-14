public with sharing class AssignmentRuleHandler {
	
	//Set the lead controller from a 'Assignment Rule' as the owner of the 'Assignment Rule' the state, and the ZipCodes
	public static void updateOwner(List<Assignment_Rule__c> assignmentRuleList){
		
		Profile systemAdProfile = [Select id from Profile Where Name=: 'System Administrator' limit 1]; 
		Profile leadControllerProfile = AnthemOppsProfiles.salesAdminProfile;
		Profile anthemAdminProfile = AnthemOppsProfiles.adminProfile;

		RecordType geoRT = [Select id from RecordType where DeveloperName =:'Geographical_Record_Type'];
		Map<ID,ID> ownerByState = new Map<ID,ID>(); //<State, OwnerID>
		
		Map<ID,Assignment_Rule__c> assignmentByUser = new Map<ID,Assignment_Rule__c> (); // <leadController, AssRule>
		Set<ID> userID =  new Set<ID>();
		for(Assignment_Rule__c ar: assignmentRuleList){
			userID.add(ar.Lead_Controller__c);
			assignmentByUser.put(ar.Lead_Controller__c, ar);
		}
		
		List<User> users = [Select Id, profileID from User Where ID IN: userID];
		//Check if the lead Controller has Lead Controller profile, or admin profile
		for(User u: users){
			if(u.profileID!=systemAdProfile.id && u.profileID!=leadControllerProfile.id && u.profileID!=anthemAdminProfile.id){
				assignmentByUser.get(u.id).Lead_Controller__c.addError('User does not has Anthem Leads Controllers Profile.');
            	return;		
			}	
		}
				
		for(Assignment_Rule__c ar: assignmentRuleList){
			if(geoRT!=null && ar.RecordTypeID == geoRT.id){
				ar.ownerId = ar.Lead_Controller__c;
				ownerByState.put(ar.state__c, ar.Lead_Controller__c);
			}
		}
		
		//Because the relationship between Zip-City-County with State is masterRelationship, I dont have to update the owner of the Zip.
		if(ownerByState.size()>0){
			List<State__c> states = [Select id, OwnerID from State__C where ID IN: ownerByState.keySet() ] ;
			if(states!=null && states.size()>0){
				for(State__c state: states){
					state.ownerID = ownerByState.get(state.id);
					
				}
			}
			update states;
		}
	}

}