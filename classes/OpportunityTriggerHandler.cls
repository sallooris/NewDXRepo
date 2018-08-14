/******************************************************************************
 * Name:		OpportunityTriggerHandler
 *  
 * Purpose: 	Controller class that contains all methods for the triggers on Opportunity object.
 * 
 * @Author:     Unknown
 * @Date:       xx-xx-xxxx
 *
 * @Updates:
 * 10-27-2015	Abdul Sattar (Magnet 360)
 * 				1. MSP-655 - Added code for Account Sharing Rule Automation
 * 				2. Added header comments
 * 
 */
public class OpportunityTriggerHandler { 
	
	public static Boolean afterWorkFlow =  false;
	public static Boolean afterUpdate = true;
	
	/**
	 * Creates account sharing if there is a change in Owner on Opportunities
	 * 
	 * @param: 	newOpps    List of new versions of Opportunity objects
	 * @param: 	oldOppsMap Map of old versions of Opportunity objects
	 *
	 * @author: Abdul Sattar (Magnet 360)
	 * @Date: 	10-27-2015
	 */
	public static void createAccountSharing(List<Opportunity> newOpps, Map<Id, Opportunity> oldOppsMap ) {
		System.debug('START: OpportunityTriggerHandler.createAccountSharing(LIST newOpps, Map oldOppsMap)');
		
		// Select already created manual account sharing records for Accounts & Users on Opportunities.
		// Account share creation logic below will skip these to avoid DML Exceptions
		//---------------------------------------------------------------------------------------
		Set<String> userIds = new Set<String>();	// Set of User Ids
		Set<String> acctIds = new Set<String>();	// Set of Account Ids

		// Loop through all opportunities and prepare sets of Account and User Ids
		for (Opportunity opp : newOpps) {
			userIds.add(opp.OwnerId);
			acctIds.add(opp.AccountId);
		}

		// Select already created manual account sharing records, if any
		List<AccountShare> existingActShrs = [ SELECT   Id
														,UserOrGroupId
														,AccountId 
												FROM  	AccountShare
												WHERE 	UserOrGroupId IN :userIds
													AND AccountId IN :acctIds
													AND RowCause = 'Manual'];
		
		// Loop through existing Account Share records and 
		// create a unique set of Account Id - User Id 
		Set<String> ignroreActShrs = new Set<String>();
		for (AccountShare actshr : existingActShrs) {
			ignroreActShrs.add(actshr.UserOrGroupId + '-' + actshr.AccountId);
		}

		// List to hold new account shares that are to be inserted later
		Map<String, AccountShare> newAccountShares = new Map<String, AccountShare>();

		// Loop through all opportunities and create an Account Share record, if needed
		for (Opportunity oppNew : newOpps) {
            String mapKey = oppNew.OwnerId + '-' + oppNew.AccountId;

			// Get reference to old Opportunity
			Opportunity oppOld = oldOppsMap.get(oppNew.Id);

			// Only add Account Share record if needed
			if( oppOld != NULL &&
				oppNew.AccountId != NULL && 
				oppNew.OwnerId != oppOld.OwnerId &&
				!ignroreActShrs.contains(mapKey) &&
                !newAccountShares.containsKey(mapKey)) {

				AccountShare actshr = new AccountShare(	 UserOrGroupId = oppNew.OwnerId
														,AccountId = oppNew.AccountId
														,AccountAccessLevel = 'Read'
														,OpportunityAccessLevel = 'None'
														,CaseAccessLevel = 'None');
				// Add new Account Share record to map.
				newAccountShares.put(mapKey, actshr);
			}
		}
	
		// Save changes to database
		if(newAccountShares.size() > 0) {
			// Insert sharing records
	        // The false parameter allows for partial processing if multiple 
	        // records are passed into the operation.
            System.debug('SCS: newAccountShares = ' + newAccountShares);
			Database.SaveResult[] lsrs = Database.insert(newAccountShares.values(), FALSE);

            for (Database.SaveResult sr : lsrs) {
                if(!sr.isSuccess()){
                    // Get the first save result error
                    Database.Error err = sr.getErrors()[0];
                    System.debug('Account Sharing Create Error: ' + err.getMessage() );
                }
            }
		}

		System.debug('END: OpportunityTriggerHandler.createAccountSharing(LIST newOpps, Map oldOppsMap)');
	}

	//Sets the zip code, Lead controller and the Event Id references in the opp. 
	public static List<Opportunity> setZipCodeAndEventID(List<Opportunity> oppList){
		Set<String> zipCodeSet = new Set<String>();
		Set<String> eventCodeSet =  new Set<String>();
		
		for(Opportunity opp: oppList ){
			if(opp.Site_ZIP__c!=null){
				zipCodeSet.add(opp.Site_ZIP__c);
			}
			if(opp.Marketing_Event__c!=null){
				eventCodeSet.add(opp.Marketing_Event__c);
			}
		}
		
		if(zipCodeSet.size()>0){
			OpportunityTriggerHandler.updateLeadController(oppList,zipCodeSet);
			
		}
		
		if(eventCodeSet.size()>0){
			List< Campaign > camp_with_event_code = [Select id, Event_Code1__c from Campaign Where Event_Code1__c IN:eventCodeSet ];
			//List<Event_ID__c> eventIDList = [Select id,Event_Campaign_Name__c, Name from Event_ID__c Where Name IN:eventCodeSet ];
			
			Map< String, Campaign > campIDMap = new Map< String, Campaign >(); // <EventCode, Campaing>
			Set<ID> campID =  new Set<ID>();
			
			for( Campaign camp : camp_with_event_code )
			{
				campIDMap.put( camp.Event_Code1__c, camp );	
				campID.add( camp.id );
			}

			for(Opportunity opp: oppList )
			{
				if( opp.Marketing_Event__c!=null )
				{
					if( campIDMap.containsKey( opp.Marketing_Event__c ) )
					{
						//opp.Event_ID__c = eventIDMap.get(opp.Event_Code__c).id;
						opp.CampaignID = campIDMap.get( opp.Marketing_Event__c ).id;
					}
				}
			}
			
			return OpportunityTriggerHandler.assignOwnerByCampaign( campID , oppList );
		}
		
		return null;
	}
	
	//In the custom setting Batch_insert__c, there is a record called 'Insert batch', that keeps a flag, that let us know if we are inserting a batch of opportunities. 
	public static boolean insertingBatch(){
		Batch_insert__c bi;
	
		try{
			bi = [Select id, Inserting_batch__c from Batch_insert__c where Name =:'Insert batch' limit 1 ];
		}catch(exception e){
			//If the custom setting doesnt exist, that means we want to keep the assigment rules. 
		}
		return bi!=null? bi.Inserting_batch__c:false;
	}
	
	public static void checkBeforeUpdateOppName(List<Opportunity> newOppList, Map<Id, Opportunity> oldOppMap){
		
		List<Opportunity> oppToupdate = new List<Opportunity>();
		
		for(Opportunity opp: newOppList){
			if(opp.Company_Name__c != oldOppMap.get(opp.id).Company_Name__c ||
				opp.First_Name__c != oldOppMap.get(opp.id).First_Name__c ||
				opp.Last_Name__c != oldOppMap.get(opp.id).Last_Name__c ){
					oppToupdate.add(opp);
			}
		}
		
		if(oppToupdate.size()>0)
			updateOppName(oppToupdate, false);		
	}
	
	
	//Updates the name of the Opp
	public static void updateOppName(List<Opportunity> oppList, boolean isInsert){
		
		for(Opportunity opp:oppList){
						
			opp.Name =(String.isNotBlank(opp.Company_Name__c)? opp.Company_Name__c +' - ' :' ') +
					  (String.isNotBlank(opp.First_Name__c)? opp.First_Name__c:' ') +' '+ 
					  (String.isNotBlank(opp.Last_Name__c)? opp.Last_Name__c: ' ') +' '+ 
					  (isInsert? date.today().format() : date.newinstance(opp.CreatedDate.year(), opp.CreatedDate.month(), opp.CreatedDate.day()).format());
		}
		
	}

	//Checks if an opp has been created upon a lead conversion
	//and updates some fields previous the assigment
	//**** WLPC-350 ****
	public static void checkConversion(List<Opportunity> oppList)
	{
		Set< ID > l_acc_id =  new Set< ID >();

		for( Opportunity opp:oppList )
		{
			if( opp.Name == 'created_upon_conversion')
			{
				l_acc_id.add( opp.AccountId );
			}
		}

		if( l_acc_id.size() > 0 )
		{
			Map< Id, Account > l_acc_list = new Map< Id, Account >([Select  id,
																			Name, 
																			BillingPostalCode,
																			BillingCity,
																			BillingStreet,
																			BillingState,
																			Phone,
																			NumberOfEmployees,
																			Lead_ID__c, 
																			(Select id,
																					FirstName ,
																					LastName,
																					Title, 
																					Email, 
																					Lead_ID__c
																			 From Contacts) 
																	From Account ac 
																	Where ID IN :l_acc_id ]);
			
			Set< ID > l_lead_id =  new Set< ID >(); 
			for( Opportunity o : oppList )
			{
				Account acc = l_acc_list.get( o.AccountId );

				if( o.Name == 'created_upon_conversion' )
				{
					o.StageName = 'Waiting for Disposition';
					o.Company_Name__c = acc.Name;
					o.Site_Address1__c = acc.BillingStreet;
					o.Site_City__c = acc.BillingCity;
					o.Site_State__c = acc.BillingState;
					o.Site_ZIP__c = acc.BillingPostalCode;
					o.Number_of_Employees__c = acc.NumberOfEmployees;
					o.Phone__c = acc.Phone;
					o.RecordTypeId = OpportunityTriggerDispatcher.anthem_opps_rt;
					o.Converted_Lead_ID__c = acc.Lead_ID__c;
					for( Contact c : acc.Contacts )
					{
						if( c.Lead_ID__c == acc.Lead_ID__c )
						{
							o.First_Name__c = c.FirstName;
							o.Last_Name__c = c.LastName;
							o.Title__c = c.Title;
							o.Primary_Account_Contact__c = c.id;
							o.Email__c = c.Email;
							break;
						}
					}
					
				}
			}

		}
		
	}

	// Sets the lead Controller and the ZipCode in the opp. 
	private static void updateLeadController(List<Opportunity> oppList, Set<String> zipCodeSet ){
		
			List<Zip_City_County__c> zipCityCountyList = [Select id,State__c, Name from Zip_City_County__c Where Name IN:zipCodeSet ];
			
			Map<String, ID> zipCityCountyMap = new Map<String, ID>(); // <ZipCode Name, id>
			Map<ID, Set<String>> zipByState =  new Map<ID, Set<String>>(); // <States ID, ZipCodeName>
			
			
			for(Zip_City_County__c zcc:zipCityCountyList ){
				zipCityCountyMap.put(zcc.Name, zcc.id);	
				
				if(zipByState.containsKey(zcc.State__c)){
					Set<String> auxSet = zipByState.get(zcc.State__c);
					auxSet.add(zcc.Name);
					zipByState.put(zcc.State__c,auxSet);
				}else{
					zipByState.put(zcc.State__c,new Set<String>{zcc.Name});
				}
			}
			List<Assignment_Rule__c> assigmentRules =  [Select id, State__c, Lead_Controller__c from Assignment_Rule__c Where  State__c IN: zipByState.keySet()];

			Map<String, Id> leadControllerbyZip = new Map<String, Id>(); //<Zip Code, leadcontroller ID>
			
			for(Assignment_Rule__c ar: assigmentRules){
				if(zipByState.containsKey(ar.State__c)){
					for(String zip: zipByState.get(ar.State__c)){
						leadControllerbyZip.put(zip,ar.Lead_Controller__c );
					}
				}
			}
			
			//Assign the lead controller and the ZipCode
			for(Opportunity opp: oppList ){
				if(opp.Site_ZIP__c!=null){
					opp.Zip_Code__c = zipCityCountyMap.get(opp.Site_ZIP__c);
					opp.Lead_Controller__c =leadControllerbyZip.get(opp.Site_ZIP__c);
				}
			}		
		
	}
	
	//Assignment of the owner base on the EventId in the Opp.
	private static List<Opportunity> assignOwnerByCampaign (Set<ID> campID, List<Opportunity> oppList){
		
		List<Assignment_Rule__c> assignmentRulesByCampaign = [Select id,Event_Code__c, Campaign__c, User__c
														From Assignment_Rule__c 
														Where Campaign__c IN:campID
														and recordType.DeveloperName =: 'Campaign_Record_Type' ];	

																				system.debug('AQUIIIII' + assignmentRulesByCampaign);
														
														
		Map<ID,Assignment_Rule__c> assigRulesByCampID = new Map<ID,Assignment_Rule__c>(); // <EventID, Assignment Rule>
		
		for(Assignment_Rule__c ar: assignmentRulesByCampaign)
		{
			assigRulesByCampID.put( ar.Campaign__c,ar );
			
		}
													
		List<Opportunity> oppsToReturn = new List<Opportunity>();	

		if( assignmentRulesByCampaign!=null && assignmentRulesByCampaign.size()>0 )
		{												
			for( Opportunity opp: oppList )
			{
				if( opp.CampaignID != null )
				{
					if( assigRulesByCampID.get( opp.CampaignID ) != null )
					{
						opp.OwnerID = assigRulesByCampID.get(opp.CampaignID).User__c;
						opp.OwnerID__c = assigRulesByCampID.get(opp.CampaignID).User__c;
						opp.Auto_assignment__c = true;
					}
					else
					{
						oppsToReturn.add(opp);
					}
				}
			}
			return 	oppsToReturn;												
		}
		else{
			return oppList;
		}
		
	}
	
	//If the state of an opp changes, the check box field "Stage_changed__c" will be flagged. 
	//If an opp has been flagged for auto re assignment by the workflow, then the opp will be re assign. 
	//Update the reference to the zipCode
	public static void afterUpdate (List<Opportunity> newOppList ,Map< Id , Opportunity> oldOppMap ){
		List<Opportunity> autoReassignment =  new List<Opportunity>();
		List<Opportunity> oppCampIdChanged =  new List<Opportunity>();
		List<Opportunity> oppOwnerUpdated =  new List<Opportunity>();
		List<Opportunity> oppZipCodeChanged = new List<Opportunity>();
		Set<ID> campIDSet = new Set<ID>(); //<Event ID>
		Set<ID> userID =  new Set<ID>(); 
		Set<String> zipCode = new Set<String>();
		
		for(Opportunity newOpp :  newOppList ){
			
			Opportunity oldOpp = oldOppMap.get( newOpp.id );

			if(oldOpp.StageName !=newOpp.stageName && newOpp.stageName !='Decline' ){ // The opp changes of status (stage)
				newOpp.Stage_changed__c = true;
			}
			if(oldOpp.ownerID !=newOpp.ownerID){ // The owner has changed
				newOpp.Stage_changed__c = false;
				oppOwnerUpdated.add(newOpp);
				userID.add(newOpp.ownerID);
			}
			if(newOpp.Auto_assignment__c==true && oldOpp.Auto_assignment__c ==false){ //The opp has been auto re assigned by the workflow
				autoReassignment.add(newOpp);
			}
			//if(newOpp.Campaign!=oldOpp.Campaign){ //The event ID changed
			//	oppCampIdChanged.add(newOpp);
			//	campIDSet.add(newOpp.Campaign);
			//}
			if(newOpp.Site_ZIP__c!=oldOpp.Site_ZIP__c){
				zipCode.add(newOpp.Site_ZIP__c);
				oppZipCodeChanged.add(newOpp);
			}
		}
		
		if(autoReassignment.size()>0)
			OpportunityTriggerHandler.autoReassignment(autoReassignment);//Auto reassignment
		
		//if(oppCampIdChanged.size()>0)
			//OpportunityTriggerHandler.eventIdChanged(oppCampIdChanged,campIDSet); //If the EventId changes, the Campaign is updated
			
		if(oppOwnerUpdated.size()>0)
			OpportunityTriggerHandler.updateUser(oppOwnerUpdated,userID); // If the owners changes, we update the references to the SalesRep and SalesMan	 
		
		if(oppZipCodeChanged.size()>0)
			OpportunityTriggerHandler.oppZipCodeChanged(oppZipCodeChanged,zipCode);

	}
	
	//If the ZipCode changes, the Look up to ZipCode is updated. 
	private static void oppZipCodeChanged(List<Opportunity> oppZipCodeChanged, Set<String> zipCode){
		
		List<Zip_City_County__c> zipCodes = [Select id, Name from Zip_City_County__c Where Name IN: zipCode];
		
		Map<String, ID> zipCodesID = new Map<String, ID>(); //<Zip Code Name, Id>
		for(Zip_City_County__c zcc: zipCodes){
			zipCodesID.put(zcc.Name, zcc.id);	
		}
		
		for(Opportunity opp: oppZipCodeChanged){
			ID zCodeID = zipCodesID.get(opp.Site_ZIP__c);
			if(zCodeID!=null){
				opp.Zip_Code__c = zCodeID;
			}else{
				opp.Zip_Code__c = null;
			}
		}

	}
	
	//When a new broker is assigned as owner, updates the references from the Sales Rep, and the Sales Manager in the Opp.
	private static void updateUser(List<Opportunity> oppOwnerUpdated, Set<ID> userID){
		
		Map<id,User> brokerUserList = new Map<id,User> ([Select id,Sales_Rep__c,contactID, Sales_Rep__r.contactID,Sales_Rep__r.Sales_Manager__c, Sales_Rep__r.Sales_Manager__r.contactID  from User Where ID IN: userID order by Opp_Assigned__c ]);
		Set<String> zipCodeSet =  new Set<String>();
		for(Opportunity opp: oppOwnerUpdated){
			User u = brokerUserList.get(opp.OwnerID);
			if(u.Sales_Rep__c!=null){
				opp.Broker__c = u.contactID;
				if(u.Sales_Rep__r.contactID!=null)
					opp.Sales_Rep__c = u.Sales_Rep__r.contactID;
				if(u.Sales_Rep__r.Sales_Manager__c!=null)	
					opp.Sales_Manager__c = u.Sales_Rep__r.Sales_Manager__r.contactID;
					
				opp.Broker_Expired__c =false;
				opp.Sales_rep_expired__c = false;
				opp.Lead_Controller_Expired__c = false;
				opp.StageName = 'Waiting for Disposition';
				opp.Secondary_Disposition_new__c ='';
				opp.Auto_assignment__c = false;
				opp.Assigned_to_Lead_Controller__c =false;
				opp.Users_who_declined__c ='';
				if(opp.Site_ZIP__c!=null)
					zipCodeSet.add(opp.Site_ZIP__c);
			}	
		}
		
		if(zipCodeSet.size()>0){
			OpportunityTriggerHandler.updateLeadController(oppOwnerUpdated,zipCodeSet);
			
		}					
		
	}
	/*
	//When an event Id change, Update the values of the fields: Primary Campaign Source, Event Description,Event Code
	private static void eventIdChanged(List<Opportunity> oppEventIdChanged,Set<ID> eventIDSet){
		
		Map<ID,Event_ID__c> eventIDMap =new Map<ID,Event_ID__c>( [Select id,Event_Campaign_Name__c,Name from Event_ID__c Where Id IN: eventIDSet]);
		
		For(Opportunity opp: oppEventIdChanged){
			Event_ID__c event =  eventIDMap.get(opp.Event_ID__c);
			opp.Event_Code__c = event.Name;
			opp.CampaignID = event.Event_Campaign_Name__c;
		}
		
		
	}*/
		
	//After a workflow is execute, this method could do :
	//If the lead has been declined, it will be reasigned to another Broker or to the lead Admin
	public static void afterWorkFlow(List<Opportunity> newOppList ,Map< Id, Opportunity> oldOppMap ){
		
		List<Opportunity> oppDeclineToAdmin =  new List<Opportunity>();
		List<Opportunity> oppDeclineToRR =  new List<Opportunity>();
		
		for( Opportunity newOpp : newOppList ){
			Opportunity oldOpp = oldOppMap.get( newOpp.id);

			
			if(oldOpp.StageName !='Decline' && newOpp.stageName =='Decline' ){
				newOpp.Stage_changed__c = false;
				if(newOpp.Declined__c){
					oppDeclineToRR.add(newOpp);
				}else if(newOpp.Declined_to_Admin__c){
					oppDeclineToAdmin.add(newOpp);
				}
			}		
		}
		if(oppDeclineToAdmin.size()>0)
			OpportunityTriggerHandler.changeOwnerToLeadAdmin(oppDeclineToAdmin);

		if(oppDeclineToRR.size()>0)
			OpportunityTriggerHandler.changeOwnerToAnotherBroker(oppDeclineToRR);
			
	
	}
	
	//Finds the owner of the opp that has been reasign. 
	//The first owner after the first reasign is going to be the SalesRep
	//Is the opp is re asign twice, the owner is going to be the lead controller
	//The third time, is going to be reasigned to the sales manager
	private static void autoReassignment(List<Opportunity> oppList){
		
		Set<String> oppId  = new Set<String>();
		Set<ID> ownerIDSet =  new Set<ID>();
		Set<ID> oppBrokerExpired = new Set<ID>();
		Set<ID> oppBSalesRepExpired = new Set<ID>();
		Set<ID> oppLeadControllerExpired = new Set<ID>();
		for(Opportunity opp: oppList){
			ownerIDSet.add(opp.OwnerID);
		}
		
		Map<ID,User> users = new Map<Id,User>([Select id, Sales_Rep__c, Sales_Manager__c from User Where id IN:ownerIDSet ]);
		
		List<Opportunity> oppToLeadController =  new List<Opportunity>();
		List<Expired_Opportunities__c> expOpp =  new List<Expired_Opportunities__c>();
		List<ID> salesManagerId =new List<ID>();
		List<Opportunity> oppToSalesManager =  new List<Opportunity>();
		
		for(Opportunity opp: oppList){
			opp.StageName = 'Expired';
			opp.Stage_changed__c = false;
			if(users.get(opp.OwnerID).Sales_Rep__c !=null){ //broker -> SR
				expOpp.add(OpportunityTriggerHandler.createExpiredOpp(opp));
				opp.OwnerID = users.get(opp.OwnerID).Sales_Rep__c;
				opp.Date_Time_Assigned__c = datetime.now();
				oppBrokerExpired.add(opp.id);
				oppId.add(opp.id);
			}else if(!opp.Assigned_to_Lead_Controller__c){ // SR - > leadController
				oppBSalesRepExpired.add(opp.id);
				oppToLeadController.add(opp);
			}else{
				
				if(opp.Sales_Manager__c!=null){ // Lead Controller -> SalesManager
					oppLeadControllerExpired.add(opp.id);
					salesManagerId.add(opp.Sales_Manager__c);
					oppToSalesManager.add(opp);
				}
			}
		}
		
		if(oppToLeadController.size()>0){
			oppId.addAll( OpportunityTriggerHandler.oppToLeadController(oppToLeadController,true) ); 
		}
		
		
		if(oppToSalesManager.size()>0){ 
			List<User> usersByContactId = [Select id ,ContactID  from User Where ContactID IN:salesManagerId];
			Map<ID,ID> userByContactIDMap = new Map<ID,ID>(); //<ContactId, UserID>
			for(User u: usersByContactId){
				userByContactIDMap.put(u.ContactID,u.id);
			}
			
			for(Opportunity opp: oppToSalesManager){
				if(userByContactIDMap.get(opp.Sales_Manager__c)!=null){
					expOpp.add(OpportunityTriggerHandler.createExpiredOpp(opp));			
					opp.OwnerID = userByContactIDMap.get(opp.Sales_Manager__c);
					opp.Date_Time_Assigned__c = datetime.now();				
				}
			}
			
			OpportunityTriggerHandler.checkLeadControllerExpired(oppLeadControllerExpired); //Future method that will check the field: Lead_Controller_Expired__c
			
		}
		
		if(oppBrokerExpired.size()>0)
			OpportunityTriggerHandler.checkBrokerExpired(oppBrokerExpired);	 //Future method that will check the field: Broker_Expired__c
			
		if(oppBSalesRepExpired.size()>0)
			OpportunityTriggerHandler.checkSalesRepExpired(oppBSalesRepExpired); //Future method that will check the field: Sales_rep_expired__c


		if(oppId.size()>0)
			OpportunityTriggerHandler.uncheckAutoAssignment(oppId);
			
		if(expOpp.size()>0)
			insert expOpp;
		
		
		
	}
	
	//Assign the opp to the lead controller of the state
	private static Set<String>  oppToLeadController(List<Opportunity> oppToLeadController, Boolean autoAssignment){
		
		Set<String> oppId  = new Set<String>();
		List<Expired_Opportunities__c> expOpp =  new List<Expired_Opportunities__c>();
		for(Opportunity opp: oppToLeadController){
			if(autoAssignment){
				expOpp.add(OpportunityTriggerHandler.createExpiredOpp(opp));			
			}
			if(opp.Lead_Controller__c!=null)
				opp.OwnerID = opp.Lead_Controller__c;
			opp.Date_Time_Assigned__c = datetime.now();
			opp.Assigned_to_Lead_Controller__c = true;
			oppId.add(opp.id);				
		}
		if(expOpp.size()>0 && autoAssignment)
			insert expOpp;
				
		return oppId;
	}
	
	@future
	public static void checkBrokerExpired(Set<ID> oppIDSet){
		List<Opportunity> oppList = [Select id, Broker_Expired__c from Opportunity Where id IN: oppIDSet ];
		for(Opportunity opp: oppList){
			opp.Broker_Expired__c =true;
		}
		update oppList;
	}	
	
	@future
	public static void checkSalesRepExpired(Set<ID> oppIDSet){
		List<Opportunity> oppList = [Select id, Sales_rep_expired__c from Opportunity Where id IN: oppIDSet ];
		for(Opportunity opp: oppList){
			opp.Sales_rep_expired__c =true;
		}
		update oppList;		
	}
	
	@future
	public static void checkLeadControllerExpired(Set<ID> oppIDSet){
		List<Opportunity> oppList = [Select id, Lead_Controller_Expired__c from Opportunity Where id IN: oppIDSet ];
		for(Opportunity opp: oppList){
			opp.Lead_Controller_Expired__c =true;
		}
		update oppList;		
	}	
		
	//Unmark the check box field "Auto_assignment__c" in an opportunity. 
	@future
	public static void uncheckAutoAssignment(Set<String> oppId){
		List<Opportunity> oppList = [Select id,Auto_assignment__c from Opportunity Where id IN:  oppId];
		
		if(oppList.size()>0){
			for(Opportunity opp:oppList ){
				opp.Auto_assignment__c =  false;
			}
			
			update oppList;
		}
		
		
	}
	
	//Optain the Lead admin ID from the custom setting "AnthemLeadsAdmin__c"
	public static string getAnthemLeadAdmin(){
		List<AnthemLeadsAdmin__c> mcs = AnthemLeadsAdmin__c.getall().values();
     	String adminID = UserInfo.getUserId();
     	if(mcs!=null && mcs.size()>0){
     		adminID = mcs[0].ID__c;
     	}
     	return adminID;
	}
	
	//The new owner of the opp is going to be Lead Admin
	private static void changeOwnerToLeadAdmin(List<Opportunity> oppList){
		String owner = getAnthemLeadAdmin();
		for(Opportunity opp: oppList){
			opp.ownerId = owner;
			//opp.StageName = 'Waiting for Disposition';
			//opp.Secondary_Disposition_new__c = '';
			opp.Declined_to_Admin__c = false; 
			opp.Assigned_to_Lead_Controller__c=true;
		}
	}
	
	//An opportunity is re assigned to another broker. 
	private static void changeOwnerToAnotherBroker(List<Opportunity> oppList){
		
		Set<ID> brokerID  = new Set<ID>();
		for(Opportunity opp: oppList){
			brokerID.add(opp.OwnerID);
		}
		
		List<Opportunity> oppToAntoherBroker = new List<Opportunity>();
		List<Opportunity> oppToLeadController= new List<Opportunity>();
		List<Opportunity> oppToLeadAdmin= new List<Opportunity>();
		
		Map<id,User> brokers = new Map<id,User> ( [Select id, Sales_Rep__c from User where id IN: brokerID]);
		
		Set<ID> salesRepID =  new Set<ID>();
		
		for(Opportunity opp: oppList){
			ID saRepID = brokers.get(opp.OwnerID).Sales_Rep__c;
			
			if(saRepID!=null){
				if(opp.Users_who_declined__c!=null){ // Users_who_declined__c keeps a list of all the Brokers who declined the opp already
					opp.Users_who_declined__c = opp.Users_who_declined__c + ' ' + opp.OwnerID;
				}else{
					opp.Users_who_declined__c =opp.OwnerID;
				}
				opp.OwnerID = saRepID;
				salesRepID.add(saRepID);
				oppToAntoherBroker.add(opp);
				
			}else if(!opp.Assigned_to_Lead_Controller__c){
				oppToLeadController.add(opp);
			}else{
				oppToLeadAdmin.add(opp);
			}
			
			//opp.StageName = 'Waiting for Disposition';
			//opp.Secondary_Disposition_new__c = '';
			opp.Declined__c =  false;			
			
		}
		
		if(oppToAntoherBroker.size()>0) 
			AssignBrokers.getBrokers(oppToAntoherBroker,salesRepID,brokerID);
		if(oppToLeadController.size()>0)
			OpportunityTriggerHandler.oppToLeadController(oppToLeadController,false); 
		if(oppToLeadAdmin.size()>0)	
			OpportunityTriggerHandler.changeOwnerToLeadAdmin(oppToLeadAdmin);	
	}
	
	public static void setOppTeam(List<Opportunity> oppList){
		
		Set<ID>oppID = new Set<ID>();
		for(Opportunity opp: oppList){
			oppID.add(opp.id);
		}

		List<String> oppRoles =  new List<String>{'Sales Manager','Sales Rep','Broker','Back-up'};

		List<OpportunityTeamMember> oppTeamList = [Select id,TeamMemberRole from OpportunityTeamMember Where OpportunityId IN: oppID  and TeamMemberRole IN: oppRoles];

	 	if(oppTeamList!=null && oppTeamList.size()>0)
	 		delete oppTeamList;
	 		
	 	Set<ID> salesTeam = new Set<ID>();
	 	Map<id,List<Opportunity>> oppByOwnerID = new Map<id,List<Opportunity>> (); // <OwnerID, List<Opp>>	
 		for(Opportunity opp: oppList){
 			if(oppByOwnerID.containskey(opp.ownerId)){
 				List<Opportunity> auxList = oppByOwnerID.get(opp.OwnerID);
 				auxList.add(opp);
 				oppByOwnerID.put(opp.OwnerId, auxList );
 			}else{
 				oppByOwnerID.put(opp.OwnerId, new List<Opportunity>{opp} );
 			}
 			if(opp.Sales_Manager__c!=null)
 				salesTeam.add(opp.Sales_Manager__c);	
  			if(opp.Sales_Rep__c!=null)
 				salesTeam.add(opp.Sales_Rep__c);				
 		}

		Map<Id,User> userMap = new Map<Id,User>([Select id, Sales_Rep__c, Sales_Rep__r.Sales_Manager__c,Sales_Manager__c,ContactID, Profile.Name,Back_up__c From User Where ID IN:oppByOwnerID.keyset() or ContactID IN:salesTeam]);
		
		Map<ID,User> userByContact = new Map<ID,User>();
		for(User u: userMap.values())
		{
			if( u.ContactID != null )
			{
				userByContact.put(u.ContactID, u);
			}
		}
		
		oppTeamList  = new List<OpportunityTeamMember>();
		Set<ID> usersInRoles = new Set<ID>();
		for(Opportunity opp: oppList){
			User u = userMap.get(opp.OwnerID);
			if(u!=null){
				
				if(u.Profile.Name!=AnthemOppsProfiles.salesAdminProfile.Name  && u.Profile.Name!= AnthemOppsProfiles.salesManagerProfile.Name){
					if(u.Sales_Rep__c!=null){ 
						oppTeamList.add(OpportunityTriggerHandler.createTeamMember(u.Sales_Rep__c,opp.id,'Sales Rep')) ;
						usersInRoles.add(u.Sales_Rep__c);
					}
					if(u.Sales_Rep__r.Sales_Manager__c!=null || u.Sales_Manager__c!=null){
						ID salesManagerID = u.Sales_Rep__r.Sales_Manager__c!=null ? u.Sales_Rep__r.Sales_Manager__c : u.Sales_Manager__c;
						oppTeamList.add(OpportunityTriggerHandler.createTeamMember(salesManagerID,opp.id,'Sales Manager')) ;
						usersInRoles.add(salesManagerID);						
					}
				}else{
					if(u.Profile.Name==AnthemOppsProfiles.salesAdminProfile.Name && opp.Sales_Manager__c != null ){
						if(userByContact.containsKey(opp.Sales_Manager__c)){
							User saleRep = userByContact.get(opp.Sales_Manager__c);
							if(saleRep!=null){
								oppTeamList.add(OpportunityTriggerHandler.createTeamMember(saleRep.id,opp.id,'Sales Manager')) ;
								usersInRoles.add(saleRep.id);
							}							
						}						
					}else if(u.Profile.Name==AnthemOppsProfiles.salesManagerProfile.Name && opp.Sales_Rep__c != null ){
						if(userByContact.containsKey(opp.Sales_Rep__c)){
							User saleRep = userByContact.get(opp.Sales_Rep__c);
							if(saleRep!=null){
								oppTeamList.add(OpportunityTriggerHandler.createTeamMember(saleRep.id,opp.id,'Sales Rep')) ;
								usersInRoles.add(saleRep.id);
							}							
							
						}
					}
				}
				
				if(u.Back_up__c!=null)
					oppTeamList.add(OpportunityTriggerHandler.createTeamMember(u.Back_up__c, opp.id, 'Back-up'));	
			}
		}
		
		if(oppTeamList.size()>0)
			insert oppTeamList;

		List<OpportunityShare> shares = [select Id, OpportunityAccessLevel, RowCause 
											from OpportunityShare 
											where OpportunityId IN: oppID
												and UserOrGroupId IN:usersInRoles  
												and RowCause = 'Team'];
		
		// set all team members access to read/write
		for (OpportunityShare share : shares)  
			share.OpportunityAccessLevel = 'Edit';
			
		if(shares!=null && shares.size()>0)
			update shares;				
	}
	
	public static OpportunityTeamMember createTeamMember(Id userID, Id oppID, String userRole){
		OpportunityTeamMember oppTM =  new OpportunityTeamMember();	
		oppTM.UserId = userID;
		oppTM.OpportunityId = oppID;
		oppTM.TeamMemberRole = userRole;
		
		return oppTM;
	}
	
	private static Expired_Opportunities__c createExpiredOpp (Opportunity opp){
		Expired_Opportunities__c eo = new Expired_Opportunities__c();
		eo.Opportunity_Name__c = opp.id;
		eo.Opportunity_Owner__c = opp.OwnerID;
		eo.Name = opp.Name;		
		return eo;
	}
	

}