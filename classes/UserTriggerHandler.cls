public with sharing class UserTriggerHandler {
	
	//Resets the counter of number of all the users(Brokers) related with the same SalesRep
	//Checks the IND field of the SalesRep, if the Broker has it flagged. 
	public static void beforeInsert(List<User> users){
		
		Set<id> salesRepIDOutOffice = new Set<id>();
		Set<id> salesRepIDIND = new Set<id>();
		Set<id> salesRepIDLanguage= new Set<id>();
		Map<id, List<String>> languagesByBroker =  new Map<id, List<String>>();
		List<User> brokersByLanguage =  new List<User>();

		
		for(User u: users){
			if(u.Sales_Rep__c!=null){
				languagesByBroker.put(u.id, u.Language__c.split(';',-2));
				salesRepIDLanguage.add(u.Sales_Rep__c);
				brokersByLanguage.add(u);
				
				if( !u.Out_of_office__c)
					salesRepIDOutOffice.add(u.Sales_Rep__c);
				if(u.IND__c)
					salesRepIDIND.add(u.Sales_Rep__c);

			}
		}
		
		List<User> brokersBySalesRepList = [Select id,Sales_Rep__c, Opp_Assigned__c from User where IsActive = True and Sales_Rep__c IN: salesRepIDOutOffice and Out_of_office__c =: false and Deactivate_Broker__c=:false];
		

		if(brokersBySalesRepList!=null && brokersBySalesRepList.size()> 0)
			UserTriggerHandler.recalculateOppByBroker(brokersBySalesRepList,null);
		
		if(salesRepIDIND.size()>0)	
			UserTriggerHandler.checkIND(salesRepIDIND);
		
		if(salesRepIDLanguage.size()>0)
			UserTriggerHandler.checkLanguages(salesRepIDLanguage, languagesByBroker , brokersByLanguage, true );
		
	}
	
	//Check if the language of the broker has change, and update the SR
	private static void checkLanguages(Set<id> salesRepID, Map<id, List<String>> languagesByBroker , List<User> brokers, Boolean isInsert ){
		Map<Id,Set<String>> languagesBySR = new Map<Id,Set<String>>();
		Map<Id, User> salesRep = new Map<Id, User>( [Select id,Language__c from User Where id IN:  salesRepID]);
		Map<Id, User> salesRepWithNewLanguage = new Map<Id, User>(); // SR Id, user
		
		List<User> salesRepToUpdate = new List<User>();
		if(brokers.size()>0){
			for(User broker: brokers ){
				User salesR = new User();
				if(salesRepWithNewLanguage.containsKey(broker.Sales_Rep__c))
					salesR = salesRepWithNewLanguage.get(broker.Sales_Rep__c);
				else{
					salesR = salesRep.get(broker.Sales_Rep__c);
					if(!isInsert)
						salesR.Language__c =''; 
				}
				for(String language: languagesByBroker.get(broker.id)){
					if(!salesR.Language__c.contains(language))
						salesR.Language__c = salesR.Language__c+';'+ language;
				}
				salesRepWithNewLanguage.put(salesR.id,salesR);
			}
			update salesRepWithNewLanguage.values();
		}else{
			List <User> salesRepsToUpdate = new List<User>();
			for(User u: salesRep.values()){
				u.Language__c ='English'; 
				salesRepsToUpdate.add(u);
			}
			system.debug(salesRepsToUpdate.size());
			update salesRepsToUpdate;
		}
	}

	//Flag the IND field on the Users
	private static void checkIND(Set<id> salesRepIDIND){

		List<User> salesRep =[Select id, IND__c,IND_Only__c from User Where id IN: salesRepIDIND ];
		if(salesRep!=null && salesRep.size()>0){
			for(User u : salesRep){
				u.IND__c = true;
			}
		}
		update salesRep;		
	}
	
	//Check a SalesRep as IND only 
	private static void checkOnlyIND(Map<id,boolean> salesRepSet, Set<ID> brokerID){
		
		List<User> brokersBySR = [Select id, IND_Only__c,Sales_Rep__c from User Where Sales_Rep__c IN: salesRepSet.keySet() and Out_of_office__c = false and Deactivate_Broker__c=false and ID NOT IN: brokerID ];
		
		
		Map<Id,Boolean> isINDOnlyMap = new Map<Id,Boolean>();
		for(User u: brokersBySR){
			if(isINDOnlyMap.containskey(u.Sales_Rep__c) && isINDOnlyMap.get(u.Sales_Rep__c))
				isINDOnlyMap.put(u.Sales_Rep__c,u.IND_Only__c );
			else if(!isINDOnlyMap.containskey(u.Sales_Rep__c))
				isINDOnlyMap.put(u.Sales_Rep__c,u.IND_Only__c );
		}

		List<User> salesRep =[Select id, IND__c,IND_Only__c from User Where id IN: salesRepSet.keySet() ];
		if(salesRep!=null && salesRep.size()>0){
			for(User u : salesRep){
				if(isINDOnlyMap.get(u.id)!=null){
					if(isINDOnlyMap.get(u.id))
						u.IND_Only__c =true;
				}else{
					u.IND_Only__c = salesRepSet.get(u.id);
				}
			}
		}
		update salesRep;			
	}
	
	
	//Uncheck a SalesRep as IND only
	private static void uncheckOnlyIND(Set<id> salesRepSet){
		List<User> salesRep =[Select id, IND__c,IND_Only__c from User Where id IN: salesRepSet ];
		if(salesRep!=null && salesRep.size()>0){
			for(User u : salesRep){
				u.IND_Only__c =false;
			}
		}
		update salesRep;		
	}
	
	//Verifies if the IND flag, should continue checked in the SalesRep (SR). 
	private static void checkUncheckIND(Set<id> salesRepIDNoIND ,Set<id> brokerID){
		
		List<User> brokerList = [Select id, IND__c ,Sales_Rep__c from User Where id NOT IN: brokerID AND Sales_Rep__c IN: salesRepIDNoIND AND IND__c =: true AND Out_of_office__c=false AND Deactivate_Broker__c=false];
		List<User> salesRep = [Select id, IND__c from User Where id IN: salesRepIDNoIND ];
		
		if(brokerList!=null && brokerList.size()>0){
			Set<ID> SRwithBrokerWithIND = new Set<ID>(); // <salesRep id. from Brokers that has IND==true>
			for(User u: brokerList){
				SRwithBrokerWithIND.add(u.Sales_Rep__c);
			}
			for(User u : salesRep){
				if(SRwithBrokerWithIND.contains(u.id))
					u.IND__c = true;
				else
					u.IND__c = false;
			}
		}else{
			for(User u : salesRep){
				u.IND__c = false;
			}			
			
		}
		update salesRep;	
	}	
	
	public static void beforeUpdate(List<User> newUsers, List<User> oldUsers){
		Set<id> allUserId = new Set<id>();
		Set<id> salesRepID = new Set<id>();
		Set<id> userIDNotOutOff = new Set<id>();
		Set<Id> userID = new Set<ID>();
		Set<id> userIDOutOff = new Set<id>();
		Set<id> salesRepIDIND = new Set<id>();
		Set<id> brokersIND = new Set<id>();
		Set<id> brokersINDInsert = new Set<id>();  
		Set<id> salesRepIDNoIND = new Set<id>();
		Map<id,Boolean> salesRepIDNOnly = new Map<id,Boolean>();
		Set<id> salesRepIDNOnlyInsert = new Set<id>();
		Set<id> salesRepIDNOnlyUncheck = new Set<id>();
		List<User> brokersByLanguage = new List<User>();
		List<User> usersAddBackUp = new List<User>();
		List<User> usersRemovingBackUp = new List<User>();
		Set<ID> brokersByLanguageSet = new Set<ID>();
		Set<id> salesRepIDLanguage= new Set<id>();
		Map<id, List<String>> languagesByBroker =  new Map<id, List<String>>();
		Set<id> brokerID =  new Set<id>();
		
		for(Integer i=0; i<newUsers.size();i++){
			User newU = newUsers[i];
			User oldU = oldUsers[i];
			allUserId.add(newU.id);
			
			if( newU.Sales_Rep__c!=null ){ //Is a Broker
				if( ( (newU.Sales_Rep__c!=oldU.Sales_Rep__c)  
					|| (newU.Out_of_office__c!=oldU.Out_of_office__c && !newU.Out_of_office__c) 
					|| (newU.Deactivate_Broker__c!=oldU.Deactivate_Broker__c && !newU.Deactivate_Broker__c)  )){ //Reset the counter	
						newU.Opp_Assigned__c = 0;
						salesRepID.add(newU.Sales_Rep__c);
						userIDNotOutOff.add(newU.id);			
				}
				//check if the SalesRep is going to be IND Only
				if(newU.IND_Only__c!=oldU.IND_Only__c){
					if(newU.IND_Only__c  && !newU.Out_of_office__c && !newU.Deactivate_Broker__c){
						brokersIND.add(newU.id);
						salesRepIDNOnly.put(newU.Sales_Rep__c,true);
					}else if(!newU.IND_Only__c  && !newU.Out_of_office__c && !newU.Deactivate_Broker__c){
						salesRepIDNOnlyUncheck.add(newU.Sales_Rep__c);
					}	
				}
				
				//If outOfOffice or deactivate changes, the IND in the SR should change too	
				if((newU.Out_of_office__c!=oldU.Out_of_office__c) || (newU.Deactivate_Broker__c!=oldU.Deactivate_Broker__c)){
					
					if( (newU.Out_of_office__c && !newU.Deactivate_Broker__c) || (!newU.Out_of_office__c && newU.Deactivate_Broker__c) ||  (newU.Out_of_office__c && newU.Deactivate_Broker__c) ){
						userIDOutOff.add(newU.id);
						brokersIND.add(newU.id);
						salesRepIDNOnly.put(newU.Sales_Rep__c,false);	
					}
					
					if(newU.Out_of_office__c || newU.Deactivate_Broker__c){
						salesRepIDNoIND.add(newU.Sales_Rep__c);
						brokerID.add(newU.id);						
					}else{
						if(newU.IND__c){
							salesRepIDIND.add(newU.Sales_Rep__c);						
						}
						if(newU.IND_Only__c){
							brokersINDInsert.add(newU.id);
							salesRepIDNOnly.put(newU.Sales_Rep__c,true);	
						}else{
							salesRepIDNOnlyUncheck.add(newU.Sales_Rep__c);							
						}
					}
					//Update the language if the outOffOffice or deactive changed
					brokersByLanguageSet.add(newU.id);
					salesRepIDLanguage.add(newU.Sales_Rep__c);

					if(newU.Sales_Rep__c!=oldU.Sales_Rep__c && oldU.Sales_Rep__c!=null ){
						salesRepIDLanguage.add(oldU.Sales_Rep__c);
					}
					
					if( !newU.Out_of_office__c && !newU.Deactivate_Broker__c){
						brokersByLanguage.add(newU);
						languagesByBroker.put(newU.id, newU.Language__c.split(';',-2));
					}
				}
				//Check or uncheck the IND flag in the SR
				if(newU.IND__c!=oldU.IND__c && !newU.Out_of_office__c && !newU.Deactivate_Broker__c){ 
					if(newU.IND__c){
						salesRepIDIND.add(newU.Sales_Rep__c);
					}else{
						salesRepIDNoIND.add(newU.Sales_Rep__c);
						brokerID.add(newU.id);
					}
				}
				//Change of owner, should update the IND Flag in the SR and languages
				if(newU.Sales_Rep__c!=oldU.Sales_Rep__c ){ 
					
					//Check the IND only
					if(newU.IND_Only__c){
						if(newU.Sales_Rep__c!=null && !newU.Out_of_office__c && !newU.Deactivate_Broker__c){
							brokersINDInsert.add(newU.id);
							salesRepIDNOnly.put(newU.Sales_Rep__c,true);
						}
					}else{
						salesRepIDNOnlyUncheck.add(oldU.Sales_Rep__c);
						if(!newU.Out_of_office__c && !newU.Deactivate_Broker__c)
							salesRepIDNOnlyUncheck.add(newU.Sales_Rep__c);
					}
					
					brokersIND.add(oldU.id);
					salesRepIDNOnly.put(oldU.Sales_Rep__c,false);					
					
					if(newU.IND__c ){
						if(newU.Sales_Rep__c!=null && !newU.Out_of_office__c && !newU.Deactivate_Broker__c){
							salesRepIDIND.add(newU.Sales_Rep__c);
						}if(oldU.Sales_Rep__c!=null  ){
							salesRepIDNoIND.add(oldU.Sales_Rep__c);
							brokerID.add(newU.id);
						}
					}else{
						salesRepIDNoIND.add(oldU.Sales_Rep__c);
						brokerID.add(newU.id);						
					}
					//Language hasnt change, but the owner did
					if(newU.Language__c==oldU.Language__c && !newU.Out_of_office__c && !newU.Deactivate_Broker__c){
						
						brokersByLanguage.add(newU);
						brokersByLanguageSet.add(newU.id);
						salesRepIDLanguage.add(newU.Sales_Rep__c);
						if(newU.Language__c!=null)
							languagesByBroker.put(newU.id, newU.Language__c.split(';',-2));
						if(oldU.Sales_Rep__c!=null)
							salesRepIDLanguage.add(oldU.Sales_Rep__c);
					}
								
				}
				//Check if the language has change
				if(newU.Language__c!=oldU.Language__c && !newU.Out_of_office__c && !newU.Deactivate_Broker__c){
					brokersByLanguage.add(newU);
					brokersByLanguageSet.add(newU.id);
					salesRepIDLanguage.add(newU.Sales_Rep__c);
					languagesByBroker.put(newU.id, newU.Language__c.split(';',-2));
					
					if(newU.Sales_Rep__c!=oldU.Sales_Rep__c && oldU.Sales_Rep__c!=null){
						salesRepIDLanguage.add(oldU.Sales_Rep__c);
					}
				}
				
			}else if(newU.Sales_Rep__c!=oldU.Sales_Rep__c ){ 
				salesRepIDNoIND.add(oldU.Sales_Rep__c);
				brokerID.add(newU.id);	
				brokersByLanguageSet.add(newU.id);				
			}
			
			if(oldU.Back_up__c!=newU.Back_up__c){ //The back up user has changed, or has been assigned
				
				if(oldU.Back_up__c!=null) //A backup user has been removed
					usersRemovingBackUp.add(oldU);
				if(newU.Back_up__c!=null) // A backup User has been assigned 
					usersAddBackUp.add(newU); 
			}
		}
		
		if(usersRemovingBackUp.size()>0) // remove the opportunity team user
			UserTriggerHandler.removeBackUpUser(usersRemovingBackUp);
		
		if(usersAddBackUp.size()>0) // Add a new opportunity team user
			UserTriggerHandler.addBackUpUser(usersAddBackUp);
		
		//IDN ONLY
		if(salesRepIDNOnlyUncheck.size()>0)
			UserTriggerHandler.uncheckOnlyIND(salesRepIDNOnlyUncheck);
		if(salesRepIDNOnly.size()>0)	
			UserTriggerHandler.checkOnlyIND(salesRepIDNOnly,brokersIND);

		
		if(brokersByLanguageSet.size()>0){
			List<User> brokerList = [Select id, Language__c ,Sales_Rep__c, FirstName from User Where id NOT IN: brokersByLanguageSet AND Sales_Rep__c IN: salesRepIDLanguage  AND Out_of_office__c=false AND Deactivate_Broker__c=false];

			for(User u:brokerList){
				languagesByBroker.put(u.id, u.Language__c.split(';',-2));
			}	
			brokerList.addall(brokersByLanguage);
			UserTriggerHandler.checkLanguages(salesRepIDLanguage, languagesByBroker , brokerList, false );
		}
			
		
		//Flag the IND field on the Users	
		if(salesRepIDNoIND.size()>0)
			UserTriggerHandler.checkUncheckIND(salesRepIDNoIND,brokerID);
			
		if(salesRepIDIND.size()>0)	
			UserTriggerHandler.checkIND(salesRepIDIND);		
		
		if(userIDNotOutOff.size()>0){
			userID.addAll(userIDNotOutOff);
			userId.addAll(userIDOutOff);
		}
		
		List<User> brokersBySalesRepList = [Select id,Sales_Rep__c, Opp_Assigned__c 
											from User 
											where IsActive = True and Sales_Rep__c IN: salesRepID 
												and Out_of_office__c =: false 
												and Deactivate_Broker__c=:false
												and id not IN: userID ];
																				
		if(brokersBySalesRepList!=null && brokersBySalesRepList.size()> 0){
			UserTriggerHandler.recalculateOppByBroker(brokersBySalesRepList,allUserId);
		}
		
				
		
			
	}
	
	//Removes an opportunity team user related in the 'back up' field of the user
	private static void removeBackUpUser(List<User> usersRemovingBackUp){
		
		Set<ID> backUpUser = new Set<ID>();
		Set<ID> userID = new Set<ID>();
		
		For(User u: usersRemovingBackUp){
			userID.add(u.id);
			backUpUser.add(u.Back_up__c);	
		}
		
		Map<Id,Opportunity> oppMap= new Map<Id,Opportunity> ([Select Id from Opportunity Where OwnerID IN: userID]);
		
		if(oppMap!=null && oppMap.size()>0){
		
			List<OpportunityTeamMember> oppTeamList = [Select id from OpportunityTeamMember Where OpportunityId IN: oppMap.keySet() and  UserId IN: backUpUser and TeamMemberRole =: 'Back-up' ];
			
		 	if(oppTeamList!=null && oppTeamList.size()>0){
		 		delete oppTeamList;
		 	}
		}
		
	}
	
	//If user is added to the 'back up' field in the user, Opportunity team records will be added to all the opp of that user. 
	private static void addBackUpUser(List<User> usersAddBackUp){
		Set<ID> userID = new Set<ID>();
		Set<ID> backUpUser = new Set<ID>();
		
		for(User u: usersAddBackUp){
			userID.add(u.id);
			backUpUser.add(u.Back_up__c);	
		}

		Map<Id,Opportunity> oppMap= new Map<Id,Opportunity> ([Select Id,OwnerID from Opportunity Where OwnerID IN: userID]);
		Map<Id,List<Opportunity>> oppByOwner = new Map<Id,List<Opportunity>>(); // <UserID, List<Opp> the userID owns>
		
		if(oppMap!=null && oppMap.size()>0){
			for(Opportunity opp: oppMap.values()){
				if(oppByOwner.containsKey(opp.OwnerID)){
					List<Opportunity> auxList = new List<Opportunity>();
					auxList.addAll(oppByOwner.get(opp.OwnerID));
					auxList.add(opp);
					
					oppByOwner.put(opp.OwnerID, auxList);
				}else{
					oppByOwner.put(opp.OwnerID, new List<Opportunity>{opp});
					
				}
			}
		}
		

		List<OpportunityTeamMember> oppTeamList  = new List<OpportunityTeamMember>();
		for(User u: usersAddBackUp){
			List<Opportunity> oppByOwnerList = 	oppByOwner.get(u.id);
			if(oppByOwnerList!=null && oppByOwnerList.size()>0){
				for(Opportunity opp:oppByOwnerList){
					OpportunityTeamMember oppTM =  new OpportunityTeamMember();
					oppTM.UserId = u.Back_up__c;
					oppTM.OpportunityId = opp.id;
					oppTM.TeamMemberRole = 'Back-up';
					oppTeamList.add(oppTM) ;
				}
			}
		}
			
		if(oppTeamList.size()>0)
			insert oppTeamList;
			
		// get all of the team members' sharing records
		List<OpportunityShare> shares = [select Id, OpportunityAccessLevel, RowCause 
											from OpportunityShare 
											where OpportunityId IN: oppMap.keySet() 
												and UserOrGroupId IN:backUpUser  
												and RowCause = 'Team'];
		
		// set all team members access to read/write
		for (OpportunityShare share : shares)  
			share.OpportunityAccessLevel = 'Edit';
		
		update shares;			
			
	}	

	private static void recalculateOppByBroker(List<User> brokersBySalesRepList, Set<ID> userID){

		Map<id,Map<Double,List<User>>> brokersBySalesRepMap = new Map<id,Map<Double,List<User>>>(); //<salesRepID, <lower # Opp_Assigned__c !=0,   List of brokers by salesRepID>>
		
		for (User u: brokersBySalesRepList){
        	List<User> auxList = new List<User>();
        	Map<Double,List<User>> auxMap = new Map<Double,List<User>>();
        	
        	if(brokersBySalesRepMap.containsKey(u.Sales_Rep__c)){
        		auxMap = brokersBySalesRepMap.remove(u.Sales_Rep__c);
        		List <Double> auxDoubleList = new List<Double>();
        		auxDoubleList.addAll(auxMap.keyset());
        		Double num = auxDoubleList[0];
        		auxList =auxMap.get(num);
        		auxList.add(u);
        		if(u.Opp_Assigned__c!=null && u.Opp_Assigned__c!=0 && u.Opp_Assigned__c<num){
        			auxMap = new Map<Double,List<User>>();
        			auxMap.put(u.Opp_Assigned__c, auxList);
        			brokersBySalesRepMap.put(u.Sales_Rep__c, auxMap);
        		}else{
        			auxMap.put(num, auxList);
        			brokersBySalesRepMap.put(u.Sales_Rep__c, auxMap);
        		}
        		      		
        	}else{
        		auxList.add(u);
        		auxMap.put(u.Opp_Assigned__c, auxList);
        		brokersBySalesRepMap.put(u.Sales_Rep__c, auxMap);
        	}			
		}
		
		if(brokersBySalesRepMap.size()>0){
			List<User> auxList = new List<User>();
			
			for(id salesRepID: brokersBySalesRepMap.keyset()){
				Map<Double,List<User>> auxMap = brokersBySalesRepMap.get(salesRepID);
				List <Double> auxDoubleList = new List<Double>();
        		auxDoubleList.addAll(auxMap.keyset());
				Double num = auxDoubleList[0];
				auxList = auxMap.get(num);
				for(User u : auxList){
					if(u.Opp_Assigned__c!=null && u.Opp_Assigned__c!=0){
						u.Opp_Assigned__c = u.Opp_Assigned__c - num;
					}
				}
			}
			if(auxList.size()>0){
				if(userID!=null){
					List<User> uToUpdate =  new List<User>();
					for(User u:auxList){
						if(!userID.contains(u.id))
							uToUpdate.add(u);
					}
					
					update uToUpdate;
				}else{
					update auxList;
				}
			}
		}
		
		
		
	}

}