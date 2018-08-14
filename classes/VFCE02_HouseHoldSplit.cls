/*************************************************************
Class Name   : VFCE02_HouseHoldSplit
Date Created : 20-April-2015
Created By   : Bhaskar
Description  : This class is used to split one household account into two household accounts. . 
*****************************************************************/

public with sharing class VFCE02_HouseHoldSplit{
    public List<HouseHold> HouseHoldList {get; set;}
    public String selectedRecord{get;set;}
    public List<Household_Member__c> splitHouseholdList = null;
    String referrer = apexpages.currentPage().getheaders().get('Referer');
    public String accountId = null;
    public Household_Member__c houseHoldMem = null;
    public VFCE02_HouseHoldSplit(ApexPages.StandardController controller){
      accountId = ApexPages.currentpage().getparameters().get('id');
      HouseHoldList = new List<HouseHold>();
        for(Account a: [select Id, firstname,lastname,age__c,gender__c,Tobacco_User__c,date_of_birth__c from Account where id=:accountId AND Tech_Businesstrack__c='TELESALES']) {
                HouseHoldList.add(new HouseHold(a));
       }
        //for(Household_Member__c rParty : [select Id,name,age__c,gender__c,date_of_birth__c,last_name__c,Tobacco_User__c,Relationship_Type__c from Household_Member__c where Household_ID__c=:accountId]){
        for(Household_Member__c rParty : [select Id,first_name__c,age__c,gender__c,date_of_birth__c,last_name__c,Tobacco_User__c,Relationship_Type__c from Household_Member__c where Household_ID__c=:accountId]){       
                HouseHoldList.add(new HouseHold(rParty));
       }
    }
/*
      Method Name : backMethod
      Return type : PageReference
      Description : This method is used to get back to the account detail page when user clicks on back method 
*/
    public PageReference backMethod()
    {
     
        return new PageReference('/' + accountId);
    }
/*
      Method Name : splitHouseHold
      Return type : PageReference
      Description : this method is used to split to other househod if user selects any record from the existing household to
                    split and it will redirect to the newly created household detail page
*/
  public PageReference splitHouseHold(){
   System.debug('### splitHouseHold method - START ###');
    System.Savepoint sp = Database.setSavepoint();
    Boolean isSpouse = false;
    Boolean isPrimary = false;
    Boolean isDomesticPartner = false;
    Account  newAccount = null;
    splitHouseholdList = new List<Household_Member__c>();
    try{
        
        for(HouseHold hh : HouseHoldList){
            
            if(hh.role == System.Label.Primary){
                 if(isPrimary == true){
                      isPrimary = false;
                    throw new SplitException(System.Label.OnePrimary); 
                    }else{
                        isPrimary = true;
                    }
              
            }
            if(hh.role == System.Label.Spouse){
                if(isSpouse == true){
                    isSpouse = false;
                    throw new SplitException(System.Label.OneSpouse); 
                 }else{
                    isSpouse  = true;
                }
         
            }
            if(hh.role == System.Label.DomesticPartner){
                if(isDomesticPartner == true){
                    isDomesticPartner = false;
                    throw new SplitException(System.Label.OneDomesticPartner); 
                 }else{
                    isDomesticPartner = true;
                }
         
            }
         }
          for(HouseHold hh : HouseHoldList){
              if(hh.role!=null && !('--None--').equals(hh.role) && hh.role!=System.Label.Primary){
                    Household_Member__c hm = new Household_Member__c(); 
                    hm.Relationship_Type__c= hh.role;
                    hm.id = hh.relatedPartyId;
                    //hm.name = hh.firstname;
                    hm.first_name__c = hh.firstname;
                    hm.gender__c = hh.gender;
                    hm.date_of_birth__c = hh.dateOfBirth;
                    hm.Tobacco_User__c = hh.tobaccoUser;
                    splitHouseholdList.add(hm);
              }
              if(hh.role==System.Label.Primary){
                     selectedRecord = hh.recordId;
              }
           }
      
          if(selectedRecord!=null && selectedRecord!=''){
              newAccount = this.getAccountDetails();
              newAccount.id=null;
              //houseHoldMem = [select id,name,last_name__c,age__c,gender__c,Tobacco_User__c,date_of_birth__c,Social_Security_Number__c from Household_Member__c where id=:selectedRecord];
              houseHoldMem = [select id,first_name__c,last_name__c,age__c,gender__c,Tobacco_User__c,date_of_birth__c,Social_Security_Number__c from Household_Member__c where id=:selectedRecord];
              delete houseHoldMem;
              //newAccount.firstname = houseHoldMem.name;
              newAccount.firstname = houseHoldMem.first_name__c;
              newAccount.gender__c = houseHoldMem.gender__c;
              newAccount.Tobacco_User__c = houseHoldMem.Tobacco_User__c;
              newAccount.date_of_birth__c = houseHoldMem.date_of_birth__c;
              newAccount.Social_Security_Number__c = houseHoldMem.Social_Security_Number__c;
              insert newAccount;
              insertOpportunity(newAccount.id,newAccount.firstname,newAccount.lastname);
          }else{
            throw new  SplitException(System.Label.SelectPrimary);
          }
          if(!splitHouseholdList.isEmpty()){
              for(Household_Member__c hm : splitHouseholdList){
                  hm.Household_ID__c = newAccount.id;
              }
              update splitHouseholdList; 
          }
       }catch(DMLException e){
          Database.rollback(sp);
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getDMLMessage(0));
          ApexPages.addMessage(myMsg);
          return null;
       }catch(Exception e){
          Database.rollback(sp);
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
          ApexPages.addMessage(myMsg);
          return null;
       }
        System.debug('### splitHouseHold method - END ###');
        return new PageReference('/' + newAccount.id);
    }
/*
      Method Name : getAccountDetails
      Return type : PageReference
      Description : This method is used to get the house hold demographic information to copy it to newly created household using fieldset(SplitHouseholdDemographics)
*/
    private Account getAccountDetails() {
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getDemographicFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Lastname FROM Account where id='+'\''+accountId+'\'';
        
        return Database.query(query);
    } 
/*
  Method Name : getDemographicFields
  Return type : List<Schema.FieldSetMember>
  Description : This method will return all the fields which are there in the  "SplitHouseholdDemographics" fieldset
*/
    public List<Schema.FieldSetMember> getDemographicFields() {
        return SObjectType.Account.FieldSets.SplitHouseholdDemographics.getFields();
    }
/*
  Method Name : getRelatedParties
  Return type : List<SelectOption>
  Description : This method is used to get the relationship types from Household Member object dynamically 
*/
    public List<SelectOption> getRelatedParties(){
    
      List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('--None--','--None--'));
       options.add(new SelectOption('Primary',System.Label.Primary));     
       Schema.DescribeFieldResult fieldResult = Household_Member__c.Relationship_Type__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
       for( Schema.PicklistEntry f : ple)
       {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
       }   
     return options;
    }
    /*
        Method Name : insertOpportunity
        Return type : void
        Description : This method is used to create the opportunity for the newly splitted household
    */
     public void insertOpportunity(ID accountId,String firstname,String lastname){
         Opportunity opp = new Opportunity();
         opp.name = firstname+' '+lastname;
         opp.accountid = accountId;
         opp.stagename = System.Label.Opportunity;
         Integer currentYear = System.Today().year();
         Date dt = date.newInstance(currentYear,12,31);
         opp.closedate = dt;
         insert opp;
     }
     
     /*
       Wrapper class to hold the Household and Household Member information
        
    */
    public class HouseHold {
        public Id relatedPartyId{get;set;}
        public String firstname{get;set;}
        public String lastname{get;set;}
        public String name{get;set;}
        public String age{get;set;}
        public String gender{get;set;}
        public String dob{get;set;}
        public String relationShipType{get;set;}
        public String tobaccoUser{get;set;}
        public Date dateOfBirth{get;set;}
        public String recordId{get;set;}
        public String role{get;set;}
        public HouseHold(Account a) {
            firstname = a.firstname;
            lastname = a.lastname;
            age = a.age__c;
            gender = a.gender__c;
            if(a.date_of_birth__c!=null)
            dob = datetime.newInstance(a.date_of_birth__c.year(), a.date_of_birth__c.month(),a.date_of_birth__c.day()).format('MM/dd/yyyy');
            tobaccoUser = a.Tobacco_User__c;
            relationShipType = 'Primary Insured';
         }
     
        public HouseHold(Household_Member__c r) {
            //firstname = r.name;
            firstname = r.first_name__c;
            lastname = r.last_name__c;
            age = r.age__c;
            gender = r.gender__c;
            if(r.date_of_birth__c!=null)
            dob = datetime.newInstance(r.date_of_birth__c.year(), r.date_of_birth__c.month(),r.date_of_birth__c.day()).format('MM/dd/yyyy');
            tobaccoUser = r.Tobacco_User__c;
            dateOfBirth = r.date_of_birth__c;
            relationShipType = r.Relationship_Type__c;
            relatedPartyId = r.id;
            recordId = r.id;
       }
      
    }

}