public class Contact_Controller {
    @AuraEnabled
    Public static List<Contact> findAll(){
        return [select id,name,phone from Contact Limit 50];
        
    }
    @AuraEnabled
    Public Static List<Contact> findByName(string key){
       string name='%'+key+'%';
     return [select id ,name ,phone from Contact where name Like : name  Limit 50];
    }
    @AuraEnabled
     Public Static List<Contact> findById(Id conid){ 
     return [select id ,name ,phone,mobilephone, Account.Name from Contact where id=:conid  Limit 50];
    }
}