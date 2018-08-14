public with sharing class BrokerSearchController {
    public String accountNameSearch{get; set;}
    public String firstNameSearch{get; set;}
    public String lastNameSearch{get; set;}
    public String phoneSearch{get; set;}
    public String emailSearch{get; set;}
    public String employerTinSearch{get; set;}
    public String agencyTinSearch{get; set;}
    public String agentTinSearch{get; set;}
    public String writingAgentSearch{get; set;}
    public String streetSearch{get; set;}
    public String citySearch{get; set;}
    public String stateSearch{get; set;}    
    public String zipCodeSearch{get; set;}
    
    public List<Account> filteredRecAccnts {get; set;}
    public List<Lead> filteredRecords {get; set;}
    public List<Contact> filteredRecContacts {get; set;}
    public List<Opportunity> filteredRecOpportunities {get; set;}

    public brokerSearchController()
    {
        filteredRecAccnts = new List<Account>();
        filteredRecords = new List<Lead>();
        filteredRecContacts = new List<Contact>();
        filteredRecOpportunities = new List<Opportunity>();
    }
    private Boolean HasValue (String field) {
        if(field!=null && field.length()>0 && field!='')
            return true;
        else if(field== null || field== '' || field.length()==0)
            return false;
        else
            return false;
    }
    
    public void search()
    {
        
        Boolean result = validateInputFields();
        
        if(result== true) {
            String strQuery = queryBuilder();
            System.debug('This is the final query Lead' + strQuery);
            if(strQuery!=null) {
                filteredRecords  = Database.Query(strQuery);
                if(filteredRecords!=null)
                    if(filteredRecords.size() == 1000)
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Too many results! Please refine your search criteria'));
            }
            
            String strQueryAcc = queryBuilderAccounts();
            System.debug('This is the final query version Account' + strQueryAcc);
            if(strQueryAcc!= null) {
                filteredRecAccnts = Database.Query(strQueryAcc);
                if(filteredRecAccnts!=null)
                    if(filteredRecAccnts.size() == 1000)
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Too many results! Please refine your search criteria'));
            }
            
            String strQueryOpportunity = queryBuilderOpportunity();
            System.debug('This is the final query version Opportunity' + strQueryOpportunity);
            if(strQueryOpportunity!= null ){ //&& HasValue(RSVPSearch) == false) {
                filteredRecOpportunities = Database.Query(strQueryOpportunity);
                if(filteredRecOpportunities!=null)
                    if(filteredRecOpportunities.size() == 1000)
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Too many results! Please refine your search criteria'));
            }
            
            String strQueryContact = queryBuilderContact();
            System.debug('This is the final query version Contact' + strQueryContact);
            if(strQueryContact!= null ){ //&& HasValue(RSVPSearch) == false) {
                filteredRecContacts = Database.Query(strQueryContact);
                if(filteredRecContacts!=null)
                    if(filteredRecContacts.size() == 1000)
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Too many results! Please refine your search criteria'));
            }        
            
            if(filteredRecords.size()==0 && filteredRecAccnts.size()==0 && filteredRecOpportunities.size()==0 && filteredRecContacts.size() == 0)
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No Results fetched for the search criteria'));
            System.debug('list------->'+filteredRecords  );
        }
    }
    
    private Boolean validateInputFields () {
        Boolean returnresult = true;
        if(!HasValue(accountNameSearch) && !HasValue(firstNameSearch) && !HasValue(lastNameSearch) && !HasValue(phoneSearch) &&  !HasValue(zipCodeSearch) && 
           !HasValue(streetSearch) && !HasValue(citySearch) && !HasValue(stateSearch) && !HasValue(emailSearch) 
           && !HasValue(employerTinSearch) && !HasValue(agencyTinSearch) && !HasValue(agentTinSearch) && !HasValue(writingAgentSearch)){
               ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a search criteria');
               ApexPages.addMessage(errorMsg);
               returnresult = false;            
           }
        return returnresult;
    }
    private String queryBuilder(){
        String strQuery=null;
        String strWhereClause = whereClause();      
        //Integer OverLimit = MaxRecordLimit+1;
        if(strWhereClause!='')
            //Vlocity May 5 2016  adding MobilePhone to avoid soql error
            strQuery = 'SELECT MobilePhone, firstName, lastName, Company,Date_of_Birth__c,Social_Security_Number__c, Phone,Mobile_Phone__c,Work_Phone__c, Email, PostalCode, Street,State, city,country,County__c,Status'
            +' FROM Lead '+ strWhereClause+' limit 100';
        return strQuery;
    }
    
    private String queryBuilderAccounts(){
        String strQuery=null;
        String strWhereClauseacc = whereClauseAccounts();      
        //Integer OverLimit = MaxRecordLimit+1;
        if(strWhereClauseacc!='')
            strQuery = 'SELECT Name,vlocity_ins__SocialSecurityNumber__pc, PersonEmail,Phone,PersonMobilePhone,PersonHomePhone,PersonOtherPhone,PersonBirthdate, Type, Billing_State__c,Billing_Street__c,Billing_City__c,BillingCountry,County__c,Billing_PostalCode__c'
            +' FROM Account '+ strWhereClauseacc+' limit 100';
        return strQuery;
    }
    
    private String queryBuilderContact(){
        String strQuery=null;
        String strWhereClauseContact = whereClauseContacts();      
        //Integer OverLimit = MaxRecordLimit+1;
        if(strWhereClauseContact!='')
            strQuery = 'SELECT Name, firstname, lastname, Birthdate , vlocity_ins__SocialSecurityNumber__c, Email,Phone, MobilePhone, HomePhone, OtherPhone, MailingState,MailingStreet,MailingCity,MailingCountry,MailingPostalCode'
            +' FROM Contact '+ strWhereClauseContact+' limit 100';
        return strQuery;
    }
    
    private String queryBuilderOpportunity(){
        String strQuery=null;
        String strWhereClauseOpportunity = whereClauseOpportunities();      
        //Integer OverLimit = MaxRecordLimit+1;
        if(strWhereClauseOpportunity !='')
            strQuery = 'SELECT Name, description,stageName, type , CloseDate, Amount'
            +' FROM Opportunity '+ strWhereClauseOpportunity +' limit 100';
        return strQuery;
    }
    
    
    private String whereClause(){
        String strWhereClause='where';
        String patPhoneNumber = '^[0-9]{3}-[0-9]{3}-[0-9]{4}$';        
        if(HasValue(accountNameSearch))
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
            +'Name like \'%'+String.escapeSingleQuotes(accountNameSearch)+'%\'';
        if(HasValue(firstNameSearch))
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
            +'firstName like \'%'+String.escapeSingleQuotes(firstNameSearch)+'%\'';
        if(HasValue(lastNameSearch))
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
            +'lastName like \'%'+String.escapeSingleQuotes(lastNameSearch)+'%\'';
        
        if(HasValue(phoneSearch)) {
            String patPhoneSearch = null;
            if (phoneSearch.length()>10) {
                patPhoneSearch = phoneSearch.replaceAll('[^0-9]','');
                phoneSearch =  phoneSearch.replaceAll('[^0-9]','');
                //line added by Nitish, because if someone enters 989670-1089, then the above line would remove - from number, but was not reformatting to (989) 670-1089.
                patPhoneSearch = '(' + patPhoneSearch.substring(0, 3) + ') ' + patPhoneSearch.substring(3, 6) + '-' + patPhoneSearch.substring(6);
            }
            else if(phoneSearch.length()==10)
                patPhoneSearch = '(' + phoneSearch.substring(0, 3) + ') ' + phoneSearch.substring(3, 6) + '-' + phoneSearch.substring(6);
            System.debug('patPhoneSearch -------->'+patPhoneSearch);
            if(patPhoneSearch!=null) {
                strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
                    + '(Phone = \''+patPhoneSearch + '\' OR Mobile_Phone__c = \''+ patPhoneSearch + '\' OR Work_Phone__c = \'' + patPhoneSearch + '\' OR Phone = \'' + phoneSearch + '\' OR Mobile_Phone__c = \'' + phoneSearch + '\' OR Work_Phone__c = \'' + phoneSearch + '\')';
            }
            else {
                strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
                    + '(Phone = \'' + phoneSearch + '\' OR Mobile_Phone__c = \'' + phoneSearch + '\' OR Work_Phone__c = \'' + phoneSearch + '\')';
            }
            
        }
        
        if(HasValue(emailSearch))
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
            +'Email = \''+String.escapeSingleQuotes(emailSearch)+'\''; 
        if(HasValue(writingAgentSearch))
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
            +'Owner.Name  = \''+String.escapeSingleQuotes(writingAgentSearch)+'\'';
        
        
        if(HasValue(streetSearch))
        {
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
                +'Street = \''+String.escapeSingleQuotes(streetSearch)+'\'';
        }
        if(HasValue(citySearch))
        {
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
                +'City like \'%'+String.escapeSingleQuotes(citySearch)+'%\'';
        }
        if(HasValue(stateSearch))
        {
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
                +'State = \''+String.escapeSingleQuotes(stateSearch)+'\'';
        }
        if(HasValue(zipCodeSearch))
        {
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
                +'PostalCode = \''+String.escapeSingleQuotes(zipCodeSearch)+'\'';
        }
        
        if((HasValue(accountNameSearch) || HasValue(firstNameSearch) || HasValue(lastNameSearch) || HasValue(phoneSearch) ||
            HasValue(emailSearch) || HasValue(employerTinSearch) || HasValue(agencyTinSearch) || HasValue(agentTinSearch) || HasValue(writingAgentSearch) || 
            HasValue(streetSearch) || HasValue(citySearch) || HasValue(stateSearch) || HasValue(zipCodeSearch))) {
                System.debug('isconverted----------->');
                strWhereClause=strWhereClause+ (!strWhereClause.equals('where')?' and ':' ') +
                    'isConverted=False';
            }
        
        return (!strWhereClause.equals('where')?strWhereClause:'');    
    }
    
    private String whereClauseAccounts(){
        String strWhereClause='where';
        
        if(HasValue(accountNameSearch))
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
            +'name like \'%'+String.escapeSingleQuotes(accountNameSearch)+'%\'';
        if(HasValue(firstNameSearch))
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
            +'firstname like \'%'+String.escapeSingleQuotes(firstNameSearch)+'%\'';
        if(HasValue(lastNameSearch))
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
            +'lastname like \'%'+String.escapeSingleQuotes(lastNameSearch)+'%\'';
        if(HasValue(phoneSearch)) {
            String patPhoneSearch = null;
            if(phoneSearch.length()>10) {
                patPhoneSearch = phoneSearch.replaceAll('[^0-9]','');
                phoneSearch =  phoneSearch.replaceAll('[^0-9]','');
                //line added by Nitish, because if someone enters 989670-1089, then the above line would remove - from number, but was not reformatting to (989) 670-1089.
                patPhoneSearch = '(' + patPhoneSearch.substring(0, 3) + ') ' + patPhoneSearch.substring(3, 6) + '-' + patPhoneSearch.substring(6);
            }
            else if(phoneSearch.length()==10)
                patPhoneSearch = '(' + phoneSearch.substring(0, 3) + ') ' + phoneSearch.substring(3, 6) + '-' + phoneSearch.substring(6);
            System.debug('patPhoneSearch -------->'+patPhoneSearch);
            if(patPhoneSearch!=null) { 
                strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')         
                    +'(PersonOtherPhone = \''+patPhoneSearch +'\' OR PersonMobilePhone = \''+patPhoneSearch + '\' OR PersonHomePhone = \''+ patPhoneSearch + '\' OR PersonOtherPhone= \''+ phoneSearch +'\' OR PersonMobilePhone = \''+ phoneSearch +'\' OR PersonHomePhone = \''+ phoneSearch +'\')';
            }
            else{
                strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')         
                    +'(PersonOtherPhone = \''+ phoneSearch + '\' OR PersonMobilePhone = \''+ phoneSearch + '\' OR PersonHomePhone = \''+ phoneSearch+ '\' )';
                
            }
        }
        
        if(HasValue(emailSearch))
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
            +'PersonEmail = \''+String.escapeSingleQuotes(emailSearch)+'\'';  
        if(HasValue(employerTinSearch))
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
            +'Employer_EIN__c  = \''+String.escapeSingleQuotes(employerTinSearch)+'\'';  
        if(HasValue(agencyTinSearch))
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
            +'Temp_GeneralAgencyETIN__c = \''+String.escapeSingleQuotes(agencyTinSearch)+'\'';  
        if(HasValue(agentTinSearch))
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
            +'Temp_PaidAgencyETIN__c   = \''+String.escapeSingleQuotes(agentTinSearch)+'\'';  
        if(HasValue(writingAgentSearch))
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
            +'Owner.Name  = \''+String.escapeSingleQuotes(writingAgentSearch)+'\'';    
        
        if(HasValue(streetSearch))
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
            +'Billing_Street__c = \''+String.escapeSingleQuotes(streetSearch)+'\'';
        
        if(HasValue(citySearch))
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
            +'Billing_City__c like \'%'+String.escapeSingleQuotes(citySearch)+'%\'';
        if(HasValue(stateSearch))
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
            +'Billing_State__c = \''+String.escapeSingleQuotes(stateSearch)+'\'';
        if(HasValue(zipCodeSearch)) 
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
            +'Billing_PostalCode__c = \''+String.escapeSingleQuotes(zipCodeSearch)+'\'';
        
        return (!strWhereClause.equals('where')?strWhereClause :'');    
    }
    
    private String whereClauseContacts(){
        String strWhereClause='where';
        
        if(HasValue(accountNameSearch))
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
            +'name like \'%'+String.escapeSingleQuotes(accountNameSearch)+'%\'';
        if(HasValue(firstNameSearch))
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
            +'firstname like \'%'+String.escapeSingleQuotes(firstNameSearch)+'%\'';
        if(HasValue(lastNameSearch))
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
            +'lastname like \'%'+String.escapeSingleQuotes(lastNameSearch)+'%\'';
        if(HasValue(phoneSearch)) {
            String patPhoneSearch = null;
            if(phoneSearch.length()>10) {
                patPhoneSearch = phoneSearch.replaceAll('[^0-9]','');
                phoneSearch =  phoneSearch.replaceAll('[^0-9]','');
                //line added by Nitish, because if someone enters 989670-1089, then the above line would remove - from number, but was not reformatting to (989) 670-1089.
                patPhoneSearch = '(' + patPhoneSearch.substring(0, 3) + ') ' + patPhoneSearch.substring(3, 6) + '-' + patPhoneSearch.substring(6);
            }
            else if(phoneSearch.length()==10)
                patPhoneSearch = '(' + phoneSearch.substring(0, 3) + ') ' + phoneSearch.substring(3, 6) + '-' + phoneSearch.substring(6);
            System.debug('patPhoneSearch -------->'+patPhoneSearch);
            if(patPhoneSearch!=null) { 
                strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')         
                    +'(Phone = \''+ patPhoneSearch + '\' OR MobilePhone = \''+ patPhoneSearch + '\' OR HomePhone = \''+ patPhoneSearch + '\' OR OtherPhone= \''+phoneSearch + '\' )';
            }
            else{
                strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')         
                    +'(Phone = \''+ phoneSearch + '\' OR MobilePhone = \''+phoneSearch + '\' OR HomePhone = \'' + phoneSearch + '\' OR OtherPhone = \''+ phoneSearch+ '\' )';
                
            }
        }
        
        if(HasValue(emailSearch))
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
            +'Email = \'' + String.escapeSingleQuotes(emailSearch)+'\'';  
        if(HasValue(writingAgentSearch))
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
            +'Owner.Name  = \''+String.escapeSingleQuotes(writingAgentSearch)+'\'';  
        
        if(HasValue(streetSearch))
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ') 
            +'MailingStreet = \''+String.escapeSingleQuotes(streetSearch)+'\'';
        
        if(HasValue(citySearch))
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
            +'MailingCity like \'%'+String.escapeSingleQuotes(citySearch)+'%\'';
        if(HasValue(employerTinSearch))
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
            +'ETIN__c  = \''+String.escapeSingleQuotes(employerTinSearch)+'\'';  
        if(HasValue(agencyTinSearch))
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
            +'account.Temp_GeneralAgencyETIN__c = \''+String.escapeSingleQuotes(agencyTinSearch)+'\'';  
        if(HasValue(agentTinSearch))
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
            +'account.Temp_PaidAgencyETIN__c   = \''+String.escapeSingleQuotes(agentTinSearch)+'\'';  
        if(HasValue(stateSearch))
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
            +'MailingState = \''+String.escapeSingleQuotes(stateSearch)+'\'';
        return (!strWhereClause.equals('where')?strWhereClause :'');    
    }
    
    private String whereClauseOpportunities(){
        String strWhereClause='where';
        
        if(HasValue(accountNameSearch))
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
            +'name like \'%'+String.escapeSingleQuotes(accountNameSearch)+'%\'';
        if(HasValue(firstNameSearch))
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
            +'name like \'%'+String.escapeSingleQuotes(firstNameSearch)+'%\'';
        if(HasValue(lastNameSearch))
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
            +'name like \'%'+String.escapeSingleQuotes(lastNameSearch)+'%RequestEffe\'';
        if(HasValue(writingAgentSearch))
            strWhereClause=strWhereClause+(!strWhereClause.equals('where')?' and ':' ')
            +'Owner.Name  = \''+String.escapeSingleQuotes(writingAgentSearch)+'\'';  
        
        return (!strWhereClause.equals('where')?strWhereClause :'');    
    }
    
    public PageReference addCampaign() 
    {
        return null;
    }
    public PageReference URlRedirecting() {
        
        return null;

    }
}