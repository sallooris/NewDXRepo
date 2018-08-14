/*************************************************************
Class Name: VFCE01_HouseHoldQuote
Date Created : 20-April-2015
Created By   : Bhaskar/Santosh
Description  : This class will be called at the time of launching PTB. 
*****************************************************************/
public with sharing class VFCE01_HouseHoldQuote{
    public List<HouseHold> houseHoldList{set;get;}
    private String accountId = null;
    private String quoteAccntId = null;
    public Account acc{get;set;} 
    /*
     * Constructor
     */
    public VFCE01_HouseHoldQuote(ApexPages.StandardController controller){
    accountId = ApexPages.currentpage().getparameters().get(Util03_HardCodingConstants.ID);
        houseHoldList = new List<HouseHold>();
        for(Account a: [select Id, firstname,lastname,age__c,gender__c,Tobacco_User__c,date_of_birth__c 
                        from Account where id=:accountId AND Tech_Businesstrack__c='TELESALES'] ) {
                acc = a;
                quoteAccntId  = a.Id;
                houseHoldList.add(new HouseHold(a));
       }
        for(Household_Member__c rParty : [select Id,first_name__c,age__c,gender__c,date_of_birth__c,last_name__c,
                                          Tobacco_User__c,Relationship_Type__c 
                                          from Household_Member__c where Household_ID__c=:accountId]){
                houseHoldList.add(new HouseHold(rParty));
       }
                             
     } 
/*
  Method Name : getRelatedParties
  Return type : List<SelectOption>
  Description : This method is used to get the relationship types from Household Member object dynamically 
*/
  public List<SelectOption> getRelatedParties(){
    
      System.debug('### getRelatedParties method - START ###');
      List<SelectOption> options = new List<SelectOption>();
       Schema.DescribeFieldResult fieldResult = Household_Member__c.Relationship_Type__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
       for( Schema.PicklistEntry f : ple)
       {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
       }   
     options.add(new SelectOption(System.Label.Applicant, System.Label.Applicant));
     System.debug('### getRelatedParties method - END ###');
     return options;
     
    }
/*
      Method Name : backMethod
      Return type : PageReference
      Description : This method is used to get back to the account detail page when user clicks on back method 
*/
 /*  public pagereference backMethod()
    {
         return new PageReference('/' + accountId);
    }*/
    /*
          Method Name : next
          Return type : PageReference
          Description : This method is used to submit the quote related details to PTB and it will redirect to PTB page
    */
    public PageReference next(){
    System.debug('### Next method - START ###');
    String selectedApplicants = null;
    String selectedApplicantRoles = null;
    String applicantAccountid = null;
    
      try{
          Boolean isSpouse = false;
          Boolean isPrimary = false;
          Boolean isDomesticPartner = false;
          Boolean selectedAny = false;
        for(HouseHold hh : houseHoldList){
            if(hh.role == System.Label.Applicant && hh.isSelect == true){
                 if(isPrimary == true){
                      isPrimary = false;
                    throw new SplitException(System.Label.OneApplicant); 
                    }else{
                        isPrimary = true;
                    }
              
            }if(hh.role == System.Label.Spouse && hh.isSelect == true){
                if(isSpouse == true){
                    isSpouse = false;
                    throw new SplitException(System.Label.OneSpouse); 
                 }else{
                    isSpouse  = true;
                }
         
            } if(hh.role == System.Label.DomesticPartner && hh.isSelect == true){
                 if(isDomesticPartner == true){
                      isDomesticPartner = false;
                    throw new SplitException(System.Label.OneDomesticPartner); 
                    }else{
                        isDomesticPartner = true;
                    }
              
            } if(hh.isSelect == true && hh.role == null){
                throw new SplitException(System.Label.SelectRole);
            } if(hh.isSelect == true){
                System.debug('###selected the check box###');
                selectedAny = true;
            }
                    //To pass selected household members to PTB - Added By Arun
        if(hh.isSelect == true){
           if(selectedApplicants ==null)
            selectedApplicants = hh.houseHoldMbrId;
            else
           selectedApplicants = selectedApplicants + '|'+hh.houseHoldMbrId;  
           if(selectedApplicantRoles ==null)
            selectedApplicantRoles = hh.role;
            else
           selectedApplicantRoles = selectedApplicantRoles + '|'+hh.role;  
        }
        
        
        //End Here

            
        }
        if(selectedAny == false){
            throw new SplitException(System.Label.SelecttoQuote);
        }else if(isPrimary == true && isSpouse == true && isDomesticPartner == true){
            throw new SplitException(System.Label.QuotePrimarySpouseDomestic);
        }else if(isSpouse == true && isDomesticPartner == true){
            throw new SplitException(System.Label.QuoteSpouseDomestic);
        }else{
             acc.Customer_Stage__c = System.Label.QuoteProvided;
             update acc;
        }
      }catch(Exception e){
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
          ApexPages.addMessage(myMsg);
          
          return null;
      }
     
      System.debug('### Next method - END ###');
      System.debug('### Next method - END ###');
      System.debug('### Before Invoking PTB - Selected Household Ids for Quoting ###'+selectedApplicants);
      System.debug('### Before Invoking PTB - Selected Household Roles for Quoting ###'+selectedApplicantRoles);
      PageReference pageRef = new PageReference('/apex/PTBIntegrationPilot?ParentId='+ quoteAccntId +'&HouseholdMemberIds=' +selectedApplicants+'&HouseholdMemberRoles=' +selectedApplicantRoles);
      return pageRef;    
     }
    /*
       Wrapper class to hold the Household and Household Member information
        
    */
    public without sharing class HouseHold {
        public String firstname{get;set;}
        public String houseHoldMbrId{get;set;} //To pass selected household members to PTB
        public String lastname{get;set;}
        public String name{get;set;}
        public String age{get;set;}
        public String gender{get;set;}
        public Datetime dob{get;set;}
        public String relationShipType{get;set;}
        public String tobaccoUser{get;set;}
        public String role{get; set;}
        public Boolean isSelect {get; set;}
        /*
         * Constructor
         */
        public HouseHold(Account a) {
            firstname = a.firstname;
            houseHoldMbrId = a.Id; //To pass selected household members to PTB
            lastname = a.lastname;
            age = a.age__c;
            gender = a.gender__c;
            dob = a.date_of_birth__c;
            tobaccoUser = a.Tobacco_User__c;
            relationShipType = System.Label.Applicant;
            role = relationShipType ;
            isSelect=true;
       }
        /*
         * Constructor
         */
        public HouseHold(Household_Member__c r) {
            firstname = r.first_name__c;
            lastname = r.last_name__c;
            houseHoldMbrId = r.Id; //To pass selected household members to PTB
            age = r.age__c;
            gender = r.gender__c;
            dob = r.date_of_birth__c;
            tobaccoUser = r.Tobacco_User__c;
            relationShipType = r.Relationship_Type__c;
            role = relationShipType ;
            isSelect=true;
        }
    }

}