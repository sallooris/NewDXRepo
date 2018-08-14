public class ManageGeographyController {

    public List<SelectOption> statesMultiPickListOptions {set; }

    public String statesMultiPickList{ get; set; }

    private id brokerProfile;
    public Boolean adminProf{ get; set; }
    
    private Map<Id,Set<String>> statesByUser;
    private Map<String,Id> satesIDMap; // <State name, state ID>
    private Map<Id,String> idStatesMap; // <stateId, State Name>
    private Map<id,User> salesRepList;
    public Boolean salesRepSelected{get;set;}
    private List<SelectOption> salesRepOptAll; 
    private List<SelectOption> brokersOptsAll;   
    private Map<id,User> brokersBySR;   

    public List<SelectOption> salesRepOpt{get;set;}    
    public List<SelectOption> statesOpts{get;set;}
    public List<SelectOption> territoriesOpts{get;set;}
    public List<SelectOption> brokersOpts{get;set;}       
       
    public List<String> statesSelected{get;set;}
    public List<String> territoriesSelected{get;set;}
    public Set<String> previousTerritoriesSelected{get;set;}      
    public String brokerSelected{get;set;} 
    public String salesRep {get;set;}    
   
    public ManageGeographyController(){
        this.statesSelected = new List<String>();
        this.territoriesSelected = new List<String>();
        this.previousTerritoriesSelected = new Set<String>();
        
        this.salesRepOpt = new List<SelectOption>();
        this.statesOpts = new List<SelectOption>();
        this.territoriesOpts = new List<SelectOption>();
        this.brokersOpts = new List<SelectOption>();
        this.salesRepOptAll = new List<SelectOption> ();
        this.brokersOptsAll = new List<SelectOption> ();
        this.statesByUser = new Map<id,Set<String>>();
        this.satesIDMap =  new Map<String,id>();
        this.idStatesMap =  new Map<id,String>();
        this.salesRepList = new Map<id,User>();
        this.brokersBySR = new Map<id,User>() ; 
        this.statesMultiPickList = 'ALL';
        
        this.salesRepSelected=true;
    
        User user = [Select id, Profile.Name from User where id = : Userinfo.getUserId()]; 
        
        if(user.Profile.Name==AnthemOppsProfiles.salesAdminProfile.Name){
            this.adminProf = false;
            iniByLeadController();
        }else{
            this.adminProf = true;    
            iniAdmin();
                
        }       
            
    } 
    
    private void iniByLeadController(){
        
        Boolean noSalesRep = false;
        Set<ID> salesRepID =  new Set<ID>();
        this.brokerProfile = AnthemOppsProfiles.brokerProfile.id;
            
        Profile salesRepProfile = AnthemOppsProfiles.salesRepProfile; 

        List<Assignment_Rule__c> assignmentRules = [Select id, State__c, State__r.Name from Assignment_Rule__c where Lead_Controller__c = : Userinfo.getUserId()]; 
        //List<Assignment_Rule__c> assignmentRules = [Select id, State__c from Assignment_Rule__c where Lead_Controller__c = : '005i0000004mp61'];  
        
        if(assignmentRules !=null && assignmentRules.size()>0 && salesRepProfile !=null){
                
            Set<ID> stateID = new Set<ID>();
            for(Assignment_Rule__c ar:assignmentRules  ){
                stateID.add(ar.State__c);
                statesOpts.add(new SelectOption(ar.State__c,ar.State__r.Name));
                satesIDMap.put(ar.State__r.Name,ar.State__c);
                idStatesMap.put(ar.State__c,ar.State__r.Name);
            }
            
            AggregateResult [] salesRepList= [Select  User__r.id id, User__r.Name name, Zip_Code__r.Territory__c territory ,Zip_Code__r.State__r.Name state
                                                    from User_by_Zip_City_County__c 
                                                    where Zip_Code__r.State__c IN:stateID and User__r.ProfileID =:salesRepProfile.id
                                                    group by User__r.id,User__r.Name , Zip_Code__r.Territory__c , Zip_Code__r.State__r.Name, User__r.LastName order by User__r.Name, User__r.LastName ];

            if(salesRepList!=null && salesRepList.size()>0){                                       
                for (AggregateResult ar : salesRepList) {
                    if(!salesRepID.contains((ID)ar.get('id'))){
                        salesRepOpt.add(new SelectOption((String)ar.get('id'),(String)ar.get('Name')));
                        salesRepID.add((ID)ar.get('id'));
                    }
                }
                salesRepOptAll =salesRepOpt ;
            }else{
                noSalesRep= true;
            }                                                   
            if(brokerProfile!=null){
                AggregateResult [] brokersByState= [Select  User__r.id id, User__r.Name name, User__r.Sales_Rep__r.Name srName
                                                        from User_by_Zip_City_County__c 
                                                        where Zip_Code__r.State__c IN:stateID and User__r.ProfileID =:brokerProfile
                                                        group by User__r.id,User__r.Name,User__r.FirstName, User__r.Sales_Rep__r.Name order by  User__r.Sales_Rep__r.Name ASC, User__r.Name DESC ];    
                System.debug('UAC: brokersByState ' + brokersByState );
                if(brokersByState!=null && brokersByState.size()>0){
                   for (AggregateResult ar : brokersByState) {
                        brokersOpts.add(new SelectOption((String)ar.get('id'),((String)ar.get('Name') + ' (' + (String)ar.get('srName') + ')' )));
                        //brokersOpts.sort();
                    }
                }                   
            }
        }else{
            noSalesRep= true;
        }
        
        if(noSalesRep){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'No Sales Rep. to display');
            ApexPages.addMessage(myMsg);        
        }       
        
    }
    

    
    //Show all the SalesReps and Brokers
    private void iniAdmin(){
        
        List<State__c> statesList = [Select id, Name From State__c Order by Name ]; //Init the list of States
        if(statesList!=null && statesList.size()>0  ){
             for(State__c st: statesList ){
                statesOpts.add(new SelectOption(st.id,st.Name));
                satesIDMap.put(st.Name,st.id);
                idStatesMap.put(st.id,st.Name);
            }           
        }       
        

        this.brokerProfile = AnthemOppsProfiles.brokerProfile.id;
    
        Profile salesRepProfile = AnthemOppsProfiles.salesRepProfile;  
        if(salesRepProfile !=null){
            salesRepList= new Map<Id,User>([Select id, Name, User_State__c from User Where ProfileID =:salesRepProfile.id and isactive=:true Order By Name, LastName ]);
            
            if(salesRepList!=null && salesRepList.size()>0){
                for(User u: salesRepList.values()){
                    salesRepOpt.add(new SelectOption(u.id,u.Name));
                    if(u.User_State__c!=null)
                        statesByUser.put(u.id, getStatesID(u.User_State__c) );     //<User id, set<States ID>>               
                }
                salesRepOptAll =salesRepOpt;
            }
        }
         
        if(brokerProfile!=null){
            brokersBySR = new Map<Id,User>([Select id, Name,User_State__c ,Sales_Rep__r.Name from User Where ProfileID =:brokerProfile and isactive=:true Order by Sales_Rep__r.Name ASC, Name DESC  ]);
            System.debug('UAC: brokersBySR ' + brokersBySR );
            if(brokersBySR!=null && brokersBySR.size()>0){
                for(User u: brokersBySR.values() ){
                   brokersOpts.add(new SelectOption(u.id,u.Name + ' (' +u.Sales_Rep__r.Name+')'));
                   //brokersOpts.sort();
                    if(u.User_State__c!=null)
                        statesByUser.put(u.id, getStatesID(u.User_State__c) );                       
                }
            } 
            
            brokersOptsAll = brokersOpts;
        }       
        
    }
    
    //Return set of StateID
    private Set<String>getStatesID(String states){
        Set<String> statesID = new  Set<String>();
        if(satesIDMap!=null && satesIDMap.size()>0){
            
            For(string state : states.split(';',-2)){
                if(satesIDMap.containsKey(state)){
                    statesID.add(satesIDMap.get(state));
                }
            }
        }
        return statesID;
    
    }

    public void salesRepSelectedActions() { 
        this.brokerSelected ='';
        if(this.salesRep!=null && this.SalesRep!=''){ 
            updateSatesAndTerritories(this.SalesRep);
        }          
    }
    
    public void brokerSelectedActions() { 
        this.salesRep='';
        if(this.brokerSelected !=null && this.brokerSelected !=''){ 
            updateSatesAndTerritories(this.brokerSelected);
        }          
    }    
    
    
    private void updateSatesAndTerritories( ID userID){
        this.salesRepSelected=false;
        this.statesSelected = new List<String>();
        this.territoriesSelected = new List<String>(); 
        this.previousTerritoriesSelected = new Set<String>();
        this.territoriesOpts = new List<SelectOption>(); 
        
        AggregateResult [] territoryByState = [Select  Zip_Code__r.Territory__c territory ,Zip_Code__r.State__c state
                                                from User_by_Zip_City_County__c 
                                                where User__c =: userID or State__c IN: statesSelected
                                                group by Zip_Code__r.Territory__c, Zip_Code__r.State__c Order By Zip_Code__r.Territory__c ];

        
        Set<String> statesID =  new Set<String>();
        Set<String> territoriesName=  new Set<String>();
        for (AggregateResult ar : territoryByState ) {
            statesID.add((String)ar.get('state'));
            if((String)ar.get('territory')!=null && (String)ar.get('territory')!='')
                territoriesName.add((String)ar.get('territory'));
        }
        
        statesSelected = new List<String>();
        if(statesID.size()>0 || statesSelected!=null ) {
            statesSelected.addAll(statesID);
            if(statesByUser!=null && statesByUser.containsKey(userID))
                statesSelected.addAll(statesByUser.get(userID));   //statesByUser.get(userID) returns= Set stateID
            statesSelectedActions();
                      
        }else{
            statesSelected.addAll(statesByUser.get(userID)); 
        }
        System.debug('UAC: territoriesName ' + territoriesName );
        if(territoriesName.size()>0){
            territoriesSelected.addAll(territoriesName);
            previousTerritoriesSelected.addAll(territoriesSelected);
        }          
   
    }

    public void statesSelectedActions() {
        //this.territoriesSelected = new List<String>();
        this.territoriesOpts = new List<SelectOption>();

        if(statesSelected!=null && statesSelected.size()>0){
        
            AggregateResult [] territoryByState = [Select  Territory__c 
                                                    from Zip_City_County__c 
                                                    where State__c IN: statesSelected
                                                    group by Territory__c Order by Territory__c DESC ];
            System.debug('UAC: territoryByState ' + territoryByState );                               
             for (AggregateResult ar : territoryByState)  { //Init the territories
                 if((String)ar.get('Territory__c')!=null)
                     territoriesOpts.add(new SelectOption((String)ar.get('Territory__c'), (String)ar.get('Territory__c')));
                 	 territoriesOpts.sort();
             }                                             
        }else{
            this.territoriesOpts = new List<SelectOption>();
            this.territoriesSelected = new List<String>();
        }
    }
    
    
    public void cancel() {
        this.statesSelected = new List<String>();
        this.territoriesSelected = new List<String>(); 
        this.previousTerritoriesSelected = new Set<String>();
        this.territoriesOpts = new List<SelectOption>();  
        this.brokerSelected = '';
        this.salesRep = '';
   
    }


    public void save() {
    
        if( (salesRep!=null && salesRep!='') || (brokerSelected!=null && brokerSelected!='')){
            String userToUse;
            Boolean isBroker =false;
    
            if(this.salesRep!=null && this.SalesRep!=''){
                 userToUse = salesRep; 
            }else {
                userToUse = brokerSelected;
                isBroker=true;
            }
            User userToUpdate = new User(id=userToUse);
                
            if(statesSelected!=null){
                if(statesSelected.size()>0){
                    String newStates = '';
                    for(String state :statesSelected){
                        if(idStatesMap.containsKey(state))
                            newStates  = newStates==''?idStatesMap.get(state)+';' : newStates +idStatesMap.get(state)+';';
                    }
                    userToUpdate.User_State__c=newStates; 
                }else{
                    userToUpdate.User_State__c='';    
                }
                
            }
        
            ApexPages.Message myMsg;    
            if((territoriesSelected!=null &&  previousTerritoriesSelected!=null ) && (territoriesSelected.size()>0 || previousTerritoriesSelected.size()>0)&& statesSelected.size()>0){
     
                List<String> territoriesIds =new  List<String>();    
            
                for(String territory: this.territoriesSelected){
                    if(this.previousTerritoriesSelected!=null && this.previousTerritoriesSelected.contains(territory)){ //The territory is not new, and it was not removed.
                        this.previousTerritoriesSelected.remove(territory);
                    }else{ // The territory has just been selected
                        territoriesIds.add(territory);
                    }
                }
                try{
    
                    
                    if(this.previousTerritoriesSelected!=null && this.previousTerritoriesSelected.size()>0){ //It means that there are territories that were unassigned.
                        Delete [Select id from User_by_Zip_City_County__c where User__c =: userToUse and Zip_Code__c IN (Select id from Zip_City_County__c Where Territory__c IN: previousTerritoriesSelected) ];
                    }
    
                        
                    List<User_by_Zip_City_County__c> userByZip = new List<User_by_Zip_City_County__c> ();
                    for(Zip_City_County__c zcc: [Select id from Zip_City_County__c Where Territory__c IN: territoriesIds]){
                        userByZip.add(new User_by_Zip_City_County__c(Zip_Code__c=zcc.id, User__c = userToUse, Broker__c=isBroker ) );
                    }
                    if(userByZip.size()>0)
                        insert userByZip;
                        
                    myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Changes have been saved');
                    ApexPages.addMessage(myMsg);  
                        
                    previousTerritoriesSelected = new  Set<String> ();
                    previousTerritoriesSelected.addAll(territoriesSelected); 
                    
                    update userToUpdate; 
                    statesByUser.put(userToUpdate.id,new Set<String>(statesSelected));                          
                }catch(exception e){
                    myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage());
                    ApexPages.addMessage(myMsg);
                }    
            }else{
                if(userToUpdate.User_State__c!=''){
                    update userToUpdate; 
                    statesByUser.put(userToUpdate.id,new Set<String>(statesSelected)); 
                    
                    if(!isBroker){
                        User temporaryUser =  salesRepList.get(userToUpdate.id);
                        temporaryUser.User_State__c = userToUpdate.User_State__c;   
                        salesRepList.put(temporaryUser.id, temporaryUser );
                    }else{
                        User temporaryUser =  brokersBySR.get(userToUpdate.id);
                        temporaryUser.User_State__c = userToUpdate.User_State__c;   
                        salesRepList.put(temporaryUser.id, temporaryUser );                    
                    } 
                    
                    myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Changes have been saved');
                    ApexPages.addMessage(myMsg); 
                
                }else{
                   myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'The user must have a state');
                   ApexPages.addMessage(myMsg); 
                }       
            }
        }

    } 

    public List<SelectOption> getstatesMultiPickListOptions(){
        List<SelectOption>  states = new List<SelectOption>();
        states.add(new SelectOption('ALL','Display All'));
        
        for(State__c st: [Select Name from State__c Order by Name]){
            states.add(new SelectOption(st.Name,st.Name));
        }
        
    
        return states;
    }
    
    public void filterSR() {
    
        if(statesMultiPickList!='ALL' ){
            salesRepOpt = new List<SelectOption>();
            
            if(salesRepList!=null && salesRepList.size()>0){
                for(User u: salesRepList.values()){
                    if(u.User_State__c.contains(statesMultiPickList))
                        salesRepOpt.add(new SelectOption(u.id,u.Name));
                }
            }
            brokersOpts = new List<SelectOption>();
            if(brokersBySR!=null && brokersBySR.size()>0){
                for(User u: brokersBySR.values() ){
                    if(u.User_State__c.contains(statesMultiPickList))
                        brokersOpts.add(new SelectOption(u.id,u.Name + ' (' +u.Sales_Rep__r.Name+')'));                      
                }
            }            
            
              
        }else{
            salesRepOpt=salesRepOptAll;
            brokersOpts = brokersOptsAll; 
        }
        cancel();
            
    }    
            
    
}