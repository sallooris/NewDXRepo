public class ManageSalesRepController {

    private id brokerProfile;
    public List<String> brokers{get;set;}
    private Set<String> oldBrokers;
    public List<SelectOption> brokerOpts{get;set;}
    public List<SelectOption> salesRepOpt{get;set;}
    public String salesRep {get;set;}
    public Boolean selectBroker {get;set;}
    public Boolean noBrokers {get;set;}
    private Map<ID,String> userByState; 
    private Map<ID,String> userByTerritory;
    private Set<ID> stateID;
    public Boolean adminProf{ get; set; } 
    private Map<id,User> salesRepMap;  
    private List<SelectOption> salesRepOptAll;          
    private Map<String,Id> satesIDMap; // <State name, state ID>
    private Map<Id,String> idStatesMap; // <stateId, State Name>
    private Map<Id,Set<String>> statesByUser;    
        
    public List<SelectOption> statesMultiPickListOptions {set; }
    public String statesMultiPickList{ get; set; }

    
    public ManageSalesRepController(){
        userByState = new Map<ID,String>() ; 
        userByTerritory=new Map<ID,String> ();
        this.brokers = new List<String>();
        this.salesRepOpt = new List<SelectOption>();
        this.brokerOpts = new List<SelectOption>();
        this.selectBroker =true;
        this.noBrokers = false;
        this.stateID = new Set<ID>();
        this.statesMultiPickList = 'ALL';
        this.salesRepMap = new Map<id,User>();
        this.brokerProfile = AnthemOppsProfiles.brokerProfile.id;    
        this.salesRepOptAll = new List<SelectOption> ();
        this.satesIDMap =  new Map<String,id>();
        this.idStatesMap =  new Map<id,String>(); 
        this.idStatesMap =  new Map<id,String>();
        this.statesByUser = new Map<id,Set<String>>();
                                       
        User user = [Select id, Profile.Name from User where id = : Userinfo.getUserId()]; 
        
        if(user.Profile.Name==AnthemOppsProfiles.salesAdminProfile.Name){
            this.adminProf = false;
            iniByLeadController();
        }else{
            this.adminProf = true;    
            iniAdmin();
                
        } 

    }
    
    public void iniAdmin(){
    
        Boolean noSalesRep = false;    
        Profile salesRepProfile =  AnthemOppsProfiles.salesRepProfile; 
        Set<ID> salesRepID =  new Set<ID>();
        Set<ID> brokersID =  new Set<ID>();
        

        if(salesRepProfile !=null ){
            System.debug('______________salesRepProfile_____'+salesRepProfile);
            AggregateResult [] salesRepList= [Select  User__r.id id, User__r.Name name , Zip_Code__r.Territory__c territory ,Zip_Code__r.State__r.Name state
                                                    from User_by_Zip_City_County__c 
                                                    where  User__r.ProfileID =:salesRepProfile.id
                                                    group by User__r.id,User__r.Name , Zip_Code__r.Territory__c , Zip_Code__r.State__r.Name,User__r.FirstName order by User__r.FirstName];
                                                    
            this.salesRepMap= new Map<Id,User>([Select id, Name, User_State__c from User Where ProfileID =:salesRepProfile.id and isactive=:true]);                                                            

              
            if((salesRepList!=null && salesRepList.size()>0) || (salesRepMap!=null && salesRepMap.size()>0)){                                       
                for (AggregateResult ar : salesRepList) {
                    if(!salesRepID.contains((ID)ar.get('id'))){
                        salesRepOpt.add(new SelectOption((String)ar.get('id'),(String)ar.get('Name')));
                        salesRepID.add((ID)ar.get('id'));
                    }
                    if(userByState.containskey((ID)ar.get('id'))){
                        if(userByState.get((ID)ar.get('id'))!=(String)ar.get('state'))
                            userByState.put((ID)ar.get('id'), userByState.get((ID)ar.get('id')) +', ' + (String)ar.get('state'));
                    }else{
                        userByState.put((ID)ar.get('id'),(String)ar.get('state'));
                    }       
    
                    if(userByTerritory.containskey((ID)ar.get('id'))){
                        if(userByTerritory.get((ID)ar.get('id'))!=(String)ar.get('territory'))
                            userByTerritory.put((ID)ar.get('id'), userByTerritory.get((ID)ar.get('id')) +', ' + (String)ar.get('territory'));
                    }else{
                        userByTerritory.put((ID)ar.get('id'),(String)ar.get('territory'));
                    }
                }
                
                List<State__c> statesList = [Select id, Name From State__c Order by Name ]; //Init the list of States
                if(statesList!=null && statesList.size()>0  ){
                     for(State__c st: statesList ){
                        satesIDMap.put(st.Name,st.id);
                        idStatesMap.put(st.id,st.Name);
                    }           
                }       

                if(this.salesRepMap!=null && this.salesRepMap.size()>0){
                    for(User u: this.salesRepMap.values()){
                        if(u.User_State__c!=null)
                            statesByUser.put(u.id, getStatesID(u.User_State__c) );     //<User id, set<States ID>>  
                        if(!salesRepID.contains(u.id))   
                            salesRepOpt.add(new SelectOption(u.id,u.Name));                                     
                    }
                    salesRepOptAll =salesRepOpt;
                }
            }else{
                noSalesRep= true;
            }                                                   

        }else{
            noSalesRep= true;
        }
        
        if(noSalesRep){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'No Sales Rep. to display');
            ApexPages.addMessage(myMsg);        
        }    
    
    
    }
    

    public void iniByLeadController(){
        
        Boolean noSalesRep = false;    
        Profile salesRepProfile =  AnthemOppsProfiles.salesRepProfile; 
        Set<ID> salesRepID =  new Set<ID>();
        Set<ID> brokersID =  new Set<ID>();
        
        
        List<Assignment_Rule__c> assignmentRules = [Select id, State__c from Assignment_Rule__c where Lead_Controller__c = : Userinfo.getUserId()]; 
        //List<Assignment_Rule__c> assignmentRules = [Select id, State__c from Assignment_Rule__c where Lead_Controller__c = : '005e00000020DGa'];        
         
        if(assignmentRules !=null && assignmentRules.size()>0 && salesRepProfile !=null ){
        
            stateID = new Set<ID>();
            for(Assignment_Rule__c ar:assignmentRules  ){
                stateID.add(ar.State__c);
            }
            
            AggregateResult [] salesRepList= [Select  User__r.id id, User__r.Name name , Zip_Code__r.Territory__c territory ,Zip_Code__r.State__r.Name state
                                                    from User_by_Zip_City_County__c 
                                                    where Zip_Code__r.State__c IN:stateID and User__r.ProfileID =:salesRepProfile.id
                                                    group by User__r.id,User__r.Name , Zip_Code__r.Territory__c , Zip_Code__r.State__r.Name,User__r.FirstName order by User__r.FirstName];

              
            if(salesRepList!=null && salesRepList.size()>0){                                       
                for (AggregateResult ar : salesRepList) {
                    if(!salesRepID.contains((ID)ar.get('id'))){
                        salesRepOpt.add(new SelectOption((String)ar.get('id'),(String)ar.get('Name')));
                        salesRepID.add((ID)ar.get('id'));
                    }
                    if(userByState.containskey((ID)ar.get('id'))){
                        if(userByState.get((ID)ar.get('id'))!=(String)ar.get('state'))
                            userByState.put((ID)ar.get('id'), userByState.get((ID)ar.get('id')) +', ' + (String)ar.get('state'));
                    }else{
                        userByState.put((ID)ar.get('id'),(String)ar.get('state'));
                    }       
    
                    if(userByTerritory.containskey((ID)ar.get('id'))){
                        if(userByTerritory.get((ID)ar.get('id'))!=(String)ar.get('territory'))
                            userByTerritory.put((ID)ar.get('id'), userByTerritory.get((ID)ar.get('id')) +', ' + (String)ar.get('territory'));
                    }else{
                        userByTerritory.put((ID)ar.get('id'),(String)ar.get('territory'));
                    }
                }
            }else{
                noSalesRep= true;
            }                                                   

        }else{
            noSalesRep= true;
        }
        
        if(noSalesRep){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'No Sales Rep. to display');
            ApexPages.addMessage(myMsg);        
        }
        
    }
   
    public PageReference cancel() {
        updateBrokers();
        return null;
    }

    public void save() {
    
        Boolean saved = false;
        List<String> brokerIds =new  List<String>();
        
        for(String brokerID: this.brokers){
            if(this.oldBrokers!=null && this.oldBrokers.contains(brokerID)){
                this.oldBrokers.remove(brokerID);
            }else{
                brokerIds.add(brokerID);
            }
        }
        List<User> unassigBroker;
        if(this.oldBrokers!=null && this.oldBrokers.size()>0){ //It means that there are brokers that were unassigned.
            unassigBroker = [Select id, Sales_Rep__c from User Where id IN:this.oldBrokers ];
            for(User u: unassigBroker ){
                u.Sales_Rep__c =null;
            }
        }
        
        List<User> newAssigBroker;
        if(brokerIds.size()>0){ //Brokers new assigned
            newAssigBroker = [Select id, Sales_Rep__c from User Where id IN:brokerIds];
            for(User u: newAssigBroker ){
                u.Sales_Rep__c =this.salesRep ;
            }         
        }
        
        ApexPages.Message myMsg;
        try{
            
            if(unassigBroker!=null){
                if(newAssigBroker!=null)
                    unassigBroker.addAll(newAssigBroker);
                update unassigBroker;
                saved =true;
            }else if(newAssigBroker!=null){
                update newAssigBroker;
                saved=true;
            }
            if(saved){
                myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Changes have been saved');
                ApexPages.addMessage(myMsg);
                }
            
        }catch(exception e){
            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage());
            ApexPages.addMessage(myMsg);
        }
    }

    public void updateBrokers() { 
        this.noBrokers=false;
        this.brokerOpts = new List<SelectOption>();
        
        if(this.salesRep!=null && this.SalesRep!='' && brokerProfile!=null ){
            
            if(userByTerritory.get(salesRep)!=null){
                AggregateResult [] brokersByState;
                
                if(adminProf){
                    brokersByState= [Select  User__r.id id, User__r.Name name , Zip_Code__r.Territory__c territory 
                                                        from User_by_Zip_City_County__c 
                                                        where User__r.ProfileID =:brokerProfile
                                                        group by User__r.id,User__r.Name, Zip_Code__r.Territory__c , User__r.FirstName order by User__r.FirstName]; 
                                                        
                }else{
                    brokersByState= [Select  User__r.id id, User__r.Name name , Zip_Code__r.Territory__c territory 
                                                        from User_by_Zip_City_County__c 
                                                        where Zip_Code__r.State__c IN:stateID and User__r.ProfileID =:brokerProfile
                                                        group by User__r.id,User__r.Name, Zip_Code__r.Territory__c , User__r.FirstName order by User__r.FirstName];                 
                }   
                 
                
                Set<String> salesRepTerritories =  new Set<String>(); 
                salesRepTerritories.addall(userByTerritory.get(salesRep).split(', ', -2));
                Set<Id> brokersThatCantBeAssigned = new Set<ID>();
                Map<String, String> broker = new Map<String, String>();
                                                        
                if(brokersByState!=null && brokersByState.size()>0){
                    for (AggregateResult ar : brokersByState) {
                        if (salesRepTerritories.contains((String)ar.get('territory')) && !brokersThatCantBeAssigned.contains((ID)ar.get('id'))){
                            if(broker.containsKey((String)ar.get('id')))
                                broker.put((String)ar.get('id'),broker.get((String)ar.get('id'))+', '+(String)ar.get('territory'));
                            else
                                broker.put((String)ar.get('id'),(String)ar.get('Name')+' - Territories: '+(String)ar.get('territory'));
                            
                        }else{
                        
                            brokersThatCantBeAssigned.add((ID)ar.get('id'));
                            broker.remove((String)ar.get('id'));
                            
                        }
                    }
                    
                    if(broker.size()>0){
                        for(String brokerId: broker.keyset()){
                            brokerOpts.add(new SelectOption(brokerId,broker.get(brokerID)));
                        }
                    }else{
                        noBrokers=true;
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'There are not brokers assigned to any of the territories from the Sales Rep.');
                        ApexPages.addMessage(myMsg);                        
                    }                    
                }
            }else{
                //SalesRep doesnt have territories
            }                      
        }       

        this.selectBroker =false;
        brokers= new List<String>();
        oldBrokers = new Set<String>();
        if(this.salesRep!=null && this.SalesRep!=''){   
            List<User> brokersBySR = [Select id, Name  from User Where ProfileID =:brokerProfile and Sales_Rep__c=: this.salesRep];
            if(brokersBySR!=null && brokersBySR.size()>0){
                for(User u: brokersBySR ){
                   brokers.add(u.id);
                }
                oldBrokers.addAll(brokers);
            }
        }          
    }   

    public String getSalesRepTerritories() {
        String states = userByTerritory.get(salesRep);
        if(states!=null)
            return states;
        else
            return '';
    }

    public String getSalesRepStates() {
        String states = userByState.get(salesRep);
        if(states!=null)
            return states;
        else
            return '';
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
            
            if(salesRepMap!=null && salesRepMap.size()>0){
                for(User u: salesRepMap.values()){
                    if(u.User_State__c.contains(statesMultiPickList))
                        salesRepOpt.add(new SelectOption(u.id,u.Name));
                }
            }
    
        }else{
            salesRepOpt=salesRepOptAll;
        }
        this.brokerOpts = new List<SelectOption>();
        this.salesRep=null;
        cancel();
            
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
             

}