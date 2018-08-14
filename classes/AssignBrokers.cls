public without sharing class AssignBrokers {
    
    private static boolean insertOpp =  true;
    
    @future
    public static void getBrokersFutureMethod (Set<ID> oppID, Set<ID> oppOwnerID){
        
        List<Opportunity> opportunities = [Select id,  OwnerID,OwnerID__c, Site_ZIP__c, Secondary_Disposition_new__c,Users_who_declined__c, Assignment_by__c,Language_Preference__c,IND__c ,StageName from Opportunity where Id in: oppID];
        System.debug('**** future method opps' + opportunities  );

        for( Opportunity opp : opportunities )
        {
            if( opp.OwnerID__c != null )
            {
               opp.OwnerID = opp.OwnerID__c;
            }
        }

        update opportunities;
        
        AssignBrokers.getBrokers(opportunities,oppOwnerID, null);       
    }
    

    public static void getBrokers(List<Opportunity> opportunities, Set<ID> oppOwnerID, Set<ID> oppBrokOwnerID){
         if(oppBrokOwnerID!=null){ // Insert or update
            AssignBrokers.insertOpp = false; // it  an update
         }  
        
        Set<String> zipCodeSet= new Set<String>();
        
        Map<ID,List<Opportunity>> oppMap = new Map<ID,List<Opportunity>> (); // <SalesRepID(Owner ID), List Opp>
        Map<String, Set<ID>> salesRepByAssingType =new  Map<String, Set<ID>>(); //<Type of update, list SalesRepID> 
        List<String> brokersDeclinedAlready =  new  List<String>();
        
        for(Opportunity opp: opportunities){
            String l_ownerID = opp.OwnerID;
            
            if(oppBrokOwnerID==null){ // Insert or update
                l_ownerID  = opp.OwnerID__c; // it  an insert
            }
            
            
            if(opp.Users_who_declined__c!=null){
                brokersDeclinedAlready.addAll(opp.Users_who_declined__c.split(' ',-2)); //Users_who_declined__c is a field that keep track of all the owners id that have declined an opp already.
            }       
            zipCodeSet.add(opp.Site_ZIP__c);
            List<Opportunity> auxList = new List<Opportunity>();
            Set<ID> auxIdSet = new Set<ID>();
            
            if(oppMap.containsKey(l_ownerID  )){
                auxList = oppMap.get(l_ownerID  );
                auxList.add(opp);
                oppMap.put(l_ownerID  , auxList);               
            }else{
                auxList.add(opp);
                oppMap.put(l_ownerID  , auxList);
            }
            
            if(salesRepByAssingType.containsKey(opp.Assignment_by__c)){
                auxIdSet = salesRepByAssingType.get(opp.Assignment_by__c);
                auxIdSet.add(l_ownerID  );
                salesRepByAssingType.put(opp.Assignment_by__c, auxIdSet);               
            }else{
                auxIdSet.add(l_ownerID  );
                salesRepByAssingType.put(opp.Assignment_by__c, auxIdSet);
            }
            
            
        }
        
        List<Zip_City_County__c> zipCityCounty = [Select id,Name, City__c, County__c, State__r.Name from Zip_City_County__c where Name in:zipCodeSet]; 

        Map<String, Zip_City_County__c> mapZipCityCounty = new Map<String, Zip_City_County__c>(); // <ZipCode, Zip_City_County__c>
        
        for (Zip_City_County__c zcc: zipCityCounty){
            mapZipCityCounty.put(zcc.Name, zcc);
        }
        
        for(String s:salesRepByAssingType.keyset() ){ //This is going to iterate a max of 4 times.
            
            if(s=='ST'){            
                AggregateResult [] brokersByState = [Select  User__c,  Zip_Code__r.State__c ST, User__r.Sales_Rep__c owner 
                                                from User_by_Zip_City_County__c 
                                                where Broker__c=:true 
                                                    and User__r.isActive =: true 
                                                    and User__r.Out_of_office__c=: false 
                                                    and User__r.Deactivate_Broker__c =:false
                                                    and User__r.Sales_Rep__c in: salesRepByAssingType.get('ST') 
                                                    and User__c NOT IN: oppBrokOwnerID
                                                    and User__c NOT IN: brokersDeclinedAlready
                                                group by User__c, Zip_Code__r.State__c ,User__r.Sales_Rep__c]; 
                                                 
                System.debug('**** brokersByState' + brokersByState);
                
                AssignBrokers.setBrokerAsOwner('ST', brokersByState,salesRepByAssingType,mapZipCityCounty,oppMap);          
            }else if(s=='CI'){
                AggregateResult [] brokersByCity = [Select  User__c,  Zip_Code__r.City__c CI, User__r.Sales_Rep__c owner
                                                from User_by_Zip_City_County__c 
                                                where Broker__c=:true 
                                                    and User__r.isActive =: true 
                                                    and User__r.Out_of_office__c=: false 
                                                    and User__r.Deactivate_Broker__c =:false
                                                    and User__r.Sales_Rep__c in: salesRepByAssingType.get('CI') 
                                                    and User__c NOT IN: oppBrokOwnerID
                                                    and User__c NOT IN: brokersDeclinedAlready
                                                group by User__c, Zip_Code__r.City__c ,User__r.Sales_Rep__c];
                
                System.debug('**** brokersByCity ' + brokersByCity );
                                                                    
                AssignBrokers.setBrokerAsOwner('CI', brokersByCity,salesRepByAssingType,mapZipCityCounty,oppMap);               
            }else if(s=='CO'){
                AggregateResult [] brokersByCounty= [Select  User__c,  Zip_Code__r.County__c CO, User__r.Sales_Rep__c owner
                                                from User_by_Zip_City_County__c 
                                                where Broker__c=:true 
                                                    and User__r.isActive =: true 
                                                    and User__r.Out_of_office__c=: false 
                                                    and User__r.Deactivate_Broker__c =:false
                                                    and User__r.Sales_Rep__c in: salesRepByAssingType.get('CO') 
                                                    and User__c NOT IN: oppBrokOwnerID
                                                    and User__c NOT IN: brokersDeclinedAlready
                                                group by User__c, Zip_Code__r.County__c ,User__r.Sales_Rep__c];                 
                
                System.debug('**** brokersByCounty' + brokersByCounty);
                
                AssignBrokers.setBrokerAsOwner('CO', brokersByCounty,salesRepByAssingType,mapZipCityCounty,oppMap);         
            }else if(s=='ZC'){
                AggregateResult [] brokersByZipCode= [Select  User__c,  Zip_Code__r.Name ZC, User__r.Sales_Rep__c owner
                                                        from User_by_Zip_City_County__c 
                                                        where Broker__c=:true 
                                                            and User__r.isActive =: true 
                                                            and User__r.Out_of_office__c=: false 
                                                            and User__r.Deactivate_Broker__c =:false
                                                            and User__r.Sales_Rep__c in: salesRepByAssingType.get('ZC') 
                                                            and User__c NOT IN: oppBrokOwnerID
                                                            and User__c NOT IN: brokersDeclinedAlready
                                                            and Zip_Code__r.Name in:zipCodeSet
                                                        group by User__c, Zip_Code__r.Name ,User__r.Sales_Rep__c];  
                                                        
                                                        system.debug('zzzip ' + brokersByZipCode);              
                
                System.debug('**** brokersByZipCode' + brokersByZipCode);
                
                AssignBrokers.setBrokerAsOwner('ZC', brokersByZipCode,salesRepByAssingType,mapZipCityCounty,oppMap);                
            }   
        }
    }
    
    
    public static void setBrokerAsOwner (String location, AggregateResult [] brokersAggregateResult, Map<String, Set<ID>> salesRepByAssingType ,Map<String, Zip_City_County__c> mapZipCityCounty ,Map<ID,List<Opportunity>> oppMap  ){
        system.debug('brokersAggregateResult '+ brokersAggregateResult );
        if(brokersAggregateResult!=null && brokersAggregateResult.size()>0){
                
            List<Broker> brokerByLocation = new  List<Broker>();
            Set<ID> brokerIDs =  new Set<ID> ();     
            for (AggregateResult ar : brokersAggregateResult)  {
                
                Broker brok = new Broker();
                brok.brokerID =(ID) ar.get('User__c');
                brok.salesRepID =(ID)ar.get('owner');
                brokerIDs.add(brok.brokerID);
                if(location=='ST'){
                    brok.state =(ID)ar.get('ST');
                }else if(location=='CI'){
                    brok.city =(String)ar.get('CI');
                }else if(location=='CO'){
                    brok.county =(String)ar.get('CO');
                }else if(location=='ZC'){
                    brok.zipCode =(String)ar.get('ZC');
                } 
                    
                brokerByLocation.add(brok);
                
            }
                
            Map<id,User> brokerUserList = new Map<id,User> ([Select id,Opp_Assigned__c,Sales_Rep__c,contactID, Language__c,IND__c,IND_Only__c,Sales_Rep__r.contactID, Sales_Rep__r.Sales_Manager__r.contactID, Back_up__c  from User Where ID IN: brokerIDs order by Opp_Assigned__c ]);
            
            List<Broker> brokerList = new List<Broker>(); 
            for(Broker b:brokerByLocation ){
                b.oppAssigned = brokerUserList.get(b.brokerID).Opp_Assigned__c;
                b.contactID = brokerUserList.get(b.brokerID).contactID;
                b.salesRepContID = brokerUserList.get(b.brokerID).Sales_Rep__r.contactID;
                b.salesMagContID = brokerUserList.get(b.brokerID).Sales_Rep__r.Sales_Manager__r.contactID;
                b.IND = brokerUserList.get(b.brokerID).IND__c;
                b.INDOnly = brokerUserList.get(b.brokerID).IND_Only__c;
                b.backup = brokerUserList.get(b.brokerID).Back_up__c;

                if(brokerUserList.get(b.brokerID).Language__c.contains('Spanish')){
                    b.spanish = true;
                }else{
                    b.spanish = false;
                }
                brokerList.add(b); 
            }
            
            system.debug('brokerByLocation ' + brokerByLocation );
            
            brokerList = AssignBrokers.sortBrokers(brokerList);
    
            Map<ID, List<Broker>> brokersMap = new Map<ID, List<Broker>>(); //<SalesRepID, list Brokers>
                    
            if(location=='ST'){
                brokersMap = AssignBrokers.getBrokersbyState(brokerList);
            }else if(location=='CI'){
                brokersMap = AssignBrokers.getBrokersbyCity(brokerList);
            }else if(location=='CO'){
                brokersMap = AssignBrokers.getBrokersbyCounty(brokerList);
            }else if(location=='ZC'){
                brokersMap = AssignBrokers.getBrokersbyZipCode(brokerList);
            }
    
            for(ID salesRepID:salesRepByAssingType.get(location) ){
                if(brokersMap!=null &&  brokersMap.containsKey(salesRepID)){
                    roundRobin(brokersMap.get(salesRepID), oppMap.get(salesRepID),mapZipCityCounty);
                }   
            }       
        }
    }     
    
    
    // <SalesRepID, brokers grouped by city>
    private static Map<ID, List<Broker>>  getBrokersbyCity (List<Broker> BrokersList){
        
        Map<ID, List<Broker>>  brokerBySaleRepMap = new Map<ID, List<Broker>>();  //<SalesRepID, list Brokers>
        Map<String, String> auxBrokerByLocation = new Map<String, String>(); // <brokerID, City Name>
        
        for(Broker broker :BrokersList ){
            List<Broker> brokerListAux = new List<Broker>();
            Boolean insertBroker = true;
            
            if(brokerBySaleRepMap.containsKey(broker.salesRepID)){
                if(auxBrokerByLocation.get( broker.BrokerID )!=null && auxBrokerByLocation.get( broker.BrokerID )==broker.city ){
                    insertBroker = false;
                }
                if(insertBroker){
                    auxBrokerByLocation.put(broker.BrokerID, broker.city);
                    brokerListAux = brokerBySaleRepMap.get(broker.salesRepID);
                    brokerListAux.add(broker);
                    brokerBySaleRepMap.put(broker.salesRepID,brokerListAux );   
                }
            }else{
                auxBrokerByLocation.put(broker.BrokerID,broker.city);
                brokerListAux.add(broker);
                brokerBySaleRepMap.put(broker.salesRepID,brokerListAux );
            }           
        }
        return brokerBySaleRepMap;
    }
    
    
    // <SalesRepID, brokers grouped by County>
    private static Map<ID, List<Broker>>  getBrokersbyCounty (List<Broker> BrokersList){

        
        Map<ID, List<Broker>>  brokerBySaleRepMap = new Map<ID, List<Broker>>();  //<SalesRepID, list Brokers>
        Map<String, String> auxBrokerByLocation = new Map<String, String>(); // <brokerID, County Name>
        
        for(Broker broker :BrokersList ){
            List<Broker> brokerListAux = new List<Broker>();
            Boolean insertBroker = true;
            
            if(brokerBySaleRepMap.containsKey(broker.salesRepID)){
                if(auxBrokerByLocation.get( broker.BrokerID )!=null && auxBrokerByLocation.get( broker.BrokerID )==broker.county ){
                    insertBroker = false;
                }
                if(insertBroker){
                    auxBrokerByLocation.put(broker.BrokerID,broker.county);
                    brokerListAux = brokerBySaleRepMap.get(broker.salesRepID);
                    brokerListAux.add(broker);
                    brokerBySaleRepMap.put(broker.salesRepID,brokerListAux );   
                }
            }else{
                auxBrokerByLocation.put(broker.BrokerID,broker.county);
                brokerListAux.add(broker);
                brokerBySaleRepMap.put(broker.salesRepID,brokerListAux );
            }           
        }
        return brokerBySaleRepMap;
    }   


    // <SalesRepID, brokers grouped by State>
    private static Map<ID, List<Broker>>  getBrokersbyState (List<Broker> BrokersList){
        
        Map<ID, List<Broker>>  brokerBySaleRepMap = new Map<ID, List<Broker>>();  //<SalesRepID, list Brokers>
        Map<String, String> auxBrokerByLocation = new Map<String, String>(); // <brokerID, State Name>
        
        for(Broker broker :BrokersList ){
            List<Broker> brokerListAux = new List<Broker>();
            Boolean insertBroker = true;
            
            if(brokerBySaleRepMap.containsKey(broker.salesRepID)){
                if(auxBrokerByLocation.get( broker.BrokerID )!=null && auxBrokerByLocation.get( broker.BrokerID )==broker.State){
                    insertBroker = false;
                }
                if(insertBroker){
                    auxBrokerByLocation.put(broker.BrokerID,broker.State);
                    brokerListAux = brokerBySaleRepMap.get(broker.salesRepID);
                    brokerListAux.add(broker);
                    brokerBySaleRepMap.put(broker.salesRepID,brokerListAux );   
                }
            }else{
                auxBrokerByLocation.put(broker.BrokerID,broker.State);
                brokerListAux.add(broker);
                brokerBySaleRepMap.put(broker.salesRepID,brokerListAux );
            }           
        }
        return brokerBySaleRepMap;
    }   
        


    // <SalesRepID, brokers grouped by ZipCode>
    private static Map<ID, List<Broker>>  getBrokersbyZipCode(List<Broker> BrokersList){
        
        Map<ID, List<Broker>>  brokerBySaleRepMap = new Map<ID, List<Broker>>();  //<SalesRepID, list Brokers>
        Map<String, String> auxBrokerByLocation = new Map<String, String>(); // <brokerID, ZipCode Name>
        
        for(Broker broker :BrokersList ){
            List<Broker> brokerListAux = new List<Broker>();
            Boolean insertBroker = true;
            
            if(brokerBySaleRepMap.containsKey(broker.salesRepID)){
                if(auxBrokerByLocation.get( broker.BrokerID )!=null && auxBrokerByLocation.get( broker.BrokerID )==broker.zipCode ){
                    insertBroker = false;
                }
                if(insertBroker){
                    auxBrokerByLocation.put(broker.BrokerID,broker.zipCode);
                    brokerListAux = brokerBySaleRepMap.get(broker.salesRepID);
                    brokerListAux.add(broker);
                    brokerBySaleRepMap.put(broker.salesRepID,brokerListAux );   
                }
            }else{
                auxBrokerByLocation.put(broker.BrokerID,broker.zipCode);
                brokerListAux.add(broker);
                brokerBySaleRepMap.put(broker.salesRepID,brokerListAux );
            }           
        }
        return brokerBySaleRepMap;
    }   



     public static void roundRobin(List<Broker> broks, List<Opportunity> opportunities ,Map<String, Zip_City_County__c> mapZipCityCounty){

        String adminID = OpportunityTriggerHandler.getAnthemLeadAdmin();

        Map<id, Decimal> broksToUpdate = new Map<id, Decimal>();
        Integer broksSize =  broks.size();
        Integer i = 0;
        Boolean tracker = false;
        List<OpportunityTeamMember> oppTeamList = new List<OpportunityTeamMember>();
        for(Opportunity opp: opportunities){
            tracker = false;
            for(Integer j =i ; j < broksSize ;j++){

                if(j==i && tracker){ // I didnt find any broker that could work with the opp, just stop and the SalesRep be the owner. 
                    break;
                }
                tracker = true;

                if(   ((opp.Assignment_by__c=='ZC' && broks[j].zipCode == opp.Site_ZIP__c ) 
                    || (opp.Assignment_by__c=='CI' &&  broks[j].City== mapZipCityCounty.get(opp.Site_ZIP__c).City__c )
                    || (opp.Assignment_by__c=='CO' &&  broks[j].County== mapZipCityCounty.get(opp.Site_ZIP__c).County__c)
                    || (opp.Assignment_by__c=='ST' &&  broks[j].State == mapZipCityCounty.get(opp.Site_ZIP__c).State__c) )
                    && ((opp.Language_Preference__c =='Spanish' &&  broks[j].spanish)
                        || (opp.Language_Preference__c !='Spanish'))    
                    && ((opp.IND__c && broks[j].IND)
                        ||(!opp.IND__c && !broks[j].INDOnly))){

                        opp.ownerID = broks[j].BrokerID;
                        
                        if(broks[j].backup!=null){
                            oppTeamList.add(OpportunityTriggerHandler.createTeamMember(broks[j].backup, opp.id, 'Back-up'));
                        }
                        if(!AssignBrokers.insertOpp){
                            opp.StageName = 'Waiting for Disposition';
                            opp.Secondary_Disposition_new__c = '';
                            opp.Declined__c =  false;
                        }
                        
                        if(broks[j].contactID!=null)
                            opp.Broker__c = broks[j].contactID;
                        if(broks[j].salesRepContID!=null)
                            opp.Sales_Rep__c = broks[j].salesRepContID;
                        if(broks[j].salesMagContID!=null)
                            opp.Sales_Manager__c = broks[j].salesMagContID;                         
                                                    
                        if(broksToUpdate.containsKey(broks[j].BrokerID)){
                            Double numOpp = broksToUpdate.get(broks[j].BrokerID);
                            broksToUpdate.put(broks[j].BrokerID, numOpp+1);
                        }else
                            broksToUpdate.put(broks[j].BrokerID, broks[j].oppAssigned+1);
                        i=j;
                        if(i<broksSize-1){
                            i++; 
                        }else{
                            i=0;
                        }
                        break;                  
                }else{

                    if( j==broksSize-1 ){
                        j=-1; 
                    }
                }
                
            }
        }
        
        if (oppTeamList.size()>0)
            insert oppTeamList;
        
        List<User> uToUpdate =AssignBrokers.getUsers(broksToUpdate);

        update uToUpdate;
        if(AssignBrokers.insertOpp)
            update opportunities;  
    }
    
    //Order the broker by # oppAssigned
    public static List<Broker> sortBrokers(List<Broker> sortingList) {
        
        for (Integer i =0; i < sortingList.size(); i++) {
            for (Integer j = i; j > 0; j--) {
                if (sortingList[j-1].oppAssigned > sortingList[j].oppAssigned){
                    Broker temp = sortingList[j];
                    sortingList[j] = sortingList[j-1];
                    sortingList[j-1] = temp;
                }
            }
        }
        return sortingList;
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

     public class broker{
        public ID brokerID;
        public ID salesRepID;
        public double oppAssigned;
        public ID State;
        public String city;
        public String county;
        public String zipCode;
        public ID contactID;
        public ID salesRepContID;
        public ID salesMagContID;
        public Boolean spanish;
        public Boolean IND;
        public Boolean INDOnly;
        public ID backup;
        
        public broker(){
            oppAssigned=0;
        }
        
    }        
    

}