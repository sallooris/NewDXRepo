public class nbsp {
  

    public String selectedValue { get; set; }
     public String selectedValue1 { get; set; }
    public List<String> strSearch { get; set; }  
    public List<Account> accList{get;set;}
    public List<Opportunity> oppList{get;set;}
    public List<Contact> contList{get;set;}
    
    public PageReference searchMethod() {
        
    accList = new List<Account>();
    oppList = new List<Opportunity>();
    contList = new List<Contact>();
    
    String searchItem = selectedValue;
    System.debug('searchItem  '+ searchItem);
  
     List<Account> acc= [SELECT Name,Type, (SELECT Name,StageName, Type FROM Opportunities),(SELECT Name, email FROM Contacts) FROM Account where Name = :searchItem];
    
    System.debug('acc'+acc);
    accList = acc;
        System.debug('accList'+accList);

     If(accList!=null && accList.size()>0){

         contList = new List<Contact>(acc[0].Contacts);

         oppList = new List<Opportunity>(acc[0].Opportunities);

    }
    return null; 
    }
    
    public nbsp(){
    strSearch = new List<String>();
    
    for(Account a: [SELECT id, Name From Account]){
        strSearch.add(a.name);
    }
    
    
    }    
}