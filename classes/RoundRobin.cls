public class RoundRobin {
    
    
    public static void assignmentRules(List<Opportunity> opportunities){
        system.debug( '### method : assignmentRules() '  );
        system.debug( '### param: opportunities : ' + opportunities );
        
       // ID accountID = RoundRobin.getAccountID(); was used to create generic accounts by Magnet, no longer needed 

        List<Opportunity> oppByBroker = new List<Opportunity>();
        List<Opportunity> oppBySalesRep = new List<Opportunity>();
        
        List<Opportunity> oppByEvent = OpportunityTriggerHandler.setZipCodeAndEventID(opportunities); // Convert the Zip Code and the EventId text values into a look up. Check if the opp has an EventId and assign it.
        
        for(Opportunity opp: opportunities)
        {
        
            system.debug( '### opp.CampaignID : ' + opp.CampaignID );
            system.debug( '### opp.OwnerID : ' + opp.OwnerID );
            system.debug( '### UserInfo.getUserId() : ' + UserInfo.getUserId());
            system.debug( '### opp.Broker_Name__c  : ' + opp.Broker_Name__c );
            system.debug( '### opp.Working_With_Broker__c : ' + opp.Working_With_Broker__c );

            if( ( opp.CampaignID==null || ( opp.CampaignID!=null && opp.OwnerID == UserInfo.getUserId() ))  && ( String.isNotBlank( opp.Broker_Name__c ) || ( String.isNotBlank( opp.Working_With_Broker__c ) && opp.Working_With_Broker__c=='Yes'))){ //Broker is filled
                system.debug( '### enter IF ' + opp);
                oppByBroker.add(opp);
            }else if( ( opp.CampaignID==null || ( opp.CampaignID!=null && opp.OwnerID == UserInfo.getUserId() ))  &&  String.isBlank( opp.Broker_Name__c ) && ( String.isBlank( opp.Working_With_Broker__c ) || opp.Working_With_Broker__c=='No' )){
                system.debug( '### enset Else ' + opp );
                oppBySalesRep.add(opp);
            }
            
         //   if(accountID!=null && opp.AccountID==null){ was used to create generic accounts by Magnet, no longer needed - Omari Worthy
          //      opp.AccountID = accountID;
         //   }
        }
        /*
        if(oppByEvent!=null && oppByEvent.size()>0){
            oppBySalesRep.addAll(oppByEvent); // If the opp has an EventId, but there are not Assignment rules associated with that EventId, then I added to the list of opp to assign.
        }*/
        
        if(oppBySalesRep.size()>0)
        {
            system.debug( '### Calling assignSalesRep method : ' + oppBySalesRep);
            RoundRobin.assignSalesRep(oppBySalesRep);
        }
        if(oppByBroker.size()>0)
        {
            system.debug( '### Calling assignLeadController method : ' + oppByBroker);
            RoundRobin.assignLeadController(oppByBroker);
        }
    }
    
 
    
    // return MAP <ZipCode Name, List<Opp with that Zip>>
    private static Map<String,List<Opportunity>> oppByZip(List<Opportunity> opportunities){
        
        Map<String,List<Opportunity>> oppByZipMap = new Map<String,List<Opportunity>>();  // <ZipCode Name, List<Opp with that Zip>>

        for(Opportunity opp: opportunities){
            List<Opportunity> auxList = new List<Opportunity>();
            
            if(oppByZipMap.containsKey(opp.Site_ZIP__c)){
                auxList = oppByZipMap.get(opp.Site_ZIP__c);
                auxList.add(opp);
                oppByZipMap.put(opp.Site_ZIP__c,auxList );  
            }else{
                auxList.add(opp);
                oppByZipMap.put(opp.Site_ZIP__c,auxList );
            }
        }
        return  oppByZipMap;
    }
    
    private static void assignLeadController(List<Opportunity> oppByBroker){
        system.debug( '### method assignLeadController()  ');
        system.debug( '### param oppByBroker : ' + oppByBroker);

        Map<String,List<Opportunity>> oppByZipMap = RoundRobin.oppByZip(oppByBroker);   // <ZipCode Name, List<Opp with that Zip>>
        List<Zip_City_County__c> zipCityCountyList = [Select id, County__c, State__c, City__c, Name from Zip_City_County__c where Name IN: oppByZipMap.keyset() ];
        
        Map<String,List<String>> zipByStateMap = new Map<String,List<String>>();   // <State ID, List<Zip Codes Name>>
        for(Zip_City_County__c zcc: zipCityCountyList){
            List<String> auxList = new List<String>();
            if(zipByStateMap.containsKey(zcc.State__c)){
                auxList = zipByStateMap.get(zcc.State__c);
                auxList.add(zcc.Name);
                zipByStateMap.put(zcc.State__c,auxList );
                    
            }else{
                auxList.add(zcc.Name);
                zipByStateMap.put(zcc.State__c,auxList );           
            }               
        }
        
        List<Assignment_Rule__c> assignmentRules = [Select id,Assignment_by_Broker__c, Assignment_by_Campaign__c,Assignment_by_City__c,Assignment_by_County__c,Assignment_by_State__c,Assignment_by_Zip_Code__c, State__c ,Lead_Controller__c
                                                        From Assignment_Rule__c 
                                                        Where State__c IN:zipByStateMap.keySet()
                                                        and recordType.DeveloperName =: 'Geographical_Record_Type' ];
                                                        
        system.debug( '### callling method setLeadController from assignLeadController ');                                            
        RoundRobin.setLeadController(zipByStateMap.keySet(),assignmentRules,zipByStateMap,oppByZipMap);                                             
                                                        
                                                                
    }

    private static void setLeadController(Set<String> statesList, List<Assignment_Rule__c> assignmentRules,Map<String,List<String>> zipByStateMap, Map<String,List<Opportunity>> oppByZipMap){
        system.debug( '### method setLeadController()  ');
   

        Map<ID, ID> leadControllerByState = new Map<ID, ID>(); // <State ID, LeadController ID> 
        for(Assignment_Rule__c ar: assignmentRules ){
            leadControllerByState.put(ar.State__c, ar.Lead_Controller__c);
        }       
        system.debug('statesList ' +statesList);        
        system.debug('oppByZipMap ' +oppByZipMap);                              
        if(statesList!=null && statesList.size()>0){                                            
            for(ID stateID: statesList){  
                for(String zipCode: zipByStateMap.get(stateID)){
                    for(Opportunity opp: oppByZipMap.get(zipCode)){
                        System.debug('## opp : ' + opp);
                        System.debug('## opp.Assignment_by__c  : ' + opp.Assignment_by__c );
                        opp.OwnerID = leadControllerByState.get(stateID);
                        opp.OwnerID__c = leadControllerByState.get(stateID);
                        opp.Assignment_by__c ='LC'; // Lead controller is the owner of the opp
                    }
                }
            }
        }
        String adminID = RoundRobin.getAnthemAdmin();
        if(oppByZipMap.containsKey(null)){
            for(Opportunity opp: oppByZipMap.get(null)){
                opp.OwnerID = adminID;
                opp.OwnerID__c = adminID;
                opp.Assignment_by__c ='LA'; // Lead controller is the owner of the opp
            }
        }       

    }

    //11/12/15 ADG-S M360
    //Set lead controller just for a list of opportunities for one specific
    //zipcode
    private static void setLeadControllerOnUserAssigment(Set<String> statesList, List<Assignment_Rule__c> assignmentRules,Map<String,List<String>> zipByStateMap, List<Opportunity> opps , String zip_location){
        system.debug( '### method setLeadController()  ');
   

        Map<ID, ID> leadControllerByState = new Map<ID, ID>(); // <State ID, LeadController ID> 
        for(Assignment_Rule__c ar: assignmentRules ){
            leadControllerByState.put(ar.State__c, ar.Lead_Controller__c);
        }       
        
        if( zip_location != null)
        {                            
            if(statesList!=null && statesList.size()>0)
            {                                            
                for(ID stateID: statesList )
                {  
                    for(String zipCode: zipByStateMap.get(stateID))
                    {
                        if( zipCode == zip_location )
                        {
                            for(Opportunity opp: opps )
                            {
                                System.debug('## opp : ' + opp);
                                System.debug('## opp.Assignment_by__c  : ' + opp.Assignment_by__c );
                                opp.OwnerID = leadControllerByState.get(stateID);
                                opp.OwnerID__c = leadControllerByState.get(stateID);
                                opp.Assignment_by__c ='LC'; // Lead controller is the owner of the opp
                            }
                        }

                    }
                }
            }
        }
        else if( zip_location == null )
        {
            String adminID = RoundRobin.getAnthemAdmin();
            for( Opportunity opp: opps  )
            {
                opp.OwnerID = adminID;
                opp.OwnerID__c = adminID;
                opp.Assignment_by__c ='LA'; // Lead controller is the owner of the opp
            }
        } 
    }

    
    private static string getAnthemAdmin (){
        List<AnthemLeadsAdmin__c> mcs = AnthemLeadsAdmin__c.getall().values();
        String adminID = UserInfo.getUserId();
        if(mcs!=null && mcs.size()>0){
            adminID = mcs[0].ID__c;
        }   
        return adminID;     
    }
    
    
    public static void assignSalesRep(List<Opportunity> opportunities){
        
        Map<String,List<Opportunity>> oppByZipMap =  RoundRobin.oppByZip(opportunities); // <ZipCode Name, List<Opp with that Zip>> 
                
        List<Zip_City_County__c> zipCityCountyList = [Select id, County__c, State__c, City__c, Name from Zip_City_County__c where Name IN: oppByZipMap.keyset() ];
        

        
            Map<String,List<String>> zipByStateMap = new Map<String,List<String>>();   // <State ID, List<Zip Codes Name>>
            Map<ID, List<String>> countyByStateMap = new Map<ID, List<String>>(); //<State ID, List<County Name>>
            Map<ID, List<String>> cityByStateMap = new Map<ID, List<String>>(); //<State ID, List<City Name>>
            Map<String,List<String>> zipByCountyMap = new Map<String,List<String>>();   // <County Name, List<Zip Codes Name>>
            Map<String,List<String>> zipByCityMap = new Map<String,List<String>>();   // <City Name, List<Zip Codes Name>>
            
            for(Zip_City_County__c zcc: zipCityCountyList){
                List<String> auxList = new List<String>();
                
                if(zipByStateMap.containsKey(zcc.State__c)){
                    
                    auxList = zipByStateMap.get(zcc.State__c);
                    auxList.add(zcc.Name);
                    zipByStateMap.put(zcc.State__c,auxList );
                    
                    auxList = new List<String>();
                    auxList = countyByStateMap.get(zcc.State__c);
                    auxList.add(zcc.County__c);
                    countyByStateMap.put(zcc.State__c,auxList);
    
                    auxList = new List<String>();
                    auxList = cityByStateMap.get(zcc.State__c);
                    auxList.add(zcc.City__c);
                    cityByStateMap.put(zcc.State__c,auxList);           
                        
                }else{
                    auxList.add(zcc.Name);
                    zipByStateMap.put(zcc.State__c,auxList );
                    
                    auxList = new List<String>();
                    auxList.add(zcc.County__c);
                    countyByStateMap.put(zcc.State__c,auxList);
                    
                    auxList = new List<String>();
                    auxList.add(zcc.City__c);
                    cityByStateMap.put(zcc.State__c,auxList);                   
                }
                
                auxList = new List<String>();
                if(zipByCountyMap.containsKey(zcc.County__c)){
                    auxList = zipByCountyMap.get(zcc.County__c);
                    auxList.add(zcc.Name);
                    zipByCountyMap.put(zcc.County__c,auxList ); 
                }else{
                    auxList.add(zcc.Name);
                    zipByCountyMap.put(zcc.County__c,auxList );
                }
                
                auxList = new List<String>();
                if(zipByCityMap.containsKey(zcc.City__c)){
                    auxList = zipByCityMap.get(zcc.City__c);
                    auxList.add(zcc.Name);
                    zipByCityMap.put(zcc.City__c,auxList ); 
                }else{
                    auxList.add(zcc.Name);
                    zipByCityMap.put(zcc.City__c,auxList );
                }                       
                                
            }
            
            List<Assignment_Rule__c> assignmentRules = [Select id,Assignment_by_Broker__c, Assignment_by_Campaign__c,Assignment_by_City__c,Assignment_by_County__c,Assignment_by_State__c,Assignment_by_Zip_Code__c, State__c ,Lead_Controller__c
                                                            From Assignment_Rule__c 
                                                            Where State__c IN:zipByStateMap.keySet()
                                                            and recordType.DeveloperName =: 'Geographical_Record_Type' ];
                                                            
        if(assignmentRules!=null && assignmentRules.size()>0){                                          
                                                            
            List<User> salesRepList = new List<User>();
    
            Set<String> ruleByState = new Set<String>(); // Set<State>
            Set<String> ruleByCounty = new Set<String>();
            Set<String> ruleByCity = new Set<String>();
            Set<String> ruleByZipCode = new Set<String>();
            
            for(Assignment_Rule__c assigRule: assignmentRules){
                if(assigRule.Assignment_by_State__c){
                    System.debug('STATE ' + assigRule.State__c);
                    ruleByState.add(assigRule.State__c);
                }else if(assigRule.Assignment_by_County__c){
                    ruleByCounty.add(assigRule.State__c);
                }else if(assigRule.Assignment_by_City__c){
                    ruleByCity.add(assigRule.State__c);
                }else if(assigRule.Assignment_by_Zip_Code__c){
                    ruleByZipCode.add(assigRule.State__c);
                }
            }
    
            List<User_by_Zip_City_County__c> listUserBy = [Select id,  User__c,User__r.ContactID , User__r.IND_Only__c , User__r.Sales_Manager__r.contactID ,User__r.IND__c,User__r.Language__c, User__r.Name,User__r.id, User__r.Opp_Assigned__c, Zip_Code__r.Name, Zip_Code__r.City__c,Zip_Code__r.County__c, Zip_Code__r.State__c   
                                                            from User_by_Zip_City_County__c 
                                                            where Broker__c=:false 
                                                                and Zip_Code__r.Name IN: oppByZipMap.keyset() 
                                                                and User__r.isActive =: true 
                                                                and User__r.Out_of_office__c=: false 
                                                            order by Zip_Code__r.Name, User__r.Opp_Assigned__c ASC ];
                                                                                                                
            if(ruleByState.size()>0){
                Map<String, List<User_by_Zip_City_County__c>>  salesRepMapByState = RoundRobin.getSalesRepsbyState(listUserBy); // <State id, List of Users by State >
                
                if(salesRepMapByState.size()>0){
                    Map<String,List<Opportunity>> oppByStateMap = new Map<String,List<Opportunity>>(); // <State Name, list opp>
                    for(String state: ruleByState){
                        List<String> zipList = zipByStateMap.get(state); //List of Zip Codes by state
                        if(zipList.size()>0){
                            List<Opportunity> oppByState = new List<Opportunity>(); // List of Opp by state
                            for(String zipCode: zipList){
                                oppByState.addAll(oppByZipMap.get(zipCode)); //Get the opp related with the zip code
                            }
                            oppByStateMap.put(state, oppByState);
                        }
                    }       
                    RoundRobin.assignUsers(oppByStateMap,salesRepMapByState,'ST',ruleByState,assignmentRules,zipByStateMap); // Assign users as owners
                }else{
                    system.debug( '### callling method setLeadController from assignSalesRep by State'); 
                    RoundRobin.setLeadController(ruleByState,assignmentRules,zipByStateMap,oppByZipMap);    //There are not users for that location, assign the leadController
                        
                }                   
            }
            
            if(ruleByCounty.size()>0){
                Map<String, List<User_by_Zip_City_County__c>>  salesRepMapByCounty = RoundRobin.getSalesRepsbyCounty(listUserBy); // <CountyName, List of Users by County >
                if(salesRepMapByCounty.size()>0){
                    Map<String,List<Opportunity>> oppByCountyMap = RoundRobin.getOpportunities(ruleByCounty,countyByStateMap,zipByCountyMap,oppByZipMap ); // <County Name, List opp by county>
                    RoundRobin.assignUsers(oppByCountyMap,salesRepMapByCounty ,'CO',ruleByCounty,assignmentRules,zipByStateMap ); // Assign users as owners
                }else{
                    system.debug( '### callling method setLeadController from assignSalesRep by County'); 
                    RoundRobin.setLeadController(ruleByCounty,assignmentRules,zipByStateMap,oppByZipMap); //There are not users for that location, assign the leadController
                }
            }
            
            if(ruleByCity.size()>0){
                Map<String, List<User_by_Zip_City_County__c>>  salesRepMapByCity = RoundRobin.getSalesRepsbyCity(listUserBy); // <CityName, List of Users by City >
                if(salesRepMapByCity.size()>0){
                    Map<String,List<Opportunity>> oppByCityMap = RoundRobin.getOpportunities(ruleByCity,cityByStateMap,zipByCityMap,oppByZipMap ); // <County Name, List opp by county>
                    RoundRobin.assignUsers(oppByCityMap,salesRepMapByCity , 'CI',ruleByCity,assignmentRules,zipByStateMap ); // Assign users as owners
                }else{
                    system.debug( '### callling method setLeadController from assignSalesRep by City'); 
                    RoundRobin.setLeadController(ruleByCity,assignmentRules,zipByStateMap,oppByZipMap); //There are not users for that location, assign the leadController
                }
            }
            
            if(ruleByZipCode.size()>0){
                Map<String, List<User_by_Zip_City_County__c>>  salesRepMapByZip= RoundRobin.getSalesRepsbyZip(listUserBy); // <CityName, List of Users by City >
                if(salesRepMapByZip.size()>0){
                    RoundRobin.assignUsers(oppByZipMap,salesRepMapByZip, 'ZC' ,ruleByZipCode,assignmentRules,zipByStateMap ); // Assign users as owners
                }else{
                    system.debug( '### callling method setLeadController from assignSalesRep by Zipcode'); 
                    RoundRobin.setLeadController(ruleByZipCode,assignmentRules,zipByStateMap,oppByZipMap);  //There are not users for that location, assign the leadController
                }
            }
        }
        String adminID = RoundRobin.getAnthemAdmin();           
        
        for(Opportunity opp:opportunities ){
            system.debug('opp.Assignment_by__c ' + opp.Assignment_by__c);
            if(opp.Assignment_by__c==null || opp.Assignment_by__c==''){
                system.debug('adminID ' + adminID);
                opp.OwnerID = adminID;
                opp.OwnerID__c = adminID;
            }
        }
    }
    
    
    //Return a list of <County or City, and a list of opp related with each one>
    private static Map<String,List<Opportunity>> getOpportunities (Set<String> ruleByCounty , Map<ID, List<String>> countyByStateMap ,Map<String,List<String>> zipByCountyMap ,Map<String,List<Opportunity>> oppByZipMap ){
        
        Map<String,List<Opportunity>> oppByCountyMap = new Map<String,List<Opportunity>>(); // <County Name, List opp by county>

        for(String state: ruleByCounty){ //Iterate by the states
            List<String> counties = countyByStateMap.get(State); // <County Name>
            for(String county: counties){ //Iterate by the conties into the state
                List<String> zipList = zipByCountyMap.get(county); //List of Zip Codes by county
                if(zipList.size()>0){
                    List<Opportunity> oppByCounty = new List<Opportunity>(); // List of Opp by county
                    for(String zipCode: zipList){ //Iterate by zip codes into the county
                        oppByCounty.addAll(oppByZipMap.get(zipCode)); //Get the opp related with the zip code
                    }
                    oppByCountyMap.put(county, oppByCounty); // <CountyName, opp by County>
                }
            }
        }
            
        return oppByCountyMap;

    } 
    
    private static void assignUsers(Map<String,List<Opportunity>> oppMapByLocation, Map<String, List<User_by_Zip_City_County__c>>  salesRepMap, String assignmentBy ,Set<String> locationList, List<Assignment_Rule__c> assignmentRules,Map<String,List<String>> zipByStateMap ){
        
        Map <Id, Decimal> usersToUpdate = new Map <Id, Decimal> ();
        for (String location : oppMapByLocation.keySet()){ //Iterate over the States / Counties / Cities
            List<User_by_Zip_City_County__c> auxUserList= new List<User_by_Zip_City_County__c>();
            auxUserList = salesRepMap.get(location);
            if(auxUserList!=null && auxUserList.size()>0){
                List<Opportunity> auxOppList = oppMapByLocation.get(location);
                usersToUpdate.putAll(RoundRobin.roundRobinBetweenUser(auxUserList,auxOppList,assignmentBy )); //Asign the SalesRep User, and add one to the number of opp that user has.
            }else{
                //zipcode = location
                // opp = oppMapByLocation.get(location);
                system.debug('## Calling method setLeadController from assignUsers : ');
                List<Opportunity> auxOppList = oppMapByLocation.get(location);
                RoundRobin.setLeadControllerOnUserAssigment(locationList, assignmentRules,zipByStateMap, auxOppList , location);
            }
        }

        if(usersToUpdate.size()>0){
            List<User> uToUpdate =RoundRobin.getUsers(usersToUpdate); 
            update uToUpdate;
        }       
    }
        
    public static List<User> getUsers(Map <Id, Decimal> usersToInsert){
        
        List<User> uToUpdate = new List<User>();
        For(ID i: usersToInsert.keyset()){
            User u= new User(ID=i);
            u.Opp_Assigned__c = usersToInsert.get(i);
            uToUpdate.add(u);
        }
        return uToUpdate;
                
    }
    
    // <State Name, List Users by state>
    private static Map<String, List<User_by_Zip_City_County__c>>  getSalesRepsbyState (List<User_by_Zip_City_County__c> listUserBy){
        
        Map<String, List<User_by_Zip_City_County__c>>  mapUser = new Map<String, List<User_by_Zip_City_County__c>>();
        Map<String, String> auxUserByCity = new Map<String, String>(); // <UserID, County Name>
        
        for(User_by_Zip_City_County__c userby :listUserBy ){
            List<User_by_Zip_City_County__c> userListAux = new List<User_by_Zip_City_County__c>();
            Boolean insertUser = true;
            
            if(mapUser.containsKey(userby.Zip_Code__r.State__c)){
                if(auxUserByCity.get( userby.User__r.id )!=null && auxUserByCity.get( userby.User__r.id )==userby.Zip_Code__r.State__c ){
                    insertUser = false;
                }
                if(insertUser){
                    auxUserByCity.put(userby.User__r.id,userby.Zip_Code__r.State__c);
                    userListAux = mapUser.get(userby.Zip_Code__r.State__c);
                    userListAux.add(userby);
                    mapUser.put(userby.Zip_Code__r.State__c,userListAux );  
                }
            }else{
                auxUserByCity.put(userby.User__r.id,userby.Zip_Code__r.State__c);
                userListAux.add(userby);
                mapUser.put(userby.Zip_Code__r.State__c,userListAux );
            }           
        }
        return mapUser;
    }
    

    // <County Name, List Users by County>
    private static Map<String, List<User_by_Zip_City_County__c>>  getSalesRepsbyCounty (List<User_by_Zip_City_County__c> listUserBy){
        
        Map<String, List<User_by_Zip_City_County__c>>  mapUser = new Map<String, List<User_by_Zip_City_County__c>>();
        Map<String, String> auxUserByCity = new Map<String, String>(); // <UserID, County Name>
        
        for(User_by_Zip_City_County__c userby :listUserBy ){
            List<User_by_Zip_City_County__c> userListAux = new List<User_by_Zip_City_County__c>();
            Boolean insertUser = true;
            if(mapUser.containsKey(userby.Zip_Code__r.County__c)){
                if(auxUserByCity.get( userby.User__r.id )!=null && auxUserByCity.get( userby.User__r.id )==userby.Zip_Code__r.County__c ){
                    insertUser = false;
                }
                if(insertUser){
                    auxUserByCity.put(userby.User__r.id,userby.Zip_Code__r.County__c);
                    userListAux = mapUser.get(userby.Zip_Code__r.County__c);
                    userListAux.add(userby);
                    mapUser.put(userby.Zip_Code__r.County__c,userListAux ); 
                }
            }else{
                auxUserByCity.put(userby.User__r.id,userby.Zip_Code__r.County__c);
                userListAux.add(userby);
                mapUser.put(userby.Zip_Code__r.County__c,userListAux );
            }           
        }
        return mapUser;
    }
    
    
    // <City Name, List Users by city>
    private static Map<String, List<User_by_Zip_City_County__c>>  getSalesRepsbyCity (List<User_by_Zip_City_County__c> listUserBy){
        
        Map<String, List<User_by_Zip_City_County__c>>  mapUser = new Map<String, List<User_by_Zip_City_County__c>>();
        Map<String, String> auxUserByCity = new Map<String, String>(); // <UserID, City Name>
        
        for(User_by_Zip_City_County__c userby :listUserBy ){
            List<User_by_Zip_City_County__c> userListAux = new List<User_by_Zip_City_County__c>();
            Boolean insertUser = true;
            if(mapUser.containsKey(userby.Zip_Code__r.City__c)){
                if(auxUserByCity.get( userby.User__r.id )!=null && auxUserByCity.get( userby.User__r.id )==userby.Zip_Code__r.City__c ){
                    insertUser = false;
                }
                if(insertUser){
                    auxUserByCity.put(userby.User__r.id,userby.Zip_Code__r.City__c);
                    userListAux = mapUser.get(userby.Zip_Code__r.City__c);
                    userListAux.add(userby);
                    mapUser.put(userby.Zip_Code__r.City__c,userListAux );   
                }
            }else{
                auxUserByCity.put(userby.User__r.id,userby.Zip_Code__r.City__c);
                userListAux.add(userby);
                mapUser.put(userby.Zip_Code__r.City__c,userListAux );
            }           
        }
        return mapUser;
    }
    
    // <ZipCode Name, List Users by ZipCode>
    private static Map<String, List<User_by_Zip_City_County__c>>  getSalesRepsbyZip (List<User_by_Zip_City_County__c> listUserBy){
        
        Map<String, List<User_by_Zip_City_County__c>>  mapUser = new Map<String, List<User_by_Zip_City_County__c>>();
        Map<String, String> auxUserByCity = new Map<String, String>(); // <UserID, ZipCode Name>
        
        for(User_by_Zip_City_County__c userby :listUserBy ){
            List<User_by_Zip_City_County__c> userListAux = new List<User_by_Zip_City_County__c>();
            Boolean insertUser = true;
            if(mapUser.containsKey(userby.Zip_Code__r.Name)){
                if(auxUserByCity.get( userby.User__r.id )!=null && auxUserByCity.get( userby.User__r.id )==userby.Zip_Code__r.Name ){
                    insertUser = false;
                }
                if(insertUser){
                    auxUserByCity.put(userby.User__r.id,userby.Zip_Code__r.Name);
                    userListAux = mapUser.get(userby.Zip_Code__r.Name);
                    userListAux.add(userby);
                    mapUser.put(userby.Zip_Code__r.Name,userListAux );  
                }
            }else{
                auxUserByCity.put(userby.User__r.id,userby.Zip_Code__r.Name);
                userListAux.add(userby);
                mapUser.put(userby.Zip_Code__r.Name,userListAux );
            }           
        }
        return mapUser;
    }           


    public static Map<id, Decimal>  roundRobinBetweenUser(List<User_by_Zip_City_County__c> users, List<Opportunity> opportunities ,String assignmentBy){
        
        Integer usersSize =  users.size();
        Integer i = 0;
        Integer INDUser = -2;
        Integer languageUser = -2;

        Map<id, Decimal> usersToUpdate = new Map<id, Decimal>();
        Boolean tracker = false;
        
        for(Opportunity opp: opportunities){
            tracker = false;
            for(Integer j=i; i<users.size() ;j++){
                
                if(j==i && tracker){ // if j==i means that all the Users has been iterated, and none of them qualifies for the assignment
                    Integer index = j; 
                    if(INDUser!=-2){//Check if another user qualifies by IND assignment
                        index = INDUser;
                    }else if(languageUser!=-2){//Check if another user qualifies by Language assignment
                        index = languageUser;
                    }
                    
                    opp.ownerID = users[index].User__c;  //If there are not SalesRep with IND or Language, the owner is going to be the first SR. 
                    opp.OwnerID__c = users[index].User__c;
                    system.debug('##1 setting Assigment by in opp : '+opp );
                    system.debug('##1 assignmentBy : '+assignmentBy );
                    opp.Assignment_by__c = assignmentBy;
                    
                    users[index].User__r.Opp_Assigned__c = users[index].User__r.Opp_Assigned__c+1;
                    usersToUpdate.put(users[index].User__r.id,users[index].User__r.Opp_Assigned__c);
                    if(users[index].User__r.ContactID !=null){
                        opp.Sales_Rep__c = users[index].User__r.ContactID;
                    }
                    if(users[index].User__r.Sales_Manager__r.contactID!=null){
                        opp.Sales_Manager__c = users[index].User__r.Sales_Manager__r.contactID;
                    }
                    
                    INDUser = -2;
                    languageUser = -2;                  
                    break;
                }
                tracker = true; 
                if(    ((users[j].user__r.IND__c==opp.IND__c) || (users[j].user__r.IND__c && !opp.IND__c && !users[j].user__r.IND_Only__c )  ) 
                    && ( opp.Language_Preference__c==null ||  ( opp.Language_Preference__c!=null && users[j].User__r.Language__c.contains(opp.Language_Preference__c)))){        
                    opp.ownerID = users[j].User__c;
                    opp.OwnerID__c = users[j].User__c;
                    system.debug('##2 setting Assigment by in opp : '+opp );
                    system.debug('##2 assignmentBy : '+assignmentBy );
                    opp.Assignment_by__c = assignmentBy;
                    if(users[j].User__r.ContactID !=null){
                        opp.Sales_Rep__c = users[j].User__r.ContactID;
                    }
                    
                    users[j].User__r.Opp_Assigned__c = users[j].User__r.Opp_Assigned__c+1;
                    usersToUpdate.put(users[j].User__r.id,users[j].User__r.Opp_Assigned__c);

                    i=j;
                    if(i<usersSize-1){
                        i++;
                    }else{
                        i=0;
                    }
                    break;
                }else{
                    if(users[j].user__r.IND__c && opp.IND__c && INDUser==-2){ //The IND field has priority. If the language doesnt match, but the IND does, we keep track of that user. 
                        INDUser = j;
                    }else if(opp.Language_Preference__c!=null && users[j].User__r.Language__c.contains(opp.Language_Preference__c) && languageUser==-2){
                        languageUser=j;
                    }
                    if( j==users.size()-1 ){
                        j=-1; 
                    }
                }
            }
        }
        return usersToUpdate;
        
    }
    
    public static void afterInsert(List<Opportunity> opportunities){
        Set<ID> oppIDList =  new Set<ID> ();
        Set<ID> oppOwnerIDSet =  new Set<ID> ();
        for (Opportunity opp : opportunities){
            oppIDList.add(opp.id);
            oppOwnerIDSet.add(opp.OwnerID__c );  
  
        }
        AssignBrokers.getBrokersFutureMethod(oppIDList,oppOwnerIDSet); 

    }    
     
    
  

}