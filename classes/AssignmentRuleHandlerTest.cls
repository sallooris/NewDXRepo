@isTest 
private class AssignmentRuleHandlerTest {

    static testMethod void testInsertAssignmentRule() {	
		TestResources.createProfilesCustomSetting();
    	User leadController = TestResources.LeadController('Lead','Controller','leadcontroller@anthem.com','leadcontroller@anthem.com');
		insert leadController;

		State__c state = TestResources.createState(LeadController.id);
		insert state;

		Assignment_Rule__c ar = TestResources.createAssignmentRule(state.id, leadController.id);
		insert ar; 		
    }
	
	

}