/*************************************************************
Class Name   : VFCE03_CombineHouseHold
Date Created : 04-May-2015
Created By   : Bhaskar
Description  : This class is used for Combining two household accounts into one Account.
*****************************************************************/
public with sharing class VFCE03_CombineHouseHold{
    public String accountId = null;
    public List<HouseHold> HouseHoldList {get; set;}
    public List<HouseHold> HouseHoldSearchList {get;set;}
    public List<HouseHold> HouseHoldList1 {get; set;}
    public List<HouseHold> HouseHoldList2 {get;set;}
    public String selectedHousehold{get;set;}
    public String houseSearchText{get;set;}
    public String selectedRecord{get;set;}
    public String primaryRecordId{get;set;}
    public String primarySelected{get;set;}
    public Account deleteAccount;
    public Account demoGraphics1{get;set;}
    public Account demoGraphics2{get;set;}
    public Household_Member__c newHouseholdMem{get;set;}
    public List<Household_Member__c> combineHouseholdList = new List<Household_Member__c>();
    public List<Household_Member__c> detachedHouseholdList = new List<Household_Member__c>();
   public VFCE03_CombineHouseHold(ApexPages.StandardController controller){
       
         accountId = ApexPages.currentpage().getparameters().get('id');
         HouseHoldList = new List<HouseHold>();
         
         for(Account a: [select Id, firstname,lastname,age__c,gender__c,Tobacco_User__c,date_of_birth__c,Billing_Street__c, Billing_City__c, Billing_State__c, Billing_PostalCode__c,County__c,Zip_Code__c from Account where id=:accountId]){
                    demoGraphics1 = a;
                    HouseHoldList.add(new HouseHold(a));
         }
           for(Household_Member__c rParty : [select Id,name,First_Name__c,age__c,gender__c,date_of_birth__c,last_name__c,Tobacco_User__c,Relationship_Type__c from Household_Member__c where Household_ID__c=:accountId]){
                HouseHoldList.add(new HouseHold(rParty));
       }
       System.debug('### Demo Graphics1 ###'+demoGraphics1);
    }
 /*
  Method Name : getRelatedParties
  Return type : List<SelectOption>
  Description : This method is used to get the relationship types from Household Member object dynamically 
*/ 
     public List<SelectOption> getRelatedParties(){
    
      List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('--None--','--None--'));
       Schema.DescribeFieldResult fieldResult = Household_Member__c.Relationship_Type__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
       for( Schema.PicklistEntry f : ple)
       {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
       }   
     return options;
    }
/*
  Method Name : getRelatedParties
  Return type : List<SelectOption>
  Description : This method is used to get the relationship types from Household Member object dynamically in addition primary
*/
    public List<SelectOption> getRelatedPartiesPrimary(){
    
      List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('--None--','--None--'));
       options.add(new SelectOption(System.Label.Primary,System.Label.Primary));
       Schema.DescribeFieldResult fieldResult = Household_Member__c.Relationship_Type__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
       for( Schema.PicklistEntry f : ple)
       {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
       }   
     return options;
    }
 /*
  Method Name : getRelatedParties
  Return type : List<SelectOption>
  Description : This method is used to search and display all the households based on the input text
*/   
   public PageReference searchHouseHold(){
    try{
         selectedRecord=null ;
         if (houseSearchText==null || houseSearchText=='') {
              if(HouseHoldSearchList!=null) 
                  HouseHoldSearchList.clear(); 
                throw new CombineHouseholdException(System.Label.ProvideInputSearch);
                
          }else{ 
             String searchStr = '%' + houseSearchText + '%'; 
             HouseHoldSearchList = new List<HouseHold>();
      			/* commenting
             for(Account a: [select Id, firstname,lastname,age__c,gender__c,Tobacco_User__c,date_of_birth__c from Account where name like :searchStr]) {
                            HouseHoldSearchList.add(new HouseHold(a));
                 }
                 
                 
                 */
			List<List<sObject>> results  = [FIND :searchStr IN NAME FIELDS RETURNING Account(Id, firstname,lastname,age__c,gender__c,Tobacco_User__c,date_of_birth__c) ];
		 	List<Account> accts = (List<Account>)results[0];
		 	for(Account acc: accts){
		 		HouseHoldSearchList.add(new HouseHold(acc));
		 	}
		}
		}catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
      	}
		return null;
	}    
/*
      Method Name : backMethod
      Return type : PageReference
      Description : This method is used to get back to the account detail page when user clicks on back method 
*/  public PageReference backMethod()
    {
        return new PageReference('/' + accountId);
    }
/*
      Method Name : next
      Return type : PageReference
      Description : This method will call on click on next button, redirected to other vf page with two households and their related information
*/  
    public PageReference next(){
    
    try{
        if(HouseHoldSearchList==null){
             throw new CombineHouseholdException(System.Label.SearchHousehold);
        }
        if(selectedRecord==null || selectedRecord==''){
                   throw new CombineHouseholdException(System.Label.SelecttoCombine);
                  
        }else if(selectedRecord.contains(accountId)){
             throw new CombineHouseholdException(System.Label.SameRecord);
        }else{
        HouseHoldList1 = new List<HouseHold>();
        HouseHoldList2 = new List<HouseHold>();
        HouseHoldList1.addAll(HouseHoldList);
        for(Account a: [select Id, firstname,lastname,age__c,gender__c,Tobacco_User__c,date_of_birth__c,Billing_Street__c, Billing_City__c, Billing_State__c, Billing_PostalCode__c,County__c,Zip_Code__c from Account where id=:selectedRecord]) {
                    demoGraphics2 = a;
                    HouseHoldList2.add(new HouseHold(a));
         }
        for(Household_Member__c rParty : [select Id,name,First_Name__c,age__c,gender__c,date_of_birth__c,last_name__c,Tobacco_User__c,Relationship_Type__c from Household_Member__c where Household_ID__c=:selectedRecord]){
                HouseHoldList2.add(new HouseHold(rParty));
         }
            System.debug('### Demo Graphics2 ###'+demoGraphics2);
            return new PageReference('/apex/VFP04_HouseHoldCombine');  
        }
      }catch(DMLException e){
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getDMLMessage(0));
          ApexPages.addMessage(myMsg);
          return null;
       }catch(Exception e){
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
          ApexPages.addMessage(myMsg);
          selectedRecord=null ;
          return null;
      }
    }
/*
      Method Name : next
      Return type : PageReference
      Description : This method will call at the time of combine household button clicked, we are calling selectedHouseholdMembers() from this method
                    to check whether the user selected spouse and dependent for combining the household
                    if user selected the members it will perform the business logic otherwise it will not.
*/ 
  public PageReference combineHousehold(){
     System.Savepoint sp = Database.setSavepoint();
    try{
       Boolean validationPassed = checkValidations();
       if(!validationPassed)
            return null;
        Boolean isSelected = selectedHouseholdMembers();
        if(isSelected){
           if(primaryRecordId !=null && primaryRecordId !=''){
             System.debug('###Inside PrimaryRecordId Not Null if Block in Combine Houshold Method###');
            if(!combineHouseholdList.isEmpty()){
                System.debug('###Inside combineHouseholdList Not Null if Block in Combine Houshold Method###');
                for(Household_Member__c hm : combineHouseholdList){
                        hm.Household_ID__c = primaryRecordId;
                }
                newHouseholdMem.Household_ID__c = primaryRecordId;
                System.debug('newHouseholdMem'+newHouseholdMem);
               system.debug('upateList ==>'+ combineHouseholdList);
               update combineHouseholdList;
               insert newHouseholdMem;
               delete deleteAccount;
              }else if(newHouseholdMem!=null){
                    newHouseholdMem.Household_ID__c = primaryRecordId;
                    insert newHouseholdMem;
              }  
          }else{
                throw new CombineHouseholdException(System.Label.ProperPrimary);
            }
          }
         }catch(DMLException e){
          Database.rollback(sp);
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getDMLMessage(0));
          ApexPages.addMessage(myMsg);
          selectedHousehold = null;
          return null;
         }catch(Exception e){
             Database.rollback(sp);
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
             ApexPages.addMessage(myMsg);
             selectedHousehold = null;
             return null;
         }
        return new PageReference('/' + primaryRecordId);
    }
    
    public boolean checkValidations(){
        try{
        System.debug('### checkValidations -START###');
        Boolean isPrimary = false;
           for(HouseHold hh : HouseHoldList1){
                  if(hh.role == System.Label.Primary){
                         if(isPrimary == true){
                          isPrimary = false;
                        throw new CombineHouseholdException(System.Label.OnePrimary); 
                        }else{
                            isPrimary = true;
                            primarySelected = System.Label.FirstAccount;
                        }
                         
                    }else if(hh.role=='--None--' || ('--None--').equals(hh.role)){
                        throw new CombineHouseholdException(System.Label.SelectRelation); 
                
                    }
             }
            for(HouseHold hh : HouseHoldList2){
                    if(hh.role == System.Label.Primary){
                         if(isPrimary == true){
                          isPrimary = false;
                        throw new CombineHouseholdException(System.Label.OnePrimary); 
                        }else{
                            isPrimary = true;
                            primarySelected = System.Label.SecondAccount;
                        }
                         
                    }else if(hh.role=='--None--' || ('--None--').equals(hh.role)){
                        throw new CombineHouseholdException(System.Label.SelectRelation); 
                    }
             }
        
            if(isPrimary==false){
                 throw new CombineHouseholdException(System.Label.ProperPrimary); 
            }
            else if(selectedHousehold==null || selectedHousehold==''){
                 throw new CombineHouseholdException(System.Label.SelectHouseholdDemoGraphic); 
            }
           
       }catch(DMLException e){
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getDMLMessage(0));
          ApexPages.addMessage(myMsg);
          primarySelected = null;
          selectedHousehold = null;
          return null;
       }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
            primarySelected = null;
            selectedHousehold = null;
            return false;
       }
       System.debug('### checkValidations -END ###');
       return true;
    }
/*
      Method Name : selectedHouseholdMembers
      Return type : boolean
      Description : This method is called from combineHouseHold method to validate the user selected the spouse and dependents or not, 
                    returns true if user selects spouse and dependents to combine the household, else false
*/ 
    public boolean selectedHouseholdMembers(){
   try{
       System.debug('### selectedHouseholdMembers in ###');
           if(!combineHouseholdList.isEmpty()){
               combineHouseholdList.clear();    
           }
        if(primarySelected!=null || primarySelected!=''){
            Account updateAddress = new Account();
            if(System.Label.FirstAccount.equals(primarySelected)){
            
                    for(HouseHold hh : HouseHoldList1){
                        if(hh.role!=System.Label.Primary){
                                Household_Member__c hm = new Household_Member__c(id = hh.relatedPartyId); 
                                hm.Relationship_Type__c= hh.role;
                                combineHouseholdList.add(hm);
                        }else{
                            primaryRecordId = hh.recordId;
                     }
                    }
                    for(HouseHold hh : HouseHoldList2){
                        if(hh.recordId!=selectedRecord){
                                Household_Member__c hm = new Household_Member__c(id = hh.relatedPartyId); 
                                hm.Relationship_Type__c= hh.role;
                                combineHouseholdList.add(hm);
                        }else{
                            newHouseholdMem = new Household_Member__c();
                            deleteAccount = new Account();
                            newHouseholdMem.Relationship_Type__c= hh.role;
//                            newHouseholdMem.name = hh.firstname;
                            newHouseholdMem.First_Name__c= hh.firstname;                            
                            newHouseholdMem.last_name__c = hh.lastname;
                            newHouseholdMem.gender__c = hh.gender;
                            newHouseholdMem.date_of_birth__c = hh.dateOfBirth;
                            newHouseholdMem.Tobacco_User__c = hh.tobaccoUser;
                            deleteAccount.id = hh.recordId;
                        }
                    }
            if(selectedHousehold.equals(System.Label.SecondAccount)){
            System.debug('### Inside copying Demographics2 ###');
                        updateAddress.Billing_Street__c = demoGraphics2.Billing_Street__c;
                        updateAddress.Billing_City__c = demoGraphics2.Billing_City__c;
                        updateAddress.Billing_State__c = demoGraphics2.Billing_State__c;
                        updateAddress.Billing_PostalCode__c = demoGraphics2.Billing_PostalCode__c;
                        updateAddress.County__c = demoGraphics2.County__c;
                        updateAddress.Zip_Code__c = demoGraphics2.Zip_Code__c;
                        updateAddress.id = primaryRecordId;
                
                update updateAddress;
            }
        }else if(System.Label.SecondAccount.equals(primarySelected)){
            for(HouseHold hh : HouseHoldList2){
                if(hh.role!=System.Label.Primary){
                        Household_Member__c hm = new Household_Member__c(id = hh.relatedPartyId); 
                        hm.Relationship_Type__c= hh.role;
                        combineHouseholdList.add(hm);
                }else{
                 primaryRecordId = hh.recordId;
             }
            }
            for(HouseHold hh : HouseHoldList1){
                if(hh.recordId.contains(accountId)){
                    deleteAccount = new Account();
                    newHouseholdMem = new Household_Member__c();
                    newHouseholdMem.Relationship_Type__c= hh.role;
                    newHouseholdMem.First_Name__c = hh.firstname;
                    newHouseholdMem.last_name__c = hh.lastname;
                    newHouseholdMem.gender__c = hh.gender;
                    newHouseholdMem.date_of_birth__c = hh.dateOfBirth;
                    newHouseholdMem.Tobacco_User__c = hh.tobaccoUser;
                    deleteAccount.id = hh.recordId;
                        
                }else{
                    Household_Member__c hm = new Household_Member__c(id = hh.relatedPartyId); 
                        hm.Relationship_Type__c= hh.role;
                        combineHouseholdList.add(hm);
                }

            }
            if(selectedHousehold.equals(System.Label.FirstAccount)){
                        updateAddress.Billing_Street__c = demoGraphics1.Billing_Street__c;
                        updateAddress.Billing_City__c = demoGraphics1.Billing_City__c;
                        updateAddress.Billing_State__c = demoGraphics1.Billing_State__c;
                        updateAddress.Billing_PostalCode__c = demoGraphics1.Billing_PostalCode__c;
                        updateAddress.County__c = demoGraphics1.County__c;
                        updateAddress.Zip_Code__c = demoGraphics1.Zip_Code__c;
                        updateAddress.id = primaryRecordId;
                
                        update updateAddress;
                }
            }
        }
       }catch(DMLException e){
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getDMLMessage(0));
          ApexPages.addMessage(myMsg);
          combineHouseholdList=null;
          return null;
       }catch(Exception e){
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
           ApexPages.addMessage(myMsg);
           combineHouseholdList=null;
           return false;
       }
           return true;
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
            dateOfBirth = a.date_of_birth__c;
            if(a.date_of_birth__c!=null)
            dob = datetime.newInstance(a.date_of_birth__c.year(), a.date_of_birth__c.month(),a.date_of_birth__c.day()).format('MM/dd/yyyy');
            tobaccoUser = a.Tobacco_User__c;
            relationShipType = System.Label.PrimaryInsured;
            recordId = a.id;
         }
     
        public HouseHold(Household_Member__c r) {
            firstname = r.First_Name__c;
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